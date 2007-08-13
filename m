Return-Path: <linux-kernel-owner+w=401wt.eu-S939811AbXHMX7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939811AbXHMX7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXHMX7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:59:17 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4983 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbXHMX7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:59:14 -0400
Date: Mon, 13 Aug 2007 19:58:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
Message-ID: <20070813235802.GA20093@hmsreliant.think-freely.org>
References: <20070813140044.GB1960@hmsreliant.think-freely.org> <200708132125.47188.ioe-lkml@rameria.de> <20070813201130.GD1960@hmsreliant.think-freely.org> <20070813210402.GB5870@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813210402.GB5870@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 01:04:02AM +0400, Alexey Dobriyan wrote:
> On Mon, Aug 13, 2007 at 04:11:30PM -0400, Neil Horman wrote:
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -323,6 +324,68 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
> >  	return sprintf(buffer, "%lu\n", points);
> >  }
> >  
> > +struct limit_names {
> > +	char *name;
> > +	char *unit;
> > +};
> > +
> > +static const struct limit_names lnames[RLIM_NLIMITS] = {
> > +	[RLIMIT_CPU] = {"Max cpu time", "ms"},
> > +	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
> > +	[RLIMIT_DATA] = {"Max data size", "bytes"},
> > +	[RLIMIT_STACK] = {"Max stack size", "bytes"},
> > +	[RLIMIT_CORE] = {"Max core file size", "bytes"},
> > +	[RLIMIT_RSS] = {"Max resident set", "bytes"},
> > +	[RLIMIT_NPROC] = {"Max processes", "processes"},
> > +	[RLIMIT_NOFILE] = {"Max open files", "files"},
> > +	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
> > +	[RLIMIT_AS] = {"Max address space", "bytes"},
> > +	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
> > +	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},
> 
> this and processes should be left empty methinks, because max signals is
> in fact unitless.
> 
not sure I agree with that.  According to the man page, RLIMIT_SIGPENDING is
counted in number of signals and RLIMIT_NPROC is counted as a number of
processes.

> > +	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
> > +	[RLIMIT_NICE] = {"Max nice priority", NULL},
> > +	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> > +};	
> 
> aha! trailing whitespace!
> 
Fixed :)

> > +static int proc_pid_limits(struct task_struct *task, char *buffer)
> > +{
> > +	unsigned int i;
> > +	int count = 0;
> > +	char *bufptr = buffer;
> > +
> > +	struct rlimit rlim[RLIM_NLIMITS];
> > +
> > +	read_lock(&tasklist_lock);
> > +	memcpy(rlim, task->signal->rlim, (sizeof(struct rlimit) * RLIM_NLIMITS));
> 
> unneeded (, )
> 
I prefer to explicitly show order of operations, but I'm wierd that way, so I'll
change it :)

> > +	read_unlock(&tasklist_lock);
> 
> hmm, fork copies this under task lock of group leader and system calls
> in sys.c too. What's up?
> 
> I'm sure it will give you nonsensical output because of wrong locks but
> I haven't checked.
> 
I don't think so, I borrowed the code there from sys_getrlimit, which also reds
task->signal->rlim (only for one element instead of the whole array, so if its
broken here it should be broken there, but I don't see how.

> FWIW, it survived ~1 hour of cat /proc/*/limits, mini fork bombs, LTP,
> gdb testsuite and one sooper sikrit proggie. on core2
> 
Its survived for a few days for me (while true; do cat /proc/*/limits;done),
with not noticible side effects (other than a slightly higher CPU load :)).

New patch with the ()'s and whitespace fixed.

Regards
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
+	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
@@ -2310,6 +2374,7 @@ static const struct pid_entry tid_base_stuff[] = {
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
