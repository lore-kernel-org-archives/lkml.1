Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbYCGJ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbYCGJ64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYCGJ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:58:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60489 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbYCGJ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:58:45 -0500
Date: Fri, 7 Mar 2008 12:58:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: do_tkill: don't use tasklist_lock
Message-ID: <20080307095813.GA8894@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry to all, re-sending with the correct Andrew's email)

Convert do_tkill() to use rcu_read_lock() + lock_task_sighand() to avoid taking
tasklist lock.

Note that we don't return an error if lock_task_sighand() fails, we pretend the
task dies after receiving the signal. Otherwise, we should fight with the nasty
races with mt-exec without having any advantage.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~2_TKILL_NO_TASKLIST	2008-03-07 10:47:02.000000000 +0300
+++ 25/kernel/signal.c	2008-03-07 12:20:34.000000000 +0300
@@ -2194,6 +2194,7 @@ static int do_tkill(int tgid, int pid, i
 	int error;
 	struct siginfo info;
 	struct task_struct *p;
+	unsigned long flags;
 
 	error = -ESRCH;
 	info.si_signo = sig;
@@ -2202,7 +2203,7 @@ static int do_tkill(int tgid, int pid, i
 	info.si_pid = task_tgid_vnr(current);
 	info.si_uid = current->uid;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (p && (tgid <= 0 || task_tgid_vnr(p) == tgid)) {
 		error = check_kill_permission(sig, &info, p);
@@ -2210,13 +2211,12 @@ static int do_tkill(int tgid, int pid, i
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
 		 */
-		if (!error && sig && p->sighand) {
-			spin_lock_irq(&p->sighand->siglock);
+		if (!error && sig && lock_task_sighand(p, &flags)) {
 			error = specific_send_sig_info(sig, &info, p);
-			spin_unlock_irq(&p->sighand->siglock);
+			unlock_task_sighand(p, &flags);
 		}
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return error;
 }

