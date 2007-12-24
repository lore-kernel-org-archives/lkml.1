Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXLXHFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXLXHFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 02:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbXLXHEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 02:04:53 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60747 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXLXHEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 02:04:52 -0500
Message-ID: <476F5A09.5010201@garzik.org>
Date: Mon, 24 Dec 2007 02:04:41 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <20071223023348.348608a8@laptopd505.fenrus.org>
In-Reply-To: <20071223023348.348608a8@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> 3) mmconfig might or might not be enabled, depending on which driver
>> is loaded, whether it called an API or not.
>>
>> 	Even LESS testing by hw vendors than #2.  Maybe even "never"
>>
>> 	Inconsistent (config access depends on device)
> 
> the "depends on device" is even true for Linux today. For us today, MMCONFIG isn't always used, it's used on a per device basis already; except that the per-device is both defined by the bios and our quirks....
> (the mmconfig code already falls back to conf1 cycles in various cases)
> 
> So I'm not entirely buying your argument. IN fact I'm not buying your "mixed is not tested at all" argument; while the statement may be true, it's not different than it is from Linux today... which is mixed. Just differently mixed I suppose.

/If/ mixed use is truly well tested, then that eliminates one of my two 
objections.

But I don't see that in the code now...  I see we choose [get_virt() in 
mmconfig_{32,6 4}.c} strictly on a per-bus basis, based on the allowed 
bus list provided by the BIOS.

In other words, if the BIOS says "use this segment/bus range for 
mmconfig", the code does that.  There is no mixing of accesses on a 
per-device basis AFAICS in the current code.  (feel free to prove me 
wrong! :))  It looks like per-bus/domain to me, which is a more 
reasonable and expected arrangement than per-device mmconfig|typeN conf 
accesses.

At boot time, we use type1 accesses until a "flag day", at which time an 
entire bus is switched to mmconfig all at once.  After that point there 
is no mixing of accesses on that bus -- and nor were there mixed 
accesses on that bus /before/ that point.

And -- please forgive me, I mean no offense here -- we have to make sure 
whatever rule we come up with makes AMD and other non-Intel folks happy. 
  Like with PCI MSI, mmconfig (+ its Linux support) has a history of 
being written first for Intel, working great on select Intel platforms, 
and not working so great initially for other vendors even when said 
technology is supposedly compatible.  So having AMD sign-off on such an 
approach would greatly increase comfort level.



The second objection was regarding the inconsistencies introduced to 
userland (and the kernel?) whereby the existing states:

	* 256b config space
	* on per-bus basis, ext cfg space is available
	  if device provides && mmconfig active

were joined by the additional state

	* on a per-bus basis, ext cfg space is available
	  if device provides && mmconfig active

which has the potential to confuse the codebase that makes assumptions 
based upon whole system (mmconfig or not) and per-bus (ext cfg space 
capable or not) basis.

So, if my two worries here are needless, then those objections are 
eliminated.




Finally, I wonder if anything can be done about the diagnostic angle: 
it is not __only__ the driver that may want extended config space access.

It is quite reasonable and logical for an admin or developer to want to 
_view_ the entire extended cfg space (with lspci -vvvxxx) of a device, 
even if the device has not called pci_enable_ext_cfg_space(); indeed, 
even if a driver is not loaded at all.

How to address that need?

	Jeff



