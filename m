Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbXK0N7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbXK0N7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbXK0N7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:59:21 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:54196 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372AbXK0N7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:59:19 -0500
Date: Tue, 27 Nov 2007 16:59:48 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/3] start the global /sbin/init with 0,0 special pids
Message-ID: <20071127135948.GA8370@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As Eric pointed out, there is no problem with init starting with sid == pgid
== 0, and this was historical linux behavior changed in 2.6.18.

Remove kernel_init()->__set_special_pids().

This change and the previous change in daemonize() mean that /sbin/init does
not need the special "session != 1" hack in sys_setsid() any longer. We can't
remove this check yet, we should cleanup copy_process(CLONE_NEWPID) first, so
update the comment only.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/init/main.c~4_glob_init	2007-11-26 16:56:24.000000000 +0300
+++ PT/init/main.c	2007-11-27 15:21:56.000000000 +0300
@@ -829,7 +829,6 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
-	__set_special_pids(task_pid(current));
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(max_cpus);
--- PT/kernel/sys.c~4_glob_init	2007-11-26 17:42:40.000000000 +0300
+++ PT/kernel/sys.c	2007-11-27 16:58:38.000000000 +0300
@@ -1054,12 +1054,11 @@ asmlinkage long sys_setsid(void)
 	if (group_leader->signal->leader)
 		goto out;
 
-	/* Fail if a process group id already exists that equals the proposed
-	 * session id.
+	/* Fail if a process group id already exists that equals the
+	 * proposed session id.
 	 *
-	 * Don't check if session == 1 because kernel threads and CLONE_NEWPID
-	 * tasks use this session id and so the check will always fail and make
-	 * it so init cannot successfully call setsid.
+	 * Don't check if session == 1, clone(CLONE_NEWPID) creates
+	 * this group/session beforehand.
 	 */
 	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
 		goto out;

