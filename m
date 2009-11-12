Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZKLSNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZKLSNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZKLSNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:13:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:49933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbZKLSNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:13:06 -0500
Date: Thu, 12 Nov 2009 18:12:41 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, spencer@bluehost.com, hpa@zytor.com,
       mingo@redhat.com, seto.hidetoshi@jp.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, oleg@redhat.com, sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, spencer@bluehost.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com,
       sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <4AFB9029.9000208@jp.fujitsu.com>
References: <4AFB9029.9000208@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix granularity of task_u/stime()
Message-ID: <tip-761b1d26df542fd5eb348837351e4d2f3bc7bffe@git.kernel.org>
Git-Commit-ID: 761b1d26df542fd5eb348837351e4d2f3bc7bffe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  761b1d26df542fd5eb348837351e4d2f3bc7bffe
Gitweb:     http://git.kernel.org/tip/761b1d26df542fd5eb348837351e4d2f3bc7bffe
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 12 Nov 2009 13:33:45 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Nov 2009 15:23:47 +0100

sched: Fix granularity of task_u/stime()

Originally task_s/utime() were designed to return clock_t but
later changed to return cputime_t by following commit:

  commit efe567fc8281661524ffa75477a7c4ca9b466c63
  Author: Christian Borntraeger <borntraeger@de.ibm.com>
  Date:   Thu Aug 23 15:18:02 2007 +0200

It only changed the type of return value, but not the
implementation. As the result the granularity of task_s/utime()
is still that of clock_t, not that of cputime_t.

So using task_s/utime() in __exit_signal() makes values
accumulated to the signal struct to be rounded and coarse
grained.

This patch removes casts to clock_t in task_u/stime(), to keep
granularity of cputime_t over the calculation.

v2:
  Use div_u64() to avoid error "undefined reference to `__udivdi3`"
  on some 32bit systems.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: xiyou.wangcong@gmail.com
Cc: Spencer Candland <spencer@bluehost.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
LKML-Reference: <4AFB9029.9000208@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 43e61fa..ab9a034 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5156,41 +5156,45 @@ cputime_t task_stime(struct task_struct *p)
 	return p->stime;
 }
 #else
+
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs) \
+	msecs_to_cputime(div_u64((__nsecs), NSEC_PER_MSEC))
+#endif
+
 cputime_t task_utime(struct task_struct *p)
 {
-	clock_t utime = cputime_to_clock_t(p->utime),
-		total = utime + cputime_to_clock_t(p->stime);
+	cputime_t utime = p->utime, total = utime + p->stime;
 	u64 temp;
 
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
+	temp = (u64)nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
 		temp *= utime;
 		do_div(temp, total);
 	}
-	utime = (clock_t)temp;
+	utime = (cputime_t)temp;
 
-	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
+	p->prev_utime = max(p->prev_utime, utime);
 	return p->prev_utime;
 }
 
 cputime_t task_stime(struct task_struct *p)
 {
-	clock_t stime;
+	cputime_t stime;
 
 	/*
 	 * Use CFS's precise accounting. (we subtract utime from
 	 * the total, to make sure the total observed by userspace
 	 * grows monotonically - apps rely on that):
 	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
-			cputime_to_clock_t(task_utime(p));
+	stime = nsecs_to_cputime(p->se.sum_exec_runtime) - task_utime(p);
 
 	if (stime >= 0)
-		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+		p->prev_stime = max(p->prev_stime, stime);
 
 	return p->prev_stime;
 }
