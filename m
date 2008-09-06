Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbYIFNaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYIFNaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 09:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYIFNaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 09:30:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYIFNaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 09:30:05 -0400
Date: Sat, 6 Sep 2008 15:29:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       Jes Sorensen <jes@sgi.com>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smp: reduce stack requirements for
	smp_call_function_mask
Message-ID: <20080906132944.GC4910@elte.hu>
References: <20080905214019.821172000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905214019.821172000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

>   * Cleanup cpumask_t usages in smp_call_function_mask function chain
>     to prevent stack overflow problem when NR_CPUS=4096.
> 
>   * Reduce the number of passed cpumask_t variables in the following
>     call chain for x86_64:
> 
> 	smp_call_function_mask -->
> 	    arch_send_call_function_ipi->
> 		    smp_ops.send_call_func_ipi -->
> 			    genapic->send_IPI_mask
> 
>     Since the smp_call_function_mask() is an EXPORTED function, we
>     cannot change it's calling interface for a patch to 2.6.27.
> 
>     The smp_ops.send_call_func_ipi interface is internal only and
>     has two arch provided functions:
> 
> 	arch/x86/kernel/smp.c:  .send_call_func_ipi = native_send_call_func_ipi
> 	arch/x86/xen/smp.c:     .send_call_func_ipi = xen_smp_send_call_function_ipi
> 	arch/x86/mach-voyager/voyager_smp.c:    (uses native_send_call_func_ipi)
> 
>     Therefore modifying the internal interface to use a cpumask_t pointer
>     is straight-forward.
> 
>     The changes to genapic are much more extensive and are affected by the
>     recent additions of the x2apic modes, so they will be done for 2.6.28 only.
> 
> Based on 2.6.27-rc5-git6.
> 
> Applies to linux-2.6.tip/master (with FUZZ).

applied to tip/cpus4096, thanks Mike.

I'm still wondering whether we should get rid of non-reference based 
cpumask_t altogether ...

Did you have a chance to look at the ftrace/stacktrace tracer in latest 
tip/master, which will show the maximum stack footprint that can occur?

Also, i've applied the patch below as well to restore MAXSMP in a muted 
form - with big warning signs added as well.

	Ingo

-------------->
>From 363a5e3d7b4b69371f21bcafd7fc76e68c73733a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 6 Sep 2008 15:24:52 +0200
Subject: [PATCH] x86: add MAXSMP

restore MAXSMP, it's a nice debugging helper to trigger various crashes
and problems with maximum sized x86 systems.

Make it depend on EXPERIMENTAL and DEBUG_KERNEL, and inform the user
about the effects (stacksize, overhead, memory usage) of this flag.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed97f2b..91212c1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -580,10 +580,15 @@ config IOMMU_HELPER
 
 config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
-	depends on X86_64 && SMP && BROKEN
-	default n
+	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
 	help
-	  Configure maximum number of CPUS and NUMA Nodes for this architecture.
+	  Configure maximum number of CPUS and NUMA Nodes for this
+	  architecture (up to 4096!).
+
+	  This can increase memory usage, bigger stack footprint and can
+	  add some runtime overhead as well so unless you want a generic
+	  distro kernel you likely want to say N.
+
 	  If unsure, say N.
 
 config NR_CPUS
