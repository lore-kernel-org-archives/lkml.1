Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbYCQKwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbYCQKwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYCQKwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:52:43 -0400
Received: from sacred.ru ([62.205.161.221]:44661 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbYCQKwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:52:42 -0400
Message-ID: <47DE4D43.2040404@openvz.org>
Date: Mon, 17 Mar 2008 13:51:47 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Bsd_acct: using task_struct->tgid is not right in pid-namespaces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Mar 2008 13:51:41 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case we're accounting from a sub-namespace, the tgids 
reported will not refer to the right namespace.

Save the pid_namespace we're accounting in on the acct_glbs 
and use it in do_acct_process.

Two less :) places using the task_struct.tgid member.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/acct.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 7ff5339..91e1cfd 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -58,6 +58,7 @@
 #include <asm/uaccess.h>
 #include <asm/div64.h>
 #include <linux/blkdev.h> /* sector_div */
+#include <linux/pid_namespace.h>
 
 /*
  * These constants control the amount of freespace that suspend and
@@ -74,7 +75,7 @@ int acct_parm[3] = {4, 2, 30};
 /*
  * External references and all of the globals.
  */
-static void do_acct_process(struct file *);
+static void do_acct_process(struct pid_namespace *ns, struct file *);
 
 /*
  * This structure is used so that all the data protected by lock
@@ -86,6 +87,7 @@ struct acct_glbs {
 	volatile int		active;
 	volatile int		needcheck;
 	struct file		*file;
+	struct pid_namespace	*ns;
 	struct timer_list	timer;
 };
 
@@ -175,9 +177,11 @@ out:
 static void acct_file_reopen(struct file *file)
 {
 	struct file *old_acct = NULL;
+	struct pid_namespace *old_ns = NULL;
 
 	if (acct_globals.file) {
 		old_acct = acct_globals.file;
+		old_ns = acct_globals.ns;
 		del_timer(&acct_globals.timer);
 		acct_globals.active = 0;
 		acct_globals.needcheck = 0;
@@ -185,6 +189,7 @@ static void acct_file_reopen(struct file *file)
 	}
 	if (file) {
 		acct_globals.file = file;
+		acct_globals.ns = get_pid_ns(task_active_pid_ns(current));
 		acct_globals.needcheck = 0;
 		acct_globals.active = 1;
 		/* It's been deleted if it was used before so this is safe */
@@ -196,8 +201,9 @@ static void acct_file_reopen(struct file *file)
 	if (old_acct) {
 		mnt_unpin(old_acct->f_path.mnt);
 		spin_unlock(&acct_globals.lock);
-		do_acct_process(old_acct);
+		do_acct_process(old_ns, old_acct);
 		filp_close(old_acct, NULL);
+		put_pid_ns(old_ns);
 		spin_lock(&acct_globals.lock);
 	}
 }
@@ -419,7 +425,7 @@ static u32 encode_float(u64 value)
 /*
  *  do_acct_process does all actual work. Caller holds the reference to file.
  */
-static void do_acct_process(struct file *file)
+static void do_acct_process(struct pid_namespace *ns, struct file *file)
 {
 	struct pacct_struct *pacct = &current->signal->pacct;
 	acct_t ac;
@@ -481,9 +487,9 @@ static void do_acct_process(struct file *file)
 	ac.ac_gid16 = current->gid;
 #endif
 #if ACCT_VERSION==3
-	ac.ac_pid = current->tgid;
+	ac.ac_pid = task_tgid_nr_ns(current, ns);
 	rcu_read_lock();
-	ac.ac_ppid = rcu_dereference(current->real_parent)->tgid;
+	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent), ns);
 	rcu_read_unlock();
 #endif
 
@@ -580,6 +586,7 @@ void acct_collect(long exitcode, int group_dead)
 void acct_process(void)
 {
 	struct file *file = NULL;
+	struct pid_namespace *ns;
 
 	/*
 	 * accelerate the common fastpath:
@@ -594,8 +601,10 @@ void acct_process(void)
 		return;
 	}
 	get_file(file);
+	ns = get_pid_ns(acct_globals.ns);
 	spin_unlock(&acct_globals.lock);
 
-	do_acct_process(file);
+	do_acct_process(ns, file);
 	fput(file);
+	put_pid_ns(ns);
 }
-- 
1.5.3.4

