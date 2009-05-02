Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbZEBUZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbZEBUZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbZEBUY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:24:57 -0400
Received: from www.tglx.de ([62.245.132.106]:39591 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759259AbZEBUY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:24:56 -0400
Message-Id: <20090502202317.506137353@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:23:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Luck <tony.luck@intel.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch] remove put_cpu_no_resched() [ Resend ]
References: <20090502202312.124351431@linutronix.de>
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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 arch/ia64/kernel/perfmon.c |    2 +-
 fs/nfs/iostat.h            |    4 ++--
 include/linux/smp.h        |    1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

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
 
Index: linux-2.6/fs/nfs/iostat.h
===================================================================
--- linux-2.6.orig/fs/nfs/iostat.h
+++ linux-2.6/fs/nfs/iostat.h
@@ -31,7 +31,7 @@ static inline void nfs_inc_server_stats(
 	cpu = get_cpu();
 	iostats = per_cpu_ptr(server->io_stats, cpu);
 	iostats->events[stat]++;
-	put_cpu_no_resched();
+	put_cpu();
 }
 
 static inline void nfs_inc_stats(const struct inode *inode,
@@ -50,7 +50,7 @@ static inline void nfs_add_server_stats(
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
@@ -177,7 +177,6 @@ static inline void init_call_single_data
 
 #define get_cpu()		({ preempt_disable(); smp_processor_id(); })
 #define put_cpu()		preempt_enable()
-#define put_cpu_no_resched()	preempt_enable_no_resched()
 
 /*
  * Callback to arch code if there's nosmp or maxcpus=0 on the


