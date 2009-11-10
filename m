Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZKJFrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZKJFrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZKJFrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:47:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46627 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZKJFrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:47:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF8FE76.406@jp.fujitsu.com>
Date: Tue, 10 Nov 2009 14:47:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       sgruszka@redhat.com
Subject: [PATCH] fix granularity of task_u/stime()
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>	 <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <4AF8FD3C.2090008@jp.fujitsu.com>
In-Reply-To: <4AF8FD3C.2090008@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove casting to clock_t from task_u/stime(), and keep granularity of
cputime_t over the calculation.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/sched.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 28dd4f4..1632e82 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5171,41 +5171,44 @@ cputime_t task_stime(struct task_struct *p)
 	return p->stime;
 }
 #else
+
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs) msecs_to_cputime((__nsecs) / NSEC_PER_MSEC)
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
-- 
1.6.5.2



