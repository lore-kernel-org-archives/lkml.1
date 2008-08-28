Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYH1Lo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYH1Lo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYH1Lou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:44:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYH1Lot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:44:49 -0400
Date: Thu, 28 Aug 2008 13:44:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20080828114436.GA1854@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
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
Joe Korty (2):
      lockstat: fix numerical output rounding error
      lockstat: repair erronous contention statistics

Steve VanDeBogart (1):
      exit signals: use of uninitialized field notify_count

Zhu Yi (1):
      lockdep: fix invalid list_del_rcu in zap_class


 kernel/exit.c         |    4 ++--
 kernel/lockdep.c      |    6 +++---
 kernel/lockdep_proc.c |    3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 38ec406..75c6473 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -918,8 +918,8 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 
 	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
-	    tsk->signal->notify_count < 0 &&
-	    tsk->signal->group_exit_task)
+	    tsk->signal->group_exit_task &&
+	    tsk->signal->notify_count < 0)
 		wake_up_process(tsk->signal->group_exit_task);
 
 	write_unlock_irq(&tasklist_lock);
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3bfb187..dbda475 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -875,11 +875,11 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	if (!entry)
 		return 0;
 
-	entry->class = this;
-	entry->distance = distance;
 	if (!save_trace(&entry->trace))
 		return 0;
 
+	entry->class = this;
+	entry->distance = distance;
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
@@ -3029,7 +3029,7 @@ found_it:
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (point < ARRAY_SIZE(stats->contention_point))
-		stats->contention_point[i]++;
+		stats->contention_point[point]++;
 	if (lock->cpu != smp_processor_id())
 		stats->bounces[bounce_contended + !!hlock->read]++;
 	put_lock_stats(stats);
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 4b194d3..20dbcbf 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -472,8 +472,9 @@ static void snprint_time(char *buf, size_t bufsiz, s64 nr)
 {
 	unsigned long rem;
 
+	nr += 5; /* for display rounding */
 	rem = do_div(nr, 1000); /* XXX: do_div_signed */
-	snprintf(buf, bufsiz, "%lld.%02d", (long long)nr, ((int)rem+5)/10);
+	snprintf(buf, bufsiz, "%lld.%02d", (long long)nr, (int)rem/10);
 }
 
 static void seq_time(struct seq_file *m, s64 time)
