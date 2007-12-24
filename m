Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbXLXLvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbXLXLvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 06:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXLXLvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 06:51:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47574 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbXLXLvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 06:51:05 -0500
Date: Mon, 24 Dec 2007 03:49:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
 driver opt-in issue
Message-ID: <20071224034935.600bdb30@laptopd505.fenrus.org>
In-Reply-To: <476F5A09.5010201@garzik.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	<476D1D16.5090703@garzik.org>
	<20071222064719.73fdd9a4@laptopd505.fenrus.org>
	<alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
	<476DB95F.3090801@garzik.org>
	<alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
	<476DDFEE.3010009@garzik.org>
	<alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
	<476DE98F.2010009@garzik.org>
	<20071223023348.348608a8@laptopd505.fenrus.org>
	<476F5A09.5010201@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2007 02:04:41 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Arjan van de Ven wrote:
> >> 3) mmconfig might or might not be enabled, depending on which
> >> driver is loaded, whether it called an API or not.
> >>
> >> 	Even LESS testing by hw vendors than #2.  Maybe even
> >> "never"
> >>
> >> 	Inconsistent (config access depends on device)
> > 
> > the "depends on device" is even true for Linux today. For us today,
> > MMCONFIG isn't always used, it's used on a per device basis
> > already; except that the per-device is both defined by the bios and
> > our quirks.... (the mmconfig code already falls back to conf1
> > cycles in various cases)
> > 
> > So I'm not entirely buying your argument. IN fact I'm not buying
> > your "mixed is not tested at all" argument; while the statement may
> > be true, it's not different than it is from Linux today... which is
> > mixed. Just differently mixed I suppose.
> 
> /If/ mixed use is truly well tested, then that eliminates one of my
> two objections.
> 
> But I don't see that in the code now...  I see we choose [get_virt()
> in mmconfig_{32,6 4}.c} strictly on a per-bus basis, based on the
> allowed bus list provided by the BIOS.

and this is PCI express only; afaik (but I could be wrong) it's pretty much a bus per device there in a 1:1 way

 
> And -- please forgive me, I mean no offense here -- we have to make
> sure whatever rule we come up with makes AMD and other non-Intel
> folks happy. Like with PCI MSI, mmconfig (+ its Linux support) has a
> history of being written first for Intel, working great on select
> Intel platforms, and not working so great initially for other vendors
> even when said technology is supposedly compatible.  So having AMD
> sign-off on such an approach would greatly increase comfort level.

they're very welcome to chime in.

At this point the majority of the mmconfig nightmares are for non-Intel (not that Intel
gets it right, but the current diagnostics work there pretty ok), so these patches are
aimed for non-Intel boxes in the first place.

> The second objection was regarding the inconsistencies introduced to 
> userland (and the kernel?) whereby the existing states:
> 
> 	* 256b config space
> 	* on per-bus basis, ext cfg space is available
> 	  if device provides && mmconfig active
> 
> were joined by the additional state
> 
> 	* on a per-bus basis, ext cfg space is available
> 	  if device provides && mmconfig active
> 
> which has the potential to confuse the codebase that makes
> assumptions based upon whole system (mmconfig or not) and per-bus
> (ext cfg space capable or not) basis.

right now they very very very rarely see the extended space in the first place.
(since on a LOT of the machines it just is turned off due to our very very strict
checks, which are MUCH more strict than the standards allow for). In addition, it's not even unlikely
that there will be per-device quirks where we have to disable mmconfig for a specific device
(see recent mails about that), at which point this is game over anyway; unless you want that kind of
thing to just disable mmconfig for the entire bus, which would be WAY overkill.

I can see the point of having a sysfs attribute to enable MMCONF from userspace, so
that userland diagnostics tools can turn it on if they really really want to.
(I'd make that printk a nice warning "application XYZ is enabling extended config space for devize ABC" so
that if the box then crashes and burns, people know who/why and where to direct their emails ;-)

We did something similar for "enable", it's maybe 10 lines of code or so.

I would assume lspci and friends would then only turn that on at explicit admin request

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
