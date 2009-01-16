Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZAPF5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZAPF5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 00:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZAPF5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 00:57:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbZAPF5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 00:57:20 -0500
Date: Fri, 16 Jan 2009 06:55:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] pids: immprove get_task_pid() to fix the unsafe
	sys_wait4()->task_pgrp()
Message-ID: <20090116055518.GA28128@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_wait4() does get_pid(task_pgrp(current)), this is not safe. We can
add rcu lock/unlock around, but we already have get_task_pid() which can
be improved to handle the special pids in more reliable manner.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/kernel/pid.c~SP_2_wait	2009-01-12 23:07:49.000000000 +0100
+++ CUR/kernel/pid.c	2009-01-16 02:54:26.000000000 +0100
@@ -403,6 +403,8 @@ struct pid *get_task_pid(struct task_str
 {
 	struct pid *pid;
 	rcu_read_lock();
+	if (type != PIDTYPE_PID)
+		task = task->group_leader;
 	pid = get_pid(task->pids[type].pid);
 	rcu_read_unlock();
 	return pid;
--- CUR/kernel/exit.c~SP_2_wait	2009-01-12 23:07:49.000000000 +0100
+++ CUR/kernel/exit.c	2009-01-16 02:51:48.000000000 +0100
@@ -1811,7 +1811,7 @@ asmlinkage long sys_wait4(pid_t upid, in
 		pid = find_get_pid(-upid);
 	} else if (upid == 0) {
 		type = PIDTYPE_PGID;
-		pid = get_pid(task_pgrp(current));
+		pid = get_task_pid(current, PIDTYPE_PGID);
 	} else /* upid > 0 */ {
 		type = PIDTYPE_PID;
 		pid = find_get_pid(upid);

