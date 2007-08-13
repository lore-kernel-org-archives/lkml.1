Return-Path: <linux-kernel-owner+w=401wt.eu-S940233AbXHMPoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940233AbXHMPoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946015AbXHMOBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:01:18 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3351 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S946008AbXHMOBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:01:15 -0400
Date: Mon, 13 Aug 2007 10:00:44 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       nhorman@tuxdriver.com
Subject: [PATCH]: proc: export a processes resource limits via proc/<pid>
Message-ID: <20070813140044.GB1960@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey there-
	Currently, there exists no method for a process to query the resource
limits of another process.  They can be inferred via some mechanisms but they
cannot be explicitly determined.  Given that this information can be usefull to
know during the debugging of an application, I've written this patch which
exports all of a processes limits via /proc/<pid>/limits.  Tested successfully
by myself on x86 on top of 2.6.23-rc2-mm1.

Thanks & Regards
Neil


Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

 base.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)


diff --git a/fs/proc/base.c b/fs/proc/base.c
index ed2b224..b3ddf08 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -74,6 +74,7 @@
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
 #include <linux/elf.h>
+#include <asm/resource.h>
 #include "internal.h"
 
 /* NOTE:
@@ -323,6 +324,68 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 	return sprintf(buffer, "%lu\n", points);
 }
 
+struct limit_names {
+	char *name;
+	char *unit;
+};
+
+static struct limit_names lnames[RLIM_NLIMITS] = {
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
+	char *bufptr = buffer;
+
+	struct rlimit rlim[RLIM_NLIMITS];
+
+	read_lock(&tasklist_lock);
+	memcpy(rlim, task->signal->rlim, (sizeof(struct rlimit) * RLIM_NLIMITS));
+	read_unlock(&tasklist_lock);
+
+	/*
+	 * print the file header
+	 */
+	count += sprintf(&bufptr[count], "%-25s %-20s %-20s %-10s\n",
+			"Limit","Soft Limit","Hard Limit","Units");
+
+	for (i=0; i < RLIM_NLIMITS; i++) {
+		if (rlim[i].rlim_cur == RLIM_INFINITY)
+			count += sprintf(&bufptr[count], "%-25s %-20s ", lnames[i].name,"unlimited");
+		else
+			count += sprintf(&bufptr[count], "%-25s %-20lu ", lnames[i].name, rlim[i].rlim_cur);
+
+		if (rlim[i].rlim_max == RLIM_INFINITY)
+			count += sprintf(&bufptr[count], "%-20s ","unlimited");
+		else
+			count += sprintf(&bufptr[count], "%-20lu ", rlim[i].rlim_max);
+
+		if (lnames[i].unit)
+			count += sprintf(&bufptr[count],"%-10s\n", lnames[i].unit);
+		else
+			count += sprintf(&bufptr[count],"\n");
+	}
+
+	return count;
+}
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2017,6 +2080,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("environ",    S_IRUSR, pid_environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
+	INF("limits",	  S_IRUGO, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
@@ -2310,6 +2374,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("environ",   S_IRUSR, pid_environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
+	INF("limits",	 S_IRUGO, pid_limits),
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
