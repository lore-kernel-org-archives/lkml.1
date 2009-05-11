Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZEKMQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZEKMQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbZEKMPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:15:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:35703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbZEKMPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:15:33 -0400
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
 X86_FEATURE_ARCH_PERFMON flag for AMD cpus
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090510063047.GD30778@elte.hu>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
	 <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org>
	 <1241931753.4796.15.camel@localhost.localdomain>
	 <1241934795.4796.55.camel@localhost.localdomain>
	 <20090510063047.GD30778@elte.hu>
Content-Type: text/plain
Date: Mon, 11 May 2009 17:43:44 +0530
Message-Id: <1242044024.10115.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 08:30 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
> > > should be replaced by
> > > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Performace Monitor */
> > > 
> > > All x86 cpus which support performance monitor should set this feature.
> > > 
> > 
> > Currently X86_FEATURE_ARCH_PERFMON is enabled for >= Intel Core2
> > 
> > But Performance monitor is almost supported by all Intel 
> > processors. I am adding few MSRs list for reference to see 
> > complete list please check arch/x86/kernel/cpu/cpu_debug.c
> 
> I think you are confusing two things:
> 
> - The 'architectural perfmon' CPU flag, enumerated in CPUID. (this 
>   is a relatively new CPUID flag that only Intel CPUs at around 
>   Core2 and later will report.)
> 
> - The concept of 'performance monitoring' - which has been present 
>   in various x86 CPUs starting at the original Pentium (P5) 15 years 
>   ago or so.
> 

Here is the patch for review for ancient performance monitoring
cpufeature, complete cpu_debug and cpu_feature patches are available
at :
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=summary

Subject: [PATCH] x86: Add cpufeature for ancient performance monitoring

X86_FEATURE_ARCH_PERFMON uses almost different MSRs as compare to
ancient performance monitoring, so introduced X86_FEATURE_PERFMON
to friendly access ancient performance monitor MSRs:

X86_FEATURE_PERFMON : performance monitoring for !X86_FEATURE_ARCH_PERFMON

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    2 ++
 arch/x86/kernel/cpu/intel.c       |    4 +++-
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 12fc758..3d5170b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -169,6 +169,7 @@
 #define X86_FEATURE_MM_CFG 	(7*32+ 14) /* MM configuration		*/
 #define X86_FEATURE_BUS_CFG 	(7*32+ 15) /* Bus configuration		*/
 #define X86_FEATURE_PERF_FREQ 	(7*32+ 16) /* Performance frequency	*/
+#define X86_FEATURE_PERFMON 	(7*32+ 17) /* Performance monitoring	*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4b7f7dc..849d794 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -481,6 +481,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 7) {				/* K7+		*/
 		/* MSRC001_0015 Hardware Configuration Register (HWCR)	*/
 		set_cpu_cap(c, X86_FEATURE_HW_CFG);
+		/* Performance monitoring support			*/
+		set_cpu_cap(c, X86_FEATURE_PERFMON);
 	}
 	if (c->x86 >= 8) {				/* K8+		*/
 		/*
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 33ad800..c2f16b9 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -333,7 +333,9 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		/* Check for version and the number of counters */
 		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
-	}
+	} else if (c->x86 >= 5)
+		/* ancient performance monitoring support */
+		set_cpu_cap(c, X86_FEATURE_PERFMON);
 
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-- 
1.6.0.6



