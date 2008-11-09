Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYKIT1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYKIT1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYKIT0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:26:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbYKIT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:26:53 -0500
Date: Sun, 9 Nov 2008 11:26:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hitoshi Mitake" <h.mitake@gmail.com>
Cc: "Hitoshi Mitake" <mitake@clustcom.com>, "Doug Thompson" <norsk5@yahoo.com>,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       ktaka@clustcom.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081109112646.97c594b5.akpm@linux-foundation.org>
In-Reply-To: <a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
	<20081106164641.ed369060.akpm@linux-foundation.org>
	<20081107152830.a42766f3.mitake@clustcom.com>
	<20081106223122.8a255211.akpm@linux-foundation.org>
	<20081107153824.0ec934e6.mitake@clustcom.com>
	<20081106231102.aab83cd4.akpm@linux-foundation.org>
	<a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-arch)

On Mon, 10 Nov 2008 00:10:34 +0900 "Hitoshi Mitake" <h.mitake@gmail.com> wrote:

> ...
>
> >> -static u64 x38_readq(const void __iomem *addr)
> >> +#ifndef CONFIG_X86_64
> >> +static u64 readq(const void __iomem *addr)
> >
> > hm, it'd be nice if there was some more general way of determining
> > whether the architecture provides readq/writeq.
> >
> 
> 
> I found this code in include/asm-x86/io.h
> 
> #ifdef CONFIG_X86_64
> 
> ...
> 
> /* Let people know we have them */
> #define readq readq
> #define writeq writeq
> #endif
> 
> x86 programmers are able to know existence of readq/writeq by using
> this definition.
> 
> And I grepped,
> 
> % grep readq `find include/asm-* -name "*.h"`
> include/asm-mips/io.h:			".set	mips3"		"\t\t# __readq"	"\n\t"	\
> include/asm-mips/io.h:#define readq_relaxed			readq
> include/asm-mips/io.h:#define readq				readq
> include/asm-mips/txx9/tx4927.h:	((__u32)__raw_readq(&tx4927_ccfgptr->crir)
> >> 16)
> include/asm-mips/txx9/tx4927.h:#define
> TX4927_SDRAMC_CR(ch)	__raw_readq(&tx4927_sdramcptr->cr[(ch)])
> include/asm-mips/txx9/tx4927.h:#define
> TX4927_EBUSC_CR(ch)	__raw_readq(&tx4927_ebuscptr->cr[(ch)])
> include/asm-mips/txx9/tx4927.h:	____raw_writeq(____raw_readq(adr) & ~bits, adr);
> include/asm-mips/txx9/tx4927.h:	____raw_writeq(____raw_readq(adr) | bits, adr);
> include/asm-mips/txx9/tx4927.h:	____raw_writeq(____raw_readq(&tx4927_ccfgptr->ccfg)
> include/asm-mips/txx9/tx4927.h:	____raw_writeq((____raw_readq(&tx4927_ccfgptr->ccfg)
> include/asm-mips/txx9/tx4927.h:	____raw_writeq((____raw_readq(&tx4927_ccfgptr->ccfg)
> include/asm-mips/txx9/tx4938.h:	((__u32)__raw_readq(&tx4938_ccfgptr->crir)
> >> 16)
> include/asm-parisc/io.h:static inline unsigned long long
> gsc_readq(unsigned long addr)
> include/asm-parisc/io.h:static inline unsigned long long
> __raw_readq(const volatile void __iomem *addr)
> include/asm-parisc/io.h:#define readq(addr) __fswab64(__raw_readq(addr))
> include/asm-parisc/io.h:#define readq_relaxed(addr) readq(addr)
> include/asm-x86/io.h:build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
> include/asm-x86/io.h:build_mmio_read(__readq, "q", unsigned long, "=r", )
> include/asm-x86/io.h:#define readq_relaxed(a) __readq(a)
> include/asm-x86/io.h:#define __raw_readq __readq
> include/asm-x86/io.h:#define readq readq
> 
> It seems that architectures that provide readq/writeq are
> mips, parisc and x86 (and x86_64).
> 
> mips and x86 provides this line
> #define readq readq
> to let user know existence of readq (and writeq),
> and parisc doesn't provide.
> But there is,
> #define readq(addr) __fswab64(__raw_readq(addr))
> in parisc.
> 
> There is a difference between mips and x86's readq/writeq and
> parisc's readq/writeq. mips and x86's definition is only token,
> but parisc's definition is macro function.
> 
> But these defines can be used to determine existence of readq/writeq
> by common preprocessor like this,
> #ifndef readq
> /* programmer can define private version of readq (or writeq) */
> #endif
> 
> Is this way enough general for our requirement?
> (If we use this as general way to determine existence of readq/writeq,
> I want other architecture's developer (whose architecture provides
> readq/writeq in the future)
> to support same way.)

Yes, I'd say that

#ifdef readq

Is a suitable way of determining whether the architecture implements
readq and writeq.  It isn't pretty, but it will suffice.

A problem with it is that drivers will then do

#ifndef readq
<provide a local implementation here>
#endif

which rather sucks - we don't want lots of little private readq/writeq
implementations all over the tree.

Perhaps it would be better to have a CONFIG_ARCH_HAS_READQ and to then
disable these drivers on the architectures which don't provide
readq/writeq support.


Also, I'm not sure that we have sufficiently defined the semantics of
these operations, and whether all the architectures which do purport to
implement them actually implement them with the same semantics.
