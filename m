Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbZIAM1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbZIAM1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZIAM1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:27:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbZIAM1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:27:52 -0400
Date: Tue, 1 Sep 2009 14:24:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] do_wait-wakeup-optimization: simplify
	task_pid_type()
Message-ID: <20090901122404.GC20989@redhat.com>
References: <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com> <20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com> <20090827093441.GA3451@redhat.com> <20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com> <20090827100846.GA6462@redhat.com> <20090827193133.b7eed4a9.kamezawa.hiroyu@jp.fujitsu.com> <20090827105209.GA8469@redhat.com> <20090828171724.GA17445@redhat.com> <20090828191624.0F5BC45B02@magilla.sf.frob.com> <20090901122240.GA20989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901122240.GA20989@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_pid_type() is only used by eligible_pid() which has to check
wo_type != PIDTYPE_MAX anyway. Remove this check from task_pid_type()
and factor out ->pids[type] access, this shrinks .text a bit and
simplifies the code.

The matches the behaviour of other similar helpers, say get_task_pid().
The caller must ensure that pid_type is valid, not the callee.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- WAIT/kernel/exit.c~2_WAKE_PARENT_ELIGIBLE_FIX_CLEANUP	2009-09-01 12:59:23.000000000 +0200
+++ WAIT/kernel/exit.c	2009-09-01 13:51:15.000000000 +0200
@@ -1096,17 +1096,15 @@ struct wait_opts {
 	int			notask_error;
 };
 
-static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
+static inline
+struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
 {
-	struct pid *pid = NULL;
-	if (type == PIDTYPE_PID)
-		pid = task->pids[type].pid;
-	else if (type < PIDTYPE_MAX)
-		pid = task->group_leader->pids[type].pid;
-	return pid;
+	if (type != PIDTYPE_PID)
+		task = task->group_leader;
+	return task->pids[type].pid;
 }
 
-static inline int eligible_pid(struct wait_opts *wo, struct task_struct *p)
+static int eligible_pid(struct wait_opts *wo, struct task_struct *p)
 {
 	return	wo->wo_type == PIDTYPE_MAX ||
 		task_pid_type(p, wo->wo_type) == wo->wo_pid;

