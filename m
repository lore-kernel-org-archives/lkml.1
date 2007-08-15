Return-Path: <linux-kernel-owner+w=401wt.eu-S935479AbXHOSJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935479AbXHOSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935165AbXHOSIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:08:50 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:41951 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935151AbXHOSIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:08:48 -0400
Subject: [PATCH] on_each_task - let modules iterate a function on each task
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       clark.williams@gmail.com
Content-Type: text/plain
Date: Wed, 15 Aug 2007 14:07:47 -0400
Message-Id: <1187201267.3848.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm writing a module that can do a dynamic isolcpus at run time. This is
much easier to do in the kernel than in userspace.  In order to do this,
I need to iterate over all tasks in the system but I could not find a
way to do this from a module.

So instead of exporting the tasklist_lock (and opening up a great big
can of worms), I wrote this utility function that will allow a module to
iterate some function over all tasks in the system.

Comments and flames welcome.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21.6-rt21/kernel/sched.c
===================================================================
--- linux-2.6.21.6-rt21.orig/kernel/sched.c
+++ linux-2.6.21.6-rt21/kernel/sched.c
@@ -7065,6 +7065,31 @@ void normalize_rt_tasks(void)
 
 #endif /* CONFIG_MAGIC_SYSRQ */
 
+/**
+ * on_each_task - run a function on every task.
+ * @func - function to call on the task
+ * @data - data to pass in to func.
+ *
+ * Iterate a function over all tasks in the system.
+ */
+void on_each_task(int(*func)(struct task_struct *t, void *d), void *data)
+{
+	struct task_struct *g, *p;
+
+	read_lock(&tasklist_lock);
+
+	do_each_thread(g, p) {
+
+		/* do_each_thread is a double loop! */
+		if (func(p, data))
+			goto out;
+
+	} while_each_thread(g, p);
+ out:
+	read_unlock(&tasklist_lock);
+}
+EXPORT_SYMBOL_GPL(on_each_task);
+
 #ifdef CONFIG_IA64
 /*
  * These functions are only useful for the IA64 MCA handling.
Index: linux-2.6.21.6-rt21/include/linux/sched.h
===================================================================
--- linux-2.6.21.6-rt21.orig/include/linux/sched.h
+++ linux-2.6.21.6-rt21/include/linux/sched.h
@@ -2079,6 +2079,8 @@ extern int sched_create_sysfs_power_savi
 
 extern void normalize_rt_tasks(void);
 
+extern void on_each_task(int(*func)(struct task_struct *t, void *d), void *data);
+
 #ifdef CONFIG_TASK_XACCT
 static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
 {


