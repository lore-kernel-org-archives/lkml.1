Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0BVNhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:37:25 -0500
Received: from mail.dunaweb.hu ([81.17.184.3]:33925 "EHLO mail.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0BVNhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:37:23 -0500
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2010 08:37:22 EST
Message-ID: <4B82867D.9020007@cybertec.at>
Date: Mon, 22 Feb 2010 14:28:29 +0100
From: Boszormenyi Zoltan <zb@cybertec.at>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Kill specific processes first in OOM-killer
Content-Type: multipart/mixed;
 boundary="------------060705010401010701010708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060705010401010701010708
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit

Hi,

one of our clients wanted the possibility to specify which processes
do they want to get killed first by the OOM-killer in case of low memory.
The agreement included posting the result upstream. The original
was implemented on 2.6.27, it was adapted to 2.6.33-rc8 as well.
Both patches are included.

There's a new /proc/sys/vm/oom_preferred_tasks file which accepts
a string. E.g.:

# echo "/usr/bin/httpd,myforkbomb,oocalc" >/proc/sys/vm/oom_preferred_tasks

The string must contain comma separated process names or executable
pathnames. Upon calling out_of_memory(), the processes are checked
against the list of names. The process name matching is performed in
this order:

1. full pathname of the executable using /proc/PID/exe link
2.  executable name  without full pathname
3. process name using get_task_comm()

If no such matching process is found, the usual badness check is performed.

Best regards,
Zoltán Böszörményi

-- 
Bible has answers for everything. Proof:
"But let your communication be, Yea, yea; Nay, nay: for whatsoever is more
than these cometh of evil." (Matthew 5:37) - basics of digital technology.
"May your kingdom come" - superficial description of plate tectonics

----------------------------------
Zoltán Böszörményi
Cybertec Schönig & Schönig GmbH
http://www.postgresql.at/


--------------060705010401010701010708
Content-Type: text/x-patch;
 name="oom-pref-task-2.6.27-3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="oom-pref-task-2.6.27-3.patch"

diff -durpN linux-2.6.27.orig/include/linux/oom.h linux-2.6.27/include/linux/oom.h
--- linux-2.6.27.orig/include/linux/oom.h	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/include/linux/oom.h	2010-02-15 11:20:43.000000000 +0100
@@ -6,6 +6,7 @@
 /* inclusive */
 #define OOM_ADJUST_MIN (-16)
 #define OOM_ADJUST_MAX 15
+#define OOM_PREF_TASKS_MAX_SIZE (4096)
 
 #ifdef __KERNEL__
 
diff -durpN linux-2.6.27.orig/kernel/sysctl.c linux-2.6.27/kernel/sysctl.c
--- linux-2.6.27.orig/kernel/sysctl.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/kernel/sysctl.c	2010-02-15 11:22:17.000000000 +0100
@@ -48,6 +48,7 @@
 #include <linux/acpi.h>
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -70,6 +71,7 @@ extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_oom_dump_tasks;
+extern char sysctl_oom_preferred_tasks[];
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -888,6 +890,15 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "oom_preferred_tasks",
+		.data		= sysctl_oom_preferred_tasks,
+		.maxlen		= OOM_PREF_TASKS_MAX_SIZE,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
+	{
 		.ctl_name	= VM_OVERCOMMIT_RATIO,
 		.procname	= "overcommit_ratio",
 		.data		= &sysctl_overcommit_ratio,
diff -durpN linux-2.6.27.orig/mm/oom_kill.c linux-2.6.27/mm/oom_kill.c
--- linux-2.6.27.orig/mm/oom_kill.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/mm/oom_kill.c	2010-02-17 17:27:49.000000000 +0100
@@ -27,10 +27,12 @@
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
 #include <linux/security.h>
+#include <linux/proc_fs.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks;
+char sysctl_oom_preferred_tasks[OOM_PREF_TASKS_MAX_SIZE];
 static DEFINE_SPINLOCK(zone_scan_mutex);
 /* #define DEBUG */
 
@@ -267,6 +269,102 @@ static struct task_struct *select_bad_pr
 	return chosen;
 }
 
+/* It's needed to be static, we cannot allocate a new page... */
+static char path_name_tmp[PAGE_SIZE];
+
+/*
+ * Find the next killable task in the preferred task list
+ */
+static struct task_struct *find_next_in_preferred_list(char **preferred_tasks)
+{
+	struct task_struct *g, *p;
+	struct task_struct *chosen = NULL;
+	char *ptr, *endptr, *path;
+	int len;
+#ifdef CONFIG_PROC_FS
+	struct file *exe;
+#endif
+	char	buf[TASK_COMM_LEN];
+
+	ptr = *preferred_tasks;
+retry:
+	/*
+	 * If there's no more names in the comma separated list, return.
+	 */
+	if (!*ptr)
+		return NULL;
+
+	endptr = strstr(ptr, ",");
+	if (!endptr) {
+		len = strlen(ptr);
+		endptr = ptr + len; 
+	} else
+		len = endptr - ptr;
+
+	do_each_thread(g, p) {
+		/*
+		 * skip kernel threads and tasks which have already released
+		 * their mm.
+		 */
+		if (!p->mm)
+			continue;
+		/* skip the init task */
+		if (is_global_init(p))
+			continue;
+
+#ifdef CONFIG_PROC_FS
+		/*
+		 * If the procfs was configured, try to detect these in the below order:
+		 * 1. full pathname of the executable
+		 * 2. whole executable name without the path
+		 */
+		exe = get_mm_exe_file(p->mm);
+		path = d_path(&exe->f_path, path_name_tmp, PAGE_SIZE);
+		if (strncmp(ptr, path, len) == 0 && path[len] == '\0')
+		{
+			printk(KERN_INFO "oom_kill matched path: '%s'\n", path);
+			chosen = p;
+			break;
+		}
+		if (strncmp(ptr, exe->f_dentry->d_name.name, len) == 0 &&
+			exe->f_dentry->d_name.name[len] == '\0')
+		{
+			printk(KERN_INFO "oom_kill matched d_name: '%s'\n", exe->f_dentry->d_name.name);
+			chosen = p;
+			break;
+		}
+#endif
+		/*
+		 * Last chance, use the task's shortened name, possibly
+		 * truncated to TASK_COMM_LEN length.
+		 */
+		path = get_task_comm(buf, p);
+		if (strncmp(ptr, path, len) == 0 && path[len] == 0)
+		{
+			printk(KERN_INFO "oom_kill matched task_comm: '%s'\n", path);
+			chosen = p;
+			break;
+		}
+	} while_each_thread(g, p);
+
+	if (!chosen) {
+		/*
+		 * If there are still names in the list,
+		 * advance in the list and retry.
+		 */
+		if (*endptr) {
+			ptr = endptr + 1;
+			goto retry;
+		}
+
+		/* No more tasknames. */
+		ptr = endptr;
+	}
+
+	*preferred_tasks = ptr;
+	return chosen;
+}
+
 /**
  * dump_tasks - dump current memory state of all system tasks
  * @mem: target memory controller
@@ -525,6 +623,7 @@ void out_of_memory(struct zonelist *zone
 	unsigned long points = 0;
 	unsigned long freed = 0;
 	enum oom_constraint constraint;
+	char *preferred_tasks = sysctl_oom_preferred_tasks;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
@@ -559,10 +658,16 @@ void out_of_memory(struct zonelist *zone
 		}
 retry:
 		/*
+		 * Try to find a task from the preferred task list
+		 * to kill first...
+		 */
+		p = find_next_in_preferred_list(&preferred_tasks);
+		/*
 		 * Rambo mode: Shoot down a process and hope it solves whatever
 		 * issues we may have.
 		 */
-		p = select_bad_process(&points, NULL);
+		if (!p)
+			p = select_bad_process(&points, NULL);
 
 		if (PTR_ERR(p) == -1UL)
 			goto out;

--------------060705010401010701010708
Content-Type: text/x-patch;
 name="oom-pref-task-2.6.33rc8.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="oom-pref-task-2.6.33rc8.patch"

diff -durpN linux-2.6.33-rc8/include/linux/oom.h linux-2.6.33-rc8-oom/include/linux/oom.h
--- linux-2.6.33-rc8/include/linux/oom.h	2010-02-22 14:02:28.000000000 +0100
+++ linux-2.6.33-rc8-oom/include/linux/oom.h	2010-02-22 13:56:05.000000000 +0100
@@ -6,6 +6,7 @@
 /* inclusive */
 #define OOM_ADJUST_MIN (-16)
 #define OOM_ADJUST_MAX 15
+#define OOM_PREF_TASKS_MAX_SIZE (4096)
 
 #ifdef __KERNEL__
 
diff -durpN linux-2.6.33-rc8/kernel/sysctl.c linux-2.6.33-rc8-oom/kernel/sysctl.c
--- linux-2.6.33-rc8/kernel/sysctl.c	2010-02-22 14:02:29.000000000 +0100
+++ linux-2.6.33-rc8-oom/kernel/sysctl.c	2010-02-22 13:57:58.000000000 +0100
@@ -50,6 +50,7 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -71,6 +72,7 @@ extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_oom_dump_tasks;
+extern char sysctl_oom_preferred_tasks[];
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -973,6 +975,15 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "oom_preferred_tasks",
+		.data		= sysctl_oom_preferred_tasks,
+		.maxlen		= OOM_PREF_TASKS_MAX_SIZE,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
+	{
 		.procname	= "overcommit_ratio",
 		.data		= &sysctl_overcommit_ratio,
 		.maxlen		= sizeof(sysctl_overcommit_ratio),
diff -durpN linux-2.6.33-rc8/mm/oom_kill.c linux-2.6.33-rc8-oom/mm/oom_kill.c
--- linux-2.6.33-rc8/mm/oom_kill.c	2010-02-22 14:02:29.000000000 +0100
+++ linux-2.6.33-rc8-oom/mm/oom_kill.c	2010-02-22 14:05:09.000000000 +0100
@@ -27,10 +27,12 @@
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
 #include <linux/security.h>
+#include <linux/proc_fs.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks;
+char sysctl_oom_preferred_tasks[OOM_PREF_TASKS_MAX_SIZE];
 static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
@@ -310,6 +312,102 @@ static struct task_struct *select_bad_pr
 	return chosen;
 }
 
+/* It's needed to be static, we cannot allocate a new page... */
+static char path_name_tmp[PAGE_SIZE];
+
+/*
+ * Find the next killable task in the preferred task list
+ */
+static struct task_struct *find_next_in_preferred_list(char **preferred_tasks)
+{
+	struct task_struct *g, *p;
+	struct task_struct *chosen = NULL;
+	char *ptr, *endptr, *path;
+	int len;
+#ifdef CONFIG_PROC_FS
+	struct file *exe;
+#endif
+	char	buf[TASK_COMM_LEN];
+
+	ptr = *preferred_tasks;
+retry:
+	/*
+	 * If there's no more names in the comma separated list, return.
+	 */
+	if (!*ptr)
+		return NULL;
+
+	endptr = strstr(ptr, ",");
+	if (!endptr) {
+		len = strlen(ptr);
+		endptr = ptr + len; 
+	} else
+		len = endptr - ptr;
+
+	do_each_thread(g, p) {
+		/*
+		 * skip kernel threads and tasks which have already released
+		 * their mm.
+		 */
+		if (!p->mm)
+			continue;
+		/* skip the init task */
+		if (is_global_init(p))
+			continue;
+
+#ifdef CONFIG_PROC_FS
+		/*
+		 * If the procfs was configured, try to detect these in the below order:
+		 * 1. full pathname of the executable
+		 * 2. whole executable name without the path
+		 */
+		exe = get_mm_exe_file(p->mm);
+		path = d_path(&exe->f_path, path_name_tmp, PAGE_SIZE);
+		if (strncmp(ptr, path, len) == 0 && path[len] == '\0')
+		{
+			printk(KERN_INFO "oom_kill matched path: '%s'\n", path);
+			chosen = p;
+			break;
+		}
+		if (strncmp(ptr, exe->f_dentry->d_name.name, len) == 0 &&
+			exe->f_dentry->d_name.name[len] == '\0')
+		{
+			printk(KERN_INFO "oom_kill matched d_name: '%s'\n", exe->f_dentry->d_name.name);
+			chosen = p;
+			break;
+		}
+#endif
+		/*
+		 * Last chance, use the task's shortened name, possibly
+		 * truncated to TASK_COMM_LEN length.
+		 */
+		path = get_task_comm(buf, p);
+		if (strncmp(ptr, path, len) == 0 && path[len] == 0)
+		{
+			printk(KERN_INFO "oom_kill matched task_comm: '%s'\n", path);
+			chosen = p;
+			break;
+		}
+	} while_each_thread(g, p);
+
+	if (!chosen) {
+		/*
+		 * If there are still names in the list,
+		 * advance in the list and retry.
+		 */
+		if (*endptr) {
+			ptr = endptr + 1;
+			goto retry;
+		}
+
+		/* No more tasknames. */
+		ptr = endptr;
+	}
+
+	*preferred_tasks = ptr;
+	return chosen;
+}
+
 /**
  * dump_tasks - dump current memory state of all system tasks
  * @mem: target memory controller
@@ -558,7 +656,8 @@ void clear_zonelist_oom(struct zonelist 
 static void __out_of_memory(gfp_t gfp_mask, int order)
 {
 	struct task_struct *p;
-	unsigned long points;
+	unsigned long points = 0;
+	char *preferred_tasks = sysctl_oom_preferred_tasks;
 
 	if (sysctl_oom_kill_allocating_task)
 		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
@@ -566,10 +665,17 @@ static void __out_of_memory(gfp_t gfp_ma
 			return;
 retry:
 	/*
+	 * Try to find a task from the preferred task list
+	 * to kill first...
+	 */
+	p = find_next_in_preferred_list(&preferred_tasks);
+
+	/*
 	 * Rambo mode: Shoot down a process and hope it solves whatever
 	 * issues we may have.
 	 */
-	p = select_bad_process(&points, NULL);
+	if (!p)
+		p = select_bad_process(&points, NULL);
 
 	if (PTR_ERR(p) == -1UL)
 		return;

--------------060705010401010701010708--
