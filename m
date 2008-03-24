Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbYCXScE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbYCXScE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762526AbYCXSbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:31:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36723 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762041AbYCXSbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:31:33 -0400
Date: Mon, 24 Mar 2008 21:36:04 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pids: sys_getsid: fix unsafe *pid usage, fix possible 0 instead of -ESRCH
Message-ID: <20080324183604.GA9647@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. sys_getsid() needs rcu_read_lock() to derive the session _nr, even if
   the task is current, otherwise we can race with another thread which
   does sys_setsid().

2. The task can exit between find_task_by_vpid() and task_session_vnr(),
   in that unlikely case sys_getsid() returns 0 instead of -ESRCH.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/sys.c~1_GETSID	2008-03-24 10:49:26.000000000 +0300
+++ 25/kernel/sys.c	2008-03-24 21:09:19.000000000 +0300
@@ -1016,23 +1016,30 @@ asmlinkage long sys_getpgrp(void)
 
 asmlinkage long sys_getsid(pid_t pid)
 {
+	struct task_struct *p;
+	struct pid *sid;
+	int retval;
+
+	rcu_read_lock();
 	if (!pid)
-		return task_session_vnr(current);
+		sid = task_session(current);
 	else {
-		int retval;
-		struct task_struct *p;
-
-		rcu_read_lock();
-		p = find_task_by_vpid(pid);
 		retval = -ESRCH;
-		if (p) {
-			retval = security_task_getsid(p);
-			if (!retval)
-				retval = task_session_vnr(p);
-		}
-		rcu_read_unlock();
-		return retval;
+		p = find_task_by_vpid(pid);
+		if (!p)
+			goto out;
+		sid = task_session(p);
+		if (!sid)
+			goto out;
+
+		retval = security_task_getsid(p);
+		if (retval)
+			goto out;
 	}
+	retval = pid_vnr(sid);
+out:
+	rcu_read_unlock();
+	return retval;
 }
 
 asmlinkage long sys_setsid(void)

