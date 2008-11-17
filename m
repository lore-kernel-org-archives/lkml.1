Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYKQNkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYKQNkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYKQNjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:39:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46129 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbYKQNjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:39:43 -0500
Date: Mon, 17 Nov 2008 15:40:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Cc: Doug Chapman <doug.chapman@hp.com>, Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] thread_group_cputime: kill the bogus ->signal != NULL
	check
Message-ID: <20081117144001.GA5379@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thread_group_cputime() is called by current when it must have the valid
->signal, or under ->siglock, or under tasklist_lock after the ->signal
check, or the caller is wait_task_zombie() which reaps the child. In any
case ->signal can't be NULL.

But the point of this patch is not optimization. If it is possible to call
thread_group_cputime() when ->signal == NULL we are doing something wrong,
and we should not mask the problem. thread_group_cputime() fills *times
and the caller will use it, if we silently use task_struct->*times* we
report the wrong values.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/posix-cpu-timers.c~TGTIME_KILL_CK_SIG	2008-11-16 22:09:38.000000000 +0100
+++ K-28/kernel/posix-cpu-timers.c	2008-11-17 00:38:05.000000000 +0100
@@ -58,21 +58,21 @@ void thread_group_cputime(
 	struct task_struct *tsk,
 	struct task_cputime *times)
 {
-	struct signal_struct *sig;
+	struct task_cputime *totals, *tot;
 	int i;
-	struct task_cputime *tot;
 
-	sig = tsk->signal;
-	if (unlikely(!sig) || !sig->cputime.totals) {
+	totals = tsk->signal->cputime.totals;
+	if (!totals) {
 		times->utime = tsk->utime;
 		times->stime = tsk->stime;
 		times->sum_exec_runtime = tsk->se.sum_exec_runtime;
 		return;
 	}
+
 	times->stime = times->utime = cputime_zero;
 	times->sum_exec_runtime = 0;
 	for_each_possible_cpu(i) {
-		tot = per_cpu_ptr(tsk->signal->cputime.totals, i);
+		tot = per_cpu_ptr(totals, i);
 		times->utime = cputime_add(times->utime, tot->utime);
 		times->stime = cputime_add(times->stime, tot->stime);
 		times->sum_exec_runtime += tot->sum_exec_runtime;

