Return-Path: <linux-kernel-owner+w=401wt.eu-S1762643AbYCXSbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbYCXSbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbYCXSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:31:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36713 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbYCXSb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:31:26 -0400
Date: Mon, 24 Mar 2008 21:36:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pids: sys_getpgid: fix unsafe *pid usage, s/tasklist/rcu/
Message-ID: <20080324183605.GA9650@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. sys_getpgid() needs rcu_read_lock() to derive the pgrp _nr, even if
   the task is current, otherwise we can race with another thread which
   does sys_setpgid().

2. Use rcu_read_lock() instead of tasklist_lock when pid != 0, make sure
   that we don't use the NULL pid if the task exits right after successful
   find_task_by_vpid().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/sys.c~2_GETPGID	2008-03-24 21:09:19.000000000 +0300
+++ 25/kernel/sys.c	2008-03-24 21:14:43.000000000 +0300
@@ -985,31 +985,37 @@ out:
 
 asmlinkage long sys_getpgid(pid_t pid)
 {
+	struct task_struct *p;
+	struct pid *grp;
+	int retval;
+
+	rcu_read_lock();
 	if (!pid)
-		return task_pgrp_vnr(current);
+		grp = task_pgrp(current);
 	else {
-		int retval;
-		struct task_struct *p;
-
-		read_lock(&tasklist_lock);
-		p = find_task_by_vpid(pid);
 		retval = -ESRCH;
-		if (p) {
-			retval = security_task_getpgid(p);
-			if (!retval)
-				retval = task_pgrp_vnr(p);
-		}
-		read_unlock(&tasklist_lock);
-		return retval;
+		p = find_task_by_vpid(pid);
+		if (!p)
+			goto out;
+		grp = task_pgrp(p);
+		if (!grp)
+			goto out;
+
+		retval = security_task_getpgid(p);
+		if (retval)
+			goto out;
 	}
+	retval = pid_vnr(grp);
+out:
+	rcu_read_unlock();
+	return retval;
 }
 
 #ifdef __ARCH_WANT_SYS_GETPGRP
 
 asmlinkage long sys_getpgrp(void)
 {
-	/* SMP - assuming writes are word atomic this is fine */
-	return task_pgrp_vnr(current);
+	return sys_getpgid(0);
 }
 
 #endif

