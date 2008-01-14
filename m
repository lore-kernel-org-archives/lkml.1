Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbYANVDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbYANVDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYANVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:03:21 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56120 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYANVDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:03:21 -0500
Date: Tue, 15 Jan 2008 00:02:37 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix the "remove task_ppid_nr_ns" commit
Message-ID: <20080114210237.GA2244@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 84427eaef1fb91704c7112bdb598c810003b99f3 (remove task_ppid_nr_ns)
moves the task_tgid_nr_ns(task->real_parent) outside of lock_task_sighand().
This is wrong, ->real_parent could be freed/reused.

Both ->parent/real_parent point to nothnig after __exit_signal() because we
remove the child from ->children list, and thus the child can't be reparented
when its parent exits.

rcu_read_lock() protects ->parent/real_parent, but _only_ if we know it was
valid before we take rcu lock.

Revert this part of the patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/fs/proc/array.c~ppid_fix	2008-01-14 23:45:35.000000000 +0300
+++ t/fs/proc/array.c	2008-01-14 23:59:27.000000000 +0300
@@ -426,7 +426,6 @@ static int do_task_stat(struct task_stru
 	cgtime = gtime = cputime_zero;
 
 	rcu_read_lock();
-	ppid = task_tgid_nr_ns(task->real_parent, ns);
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
 
@@ -465,6 +464,7 @@ static int do_task_stat(struct task_stru
 		}
 
 		sid = task_session_nr_ns(task, ns);
+		ppid = task_tgid_nr_ns(task->real_parent, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);

