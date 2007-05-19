Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXESFyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXESFyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXESFyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:54:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:51964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbXESFyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:54:02 -0400
From: Andi Kleen <ak@suse.de>
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
Date: Sat, 19 May 2007 07:53:16 +0200
User-Agent: KMail/1.9.1
Cc: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com>
In-Reply-To: <20070517004209.GE16810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705190753.16570.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007 02:42, Dave Jones wrote:
> On Thu, May 17, 2007 at 02:09:16AM +0200, Christian wrote:
>  > my small VIA C3_2 box does not boot with 2.6.22-rc1.
>  > It even does not uncompress the kernel.
>  >
>  > The configuration as M386 M486 works. But M586 + MVIAC3_2
>  > does not work.
>  >
>  > solution for me, cahnge arch/i386/Kconfig.cpu
>  >
>  > --- arch/i386/Kconfig.cpu.before     2007-05-17 01:38:26.000000000 +0200
>  > +++ arch/i386/Kconfig.cpu       2007-05-17 00:54:52.000000000 +0200
>  > @@ -299,5 +299,5 @@
>  >
>  >  config X86_CMPXCHG64
>  >         bool
>  > -       depends on !M386 && !M486
>  > +       depends on !M386 && !M486 && !MVIAC3_2
>  >         default y
>  >
>  >
>  > The related #ifdef is in ./include/asm-i386/cmpxchg.h
>  > May be cmpxchg8b is not supported by VIAC3_2 ?
>  >
>  > May be some other non Intel/AMD need to be excluded from X86_CMPXCHG64 ?
>  > May be the generic option CONFIG_X86_GENERIC need to switch this off
>  > also ?
>
> The C3s all have cx8, but it needs to be enabled in an MSR first.
> (See arch/i386/kernel/cpu/centaur.c , search for CX8)
>
> Did we add code that uses cmpxchg8b before identify_cpu() gets run ?
> I've not been paying attention to .22rc (busy trying to beat .21 into shape
> for F7) so I may have missed something obvious. Andi?

Can someone please test if this patch works? 

This preserves the 6 <= model  <= 9 logic of the C code; this means
if VIA ever brings out model >= 10 it hopefully sets this bit by default.
Dave, do you have any information to the contrary?

-Andi

Index: linux/arch/i386/kernel/verify_cpu.S
===================================================================
--- linux.orig/arch/i386/kernel/verify_cpu.S
+++ linux/arch/i386/kernel/verify_cpu.S
@@ -2,6 +2,7 @@
    This runs in 16bit mode so that the caller can still use the BIOS
    to output errors on the screen */
 #include <asm/cpufeature.h>
+#include <asm/msr.h>
 
 verify_cpu:
 	pushfl				# Save caller passed flags
@@ -45,6 +46,28 @@ verify_cpu:
 	cmpl	$0x1,%eax
 	jb	bad			# no cpuid 1
 
+#if REQUIRED_MASK1 & NEED_CMPXCHG64
+	/* Some VIA C3s need magic MSRs to enable CX64. Do this here */ 
+	cmpl	$0x746e6543,%ebx	# Cent
+	jne	1f
+	cmpl 	$0x48727561,%edx	# aurH
+	jne	1f
+	cmpl	$0x736c7561,%ecx	# auls
+	jne	1f
+	movl	$1,%eax			# check model
+	cpuid	
+	shr	$4,%eax
+	andl	$0xf,%eax		# get model
+	cmpl	$6,%eax
+	jb	1f
+	cmpl	$9,%eax			# newer vias hopefully don't require
+	ja	1f			# this anymore
+	movl	$MSR_VIA_FCR,%ecx
+	rdmsr
+	orl	$(1|(1<<7)),%eax	# enable CMPXCHG64 and PGE
+	wrmsr	
+1:
+#endif
 	movl    $0x1,%eax		# Does the cpu have what it takes
 	cpuid
 

-Andi
