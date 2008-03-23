Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYCWRqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYCWRqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 13:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYCWRqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 13:46:37 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50271 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbYCWRqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 13:46:36 -0400
Date: Sun, 23 Mar 2008 20:51:37 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] pids: sys_getpgid: use rcu_read_lock() instead of tasklist_lock
Message-ID: <20080323175137.GA3356@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert sys_getpgid() to use rcu_read_lock() instead of tasklist_lock, make
sure we also check the result of task_pgrp_vnr().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/sys.c~2_GETPGID	2008-03-23 19:25:36.000000000 +0300
+++ 25/kernel/sys.c	2008-03-23 20:39:03.000000000 +0300
@@ -988,19 +988,19 @@ asmlinkage long sys_getpgid(pid_t pid)
 	if (!pid)
 		return task_pgrp_vnr(current);
 	else {
-		int retval;
+		int retval = 0;
 		struct task_struct *p;
 
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		p = find_task_by_vpid(pid);
-		retval = -ESRCH;
 		if (p) {
 			retval = security_task_getpgid(p);
 			if (!retval)
 				retval = task_pgrp_vnr(p);
 		}
-		read_unlock(&tasklist_lock);
-		return retval;
+		rcu_read_unlock();
+
+		return retval ?: -ESRCH;
 	}
 }
 

