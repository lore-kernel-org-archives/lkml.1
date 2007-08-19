Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbXHSNEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbXHSNEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 09:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXHSND6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 09:03:58 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3591 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXHSND5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 09:03:57 -0400
Date: Sun, 19 Aug 2007 09:03:19 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + proc-export-a-processes-resource-limits-via-proc-pid.patch added to -mm tree
Message-ID: <20070819130319.GA25178@hmsreliant.think-freely.org>
References: <20070817222228.GA783@tv-sign.ru> <20070818115816.GA23555@hmsreliant.think-freely.org> <20070818125926.GA74@tv-sign.ru> <20070818185529.GA25372@hmsreliant.think-freely.org> <20070818190351.GA98@tv-sign.ru> <20070818232352.GA25994@hmsreliant.think-freely.org> <20070819085707.GB83@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070819085707.GB83@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Copy That

Currently, there exists no method for a process to query the resource
limits of another process.  They can be inferred via some mechanisms but
they cannot be explicitly determined.  Given that this information can be
usefull to know during the debugging of an application, I've written this
patch which exports all of a processes limits via /proc/<pid>/limits.


Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 base.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)


diff --git a/fs/proc/base.c b/fs/proc/base.c
index ed2b224..2eb197f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -74,6 +74,7 @@
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
 #include <linux/elf.h>
+#include <linux/resource.h>
 #include "internal.h"
 
 /* NOTE:
@@ -323,6 +324,78 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 	return sprintf(buffer, "%lu\n", points);
 }
 
+struct limit_names {
+	char *name;
+	char *unit;
+};
+
+static const struct limit_names lnames[RLIM_NLIMITS] = {
+	[RLIMIT_CPU] = {"Max cpu time", "ms"},
+	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
+	[RLIMIT_DATA] = {"Max data size", "bytes"},
+	[RLIMIT_STACK] = {"Max stack size", "bytes"},
+	[RLIMIT_CORE] = {"Max core file size", "bytes"},
+	[RLIMIT_RSS] = {"Max resident set", "bytes"},
+	[RLIMIT_NPROC] = {"Max processes", "processes"},
+	[RLIMIT_NOFILE] = {"Max open files", "files"},
+	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
+	[RLIMIT_AS] = {"Max address space", "bytes"},
+	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
+	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},
+	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
+	[RLIMIT_NICE] = {"Max nice priority", NULL},
+	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
+};
+
+/* Display limits for a process */
+static int proc_pid_limits(struct task_struct *task, char *buffer)
+{
+	unsigned int i;
+	int count = 0;
+	unsigned long flags;
+	char *bufptr = buffer;
+
+	struct rlimit rlim[RLIM_NLIMITS];
+
+	rcu_read_lock();
+	if (!lock_task_sighand(task,&flags)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
+	unlock_task_sighand(task, &flags);
+	rcu_read_unlock();
+
+	/*
+	 * print the file header
+	 */
+	count += sprintf(&bufptr[count], "%-25s %-20s %-20s %-10s\n",
+			"Limit", "Soft Limit", "Hard Limit", "Units");
+
+	for (i = 0; i < RLIM_NLIMITS; i++) {
+		if (rlim[i].rlim_cur == RLIM_INFINITY)
+			count += sprintf(&bufptr[count], "%-25s %-20s ",
+					 lnames[i].name, "unlimited");
+		else
+			count += sprintf(&bufptr[count], "%-25s %-20lu ",
+					 lnames[i].name, rlim[i].rlim_cur);
+
+		if (rlim[i].rlim_max == RLIM_INFINITY)
+			count += sprintf(&bufptr[count], "%-20s ", "unlimited");
+		else
+			count += sprintf(&bufptr[count], "%-20lu ",
+					 rlim[i].rlim_max);
+
+		if (lnames[i].unit)
+			count += sprintf(&bufptr[count], "%-10s\n",
+					 lnames[i].unit);
+		else
+			count += sprintf(&bufptr[count], "\n");
+	}
+
+	return count;
+}
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2017,6 +2090,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("environ",    S_IRUSR, pid_environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
+	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
@@ -2310,6 +2384,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("environ",   S_IRUSR, pid_environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
+	INF("limits",	 S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
