Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZDBMFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZDBMFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZDBMEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:04:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:42354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbZDBMEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:04:48 -0400
Date: Thu, 2 Apr 2009 12:04:18 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090402091319.577951445@chello.nl>
References: <20090402091319.577951445@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: update mmap() counter read
Message-ID: <tip-895eadace59ff56e9b86e480c9b05da61822c82f@git.kernel.org>
Git-Commit-ID: 895eadace59ff56e9b86e480c9b05da61822c82f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 12:04:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  895eadace59ff56e9b86e480c9b05da61822c82f
Gitweb:     http://git.kernel.org/tip/895eadace59ff56e9b86e480c9b05da61822c82f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 2 Apr 2009 11:12:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 13:53:01 +0200

perf_counter: update mmap() counter read

Paul noted that we don't need SMP barriers for the mmap() counter read
because its always on the same cpu (otherwise you can't access the hw
counter anyway).

So remove the SMP barriers and replace them with regular compiler
barriers.

Further, update the comment to include a race free method of reading
said hardware counter. The primary change is putting the pmc_read
inside the seq-loop, otherwise we can still race and read rubbish.

Noticed-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090402091319.577951445@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   22 ++++++++++------------
 kernel/perf_counter.c        |    4 ++--
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 90cce0c..f2b914d 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -167,30 +167,28 @@ struct perf_counter_mmap_page {
 	/*
 	 * Bits needed to read the hw counters in user-space.
 	 *
-	 * The index and offset should be read atomically using the seqlock:
-	 *
-	 *   __u32 seq, index;
-	 *   __s64 offset;
+	 *   u32 seq;
+	 *   s64 count;
 	 *
 	 * again:
-	 *   rmb();
 	 *   seq = pc->lock;
-	 *
 	 *   if (unlikely(seq & 1)) {
 	 *     cpu_relax();
 	 *     goto again;
 	 *   }
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f105a6e..2a5d4f5 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1340,13 +1340,13 @@ void perf_counter_update_userpage(struct perf_counter *counter)
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
