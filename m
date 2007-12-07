Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbXLGRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbXLGRDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXLGRCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:02:49 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:45638 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbXLGRCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:02:47 -0500
Date: Fri, 7 Dec 2007 20:03:33 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] uglify kill_pid_info() to fix kill() vs exec() race
Message-ID: <20071207170333.GA13829@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kill_pid_info()->pid_task() could be the old leader of the execing process.
In that case it is possible that the leader will be released before we take
siglock. This means that kill_pid_info() (and thus sys_kill()) can return a
false -ESRCH.

Change the code to retry when lock_task_sighand() fails. The endless loop is
not possible, __exit_signal() both clears ->sighand and does detach_pid().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/signal.c~1_kill_exec_race	2007-12-06 18:13:31.000000000 +0300
+++ PT/kernel/signal.c	2007-12-07 17:20:27.000000000 +0300
@@ -1049,17 +1049,26 @@ int kill_pgrp_info(int sig, struct sigin
 
 int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 {
-	int error;
+	int error = -ESRCH;
 	struct task_struct *p;
 
 	rcu_read_lock();
 	if (unlikely(sig_needs_tasklist(sig)))
 		read_lock(&tasklist_lock);
 
+retry:
 	p = pid_task(pid, PIDTYPE_PID);
-	error = -ESRCH;
-	if (p)
+	if (p) {
 		error = group_send_sig_info(sig, info, p);
+		if (unlikely(error == -ESRCH))
+			/*
+			 * The task was unhashed in between, try again.
+			 * If it is dead, pid_task() will return NULL,
+			 * if we race with de_thread() it will find the
+			 * new leader.
+			 */
+			goto retry;
+	}
 
 	if (unlikely(sig_needs_tasklist(sig)))
 		read_unlock(&tasklist_lock);

