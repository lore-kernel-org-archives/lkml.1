Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYKGPwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYKGPwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYKGPwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:52:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbYKGPw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:52:29 -0500
Date: Fri, 7 Nov 2008 17:52:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: adobriyan@gmail.com, Doug Chapman <doug.chapman@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] account_group_exec_runtime: fix the racy usage of ->signal
Message-ID: <20081107165238.GA23055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile tested.

Unlike other similar routines, account_group_exec_runtime() could be
called "implicitly" after exit_notify(). This means we can race with
the parent doing release_task(), we can't just check ->signal != NULL.

Take ->siglock to make sure ->signal can't go away.

This is the minimal fix, with this patch we don't need need get/put cpu,
and I think we should uninline this function.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/sched_stats.h~A_G_E_R_FIX	2008-11-07 17:32:02.000000000 +0100
+++ K-28/kernel/sched_stats.h	2008-11-07 17:44:39.000000000 +0100
@@ -351,10 +351,12 @@ static inline void account_group_exec_ru
 					      unsigned long long ns)
 {
 	struct signal_struct *sig;
+	unsigned long flags;
 
-	sig = tsk->signal;
-	if (unlikely(!sig))
+	if (unlikely(!lock_task_sighand(tsk, &flags)))
 		return;
+
+	sig = tsk->signal;
 	if (sig->cputime.totals) {
 		struct task_cputime *times;
 
@@ -362,4 +364,6 @@ static inline void account_group_exec_ru
 		times->sum_exec_runtime += ns;
 		put_cpu_no_resched();
 	}
+
+	unlock_task_sighand(tsk, &flags);
 }

