Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbZKPMGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbZKPMGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZKPMGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:06:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:37595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZKPMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:06:14 -0500
Subject: [PATCH] perf: optimize perf_output_lock
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 13:06:01 +0100
Message-ID: <1258373161.26714.254.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf: optimize perf_output_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Nov 16 12:45:14 CET 2009

The purpuse of perf_output_{un,}lock() is to:

 1) avoid publishing incomplete data
    [ possible when publishing a head that is ahead of an entry
      that is still being written ]

 2) guarantee fwd progress
    [ a simple refcount on pending writers doesn't need to drop to
      0, making it so would end up implementing something like forced
      quiecent states of RCU ]

To satisfy the above without undue complexity it serializes between
CPUs, this means that a pending writer can only be the same cpu in a
nested context, and since (under normal operation) a cpu always makes
progress we're good -- if the head is only published when the bottom 
most writer completes.

Now we don't need to disable IRQs in order to serialize between CPUs,
disabling preemption ought to be sufficient, esp since we already deal
with nesting due to NMIs.

This avoids expensive IRQ ops.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    1 -
 kernel/perf_event.c        |   21 +++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -739,7 +739,6 @@ struct perf_output_handle {
 	int				nmi;
 	int				sample;
 	int				locked;
-	unsigned long			flags;
 };
 
 #ifdef CONFIG_PERF_EVENTS
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2696,20 +2696,21 @@ static void perf_output_wakeup(struct pe
 static void perf_output_lock(struct perf_output_handle *handle)
 {
 	struct perf_mmap_data *data = handle->data;
-	int cpu;
+	int cur, cpu = get_cpu();
 
 	handle->locked = 0;
 
-	local_irq_save(handle->flags);
-	cpu = smp_processor_id();
-
-	if (in_nmi() && atomic_read(&data->lock) == cpu)
-		return;
+	for (;;) {
+		cur = atomic_cmpxchg(&data->lock, -1, cpu);
+		if (cur == -1) {
+			handle->locked = 1;
+			break;
+		}
+		if (cur == cpu)
+			break;
 
-	while (atomic_cmpxchg(&data->lock, -1, cpu) != -1)
 		cpu_relax();
-
-	handle->locked = 1;
+	}
 }
 
 static void perf_output_unlock(struct perf_output_handle *handle)
@@ -2755,7 +2756,7 @@ again:
 	if (atomic_xchg(&data->wakeup, 0))
 		perf_output_wakeup(handle);
 out:
-	local_irq_restore(handle->flags);
+	put_cpu();
 }
 
 void perf_output_copy(struct perf_output_handle *handle,


