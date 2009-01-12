Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZALPd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZALPd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZALPdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:33:15 -0500
Received: from kandzendo.ru ([195.178.208.66]:57056 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZALPdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:33:14 -0500
Date: Mon, 12 Jan 2009 18:33:05 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Linux killed Kenny, bastard!
Message-ID: <20090112153304.GA19995@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Do you want to own a tame killer? Do you want to control the world?

Start with your computer now and own the planet next: you already have
an OOM-killer in the Linux to kill for you. But to date it was quite
berserk and usually killed not what you would like him to murder.

Now you can add a name of the victims, which will be checked by the
oom-killer, who select the process to kill first among the ones which
have given string in their executable name.

By default the process to be killed is called 'Kenny', and if you like
him, change then name by calling

echo Java > /proc/sys/vm/oom_victim

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3d56fe7..26d4361 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -68,6 +68,7 @@ extern int print_fatal_signals;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
+extern char oom_victim_name[];
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_oom_dump_tasks;
 extern int max_threads;
@@ -1185,6 +1186,15 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "oom_victim",
+		.data		= oom_victim_name,
+		.maxlen		= TASK_COMM_LEN,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index a0a0190..12419f5 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -28,6 +28,8 @@
 #include <linux/memcontrol.h>
 #include <linux/security.h>
 
+char oom_victim_name[TASK_COMM_LEN] = "Kenny";
+
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks;
@@ -205,8 +207,10 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
 	struct timespec uptime;
+	char *name = oom_victim_name;
 	*ppoints = 0;
 
+again:
 	do_posix_clock_monotonic_gettime(&uptime);
 	do_each_thread(g, p) {
 		unsigned long points;
@@ -223,6 +227,9 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
 
+		if (name && !strstr(p->comm, name))
+			continue;
+
 		/*
 		 * This task already has access to memory reserves and is
 		 * being killed. Don't allow any other task access to the
@@ -263,6 +270,15 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		}
 	} while_each_thread(g, p);
 
+	/*
+	 * We did not find the process with requested string in its name,
+	 * so lets search for the usual victim.
+	 */
+	if (name && !chosen) {
+		name = NULL;
+		goto again;
+	}
+
 	return chosen;
 }
 


-- 
	Evgeniy Polyakov
