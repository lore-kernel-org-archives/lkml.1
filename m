Return-Path: <linux-kernel-owner+w=401wt.eu-S1765207AbXF1SiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765207AbXF1SiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760915AbXF1Sh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:37:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43382 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758961AbXF1Sh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:37:57 -0400
Date: Thu, 28 Jun 2007 20:39:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linuxsh-dev@lists.sourceforge.net,
       Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sh section mismatches [was Re: 2.6.22-rc6 on Dreamcast (SH4)]
Message-ID: <20070628183902.GC8011@uranus.ravnborg.org>
References: <a781481a0706280457r4abb5046wc82cff9d49b7975e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706280457r4abb5046wc82cff9d49b7975e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 05:27:55PM +0530, Satyam Sharma wrote:
> Hi,
> 
> >On Monday 25 June 2007, Adrian McMenamin wrote:
> >> Still getting this:
> >>
> >>  MODPOST vmlinux
> >> WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section
> >> mismatch: reference to .init.text: (between 'mv_dreamcast' and
> >> 'systemasic_int')
> 
> I had sent a patch for this earlier ... Adrian, did you try (build + boot +
> testrun) with it? Does this one go away (and system executes fine)?
> 
> [ http://lkml.org/lkml/diff/2007/6/23/116/1 ]
> 
> [ This has to do with __init functions calling __initmv functions in a
> zillion files in arch/sh/boards/.../setup.c which is problematic when
> __initmv is not __init itself (!SH_GENERIC && !SH_UNKNOWN) ]
> 
> >> WARNING: drivers/built-in.o(.text+0x168e0): Section mismatch: reference
> >> to .init.data: (between 'pvr2fb_check_var' and 'pvr2fb_interrupt')
> >> WARNING: drivers/built-in.o(.text+0x1701c): Section mismatch: reference
> >> to .init.data: (between 'pvr2fb_pci_probe' and 'read_mem')
> >> WARNING: drivers/built-in.o(.text+0x17024): Section mismatch: reference
> >> to .init.text: (between 'pvr2fb_pci_probe' and 'read_mem')
> >> WARNING: drivers/built-in.o(.data+0x738): Section mismatch: reference
> >> to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> >> WARNING: drivers/built-in.o(.data+0x750): Section mismatch: reference
> >> to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> 
> drivers/video/pvr2fb.c is a mess with __init, __initdata, __devinit and
> __devinitdata (__exit and __devexit variants for good measure) all being
> used and referencing each other freely ... I have no idea what function
> should actually be what. Sam normally knows about such things,
> adding him to Cc: list.

To a quick glance here.
Everything looked OK except the board_list variable. The board_list variable
contains references to both __init and __exit and modpost has no way
to tell which one is good or bad. So to fix the warning this will generate
the only solution is to teach either modpost or the driver to ignore the
references.
The driver can be teached by renaming the variable to one of the following
patterns:
*driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer

Or we could add *_board to modpost. The latter solutions I would like
to avoid.

	Sam

> 
> On 6/28/07, Mike Frysinger <vapier@gentoo.org> wrote:
> >it means there is code that is not marked as init making references
> >function/data that is marked as init ...
> 
> These warnings are most likely bogus (still good to get rid of them,
> of course).
> 
> BTW, in include/asm-sh/machvec_init.h, __initmv is:
> 
> __attribute__((__section__(".machvec.init")))	/* .machvec.init */
> 
> But from arch/sh/kernel/vmlinux.ld.S the name of the section is:
> 
> __machvec_start = .;
> .init.machvec : { *(.init.machvec) }		/* .init.machvec */
> __machvec_end = .;
> 
> Am I obtuse, or is there something weird about this?
> 
> Satyam
