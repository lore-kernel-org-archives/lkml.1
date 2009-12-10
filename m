Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbZLJTpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbZLJTpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761567AbZLJTpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:45:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51957 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761101AbZLJTpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:45:11 -0500
Date: Thu, 10 Dec 2009 20:45:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking fixes
Message-ID: <20091210194509.GA7463@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      futex: Take mmap_sem for get_user_pages in fault_in_user_writeable

Frank Rowand (2):
      lockstat: Fix min, max times in /proc/lock_stats
      lockstat: Add usage info to Documentation/lockstat.txt

Tony Luck (1):
      lockdep: Avoid out of bounds array reference in save_trace()


 Documentation/lockstat.txt |   12 ++++++++++++
 kernel/futex.c             |   10 ++++++++--
 kernel/lockdep.c           |   16 ++++++++++++----
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index 9cb9138..65f4c79 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -62,8 +62,20 @@ applicable).
 It also tracks 4 contention points per class. A contention point is a call site
 that had to wait on lock acquisition.
 
+ - CONFIGURATION
+
+Lock statistics are enabled via CONFIG_LOCK_STATS.
+
  - USAGE
 
+Enable collection of statistics:
+
+# echo 1 >/proc/sys/kernel/lock_stat
+
+Disable collection of statistics:
+
+# echo 0 >/proc/sys/kernel/lock_stat
+
 Look at the current lock statistics:
 
 ( line numbers not part of actual output, done for clarity in the explanation
diff --git a/kernel/futex.c b/kernel/futex.c
index fb65e82..d73ef1f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -304,8 +304,14 @@ void put_futex_key(int fshared, union futex_key *key)
  */
 static int fault_in_user_writeable(u32 __user *uaddr)
 {
-	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
-				 1, 1, 0, NULL, NULL);
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(current, mm, (unsigned long)uaddr,
+			     1, 1, 0, NULL, NULL);
+	up_read(&mm->mmap_sem);
+
 	return ret < 0 ? ret : 0;
 }
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f5dcd36..4f8df01 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -168,7 +168,7 @@ static void lock_time_inc(struct lock_time *lt, u64 time)
 	if (time > lt->max)
 		lt->max = time;
 
-	if (time < lt->min || !lt->min)
+	if (time < lt->min || !lt->nr)
 		lt->min = time;
 
 	lt->total += time;
@@ -177,8 +177,15 @@ static void lock_time_inc(struct lock_time *lt, u64 time)
 
 static inline void lock_time_add(struct lock_time *src, struct lock_time *dst)
 {
-	dst->min += src->min;
-	dst->max += src->max;
+	if (!src->nr)
+		return;
+
+	if (src->max > dst->max)
+		dst->max = src->max;
+
+	if (src->min < dst->min || !dst->nr)
+		dst->min = src->min;
+
 	dst->total += src->total;
 	dst->nr += src->nr;
 }
@@ -379,7 +386,8 @@ static int save_trace(struct stack_trace *trace)
 	 * complete trace that maxes out the entries provided will be reported
 	 * as incomplete, friggin useless </rant>
 	 */
-	if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
+	if (trace->nr_entries != 0 &&
+	    trace->entries[trace->nr_entries-1] == ULONG_MAX)
 		trace->nr_entries--;
 
 	trace->max_entries = trace->nr_entries;
