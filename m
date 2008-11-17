Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYKQNjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYKQNjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYKQNjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:39:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46111 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbYKQNjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:39:18 -0500
Date: Mon, 17 Nov 2008 15:39:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Cc: Doug Chapman <doug.chapman@hp.com>, Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fix the racy usage of ->signal in
	account_group_xxx/run_posix_cpu_timers
Message-ID: <20081117143947.GA5360@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another stupid patch for 2.6.28 until we find the good fix.

Contrary to ad474caca3e2a0550b7ce0706527ad5ab389a4d4 changelog, other
acct_group_xxx() helpers can be called after exit_notify() by timer tick.
Thanks to Roland for pointing out this. Somehow I missed this simple fact
when I read the original patch, and I am afraid I confused Frank during
the discussion. Sorry.

Fortunately, these helpers work with current, we can check ->exit_state
to ensure that ->signal can't go away under us.

Also, add the comment and compiler barrier to account_group_exec_runtime(),
to make sure we load ->signal only once.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/sched_stats.h~ACCT_CK_EXIT_CODE	2008-11-07 17:32:02.000000000 +0100
+++ K-28/kernel/sched_stats.h	2008-11-16 22:05:54.000000000 +0100
@@ -298,9 +298,11 @@ static inline void account_group_user_ti
 {
 	struct signal_struct *sig;
 
-	sig = tsk->signal;
-	if (unlikely(!sig))
+	/* tsk == current, ensure it is safe to use ->signal */
+	if (unlikely(tsk->exit_state))
 		return;
+
+	sig = tsk->signal;
 	if (sig->cputime.totals) {
 		struct task_cputime *times;
 
@@ -325,9 +327,11 @@ static inline void account_group_system_
 {
 	struct signal_struct *sig;
 
-	sig = tsk->signal;
-	if (unlikely(!sig))
+	/* tsk == current, ensure it is safe to use ->signal */
+	if (unlikely(tsk->exit_state))
 		return;
+
+	sig = tsk->signal;
 	if (sig->cputime.totals) {
 		struct task_cputime *times;
 
@@ -353,8 +357,11 @@ static inline void account_group_exec_ru
 	struct signal_struct *sig;
 
 	sig = tsk->signal;
+	/* see __exit_signal()->task_rq_unlock_wait() */
+	barrier();
 	if (unlikely(!sig))
 		return;
+
 	if (sig->cputime.totals) {
 		struct task_cputime *times;
 
--- K-28/kernel/posix-cpu-timers.c~ACCT_CK_EXIT_CODE	2008-11-06 19:11:02.000000000 +0100
+++ K-28/kernel/posix-cpu-timers.c	2008-11-16 22:09:38.000000000 +0100
@@ -1308,9 +1308,10 @@ static inline int task_cputime_expired(c
  */
 static inline int fastpath_timer_check(struct task_struct *tsk)
 {
-	struct signal_struct *sig = tsk->signal;
+	struct signal_struct *sig;
 
-	if (unlikely(!sig))
+	/* tsk == current, ensure it is safe to use ->signal/sighand */
+	if (unlikely(tsk->exit_state))
 		return 0;
 
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
@@ -1323,6 +1324,8 @@ static inline int fastpath_timer_check(s
 		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
 			return 1;
 	}
+
+	sig = tsk->signal;
 	if (!task_cputime_zero(&sig->cputime_expires)) {
 		struct task_cputime group_sample;
 
@@ -1330,6 +1333,7 @@ static inline int fastpath_timer_check(s
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
+
 	return 0;
 }
 

