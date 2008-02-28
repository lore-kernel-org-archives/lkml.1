Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbYB1SPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbYB1SPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbYB1SOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:14:55 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55523 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYB1SOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:14:54 -0500
Date: Thu, 28 Feb 2008 10:12:45 -0800
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: Pavel Emelianov <xemul@openvz.org>, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix warning in kernel/pid.c
Message-ID: <20080228181245.GA26319@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH]: Fix compile warning in kernel/pid.c

We get a warning in kernel/pid.c due to the deprecated find_task_by_pid().
Make the function inline in sched.h to avoid the warning.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 include/linux/sched.h |    5 ++++-
 kernel/pid.c          |    6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6-25-rc2-mm1/include/linux/sched.h
===================================================================
--- linux-2.6-25-rc2-mm1.orig/include/linux/sched.h	2008-02-27 16:07:52.000000000 -0800
+++ linux-2.6-25-rc2-mm1/include/linux/sched.h	2008-02-27 16:29:31.000000000 -0800
@@ -1632,7 +1632,10 @@ extern struct pid_namespace init_pid_ns;
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
 		struct pid_namespace *ns);
 
-extern struct task_struct *find_task_by_pid(pid_t nr) __deprecated;
+static inline struct task_struct *__deprecated find_task_by_pid(pid_t nr)
+{
+	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
+}
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
Index: linux-2.6-25-rc2-mm1/kernel/pid.c
===================================================================
--- linux-2.6-25-rc2-mm1.orig/kernel/pid.c	2008-02-27 15:18:22.000000000 -0800
+++ linux-2.6-25-rc2-mm1/kernel/pid.c	2008-02-27 16:29:31.000000000 -0800
@@ -380,12 +380,6 @@ struct task_struct *find_task_by_pid_typ
 
 EXPORT_SYMBOL(find_task_by_pid_type_ns);
 
-struct task_struct *find_task_by_pid(pid_t nr)
-{
-	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
-}
-EXPORT_SYMBOL(find_task_by_pid);
-
 struct task_struct *find_task_by_vpid(pid_t vnr)
 {
 	return find_task_by_pid_type_ns(PIDTYPE_PID, vnr,
