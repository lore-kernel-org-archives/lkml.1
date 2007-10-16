Return-Path: <linux-kernel-owner+w=401wt.eu-S1765536AbXJPQYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765536AbXJPQYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761673AbXJPQW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:22:58 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:43775
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761419AbXJPQW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:22:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/4] RT: Add support for updating push-rt priority under PI
	boost
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Tue, 16 Oct 2007 12:09:08 -0400
Message-ID: <20071016160908.5202.69086.stgit@novell1.haskins.net>
In-Reply-To: <20071016160226.5202.53965.stgit@novell1.haskins.net>
References: <20071016160226.5202.53965.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Priority of the running task can change at run-time due to
PI boosting / nice, so be sure to update the RQ version of
the priority as well.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b69e49b..bc9f4a6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4656,6 +4656,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 		 * this runqueue and our priority is higher than the current's
 		 */
 		if (task_running(rq, p)) {
+			set_rq_prio(rq, p->prio);
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
 		} else {
@@ -4715,6 +4716,9 @@ void set_user_nice(struct task_struct *p, long nice)
 		 */
 		if (delta < 0 || (delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
+
+		if (delta && task_running(rq, p))
+			set_rq_prio(rq, p->prio);
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);

