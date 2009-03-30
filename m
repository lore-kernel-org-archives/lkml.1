Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZC3RPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZC3RPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZC3RLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZC3RLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:24 -0400
Message-Id: <20090330171023.241410660@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/15] perf_counter: fix update_userpage()
Content-Disposition: inline; filename=perf_counter-fix-update_userpage.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It just occured to me it is possible to have multiple contending
updates of the userpage (mmap information vs overflow vs counter).
This would break the seqlock logic.

It appear the arch code uses this from NMI context, so we cannot
possibly serialize its use, therefore separate the data_head update
from it and let it return to its original use.

The arch code needs to make sure there are no contending callers by
disabling the counter before using it -- powerpc appears to do this
nicely.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_counter.h |   35 +++++++++++++++++++++++++++++++++++
 kernel/perf_counter.c        |   38 +++++++++++++++++++++++---------------
 2 files changed, 58 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -160,10 +160,45 @@ struct perf_counter_hw_event {
 struct perf_counter_mmap_page {
 	__u32	version;		/* version number of this structure */
 	__u32	compat_version;		/* lowest version this is compat with */
+
+	/*
+	 * Bits needed to read the hw counters in user-space.
+	 *
+	 * The index and offset should be read atomically using the seqlock:
+	 *
+	 *   __u32 seq, index;
+	 *   __s64 offset;
+	 *
+	 * again:
+	 *   rmb();
+	 *   seq = pc->lock;
+	 *
+	 *   if (unlikely(seq & 1)) {
+	 *     cpu_relax();
+	 *     goto again;
+	 *   }
+	 *
+	 *   index = pc->index;
+	 *   offset = pc->offset;
+	 *
+	 *   rmb();
+	 *   if (pc->lock != seq)
+	 *     goto again;
+	 *
+	 * After this, index contains architecture specific counter index + 1,
+	 * so that 0 means unavailable, offset contains the value to be added
+	 * to the result of the raw timer read to obtain this counter's value.
+	 */
 	__u32	lock;			/* seqlock for synchronization */
 	__u32	index;			/* hardware counter identifier */
 	__s64	offset;			/* add to hardware counter value */
 
+	/*
+	 * Control data for the mmap() data buffer.
+	 *
+	 * User-space reading this value should issue an rmb(), on SMP capable
+	 * platforms, after reading this value -- see perf_counter_wakeup().
+	 */
 	__u32   data_head;		/* head in the data section */
 };
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1316,10 +1316,22 @@ static long perf_ioctl(struct file *file
 	return err;
 }
 
-static void __perf_counter_update_userpage(struct perf_counter *counter,
-					   struct perf_mmap_data *data)
+/*
+ * Callers need to ensure there can be no nesting of this function, otherwise
+ * the seqlock logic goes bad. We can not serialize this because the arch
+ * code calls this from NMI context.
+ */
+void perf_counter_update_userpage(struct perf_counter *counter)
 {
-	struct perf_counter_mmap_page *userpg = data->user_page;
+	struct perf_mmap_data *data;
+	struct perf_counter_mmap_page *userpg;
+
+	rcu_read_lock();
+	data = rcu_dereference(counter->data);
+	if (!data)
+		goto unlock;
+
+	userpg = data->user_page;
 
 	/*
 	 * Disable preemption so as to not let the corresponding user-space
@@ -1333,20 +1345,10 @@ static void __perf_counter_update_userpa
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&counter->hw.prev_count);
 
-	userpg->data_head = atomic_read(&data->head);
 	smp_wmb();
 	++userpg->lock;
 	preempt_enable();
-}
-
-void perf_counter_update_userpage(struct perf_counter *counter)
-{
-	struct perf_mmap_data *data;
-
-	rcu_read_lock();
-	data = rcu_dereference(counter->data);
-	if (data)
-		__perf_counter_update_userpage(counter, data);
+unlock:
 	rcu_read_unlock();
 }
 
@@ -1547,7 +1549,13 @@ void perf_counter_wakeup(struct perf_cou
 	data = rcu_dereference(counter->data);
 	if (data) {
 		(void)atomic_xchg(&data->wakeup, POLL_IN);
-		__perf_counter_update_userpage(counter, data);
+		/*
+		 * Ensure all data writes are issued before updating the
+		 * user-space data head information. The matching rmb()
+		 * will be in userspace after reading this value.
+		 */
+		smp_wmb();
+		data->user_page->data_head = atomic_read(&data->head);
 	}
 	rcu_read_unlock();
 

-- 

