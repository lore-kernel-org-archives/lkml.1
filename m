Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXESLnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXESLnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 07:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXESLm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 07:42:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:62090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXESLm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 07:42:57 -0400
Message-ID: <464EE2AA.3030607@cv-sv.de>
Date: Sat, 19 May 2007 13:42:34 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de>
In-Reply-To: <200705190753.16570.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19td34HSRolj2EQIiLJwDQ8/K1MWDKOjTeJhLU
 arS4C2eUlRlq+QIvusOwWNRXzFAOa01wMO2O8XgSrPN9MoXblp
 C553JuAMRFMpNwP7VO/wQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Can someone please test if this patch works? 
> 
> This preserves the 6 <= model  <= 9 logic of the C code; this means
> if VIA ever brings out model >= 10 it hopefully sets this bit by default.
> Dave, do you have any information to the contrary?
> 
> -Andi
> 

Hi Andi,

your patch did not work. See the correction below. The mask should contain 1<<1
instead of 1.
Model 10 is now also included.

I add also a patch for setup.S. It does not print the CPUID message in case
the CPUID is wrong, cause %ds was not set proper.

Best regards,

Christian

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
        pushfl                          # Save caller passed flags
@@ -45,6 +46,28 @@
        cmpl    $0x1,%eax
        jb      bad                     # no cpuid 1

+#if REQUIRED_MASK1 & NEED_CMPXCHG64
+       /* Some VIA C3s need magic MSRs to enable CX64. Do this here */
+       cmpl    $0x746e6543,%ebx        # Cent
+       jne     1f
+       cmpl    $0x48727561,%edx        # aurH
+       jne     1f
+       cmpl    $0x736c7561,%ecx        # auls
+       jne     1f
+       movl    $1,%eax                 # check model
+       cpuid
+       shr     $4,%eax
+       andl    $0xf,%eax               # get model
+       cmpl    $6,%eax
+       jb      1f
+       cmpl    $10,%eax                 # newer vias hopefully don't require
+       ja      1f                      # this anymore
+       movl    $MSR_VIA_FCR,%ecx
+       rdmsr
+       orl     $((1<<1)|(1<<7)),%eax   # enable CMPXCHG64 and PGE
+       wrmsr
+1:
+#endif
        movl    $0x1,%eax               # Does the cpu have what it takes
        cpuid


Index: linux/arch/i386/boot/verify_cpu.S
===================================================================
--- linux.orig/arch/i386/boot/setup.S
+++ linux/arch/i386/boot/setup.S
@@ -310,12 +310,15 @@
        call verify_cpu
        testl  %eax,%eax
        jz      cpu_ok
+        # missed before: set ds
+       pushw   %cs                             # CPU too old or CPUID function bits are wrong.
+       popw    %ds                             # die.
        lea     cpu_panic_mess,%si
        call    prtstr
 1:     jmp     1b

 cpu_panic_mess:
-       .asciz  "PANIC: CPU too old for this kernel."
+        .asciz  "PANIC: CPU too old for this kernel or CPUID function bits are wrong."

 #include "../kernel/verify_cpu.S"

