Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYKGAan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYKGAan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYKGAae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:30:34 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22536 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYKGAad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:30:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:in-reply-to:user-agent;
	b=Qrx68cDILheuMGPXXOYgyOIDVJB9mxdxLvfnizJW/5mCUmOlrGsOka4qvPtxly8OW
	OzhbXI47K963i7TY/6umw==
Date: Thu, 6 Nov 2008 16:30:23 -0800
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081107003021.GA18666@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106203520.GD3578@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 12:35 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> +static int proc_pid_stack(struct task_struct *task, char *buffer)
>> +{
>> +     for (i = 0; i < trace.nr_entries; i++) {
>> +             len += sprintf(buffer + len, "[<%p>] %pS\n",
>> +                             (void *)entries[i], (void
>> *)entries[i]);
>
> hm, this looks like a potential buffer overflow - isnt 'buffer' here
> only valid up to the next PAGE_SIZE boundary?

Yeah.  the size of buffer allocated for printing is done at upper call
site in proc_info_read().  By the time we reach here, the size info is
lost.  It would be too much churn to add a argument to the read method
of proc_op.  Since these functions are all in one file, I moved
PROC_BLOCK_SIZE up so it can be used to check buffer length.  Would
that be enough?  Lots of other proc read methods don't check against
buffer overrun, I suppose those should be fixed as well.

updated patch that also fixed other comments.

Signed-off-by: Ken Chen <kenchen@google.com>


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
index 486cf3f..8fb293d 100644
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
@@ -340,6 +347,37 @@ static int proc_pid_wchan
 }
 #endif /* CONFIG_KALLSYMS */
 
+#ifdef CONFIG_STACKTRACE
+#define MAX_STACK_TRACE_DEPTH	64
+static int proc_pid_stack(struct task_struct *task, char *buffer)
+{
+	int i, len = 0;
+	unsigned long *entries;
+	struct stack_trace trace;
+
+	entries = kmalloc(sizeof(*entries) * MAX_STACK_TRACE_DEPTH, GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	trace.nr_entries = 0;
+	trace.max_entries = MAX_STACK_TRACE_DEPTH;
+	trace.entries = entries;
+	trace.skip = 0;
+
+	read_lock(&tasklist_lock);
+	save_stack_trace_tsk(task, &trace);
+	read_unlock(&tasklist_lock);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		len += snprintf(buffer + len, PROC_BLOCK_SIZE - len,
+				"[<%p>] %pS\n",
+				(void *)entries[i], (void *)entries[i]);
+	}
+	kfree(entries);
+	return len;
+}
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 /*
  * Provides /proc/PID/schedstat
@@ -688,8 +726,6 @@ static const struct file_operations proc_mountstats
 	.release	= mounts_release,
 };
 
-#define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
-
 static ssize_t proc_info_read(struct file * file, char __user * buf,
 			  size_t count, loff_t *ppos)
 {
@@ -2491,6 +2527,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",      S_IRUGO, pid_wchan),
 #endif
+#ifdef CONFIG_STACKTRACE
+	INF("stack",      S_IRUSR, pid_stack),
+#endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, pid_schedstat),
 #endif

