Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYKFUMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYKFUMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYKFUMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:12:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:58499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYKFUMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:12:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=DbXSUNUmoug932Tq8UIR0FrmNVfCoHdEDa224RbSIun1ii9ZyAPAMhLVmfJ9We4bd
	v/BPP72y/DB7iE9MAi/BQ==
MIME-Version: 1.0
In-Reply-To: <20081106195107.GA17545@x200.localdomain>
References: <b040c32a0811061101j4a93a0f2pe30c0598726acd08@mail.gmail.com>
	 <20081106195107.GA17545@x200.localdomain>
Date: Thu, 6 Nov 2008 12:12:33 -0800
Message-ID: <b040c32a0811061212x2630fda9xdd5adfdf3105044d@mail.gmail.com>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
From: Ken Chen <kenchen@google.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 11:51 AM, Alexey Dobriyan wrote:
> Please, name handler proc_pid_stack following current convention.
> And drop space before casts.

OK.  handler name changed.  For the space between cast, it looks like
there are different styles in the code base, either with or without.
I dropped the space since I don't have strong opinion one way or the
other.

Also wrap proc_pid_stack() inside CONFIG_STACKTRACE to fix compile
time error when config option is not selected.

Signed-off-by: Ken Chen <kenchen@google.com>

index bcceb99..3202d5c 100644
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
index 486cf3f..9026508 100644
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
@@ -340,6 +341,37 @@ static int proc_pid_wchan
 }
 #endif /* CONFIG_KALLSYMS */

+#ifdef CONFIG_STACKTRACE
+#define MAX_STACK_TRACE_DEPTH	32
+static int proc_pid_stack(struct task_struct *task, char *buffer)
+{
+	int i, len = 0;
+	unsigned long *entries;
+	struct stack_trace trace;
+
+	entries = kmalloc(sizeof(*entries) * MAX_STACK_TRACE_DEPTH, GFP_KERNEL);
+	if (!entries)
+		goto out;
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
+		len += sprintf(buffer + len, "[<%p>] %pS\n",
+				(void *)entries[i], (void *)entries[i]);
+	}
+	kfree(entries);
+out:
+	return len;
+}
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 /*
  * Provides /proc/PID/schedstat
@@ -2491,6 +2523,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",      S_IRUGO, pid_wchan),
 #endif
+#ifdef CONFIG_STACKTRACE
+	INF("stack",      S_IRUSR, pid_stack),
+#endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, pid_schedstat),
 #endif
