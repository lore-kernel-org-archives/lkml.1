Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbZDGJKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbZDGJKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZDGJJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:09:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:47047 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbZDGJI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:08:59 -0400
Date: Tue, 7 Apr 2009 09:08:25 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094518.083139737@chello.nl>
References: <20090406094518.083139737@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: counter overflow limit
Message-ID: <tip-79f146415623fe74f39af67c0f6adc208939a410@git.kernel.org>
Git-Commit-ID: 79f146415623fe74f39af67c0f6adc208939a410
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:08:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79f146415623fe74f39af67c0f6adc208939a410
Gitweb:     http://git.kernel.org/tip/79f146415623fe74f39af67c0f6adc208939a410
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:58 +0200

perf_counter: counter overflow limit

Provide means to auto-disable the counter after 'n' overflow events.

Create the counter with hw_event.disabled = 1, and then issue an
ioctl(fd, PREF_COUNTER_IOC_REFRESH, n); to set the limit and enable
the counter.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094518.083139737@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   12 +++++++--
 kernel/perf_counter.c        |   51 +++++++++++++++++++++++++++++++++--------
 2 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 928a7fa..ef4dcbf 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 19990d1..c05e103 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -744,6 +744,12 @@ static void perf_counter_enable(struct perf_counter *counter)
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
@@ -1311,6 +1317,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_COUNTER_IOC_DISABLE:
 		perf_counter_disable_family(counter);
 		break;
+	case PERF_COUNTER_IOC_REFRESH:
+		perf_counter_refresh(counter, arg);
+		break;
 	default:
 		err = -ENOTTY;
 	}
@@ -1590,14 +1599,6 @@ void perf_counter_wakeup(struct perf_counter *counter)
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
@@ -1607,6 +1608,22 @@ static void perf_pending_wakeup(struct perf_pending_entry *entry)
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
@@ -2063,8 +2081,21 @@ void perf_counter_munmap(unsigned long addr, unsigned long len,
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
