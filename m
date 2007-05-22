Return-Path: <linux-kernel-owner+w=401wt.eu-S966014AbXEVPx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966014AbXEVPx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763918AbXEVPxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:53:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761285AbXEVPxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:53:49 -0400
Message-ID: <465311E7.3080608@cv-sv.de>
Date: Tue, 22 May 2007 17:53:11 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Claas Langbehn <claas@rootdir.de>
CC: Artur Kedzierski <artur@kedzierski.org>, linux-kernel@vger.kernel.org
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
References: <Pine.LNX.4.64.0705191820100.11197@merry.kedzierski.org> <465293FA.1040909@rootdir.de>
In-Reply-To: <465293FA.1040909@rootdir.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19jEdFlWvhQs8ThBQufnu/4gxgskZCjNAduhkS
 Z/HYh4opnZaa3wZo88lqjBZj/X7N7pM0YioyxponviCKtJWSNR
 frT/5w2V8FPv5s/htWwxw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Claas Langbehn wrote:
> Could anyone explain to me what CMPXCHG64 / cx8 is and what happens if
> the kernel has been compiled to use it but the CPU does not have it?
> 
> Regards,
> claas
> 


Hi Claas,

the bug is at another place. But it's hidden if X86_CMPXCHG64 is
switched of.

There are 3 errors.

First: Via is capable of CMPXCHG64, but switch the related CPU bit off
to work with old Win NT versions. ( So the NT error is the fourth... but who cares
about that error. ;-) )

Second:  verify_cpu.S
This checks during the boot the capability of the CPU. It expected
the related bit, but... see first.
This error is switched of if X86_CMPXCHG64 is disabled.

Third: setup.S "PANIC: CPU too old for this kernel." is not printed
cause of a missing set register in setup.S.


As I have learned the NX-bit of the C7 is a BIOS issue.

The only real required patch is below. It enables the right bits for the C3/C7.

The first error is out of scope, and the fix for the "CPU too old.." is for
me just a cosmetic print out in case of boot errors.

I suppose .rc3 should contain a fix for this bug.


Best regards,

Christian







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
