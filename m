Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbXA1MMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbXA1MMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXA1MLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:11:41 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:10126 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752417AbXA1ML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:11:28 -0500
Message-Id: <20070128120509.719287000@programming.kicks-ass.net>
References: <20070128115118.837777000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 12:51:21 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/7] barrier: a scalable synchonisation barrier
Content-Disposition: inline; filename=barrier.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This barrier thing is constructed so that it will not write in the sync()
condition (the hot path) when there are no active lock sections; thus avoiding
cacheline bouncing. -- I'm just not sure how this will work out in relation to
PI. We might track those in the barrier scope and boost those by the max prio
of the blockers.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/barrier.h |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

Index: linux/include/linux/barrier.h
===================================================================
--- /dev/null
+++ linux/include/linux/barrier.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) 2006, Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Licenced under the GPLv2.
+ *
+ * simple synchonisation barrier
+ *
+ * The sync() operation will wait for completion of all lock sections if any.
+ *
+ * The lock sections are intended to be rare and the sync operation frequent.
+ * This construct is created to be scalable and does only 1 read in the fast
+ * path (sync), hence avoiding cacheline bounces.
+ *
+ * NOTE: it _synchronisation_ only, so if there are serialisation requirements
+ * those must be met by something external to this construct.
+ */
+#ifndef _LINUX_BARRIER_H
+#define _LINUX_BARRIER_H
+
+#ifdef __KERNEL__
+
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+
+struct barrier {
+	atomic_t count;
+	wait_queue_head_t wait;
+};
+
+static inline void init_barrier(struct barrier *b)
+{
+	atomic_set(&b->count, 0);
+	init_waitqueue_head(&b->wait);
+	__acquire(b);
+}
+
+static inline void barrier_lock(struct barrier *b)
+{
+	__release(b);
+	atomic_inc(&b->count);
+	smp_wmb();
+}
+
+static inline void barrier_unlock(struct barrier *b)
+{
+	smp_wmb();
+	if (atomic_dec_and_test(&b->count))
+		__wake_up(&b->wait, TASK_INTERRUPTIBLE|TASK_UNINTERRUPTIBLE, 0, b);
+}
+
+static inline void barrier_sync(struct barrier *b)
+{
+	might_sleep();
+
+	if (unlikely(atomic_read(&b->count))) {
+		DEFINE_WAIT(wait);
+		prepare_to_wait(&b->wait, &wait, TASK_UNINTERRUPTIBLE);
+		while (atomic_read(&b->count))
+			schedule();
+		finish_wait(&b->wait, &wait);
+	}
+}
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_BARRIER_H */

--

