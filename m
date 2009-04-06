Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbZDFJth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbZDFJth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZDFJos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:42362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZDFJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:39 -0400
Message-Id: <20090406094518.083139737@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/15] perf_counter: counter overflow limit
Content-Disposition: inline; filename=perf_counter-event_limit.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide means to auto-disable the counter after 'n' overflow events.

Create the counter with hw_event.disabled = 1, and then issue an
ioctl(fd, PREF_COUNTER_IOC_REFRESH, n); to set the limit and enable
the counter.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   12 +++++++---
 kernel/perf_counter.c        |   51 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 50 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -155,8 +155,9 @@ struct perf_counter_hw_event {
 /*
  * Ioctls that can be done on a perf counter fd:
  */
-#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
-#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
+#define PERF_COUNTER_IOC_ENABLE		_IO ('$', 0)
+#define PERF_COUNTER_IOC_DISABLE	_IO ('$', 1)
+#define PERF_COUNTER_IOC_REFRESH	_IOW('$', 2, u32)
 
 /*
  * Structure of the page that can be mapped via mmap
@@ -403,9 +404,14 @@ struct perf_counter {
 	/* poll related */
 	wait_queue_head_t		waitq;
 	struct fasync_struct		*fasync;
-	/* optional: for NMIs */
+
+	/* delayed work for NMIs and such */
+	int				pending_wakeup;
+	int				pending_disable;
 	struct perf_pending_entry	pending;
 
+	atomic_t			event_limit;
+
 	void (*destroy)(struct perf_counter *);
 	struct rcu_head			rcu_head;
 #endif
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -744,6 +744,12 @@ static void perf_counter_enable(struct p
 	spin_unlock_irq(&ctx->lock);
 }
 
+static void perf_counter_refresh(struct perf_counter *counter, int refresh)
+{
+	atomic_add(refresh, &counter->event_limit);
+	perf_counter_enable(counter);
+}
+
 /*
  * Enable a counter and all its children.
  */
@@ -1311,6 +1317,9 @@ static long perf_ioctl(struct file *file
 	case PERF_COUNTER_IOC_DISABLE:
 		perf_counter_disable_family(counter);
 		break;
+	case PERF_COUNTER_IOC_REFRESH:
+		perf_counter_refresh(counter, arg);
+		break;
 	default:
 		err = -ENOTTY;
 	}
@@ -1590,14 +1599,6 @@ void perf_counter_wakeup(struct perf_cou
 	kill_fasync(&counter->fasync, SIGIO, POLL_IN);
 }
 
-static void perf_pending_wakeup(struct perf_pending_entry *entry)
-{
-	struct perf_counter *counter = container_of(entry,
-			struct perf_counter, pending);
-
-	perf_counter_wakeup(counter);
-}
-
 /*
  * Pending wakeups
  *
@@ -1607,6 +1608,22 @@ static void perf_pending_wakeup(struct p
  * single linked list and use cmpxchg() to add entries lockless.
  */
 
+static void perf_pending_counter(struct perf_pending_entry *entry)
+{
+	struct perf_counter *counter = container_of(entry,
+			struct perf_counter, pending);
+
+	if (counter->pending_disable) {
+		counter->pending_disable = 0;
+		perf_counter_disable(counter);
+	}
+
+	if (counter->pending_wakeup) {
+		counter->pending_wakeup = 0;
+		perf_counter_wakeup(counter);
+	}
+}
+
 #define PENDING_TAIL ((struct perf_pending_entry *)-1UL)
 
 static DEFINE_PER_CPU(struct perf_pending_entry *, perf_pending_head) = {
@@ -1715,8 +1732,9 @@ struct perf_output_handle {
 static inline void __perf_output_wakeup(struct perf_output_handle *handle)
 {
 	if (handle->nmi) {
+		handle->counter->pending_wakeup = 1;
 		perf_pending_queue(&handle->counter->pending,
-				   perf_pending_wakeup);
+				   perf_pending_counter);
 	} else
 		perf_counter_wakeup(handle->counter);
 }
@@ -2063,8 +2081,21 @@ void perf_counter_munmap(unsigned long a
 int perf_counter_overflow(struct perf_counter *counter,
 			  int nmi, struct pt_regs *regs)
 {
+	int events = atomic_read(&counter->event_limit);
+	int ret = 0;
+
+	if (events && atomic_dec_and_test(&counter->event_limit)) {
+		ret = 1;
+		if (nmi) {
+			counter->pending_disable = 1;
+			perf_pending_queue(&counter->pending,
+					   perf_pending_counter);
+		} else
+			perf_counter_disable(counter);
+	}
+
 	perf_counter_output(counter, nmi, regs);
-	return 0;
+	return ret;
 }
 
 /*

-- 

