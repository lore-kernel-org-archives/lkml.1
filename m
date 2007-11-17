Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbXKQSQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbXKQSQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758506AbXKQSQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:16:05 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34375 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927AbXKQSQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:16:03 -0500
Date: Sat, 17 Nov 2007 21:15:49 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] task_pid_nr_ns() breaks proc_pid_readdir()
Message-ID: <20071117181549.GA1415@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

proc_pid_readdir:

	for (...; ...; task = next_tgid(tgid + 1, ns)) {
		tgid = task_pid_nr_ns(task, ns);
		... use tgid ...

The first problem is that task_pid_nr_ns() can race with RCU and read the
freed memory.

However, rcu_read_lock() can't help. next_tgid() returns a pinned task_struct,
but the task can be released (and it's pid detached) before task_pid_nr_ns()
reads the pid_t value. In that case task_pid_nr_ns() returns 0 thus breaking
the whole logic.

Make sure that task_pid_nr_ns() returns !0 before updating tgid. Note that
next_tgid(tgid + 1) can find the same "struct pid" again, but we shouldn't
go into the endless loop because pid_task(PIDTYPE_PID) must return NULL in
this case, so next_tgid() can't return the same task.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 24/fs/proc/base.c~pprd	2007-10-25 16:22:11.000000000 +0400
+++ 24/fs/proc/base.c	2007-11-17 20:58:14.000000000 +0300
@@ -2481,7 +2481,15 @@ int proc_pid_readdir(struct file * filp,
 	for (task = next_tgid(tgid, ns);
 	     task;
 	     put_task_struct(task), task = next_tgid(tgid + 1, ns)) {
-		tgid = task_pid_nr_ns(task, ns);
+		int nr;
+
+		rcu_read_lock();
+		nr = task_pid_nr_ns(task, ns);
+		rcu_read_unlock();
+		if (!nr)
+			continue;
+
+		tgid = nr;
 		filp->f_pos = tgid + TGID_OFFSET;
 		if (proc_pid_fill_cache(filp, dirent, filldir, task, tgid) < 0) {
 			put_task_struct(task);

