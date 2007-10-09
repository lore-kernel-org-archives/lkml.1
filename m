Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXJIOjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXJIOjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXJIOiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:38:52 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45526
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753244AbXJIOiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:38:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/5] RT - fix for scheduling issue
To: mingo@elte.hu, linux-rt-users@vger.kernel.org, rostedt@goodmis.org
Cc: kravetz@us.ibm.com, linux-kernel@vger.kernel.org, ghaskins@novell.com,
       pmorreale@novell.com, sdietrich@novell.com
Date: Tue, 09 Oct 2007 10:25:49 -0400
Message-ID: <20071009142549.4941.47062.stgit@novell1.haskins.net>
In-Reply-To: <20071009142044.4941.65189.stgit@novell1.haskins.net>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Kravetz <kravetz@us.ibm.com>

RESCHED_IPIs can be missed if more than one RT task is awoken simultaneously

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 93fd6de..3e75c62 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2207,7 +2207,7 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 * If we pushed an RT task off the runqueue,
 	 * then kick other CPUs, they might run it:
 	 */
-	if (unlikely(rt_task(current) && prev->se.on_rq && rt_task(prev))) {
+	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
 		schedstat_inc(rq, rto_schedule);
 		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
 	}

