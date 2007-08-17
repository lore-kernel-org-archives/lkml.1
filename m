Return-Path: <linux-kernel-owner+w=401wt.eu-S1764768AbXHQLAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764768AbXHQLAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 07:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758678AbXHQLAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 07:00:16 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4584 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469AbXHQLAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 07:00:13 -0400
Date: Fri, 17 Aug 2007 06:59:18 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
Message-ID: <20070817105918.GA13937@hmsreliant.think-freely.org>
References: <20070813140044.GB1960@hmsreliant.think-freely.org> <20070816123538.GA10430@hmsreliant.think-freely.org> <4379.1187338166@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4379.1187338166@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 04:09:26AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 16 Aug 2007 08:35:38 EDT, Neil Horman said:
> > Hey again-
> > 	Andrew requested that I repost this cleanly, after running the patch
> > through checkpatch.  As requested here it is with the changelog.
> > 
> > Currently, there exists no method for a process to query the resource
> > limits of another process.  They can be inferred via some mechanisms but they
> > cannot be explicitly determined.  Given that this information can be usefull 
> to
> > know during the debugging of an application, I've written this patch which
> > exports all of a processes limits via /proc/<pid>/limits.  
> > 
> > Tested successfully by myself on x86 on top of 2.6.23-rc2-mm1.
> 
> I had only one comment the first time around, and Neil addressed it.
> 
> I've also tested on x86_64 23-rc2-mm1, and it works here too.  I saw where this
> uses units of 'bytes' while the shell 'ulimit' uses 1024-byte units in some
> places, but (a) this lists the units and (b) it's consistent with setrlimit().
> Testing with values >4G show it's 64-bit clean as well.
> 
> One question:  Is the units milliseconds, or seconds here:
> 
> +	[RLIMIT_CPU] = {"Max cpu time", "ms"},
> 
> Other than that, feel free to stick either/both of these on:
> 
> Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Oops, your right,  Thanks. New patch

Currently, there exists no method for a process to query the resource
limits of another process.  They can be inferred via some mechanisms but they
cannot be explicitly determined.  Given that this information can be usefull to
know during the debugging of an application, I've written this patch which
exports all of a processes limits via /proc/<pid>/limits.

Thanks 
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 base.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)


commit 95e91e3102d7963e63d68969b8db5694b83a6684
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Thu Aug 16 08:25:59 2007 -0400

    Readding proc_pid_limits patch with checkpatch.pl run

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ed2b224..4fb34a5 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -74,6 +74,7 @@
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
 #include <linux/elf.h>
+#include <linux/resource.h>
 #include "internal.h"
 
 /* NOTE:
@@ -323,6 +324,72 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 	return sprintf(buffer, "%lu\n", points);
 }
 
+struct limit_names {
+	char *name;
+	char *unit;
+};
+
+static const struct limit_names lnames[RLIM_NLIMITS] = {
+	[RLIMIT_CPU] = {"Max cpu time", "seconds"},
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
+	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
+	read_unlock(&tasklist_lock);
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
@@ -2017,6 +2084,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("environ",    S_IRUSR, pid_environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
+	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
@@ -2310,6 +2378,7 @@ static const struct pid_entry tid_base_stuff[] = {
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
