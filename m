Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbXEOAPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbXEOAPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbXEOAPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:15:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:34629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760642AbXEOAPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:15:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,533,1170662400"; 
   d="scan'208";a="228049447"
Date: Mon, 14 May 2007 17:12:50 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: akpm@linux-foundation.org, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Christoph Lameter <clameter@sgi.com>, kiran@scalex86.org,
       linux-kernel@vger.kernel.org
Cc: fenghua.yu@intel.com
Subject: [PATCH 2/2] Use the new percpu interface for shared data -- version 2
Message-ID: <20070515001250.GA29172@linux-os.sc.intel.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com> <20070505001222.GA26142@linux-os.sc.intel.com> <Pine.LNX.4.64.0705050951040.27326@schroedinger.engr.sgi.com> <20070507171129.GA21638@linux-os.sc.intel.com> <Pine.LNX.4.64.0705071029470.5447@schroedinger.engr.sgi.com> <20070507174608.GB21638@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507174608.GB21638@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently most of the per cpu data, which is accessed by different cpus, has a
____cacheline_aligned_in_smp attribute. Move all this data to the new per cpu
shared data section: .data.percpu.shared_aligned.

This will seperate  the percpu data which is referenced frequently by other cpus
from the local only percpu data.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

---

 arch/i386/kernel/init_task.c   |    2 +-
 arch/i386/kernel/irq.c         |    2 +-
 arch/ia64/kernel/smp.c         |    2 +-
 arch/x86_64/kernel/init_task.c |    2 +-
 kernel/sched.c                 |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -Nurp linux-2.6.21-rc7.0/arch/i386/kernel/init_task.c linux-2.6.21-rc7.1/arch/i386/kernel/init_task.c
--- linux-2.6.21-rc7.0/arch/i386/kernel/init_task.c	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/i386/kernel/init_task.c	2007-05-14 12:44:43.000000000 -0700
@@ -42,5 +42,5 @@ EXPORT_SYMBOL(init_task);
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's.
  */ 
-DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
diff -Nurp linux-2.6.21-rc7.0/arch/i386/kernel/irq.c linux-2.6.21-rc7.1/arch/i386/kernel/irq.c
--- linux-2.6.21-rc7.0/arch/i386/kernel/irq.c	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/i386/kernel/irq.c	2007-05-14 12:44:43.000000000 -0700
@@ -21,7 +21,7 @@
 #include <asm/apic.h>
 #include <asm/uaccess.h>
 
-DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
+DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
diff -Nurp linux-2.6.21-rc7.0/arch/ia64/kernel/smp.c linux-2.6.21-rc7.1/arch/ia64/kernel/smp.c
--- linux-2.6.21-rc7.0/arch/ia64/kernel/smp.c	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/ia64/kernel/smp.c	2007-05-14 12:44:43.000000000 -0700
@@ -70,7 +70,7 @@ static volatile struct call_data_struct 
 #define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
-static DEFINE_PER_CPU(u64, ipi_operation) ____cacheline_aligned;
+static DEFINE_PER_CPU_SHARED_ALIGNED(u64, ipi_operation);
 
 extern void cpu_halt (void);
 
diff -Nurp linux-2.6.21-rc7.0/arch/x86_64/kernel/init_task.c linux-2.6.21-rc7.1/arch/x86_64/kernel/init_task.c
--- linux-2.6.21-rc7.0/arch/x86_64/kernel/init_task.c	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/x86_64/kernel/init_task.c	2007-05-14 12:44:43.000000000 -0700
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(init_task);
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */ 
-DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
 /* Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
diff -Nurp linux-2.6.21-rc7.0/kernel/sched.c linux-2.6.21-rc7.1/kernel/sched.c
--- linux-2.6.21-rc7.0/kernel/sched.c	2007-05-01 07:33:07.000000000 -0700
+++ linux-2.6.21-rc7.1/kernel/sched.c	2007-05-14 12:44:43.000000000 -0700
@@ -263,7 +263,7 @@ struct rq {
 	struct lock_class_key rq_lock_key;
 };
 
-static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline int cpu_of(struct rq *rq)
