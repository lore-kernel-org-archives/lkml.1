Return-Path: <linux-kernel-owner+w=401wt.eu-S935089AbZDBJOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935089AbZDBJOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762410AbZDBJMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:12:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:57845 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZDBJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:12:53 -0400
Message-Id: <20090402091319.577951445@chello.nl>
References: <20090402091158.291810516@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 11:12:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/6] perf_counter: update mmap() counter read
Content-Disposition: inline; filename=perf_counter-mmap_counter_read.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul noted that we don't need SMP barriers for the mmap() counter read
because its always on the same cpu (otherwise you can't access the hw
counter anyway).

So remove the SMP barriers and replace them with regular compiler
barriers.

Further, update the comment to include a race free method of readin
said hardware counter. The primary change is putting the pmc_read
inside the seq-loop, otherwise we can still race and read rubbish.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   30 ++++++++++++++----------------
 kernel/perf_counter.c        |    4 ++--
 2 files changed, 16 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -173,30 +173,28 @@ struct perf_counter_mmap_page {
 	/*
 	 * Bits needed to read the hw counters in user-space.
 	 *
-	 * The index and offset should be read atomically using the seqlock:
-	 *
-	 *   __u32 seq, index;
-	 *   __s64 offset;
-	 *
-	 * again:
-	 *   rmb();
-	 *   seq = pc->lock;
+	 *   u32 seq;
+	 *   s64 count;
 	 *
+	 * again:
+	 *   seq = pc->lock;
 	 *   if (unlikely(seq & 1)) {
 	 *     cpu_relax();
-	 *     goto again;
-	 *   }
+	 *     goto again;
+	 *   }
 	 *
-	 *   index = pc->index;
-	 *   offset = pc->offset;
+	 *   if (pc->index) {
+	 *     count = pmc_read(pc->index - 1);
+	 *     count += pc->offset;
+	 *   } else
+	 *     goto regular_read;
 	 *
-	 *   rmb();
+	 *   barrier();
 	 *   if (pc->lock != seq)
 	 *     goto again;
 	 *
-	 * After this, index contains architecture specific counter index + 1,
-	 * so that 0 means unavailable, offset contains the value to be added
-	 * to the result of the raw timer read to obtain this counter's value.
+	 * NOTE: for obvious reason this only works on self-monitoring
+	 *       processes.
 	 */
 	__u32	lock;			/* seqlock for synchronization */
 	__u32	index;			/* hardware counter identifier */
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1340,13 +1340,13 @@ void perf_counter_update_userpage(struct
 	 */
 	preempt_disable();
 	++userpg->lock;
-	smp_wmb();
+	barrier();
 	userpg->index = counter->hw.idx;
 	userpg->offset = atomic64_read(&counter->count);
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&counter->hw.prev_count);
 
-	smp_wmb();
+	barrier();
 	++userpg->lock;
 	preempt_enable();
 unlock:

-- 

