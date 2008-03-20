Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYCTPYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYCTPYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbYCTPXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:23:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36864 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbYCTPXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:23:48 -0400
Date: Thu, 20 Mar 2008 18:28:17 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] pids: de_thread: don't clear session/pgrp pids for the old leader
Message-ID: <20080320152816.GA6332@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Eric W. Biederman's idea.

Unless task == current, without tasklist_lock held task_session()/task_pgrp()
can return NULL if the caller races with de_thread() which switches the group
leader.

Change transfer_pid() to not clear old->pids[type].pid for the old leader.
This means that its .pid can point to "nowhere", but this is already true for
sub-threads, and the old leader is not group_leader() any longer. IOW, with
or without this change we can't trust task's special pids unless it is the
group leader.

With this change the following code

	rcu_read_lock();
	task = find_task_by_xxx();
	do_something(task_pgrp(task), task_session(task));
	rcu_read_unlock();

can't race with exec and hit the NULL pid.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/pid.c~1_PID_EXEC	2008-03-20 17:00:56.000000000 +0300
+++ 25/kernel/pid.c	2008-03-20 17:22:19.000000000 +0300
@@ -354,7 +354,6 @@ void transfer_pid(struct task_struct *ol
 {
 	new->pids[type].pid = old->pids[type].pid;
 	hlist_replace_rcu(&old->pids[type].node, &new->pids[type].node);
-	old->pids[type].pid = NULL;
 }
 
 struct task_struct *pid_task(struct pid *pid, enum pid_type type)

