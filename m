Return-Path: <linux-kernel-owner+w=401wt.eu-S2992628AbXEBHRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992628AbXEBHRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945967AbXEBHRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:17:07 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:53537 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbXEBHRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:17:05 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work as expected (2nd try)
Date: Wed, 2 May 2007 09:16:59 +0200
User-Agent: KMail/1.9.4
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
References: <200704301409.l3UE9sFg019392@harpo.it.uu.se> <200704301733.41903.juergen127@kreuzholzen.de> <20070501174808.4ac5378b.akpm@linux-foundation.org>
In-Reply-To: <20070501174808.4ac5378b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705020917.00134.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wednesday 02 May 2007 02:48, Andrew Morton wrote:
> On Mon, 30 Apr 2007 17:33:41 +0200
>
> Juergen Beisert <juergen127@kreuzholzen.de> wrote:
> > From: Juergen Beisert <juergen.beisert@weihenstephan.org>
> >
> > Replace NSC/Cyrix specific chipset access macros by inlined functions.
> > With the macros a line like this fails (and does nothing):
> > 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> > With inlined functions this line will work as expected.
> >
> > Note about a side effect: Seems on Geode GX1 based systems the
> > "suspend on halt power saving feature" was never enabled due to this
> > wrong macro expansion. With inlined functions it will be enabled, but
> > this will stop the TSC when the CPU runs into a HLT instruction.
> > Kernel outputs something like this:
> > 	Clocksource tsc unstable (delta = -472746897 ns)
> > Tested on a Geode GX1 system.
> >
> > This is the second version with some modifications suggested by
> > Mikael Pettersson
> >
> > Signed-off-by: Juergen Beisert <juergen.beisert@weihenstephan.org>
> >
> > Index: linux-2.6.21/include/asm-i386/processor.h
> > ===================================================================
> > --- linux-2.6.21.orig/include/asm-i386/processor.h
> > +++ linux-2.6.21/include/asm-i386/processor.h
> > @@ -202,37 +202,6 @@ static inline void clear_in_cr4 (unsigne
> >  	write_cr4(cr4);
> >  }
> >
> > -/*
> > - *      NSC/Cyrix CPU configuration register indexes
> > - */
> > -
> > -#define CX86_PCR0 0x20
> > -#define CX86_GCR  0xb8
> > -#define CX86_CCR0 0xc0
> > -#define CX86_CCR1 0xc1
> > -#define CX86_CCR2 0xc2
> > -#define CX86_CCR3 0xc3
> > -#define CX86_CCR4 0xe8
> > -#define CX86_CCR5 0xe9
> > -#define CX86_CCR6 0xea
> > -#define CX86_CCR7 0xeb
> > -#define CX86_PCR1 0xf0
> > -#define CX86_DIR0 0xfe
> > -#define CX86_DIR1 0xff
> > -#define CX86_ARR_BASE 0xc4
> > -#define CX86_RCR_BASE 0xdc
>
> This clashes with Andi's "msr-index" patch:
>
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/msr-index

I see. He also moves these defines to another file. Not problem where they 
are. But it isn't possible to replace the macros by the inlined functions in 
processor.h. The used outb/inb macros fail for various other files.

> Perhaps it'd be best to wait until msr-index goes upstream and to raise a
> patch then.  Or to redo and retest against 2.6.21-rc7-mm2, which includes
> msr-index.

All right. To wait is no problem for me (my system works with my 
patch.... ;-) )

> Also, include/asm-x86_64/processor.h has a getCx86(), too.  Does it also
> need fixing?

As I can see the macros are used in:
 - i386/kernel/cpu/cpufreq/gx-suspmod.c (ups, its not in my patch, so it is
   currently no complete)
 - i386/kernel/cpu/mtrr/state.c (also not part of my patch yet)
 - i386/kernel/cpu/cyrix.c
 - i386/kernel/cpu/mtrr/cyrix.c

Most comments states Cyrix CPUs when they are using the macros. Is anything 
with Cyrix 64 bit relevant? Maybe "include/asm-x86_64/processor.h" is a 
simple copy of "include/asm-i386/processor.h" and nobody delete the unused 
macros?

Please keep me informed and I will resend the patch.

Juergen
