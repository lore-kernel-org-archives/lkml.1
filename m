Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYJ3S03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYJ3S03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYJ3S0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:26:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33487 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbYJ3S0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:26:19 -0400
Date: Thu, 30 Oct 2008 19:26:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/cpu.c: Section mismatch warning fix.
Message-ID: <20081030182601.GE14102@elte.hu>
References: <b9df5fa10810292104h38fcee68kae42cf5ab6275fbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10810292104h38fcee68kae42cf5ab6275fbb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

>  LD      kernel/built-in.o
> WARNING: kernel/built-in.o(.text+0xb7c8): Section mismatch in
> reference from the function notify_cpu_starting() to the variable
> .cpuinit.data:cpu_chain
> The function notify_cpu_starting() references
> the variable __cpuinitdata cpu_chain.
> This is often because notify_cpu_starting lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
> 
> This patch fixes the above section mismatch warning. If anything else
> please notice.
> Thanks.
> 
> Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/kernel/cpu.c	2008-10-28 20:52:38.000000000 +0600
> +++ linux-2.6/kernel/cpu.c	2008-10-28 22:46:22.000000000 +0600
> @@ -462,7 +462,7 @@ out:
>   * It must be called by the arch code on the new cpu, before the new cpu
>   * enables interrupts and before the "boot" cpu returns from __cpu_up().
>   */
> -void notify_cpu_starting(unsigned int cpu)
> +void __cpuinit notify_cpu_starting(unsigned int cpu)
>  {
>  	unsigned long val = CPU_STARTING;

you've tested that on x86, right? Have you checked/reviewed all the 
non-x86 architecture codepaths:

 ./arch/m32r/kernel/smpboot.c:	notify_cpu_starting(cpu_id);
 ./arch/cris/arch-v32/kernel/smp.c:	notify_cpu_starting(cpu);
 ./arch/s390/kernel/smp.c:	 notify_cpu_starting(smp_processor_id());
 ./arch/x86/mach-voyager/voyager_smp.c:	notify_cpu_starting(cpuid);
 ./arch/x86/kernel/smpboot.c:	notify_cpu_starting(cpuid);
 ./arch/mips/kernel/smp.c:	notify_cpu_starting(cpu);
 ./arch/sparc64/kernel/smp.c:	notify_cpu_starting(cpuid);
 ./arch/ia64/kernel/smpboot.c:	notify_cpu_starting(cpuid);
 ./arch/um/kernel/smp.c:	notify_cpu_starting(cpu);
 ./arch/sparc/kernel/sun4d_smp.c:	notify_cpu_starting(cpuid);
 ./arch/sparc/kernel/sun4m_smp.c:	notify_cpu_starting(cpuid);
 ./arch/powerpc/kernel/smp.c:	notify_cpu_starting(cpu);
 ./arch/alpha/kernel/smp.c:	notify_cpu_starting(cpuid);
 ./arch/sh/kernel/smp.c:	notify_cpu_starting(smp_processor_id());
 ./arch/arm/kernel/smp.c:	notify_cpu_starting(cpu);

to make sure that they never use this function after free_initmem()?

	Ingo
