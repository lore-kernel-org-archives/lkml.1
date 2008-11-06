Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYKFTBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYKFTBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYKFTBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:01:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:50967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYKFTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:01:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=cPRaRITTEpk8C26E3JeXZ4cHTAVKlSDCo/hd1lviX+0CFXqGP5oq8HMhQmtNxMvcT
	HSA3yhbpKDdc3Nxp9S88A==
MIME-Version: 1.0
Date: Thu, 6 Nov 2008 11:01:39 -0800
Message-ID: <b040c32a0811061101j4a93a0f2pe30c0598726acd08@mail.gmail.com>
Subject: [patch] add /proc/pid/stack to dump task's stack trace
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to query a task's stack trace via /proc/pid/stack.
It is considered to be more useful than /proc/pid/wchan as it provides full
stack trace instead of single depth.

Signed-off-by: Ken Chen <kenchen@google.com>

index bcceb99..3202d5c 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -139,6 +139,7 @@ Table 1-1: Process specific entries in /proc
  statm		Process memory status information
  status		Process status in human readable form
  wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
+ stack		If CONFIG_KALLSYMS is set, report full stack trace
  smaps		Extension based on maps, the rss size for each mapped file
 ..............................................................................

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 486cf3f..466e519 100644
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
@@ -338,6 +339,35 @@ static int proc_pid_wchan
 	else
 		return sprintf(buffer, "%s", symname);
 }
+
+#define MAX_STACK_TRACE_DEPTH	32
+static int proc_stack_trace(struct task_struct *task, char *buffer)
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
+				(void *) entries[i], (void *) entries[i]);
+	}
+	kfree(entries);
+out:
+	return len;
+}
 #endif /* CONFIG_KALLSYMS */

 #ifdef CONFIG_SCHEDSTATS
@@ -2489,6 +2519,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
 #endif
 #ifdef CONFIG_KALLSYMS
+	INF("stack",      S_IRUSR, stack_trace),
 	INF("wchan",      S_IRUGO, pid_wchan),
 #endif
 #ifdef CONFIG_SCHEDSTATS
