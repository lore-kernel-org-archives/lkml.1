Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZHIQJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZHIQJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 12:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZHIQJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 12:09:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59445 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZHIQJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 12:09:42 -0400
Date: Sun, 9 Aug 2009 18:09:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] timer fix
Message-ID: <20090809160925.GA27967@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Stanislaw Gruszka (1):
      posix_cpu_timers_exit_group(): Do not use thread_group_cputimer()


 kernel/posix-cpu-timers.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bece7c0..e33a21c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -521,11 +521,12 @@ void posix_cpu_timers_exit(struct task_struct *tsk)
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
-	struct task_cputime cputime;
+	struct signal_struct *const sig = tsk->signal;
 
-	thread_group_cputimer(tsk, &cputime);
 	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
+		       cputime_add(tsk->utime, sig->utime),
+		       cputime_add(tsk->stime, sig->stime),
+		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
