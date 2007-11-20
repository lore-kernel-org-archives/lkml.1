Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbXKTQe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbXKTQe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXKTQeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:34:50 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34403 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbXKTQet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:34:49 -0500
Date: Tue, 20 Nov 2007 19:34:57 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] proc-remove-races-from-proc_id_readdir-factor-out-tgid-increment
Message-ID: <20071120163457.GA13021@tv-sign.ru>
References: <20071117181549.GA1415@tv-sign.ru> <m1bq9swqyu.fsf@ebiederm.dsl.xmission.com> <20071118142047.GA360@tv-sign.ru> <m1tzniumoo.fsf@ebiederm.dsl.xmission.com> <20071119182937.GA89@tv-sign.ru> <m1ejelvrjf.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejelvrjf.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Eric W. Biederman wrote:
> 
> So to fix the problem this patch modifies next_tgid() to return
> both a tgid and the task struct in question.
> 
> A structure is introduced to return these values because it is
> slightly cleaner and easier to optimize, and the resulting code
> is a little shorter.

Nice. Perhaps we can also factor out the incrementing of iter.tgid? Lessens
the generated code, and (imho) cleanups the source a little bit.

(untested, 2.6.24-rc2-mm1 doesn't boot on my machine)

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/fs/proc/base.c~	2007-11-20 19:00:05.000000000 +0300
+++ PT/fs/proc/base.c	2007-11-20 19:06:28.000000000 +0300
@@ -2378,6 +2378,7 @@ static struct tgid_iter next_tgid(struct
 	rcu_read_lock();
 retry:
 	iter.task = NULL;
+	iter.tgid++;
 	pid = find_ge_pid(iter.tgid, ns);
 	if (pid) {
 		iter.tgid = pid_nr_ns(pid, ns);
@@ -2394,10 +2395,8 @@ retry:
 		 * found doesn't happen to be a thread group leader.
 		 * As we don't care in the case of readdir.
 		 */
-		if (!iter.task || !has_group_leader_pid(iter.task)) {
-			iter.tgid += 1;
+		if (!iter.task || !has_group_leader_pid(iter.task))
 			goto retry;
-		}
 		get_task_struct(iter.task);
 	}
 	rcu_read_unlock();
@@ -2434,10 +2433,8 @@ int proc_pid_readdir(struct file * filp,
 
 	ns = filp->f_dentry->d_sb->s_fs_info;
 	iter.task = NULL;
-	iter.tgid = filp->f_pos - TGID_OFFSET;
-	for (iter = next_tgid(ns, iter);
-	     iter.task;
-	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+	iter.tgid = filp->f_pos - TGID_OFFSET - 1;
+	while ((iter = next_tgid(ns, iter)).task) {
 		filp->f_pos = iter.tgid + TGID_OFFSET;
 		if (proc_pid_fill_cache(filp, dirent, filldir, iter) < 0) {
 			put_task_struct(iter.task);

