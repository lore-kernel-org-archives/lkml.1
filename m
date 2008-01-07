Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYAGQ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYAGQ6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYAGQ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:58:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57285 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbYAGQ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:58:44 -0500
Subject: [PATCH 12/11] sched: rt-group: uid-group interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080107122330.GB25945@linux.vnet.ibm.com>
References: <20080106161128.152634000@chello.nl>
	 <1199703080.7143.24.camel@twins>
	 <20080107122330.GB25945@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 17:57:42 +0100
Message-Id: <1199725063.31975.53.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: sched: rt-group: add uid-group interface

Extend the /sys/kernel/uids/<uid>/ interface to allow setting
the group's rt_period and rt_runtime.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    4 +-
 kernel/user.c         |   93 +++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 84 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -559,7 +559,9 @@ struct user_struct {
 	struct task_group *tg;
 #ifdef CONFIG_SYSFS
 	struct kset kset;
-	struct subsys_attribute user_attr;
+	struct subsys_attribute share_attr;
+	struct subsys_attribute rt_period_attr;
+	struct subsys_attribute rt_runtime_attr;
 	struct work_struct work;
 #endif
 #endif
Index: linux-2.6/kernel/user.c
===================================================================
--- linux-2.6.orig/kernel/user.c
+++ linux-2.6/kernel/user.c
@@ -129,7 +129,7 @@ static inline void uids_mutex_unlock(voi
 }
 
 /* return cpu shares held by the user */
-static ssize_t cpu_shares_show(struct kset *kset, char *buffer)
+static ssize_t cpu_share_show(struct kset *kset, char *buffer)
 {
 	struct user_struct *up = container_of(kset, struct user_struct, kset);
 
@@ -137,8 +137,8 @@ static ssize_t cpu_shares_show(struct ks
 }
 
 /* modify cpu shares held by the user */
-static ssize_t cpu_shares_store(struct kset *kset, const char *buffer,
-				size_t size)
+static ssize_t cpu_share_store(struct kset *kset, const char *buffer,
+			       size_t size)
 {
 	struct user_struct *up = container_of(kset, struct user_struct, kset);
 	unsigned long shares;
@@ -151,12 +151,67 @@ static ssize_t cpu_shares_store(struct k
 	return (rc ? rc : size);
 }
 
-static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
+static ssize_t cpu_rt_period_show(struct kset *kset, char *buffer)
 {
-	sa->attr.name = name;
-	sa->attr.mode = mode;
-	sa->show = cpu_shares_show;
-	sa->store = cpu_shares_store;
+	struct user_struct *up = container_of(kset, struct user_struct, kset);
+
+	return sprintf(buffer, "%lu\n", sched_group_rt_period(up->tg));
+}
+
+static ssize_t cpu_rt_period_store(struct kset *kset, const char *buffer,
+				   size_t size)
+{
+	struct user_struct *up = container_of(kset, struct user_struct, kset);
+	unsigned long rt_period_us;
+	int rc;
+
+	sscanf(buffer, "%lu", &rt_period_us);
+	rc = sched_group_set_rt_period(up->tg, rt_period_us);
+
+	return (rc ?: size);
+}
+
+static ssize_t cpu_rt_runtime_show(struct kset *kset, char *buffer)
+{
+	struct user_struct *up = container_of(kset, struct user_struct, kset);
+
+	return sprintf(buffer, "%lu\n", sched_group_rt_runtime(up->tg));
+}
+
+static ssize_t cpu_rt_runtime_store(struct kset *kset, const char *buffer,
+				    size_t size)
+{
+	struct user_struct *up = container_of(kset, struct user_struct, kset);
+	unsigned long rt_runtime_us;
+	int rc;
+
+	sscanf(buffer, "%lu", &rt_runtime_us);
+	rc = sched_group_set_rt_runtime(up->tg, rt_runtime_us);
+
+	return (rc ?: size);
+}
+
+static void user_attr_init(struct user_struct *up)
+{
+	struct subsys_attribute *sa;
+
+	sa = &up->share_attr;
+	sa->attr.name = "cpu_share";
+	sa->attr.mode = 0644;
+	sa->show = cpu_share_show;
+	sa->store = cpu_share_store;
+
+	sa = &up->rt_period_attr;
+	sa->attr.name = "cpu_rt_period_us";
+	sa->attr.mode = 0644;
+	sa->show = cpu_rt_period_show;
+	sa->store = cpu_rt_period_store;
+
+	sa = &up->rt_runtime_attr;
+	sa->attr.name = "cpu_rt_runtime_us";
+	sa->attr.mode = 0644;
+	sa->show = cpu_rt_runtime_show;
+	sa->store = cpu_rt_runtime_store;
 }
 
 /* Create "/sys/kernel/uids/<uid>" directory and
@@ -172,15 +227,27 @@ static int user_kobject_create(struct us
 	kobj->parent = &uids_kobject;	/* create under /sys/kernel/uids dir */
 	kobject_set_name(kobj, "%d", up->uid);
 	kset_init(kset);
-	user_attr_init(&up->user_attr, "cpu_share", 0644);
+	user_attr_init(up);
 
 	error = kobject_add(kobj);
 	if (error)
 		goto done;
 
-	error = sysfs_create_file(kobj, &up->user_attr.attr);
+	error = sysfs_create_file(kobj, &up->share_attr.attr);
+	if (error)
+		goto error1;
+	error = sysfs_create_file(kobj, &up->rt_period_attr.attr);
 	if (error)
-		kobject_del(kobj);
+		goto error2;
+	error = sysfs_create_file(kobj, &up->rt_runtime_attr.attr);
+	if (error)
+		goto error3;
+
+	if (0) {
+error3:		sysfs_remove_file(kobj, &up->rt_period_attr.attr);
+error2: 	sysfs_remove_file(kobj, &up->share_attr.attr);
+error1: 	kobject_del(kobj);
+	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
@@ -238,7 +305,9 @@ static void remove_user_sysfs_dir(struct
 	if (!remove_user)
 		goto done;
 
-	sysfs_remove_file(kobj, &up->user_attr.attr);
+	sysfs_remove_file(kobj, &up->share_attr.attr);
+	sysfs_remove_file(kobj, &up->rt_period_attr.attr);
+	sysfs_remove_file(kobj, &up->rt_runtime_attr.attr);
 	kobject_uevent(kobj, KOBJ_REMOVE);
 	kobject_del(kobj);
 


