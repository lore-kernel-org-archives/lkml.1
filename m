Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbXF1L6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbXF1L6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbXF1L55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:57:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:26848 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbXF1L54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=g8wNJkzHDbD4soLIyvOL4Liz00T6iAQC2Xb0EbefiKe/h/D1cj0QrEEfYh3l8vCQxV/vaO40SIl/fOGY8TBwXa4Rz2FUxJ7AjjGB8dHwXLuGUYvU0dlkLjBN94KPNMq3uU0TKDmicb5JXTMmhYclWc3ImPSkD3vBTbGaFEjVSuc=
Message-ID: <a781481a0706280457r4abb5046wc82cff9d49b7975e@mail.gmail.com>
Date: Thu, 28 Jun 2007 17:27:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Mike Frysinger" <vapier@gentoo.org>
Subject: sh section mismatches [was Re: 2.6.22-rc6 on Dreamcast (SH4)]
Cc: linuxsh-dev@lists.sourceforge.net,
       "Adrian McMenamin" <adrian@newgolddream.dyndns.info>,
       LKML <linux-kernel@vger.kernel.org>, "Sam Ravnborg" <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Monday 25 June 2007, Adrian McMenamin wrote:
> > Still getting this:
> >
> >  MODPOST vmlinux
> > WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section
> > mismatch: reference to .init.text: (between 'mv_dreamcast' and
> > 'systemasic_int')

I had sent a patch for this earlier ... Adrian, did you try (build + boot +
testrun) with it? Does this one go away (and system executes fine)?

[ http://lkml.org/lkml/diff/2007/6/23/116/1 ]

[ This has to do with __init functions calling __initmv functions in a
zillion files in arch/sh/boards/.../setup.c which is problematic when
__initmv is not __init itself (!SH_GENERIC && !SH_UNKNOWN) ]

> > WARNING: drivers/built-in.o(.text+0x168e0): Section mismatch: reference
> > to .init.data: (between 'pvr2fb_check_var' and 'pvr2fb_interrupt')
> > WARNING: drivers/built-in.o(.text+0x1701c): Section mismatch: reference
> > to .init.data: (between 'pvr2fb_pci_probe' and 'read_mem')
> > WARNING: drivers/built-in.o(.text+0x17024): Section mismatch: reference
> > to .init.text: (between 'pvr2fb_pci_probe' and 'read_mem')
> > WARNING: drivers/built-in.o(.data+0x738): Section mismatch: reference
> > to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> > WARNING: drivers/built-in.o(.data+0x750): Section mismatch: reference
> > to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')

drivers/video/pvr2fb.c is a mess with __init, __initdata, __devinit and
__devinitdata (__exit and __devexit variants for good measure) all being
used and referencing each other freely ... I have no idea what function
should actually be what. Sam normally knows about such things,
adding him to Cc: list.

On 6/28/07, Mike Frysinger <vapier@gentoo.org> wrote:
> it means there is code that is not marked as init making references
> function/data that is marked as init ...

These warnings are most likely bogus (still good to get rid of them,
of course).

BTW, in include/asm-sh/machvec_init.h, __initmv is:

__attribute__((__section__(".machvec.init")))	/* .machvec.init */

But from arch/sh/kernel/vmlinux.ld.S the name of the section is:

__machvec_start = .;
.init.machvec : { *(.init.machvec) }		/* .init.machvec */
__machvec_end = .;

Am I obtuse, or is there something weird about this?

Satyam
