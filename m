Return-Path: <linux-kernel-owner+w=401wt.eu-S1031446AbXDJSvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031446AbXDJSvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031443AbXDJSvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:51:16 -0400
Received: from mail.screens.ru ([213.234.233.54]:46351 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031434AbXDJSvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:51:15 -0400
Date: Tue, 10 Apr 2007 22:50:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] reduce reparent_to_init()
Message-ID: <20070410185027.GA101@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move some random stuff which doesn't need tasklist_lock from reparent_to_init()
to its caller, daemonize(). Strictly speaking, rlim is protected by task_lock()
but we don't need it to copy init_task->rlim.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/kernel/exit.c~1_REDUCE	2007-04-05 12:18:28.000000000 +0400
+++ 2.6.21-rc5/kernel/exit.c	2007-04-10 21:32:44.000000000 +0400
@@ -271,7 +271,6 @@ static void reparent_to_init(void)
 	write_lock_irq(&tasklist_lock);
 
 	ptrace_unlink(current);
-	/* Reparent to init */
 	remove_parent(current);
 	current->parent = child_reaper(current);
 	current->real_parent = child_reaper(current);
@@ -280,17 +279,8 @@ static void reparent_to_init(void)
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
 	current->exit_signal = SIGCHLD;
 
-	if (!has_rt_policy(current) && (task_nice(current) < 0))
-		set_user_nice(current, 0);
-	/* cpus_allowed? */
-	/* rt_priority? */
-	/* signals? */
 	security_task_reparent_to_init(current);
-	memcpy(current->signal->rlim, init_task.signal->rlim,
-	       sizeof(current->signal->rlim));
-	atomic_inc(&(INIT_USER->__count));
 	write_unlock_irq(&tasklist_lock);
-	switch_uid(INIT_USER);
 }
 
 void __set_special_pids(pid_t session, pid_t pgrp)
@@ -402,6 +392,17 @@ void daemonize(const char *name, ...)
 	atomic_inc(&current->files->count);
 
 	reparent_to_init();
+
+	if (!has_rt_policy(current) && (task_nice(current) < 0))
+		set_user_nice(current, 0);
+	/* cpus_allowed? */
+	/* rt_priority? */
+	/* signals? */
+	memcpy(current->signal->rlim, init_task.signal->rlim,
+	       sizeof(current->signal->rlim));
+
+	atomic_inc(&(INIT_USER->__count));
+	switch_uid(INIT_USER);
 }
 
 EXPORT_SYMBOL(daemonize);

