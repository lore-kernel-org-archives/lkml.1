Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYKGH7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYKGH7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYKGH7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:59:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYKGH7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:59:36 -0500
Date: Fri, 7 Nov 2008 08:59:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081107075925.GA1825@elte.hu>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107074147.GA26607@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > + * buffer size used for proc read.  See proc_info_read().
> > > + * 4K page size but our output routines use some slack for overruns
> > > + */
> > > +#define PROC_BLOCK_SIZE	(3*1024)
> 
> That sounds like a proper limit - the hard limit for this particular 
> printout function is 4096-170, so we are well within the 
> PROC_BLOCK_SIZE range.

ok, i've added Ken's patch to tip/core/stacktrace and started testing 
it.

Alexey, i've added your Acked-by because you appeared to like the 
patch - let me know if i should remove it.

i've done a few finishing touches to the patch as well - see the end 
result below.

Andrew, i remember that you found some sort of problem (crashes?) with 
stack-dumping tasks that are running on another CPU (or something like 
that) - do you remember the specifics? Could we run into any of those 
problems with the patch below, on some rare architecture?

	Ingo

------------------->
>From d3d23f82adeb5ec8a9546747d1df058dcaad0589 Mon Sep 17 00:00:00 2001
From: Ken Chen <kenchen@google.com>
Date: Thu, 6 Nov 2008 16:30:23 -0800
Subject: [PATCH] stacktrace: add /proc/<pid>/stack to dump task's stack trace

Impact: add the new (root-only) /proc/<pid>/stack debug facility

This patch adds the ability to query a task's current stack trace via
/proc/<pid>/stack.

It is considered to be more useful than /proc/pid/wchan as it provides
full stack trace instead of single depth.

It is also more useful than sysrq-t because it does not overflow the
dmesg like sysrq-t often does, can be read in a finegrained per-task
way and can be read programmatically as well.

It works on sleeping and running tasks as well.

Also, move up PROC_BLOCK_SIZE a bit so that proc_pid_stack() can use it.

[ mingo@elte.hu: small cleanups, comments ]

Signed-off-by: Ken Chen <kenchen@google.com>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/filesystems/proc.txt |    1 +
 fs/proc/base.c                     |   52 ++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index bcceb99..11f5b75 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -139,6 +139,7 @@ Table 1-1: Process specific entries in /proc
  statm		Process memory status information
  status		Process status in human readable form
  wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
+ stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		Extension based on maps, the rss size for each mapped file
 ..............................................................................
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 486cf3f..805e514 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -65,6 +65,7 @@
 #include <linux/mm.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
+#include <linux/stacktrace.h>
 #include <linux/resource.h>
 #include <linux/module.h>
 #include <linux/mount.h>
@@ -130,6 +131,12 @@ struct pid_entry {
 		{ .proc_show = &proc_##OTYPE } )
 
 /*
+ * buffer size used for proc read.  See proc_info_read().
+ * 4K page size but our output routines use some slack for overruns
+ */
+#define PROC_BLOCK_SIZE	(3*1024)
+
+/*
  * Count the number of hardlinks for the pid_entry table, excluding the .
  * and .. links.
  */
@@ -340,6 +347,46 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_KALLSYMS */
 
+#ifdef CONFIG_STACKTRACE
+
+#define MAX_STACK_TRACE_DEPTH	64
+
+static int proc_pid_stack(struct task_struct *task, char *buffer)
+{
+	struct stack_trace trace;
+	unsigned long *entries;
+	int i, len = 0;
+
+	entries = kmalloc(sizeof(*entries)*MAX_STACK_TRACE_DEPTH, GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	trace.nr_entries	= 0;
+	trace.max_entries	= MAX_STACK_TRACE_DEPTH;
+	trace.entries		= entries;
+	trace.skip		= 0;
+
+	/*
+	 * Protect against the task exiting (and deallocating its
+	 * stack, etc.) while we save its backtrace:
+	 */
+	read_lock(&tasklist_lock);
+	save_stack_trace_tsk(task, &trace);
+	read_unlock(&tasklist_lock);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		len += snprintf(buffer + len, PROC_BLOCK_SIZE - len,
+				"[<%p>] %pS\n",
+				(void *)entries[i], (void *)entries[i]);
+		if (!len)
+			break;
+	}
+	kfree(entries);
+
+	return len;
+}
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 /*
  * Provides /proc/PID/schedstat
@@ -688,8 +735,6 @@ static const struct file_operations proc_mountstats_operations = {
 	.release	= mounts_release,
 };
 
-#define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
-
 static ssize_t proc_info_read(struct file * file, char __user * buf,
 			  size_t count, loff_t *ppos)
 {
@@ -2491,6 +2536,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",      S_IRUGO, pid_wchan),
 #endif
+#ifdef CONFIG_STACKTRACE
+	INF("stack",      S_IRUSR, pid_stack),
+#endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, pid_schedstat),
 #endif
