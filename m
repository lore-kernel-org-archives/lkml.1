Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbXBEQAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbXBEQAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXBEQAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:00:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60786 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbXBEQAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:00:19 -0500
Date: Mon, 5 Feb 2007 16:56:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205155627.GA8354@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1170682488.29759.795.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2007-02-05 at 09:45 +0100, Ingo Molnar wrote:
> >     LD      vmlinux
> >   drivers/built-in.o: In function `cafe_nand_remove':
> >   cafe.c:(.text+0x19277a): undefined reference to `nand_release'
> >   drivers/built-in.o: In function `cafe_nand_cmdfunc':
> >   cafe.c:(.text+0x193036): undefined reference to `nand_wait_ready'
> >   drivers/built-in.o: In function `cafe_nand_probe':
> >   cafe.c:(.text+0x19359e): undefined reference to `nand_scan_ident'
> >   cafe.c:(.text+0x193658): undefined reference to `nand_scan_tail'
> >   distcc[1703] ERROR: compile (null) on localhost failed
> >   make: *** [vmlinux] Error 1
> 
> > so here's the fix for the 3 affected MTD drivers: DOC2000, DOC2001 and 
> > DOC2001PLUS.
> 
> Er, what?
> 
> For a start, the affected driver is the new CAFÉ NAND controller, not 
> the old versions of the DiskOnChip drivers which don't even use the 
> generic NAND code anyway.
>
> Secondly, please don't _ever_ use 'select'. [...]

i only did the simple & minimal thing and extended the already existing 
select code that was there:

        tristate "M-Systems Disk-On-Chip 2000 and Millennium (DEPRECATED)"
        depends on MTD
        select MTD_DOCPROBE
+       select MTD_NAND
        select MTD_NAND_IDS
        ---help---

feel free to get rid of the original selects there.

> [...] If ESR's Aunt Tillie _really_ needs to configure a new kernel 
> for her $100 laptop, but she lacks the wit to realise that she might 
> need to ask for NAND flash support if she wants to be able to enable 
> the NAND flash controller, then I really couldn't care less.

i agree and i disagree. I agree that sprinkling tons of selects all 
around the Kconfigs would be bad - a dependency should only be expressed 
once.

But i disagree with your notion that it's somehow wrong to be able to 
select a component somewhere which then picks its dependencies. I think 
the right solution is not to be ambivalent towards the needs of aunts, 
but to extend the Kconfig language (and/or tools surrounding it) to be 
able to activate an inactive config entry by automatically selecting all 
its required dependencies. (just like package managers can do it on any 
modern distro)

Furthermore, there's a solution already within the existing Kconfig 
language: the Kconfig hierarchy should be a tree alike hiearachy of 
dependencies, /not/ a generic, messy directed graph. In terms of Kconfig 
dependencies: if you need the NAND subsystem for certain types of 
drivers then do it like networking: collect those dependent drivers 
under CONFIG_NET_PCI, and make that whole category dependent on 
CONFIG_PCI. Not like the MTD code does it today: there's a 
"Self-contained MTD device drivers" category and a separate selectable 
CONFIG_MTD_NAND and there's a magic non-tree dependency between them.

btw., this whole select problem is not limited to Aunt Tillie: in a 
couple of cases in the past few months when i saw some weird code in a 
driver and tried to enable it i had to search around for many minutes 
and enable random options to figure out its config dependencies until i 
had the driver truly enabled. (if there's some easy solution to this 
then i'm all ears - but i exclude the easiest solution of adding me to 
the 'aunt' category ;-) I think that by blaming Aunt Tillie you might be 
missing the real problem.

	Ingo
