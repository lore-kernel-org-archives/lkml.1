Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZBDA1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZBDA1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZBDA1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:27:43 -0500
Received: from www.tglx.de ([62.245.132.106]:51123 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZBDA1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:27:42 -0500
Message-Id: <20090204001840.664546943@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 04 Feb 2009 00:27:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Luck <tony.luck@intel.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch] remove put_cpu_no_resched()
Content-Disposition: inline; filename=remove-put-cpu-no-resched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove a high latency source

put_cpu_no_resched() is an optimization of put_cpu() which
unfortunately can cause high latencies.

The nfs iostats code uses put_cpu_no_resched() in a code sequence
where a reschedule request caused by an interrupt between the
get_cpu() and the put_cpu_no_resched() can delay the reschedule for at
least HZ.

The other users of put_cpu_no_resched() optimize correctly in
interrupt code, but there is no real harm in using the put_cpu()
function which is an alias for preempt_enable(). The extra check of the
preemmpt count is not as critical as the potential source of missing a
reschedule.

Debugged in the preempt-rt tree and verified in mainline.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 arch/ia64/kernel/perfmon.c          |    2 +-
 arch/x86/kernel/tlb_32.c            |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 fs/nfs/iostat.h                     |    4 ++--
 include/linux/smp.h                 |    1 -
 5 files changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c
+++ linux-2.6/arch/ia64/kernel/perfmon.c
@@ -5595,7 +5595,7 @@ pfm_interrupt_handler(int irq, void *arg
 		(*pfm_alt_intr_handler->handler)(irq, arg, regs);
 	}
 
-	put_cpu_no_resched();
+	put_cpu();
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/x86/kernel/tlb_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tlb_32.c
+++ linux-2.6/arch/x86/kernel/tlb_32.c
@@ -117,7 +117,7 @@ void smp_invalidate_interrupt(struct pt_
 	cpu_clear(cpu, flush_cpumask);
 	smp_mb__after_clear_bit();
 out:
-	put_cpu_no_resched();
+	put_cpu();
 	inc_irq_stat(irq_tlb_count);
 }
 
Index: linux-2.6/arch/x86/mach-voyager/voyager_smp.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-2.6/arch/x86/mach-voyager/voyager_smp.c
@@ -940,7 +940,7 @@ static void smp_enable_irq_interrupt(voi
 	vic_irq_enable_mask[cpu] = 0;
 	spin_unlock(&vic_irq_lock);
 
-	put_cpu_no_resched();
+	put_cpu();
 }
 
 /*
Index: linux-2.6/fs/nfs/iostat.h
===================================================================
--- linux-2.6.orig/fs/nfs/iostat.h
+++ linux-2.6/fs/nfs/iostat.h
@@ -28,7 +28,7 @@ static inline void nfs_inc_server_stats(
 	cpu = get_cpu();
 	iostats = per_cpu_ptr(server->io_stats, cpu);
 	iostats->events[stat]++;
-	put_cpu_no_resched();
+	put_cpu();
 }
 
 static inline void nfs_inc_stats(const struct inode *inode,
@@ -47,7 +47,7 @@ static inline void nfs_add_server_stats(
 	cpu = get_cpu();
 	iostats = per_cpu_ptr(server->io_stats, cpu);
 	iostats->bytes[stat] += addend;
-	put_cpu_no_resched();
+	put_cpu();
 }
 
 static inline void nfs_add_stats(const struct inode *inode,
Index: linux-2.6/include/linux/smp.h
===================================================================
--- linux-2.6.orig/include/linux/smp.h
+++ linux-2.6/include/linux/smp.h
@@ -174,7 +174,6 @@ static inline void init_call_single_data
 
 #define get_cpu()		({ preempt_disable(); smp_processor_id(); })
 #define put_cpu()		preempt_enable()
-#define put_cpu_no_resched()	preempt_enable_no_resched()
 
 void smp_setup_processor_id(void);
 


