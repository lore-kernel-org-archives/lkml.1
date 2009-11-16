Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZKPQKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZKPQKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZKPQKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:10:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:35295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZKPQKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:10:30 -0500
Date: Mon, 16 Nov 2009 16:09:47 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258373161.26714.254.camel@laptop>
References: <1258373161.26714.254.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: Optimize perf_output_lock()
Message-ID: <tip-559fdc3c1b624edb1933a875022fe7e27934d11c@git.kernel.org>
Git-Commit-ID: 559fdc3c1b624edb1933a875022fe7e27934d11c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  559fdc3c1b624edb1933a875022fe7e27934d11c
Gitweb:     http://git.kernel.org/tip/559fdc3c1b624edb1933a875022fe7e27934d11c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 16 Nov 2009 12:45:14 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 13:27:45 +0100

perf_event: Optimize perf_output_lock()

The purpose of perf_output_{un,}lock() is to:

 1) avoid publishing incomplete data
    [ possible when publishing a head that is ahead of an entry
      that is still being written ]

 2) guarantee fwd progress
    [ a simple refcount on pending writers doesn't need to drop to
      0, making it so would end up implementing something like forced
      quiecent states of RCU ]

To satisfy the above without undue complexity it serializes
between CPUs, this means that a pending writer can only be the
same cpu in a nested context, and since (under normal operation)
a cpu always makes progress we're good -- if the head is only
published when the bottom  most writer completes.

Now we don't need to disable IRQs in order to serialize between
CPUs, disabling preemption ought to be sufficient, esp since we
already deal with nesting due to NMIs.

This avoids potentially expensive (and needless) local IRQ
disable/enable ops.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1258373161.26714.254.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 -
 kernel/perf_event.c        |   21 +++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index df4e73e..7f87563 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -714,7 +714,6 @@ struct perf_output_handle {
 	int				nmi;
 	int				sample;
 	int				locked;
-	unsigned long			flags;
 };
 
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6f4ed3b..3256e36 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2674,20 +2674,21 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
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
@@ -2733,7 +2734,7 @@ again:
 	if (atomic_xchg(&data->wakeup, 0))
 		perf_output_wakeup(handle);
 out:
-	local_irq_restore(handle->flags);
+	put_cpu();
 }
 
 void perf_output_copy(struct perf_output_handle *handle,
