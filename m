Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYHRVwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYHRVwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYHRVuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:50:16 -0400
Received: from adsl-69-107-80-255.dsl.pltn13.pacbell.net ([69.107.80.255]:45360
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753735AbYHRVuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:50:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 9] x86: put tlb_flush_others() stats in debugfs
X-Mercurial-Node: a1d333f4292ce097ab98aaae0e9550328008bfff
Message-Id: <a1d333f4292ce097ab98.1219083818@localhost>
In-Reply-To: <patchbomb.1219083817@localhost>
Date: Mon, 18 Aug 2008 11:23:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put tlb_flush_others() latency measurements in debugfs.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/tlb_64.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -7,6 +7,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/interrupt.h>
+#include <linux/debugfs.h>
 
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
@@ -17,6 +18,8 @@
 #include <asm/idle.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_bau.h>
+
+#include <asm/timer.h>
 
 #include <mach_ipi.h>
 /*
@@ -157,15 +160,29 @@
 	add_pda(irq_tlb_count, 1);
 }
 
+#ifdef CONFIG_DEBUG_FS
+static spinlock_t tlbflush_others_lock = __SPIN_LOCK_UNLOCKED(tlb_flush_others_lock);
+static u32 tlbflush_others_count;
+static u64 tlbflush_others_accum;
+static u8 tlbflush_others_enable;
+#else
+#define tlbflush_others_enable 0
+#endif
+
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 			     unsigned long va)
 {
 	int sender;
 	union smp_flush_state *f;
 	cpumask_t cpumask = *cpumaskp;
+	u8 timing_enabled = tlbflush_others_enable;
+	u64 uninitialized_var(start), end;
 
 	if (is_uv_system() && uv_flush_tlb_others(&cpumask, mm, va))
 		return;
+
+	if (timing_enabled)
+		rdtscll(start);
 
 	/* Caller has disabled preemption */
 	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
@@ -194,6 +211,15 @@
 	f->flush_mm = NULL;
 	f->flush_va = 0;
 	spin_unlock(&f->tlbstate_lock);
+
+	if (timing_enabled) {
+		rdtscll(end);
+
+		spin_lock(&tlbflush_others_lock);
+		tlbflush_others_count++;
+		tlbflush_others_accum += cycles_2_ns(end - start);
+		spin_unlock(&tlbflush_others_lock);
+	}
 }
 
 static int __cpuinit init_smp_flush(void)
@@ -277,3 +303,15 @@
 {
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
+
+#ifdef CONFIG_DEBUG_FS
+static int __init init_tlbflush_time(void)
+{
+	debugfs_create_u8("tlbflush_others_enable", 0644, NULL, &tlbflush_others_enable);
+	debugfs_create_u32("tlbflush_others_count", 0644, NULL, &tlbflush_others_count);
+	debugfs_create_u64("tlbflush_others_accum", 0644, NULL, &tlbflush_others_accum);
+
+	return 0;
+}
+fs_initcall(init_tlbflush_time);
+#endif


