Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZAPF5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZAPF5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 00:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZAPF5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 00:57:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39637 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZAPF5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 00:57:20 -0500
Date: Fri, 16 Jan 2009 06:55:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] pids: document task_pgrp/task_session is not safe
	without tasklist/rcu
Message-ID: <20090116055513.GA28121@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if task == current, it is not safe to dereference the result of
task_pgrp/task_session. We can race with another thread which changes
the special pid via setpgid/setsid.

Document this. The next 2 patches give an example of the unsafe usage,
we have more bad users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/include/linux/sched.h~SP_1_COMMENT	2009-01-12 23:07:48.000000000 +0100
+++ CUR/include/linux/sched.h	2009-01-16 02:13:50.000000000 +0100
@@ -1449,6 +1449,13 @@ static inline struct pid *task_tgid(stru
 	return task->group_leader->pids[PIDTYPE_PID].pid;
 }
 
+/*
+ * Without tasklist or rcu lock it is not safe to dereference
+ * the result of task_pgrp/task_session even if task == current,
+ * we can race with another thread doing sys_setsid/sys_setpgid.
+ *
+ */
+
 static inline struct pid *task_pgrp(struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_PGID].pid;

