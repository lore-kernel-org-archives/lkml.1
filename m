Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbXLXHXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbXLXHXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 02:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXLXHXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 02:23:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42971 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXLXHXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 02:23:07 -0500
Message-ID: <476F5E22.3060007@garzik.org>
Date: Mon, 24 Dec 2007 02:22:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Loic Prylli <loic@myri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a	driver
 opt-in issue
References: <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org> <20071223110337.GA25441@jurassic.park.msu.ru>
In-Reply-To: <20071223110337.GA25441@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Sun, Dec 23, 2007 at 12:44:30AM -0500, Jeff Garzik wrote:
>> Failures are more predictable and more consistent with an all-or-none 
>> scenario.  The all-or-none solutions are the least complex on the software 
>> side, and far more widely tested than any mixed config access scheme.
> 
> Nope. The vast majority of mmconfig problems that happen at boot time
> actually have nothing to do with "broken" or "working" mmconfig.
> Typically these are
> - mmconf area overlapped during BAR sizing;
> - BIOS (or kernel) placed some MMIO in the middle of mmconfig area,
>   which looks like some random device "doesn't like mmconfig".
> 
> This is a result of all-or-none approach, as mmconfig is fundamentally
> unsafe until after PCI init is done.

The phrase "all or none" specifically describes the current practice in 
arch/x86/pci/mmconfig_{32,64}.c whereby a PCI bus always has one, and 
only one, access method.

So the problems you describe are unrelated to "all or none" as I was 
describing it.


> The mixed access that Loic proposes allows to avoid these boot problems
> just for free.

False.  If you have overlapping areas, then clearly it is 
board-dependent (undefined) what happens -- you might trigger an 
mmconfig access by writel() to your PCI device's MMIO BAR space.

Consider, too, what the current code in arch/x86/pci/mmconfig_{32,64}.c 
does:  it uses the range BIOS told to use for mmconfig, no more no less.

Clearly many early mmconfig BIOSes have buggy resource allocation... 
Thus if mmconfig is not known working on a system, turn it off 100% for 
all buses.  End of story.


> Systems that have both non-mmconf PCI(X) and mmconf PCI-E
> domains could be handled almost for free as well.

The existing code in arch/x86/pci/mmconfig_{32,64}.c today handles 
mixing of PCI-E and PCI-X just fine.  As noted above, its done on a 
per-bus and per-segment basis today.


> And probably most important thing is that the x86 pci_conf implementation
> would be so much simpler and cleaner that I honestly don't understand
> why are we still discussing it ;-)

The proposed API adds code, so I don't see how it simplifies things.

The current approach is quite clean anyway:

1) "raw_pci_ops" points to a single set of PCI config accessors.
2) For mmconfig, if the BIOS did not tell us to use mmconfig with a 
given PCI bus, fall back to type1 accesses.


> At the same time, making drivers to request extended config space
> still makes sense. I think of pci_request_ext_conf(dev, drv_name) which
> doesn't set any per-device flag, but
> - returns success or failure depending on mmconf availability;
> - can be logged by kernel to make it easier to debug if something
>   goes wrong.

I agree with the function as noted in response to Linus's "Sound ok with 
this plan?" email.  But note -- users and developers also need to access 
extended config space, even if driver did not request it.  Even if there 
is no driver at all.

Otherwise the value of "lspci -vvvxxx" debugging reports from users is 
diminished.

	Jeff


