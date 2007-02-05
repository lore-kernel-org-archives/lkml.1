Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbXBEQW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbXBEQW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXBEQW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:22:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45026 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbXBEQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:22:24 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070205155627.GA8354@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 16:22:19 +0000
Message-Id: <1170692539.29759.856.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 16:56 +0100, Ingo Molnar wrote:
> i only did the simple & minimal thing and extended the already existing 
> select code that was there:
> 
>         tristate "M-Systems Disk-On-Chip 2000 and Millennium (DEPRECATED)"
>         depends on MTD
>         select MTD_DOCPROBE
> +       select MTD_NAND
>         select MTD_NAND_IDS
>         ---help---
> 
> feel free to get rid of the original selects there.

Those are different, because they select items which are not
user-visible. It's just a trick to avoid having the same thing
implemented in the Makefiles like it used to be. We used to have stuff
like...
	obj-$(CONFIG_MTD_NAND)    += nand-ids.o
	obj-$(CONFIG_MTD_DOC2000) += nand-ids.o
... but now we have those options select MTD_NAND_IDS instead. That's a
reasonable enough use of select. I really don't see any reason for using
it for items which _are_ visible to the user though.

> > [...] If ESR's Aunt Tillie _really_ needs to configure a new kernel 
> > for her $100 laptop, but she lacks the wit to realise that she might 
> > need to ask for NAND flash support if she wants to be able to enable 
> > the NAND flash controller, then I really couldn't care less.
> 
> i agree and i disagree. I agree that sprinkling tons of selects all 
> around the Kconfigs would be bad - a dependency should only be expressed 
> once.

We _are_ sprinkling tons of selects all around the Kconfigs. And we're
doing it inconsistently -- nobody seems to agree on when to use 'select'
and when to use proper dependencies.

I think that "only use select for non-user-visible options" is a
perfectly good rule.

> But i disagree with your notion that it's somehow wrong to be able to 
> select a component somewhere which then picks its dependencies. I think 
> the right solution is not to be ambivalent towards the needs of aunts, 
> but to extend the Kconfig language (and/or tools surrounding it) to be 
> able to activate an inactive config entry by automatically selecting all 
> its required dependencies. (just like package managers can do it on any 
> modern distro)

It's something we can do in the tools -- if you want to turn an option
on, you can see what its dependencies are and turn them all on in one
go. In fact that's something which was implemented in external variants
of the tcl-based xconfig as long ago as 1997. I think our new xconfig
implementation now does it too.

> Furthermore, there's a solution already within the existing Kconfig 
> language: the Kconfig hierarchy should be a tree alike hiearachy of 
> dependencies, /not/ a generic, messy directed graph. In terms of Kconfig 
> dependencies: if you need the NAND subsystem for certain types of 
> drivers then do it like networking: collect those dependent drivers 
> under CONFIG_NET_PCI, and make that whole category dependent on 
> CONFIG_PCI. Not like the MTD code does it today: there's a 
> "Self-contained MTD device drivers" category and a separate selectable 
> CONFIG_MTD_NAND and there's a magic non-tree dependency between them.

No, it was MTD_NAND_CAFE which requires MTD_NAND, and that _is_ within
the same tree. I don't know why you added it to the old monolithic
DiskOnChip driver.

> btw., this whole select problem is not limited to Aunt Tillie: in a 
> couple of cases in the past few months when i saw some weird code in a 
> driver and tried to enable it i had to search around for many minutes 
> and enable random options to figure out its config dependencies until i 
> had the driver truly enabled. (if there's some easy solution to this 
> then i'm all ears - but i exclude the easiest solution of adding me to 
> the 'aunt' category ;-) 

I come across this frequently -- and I just look at the Kconfig file to
see the dependencies of the option I want to enable. It's usually very
simple.

It's got a _lot_ harder recently to turn stuff _off_, as rmk observes.
You don't just look at the option you're interested in; you have to grep
all over the rest of the tree to find the 'select' which is forcing it
on after you turn it off. It's no longer in one place.

> I think that by blaming Aunt Tillie you might be 
> missing the real problem.

No, by arbitrarily throwing 'select' into the mix with no real guidance
as to when to use it and when to use normal dependencies, _that's_ when
we're missing the real problem.

-- 
dwmw2

