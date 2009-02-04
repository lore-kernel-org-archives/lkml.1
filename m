Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZBDFht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZBDFht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZBDFhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:37:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:39448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZBDFhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:37:38 -0500
Date: Tue, 3 Feb 2009 16:16:48 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Negative values in /proc/latency_stats
Message-ID: <20090203161648.361a924a@infradead.org>
In-Reply-To: <20090202205545.4e1a32ea.akpm@linux-foundation.org>
References: <4e5e476b0901310542n796dafbem5c656da07a2f8a56@mail.gmail.com>
	<20090202205545.4e1a32ea.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 20:55:45 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 31 Jan 2009 14:42:20 +0100 Corrado Zoccolo
> <czoccolo@gmail.com> wrote:
> 
> > Hello,
> > I found negative numbers sometimes appear in /proc/latency_stats
> > (vanilla kernel 2.6.29-rc3, on x86 cpu, configuration attached)
> > 
> > [corrado@localhost ~]$ while sleep 1; do grep --
> > - /proc/latency_stats
> > >> neg_stats; done
> > ^Z
> > [1]+  Stopped                 sleep 1
> > [corrado@localhost ~]$ cat neg_stats
> > 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> > 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> > 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> > 
> > 
> > I suspect this can be the cause for
> > https://bugs.launchpad.net/ubuntu/+source/latencytop/+bug/297776 ,
> > as I saw it happening on my machine during a kernel recompilation.
> > 
> 
> <discovers kernel/latencytop.c>

how about this?

>From 4384fb13a27994949a75a31a8bbd2c8be10a2a2e Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 3 Feb 2009 16:12:48 -0800
Subject: [PATCH] latencytop: incorporate review feedback from Andrew Morton

Andrew had some suggestions for the latencytop file; this
patch takes care of most of these:
* Add documentation
* Turn account_scheduler_latency into an inline function
* Don't report negative values to userspace
* Make the file operations struct const
* Fix a few checkpatch.pl warnings

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/latencytop.h |   10 +++++-
 kernel/latencytop.c        |   83 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/include/linux/latencytop.h b/include/linux/latencytop.h
index 901c2d6..b0e9989 100644
--- a/include/linux/latencytop.h
+++ b/include/linux/latencytop.h
@@ -9,6 +9,7 @@
 #ifndef _INCLUDE_GUARD_LATENCYTOP_H_
 #define _INCLUDE_GUARD_LATENCYTOP_H_
 
+#include <linux/compiler.h>
 #ifdef CONFIG_LATENCYTOP
 
 #define LT_SAVECOUNT		32
@@ -24,7 +25,14 @@ struct latency_record {
 
 struct task_struct;
 
-void account_scheduler_latency(struct task_struct *task, int usecs, int inter);
+extern int latencytop_enabled;
+void __account_scheduler_latency(struct task_struct *task, int usecs, int inter);
+static inline void
+account_scheduler_latency(struct task_struct *task, int usecs, int inter)
+{
+	if (unlikely(latencytop_enabled))
+		__account_scheduler_latency(task, usecs, inter);
+}
 
 void clear_all_latency_tracing(struct task_struct *p);
 
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index 449db46..1f80c7e 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -9,6 +9,44 @@
  * as published by the Free Software Foundation; version 2
  * of the License.
  */
+
+/*
+ * CONFIG_LATENCYTOP enables a kernel latency tracking infrastructure that is
+ * used by the "latencytop" userspace tool. The latency that is tracked is not
+ * the 'traditional' interrupt latency (which is primarily caused by something
+ * else consuming CPU), but instead, it is the latency an application encounters
+ * because the kernel sleeps on its behalf for various reasons.
+ *
+ * This code tracks 2 levels of statistics:
+ * 1) System level latency
+ * 2) Per process latency
+ *
+ * The latency is stored in fixed sized datastructures in an accumulated form;
+ * if the "same" latency cause is hit twice, this will be tracked as one entry
+ * in the datastructure. Both the count, total accumulated latency and maximum
+ * latency are tracked in this data structure. When the fixed size structure is
+ * full, no new causes are tracked until the buffer is flushed by writing to
+ * the /proc file; the userspace tool does this on a regular basis.
+ *
+ * A latency cause is identified by a stringified backtrace at the point that
+ * the scheduler gets invoked. The userland tool will use this string to
+ * identify the cause of the latency in human readable form.
+ *
+ * The information is exported via /proc/latency_stats and /proc/<pid>/latency.
+ * These files look like this:
+ *
+ * Latency Top version : v0.1
+ * 70 59433 4897 i915_irq_wait drm_ioctl vfs_ioctl do_vfs_ioctl sys_ioctl
+ * |    |    |    |
+ * |    |    |    +----> the stringified backtrace
+ * |    |    +---------> The maximum latency for this entry in microseconds
+ * |    +--------------> The accumulated latency for this entry (microseconds)
+ * +-------------------> The number of times this entry is hit
+ *
+ * (note: the average latency is the acummulated latency deviced by the number
+ * of times)
+ */
+
 #include <linux/latencytop.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
@@ -72,7 +110,7 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
 				firstnonnull = i;
 			continue;
 		}
-		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
+		for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
 			unsigned long record = lat->backtrace[q];
 
 			if (latency_record[i].backtrace[q] != record) {
@@ -101,31 +139,52 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
 	memcpy(&latency_record[i], lat, sizeof(struct latency_record));
 }
 
-static inline void store_stacktrace(struct task_struct *tsk, struct latency_record *lat)
+/*
+ * Iterator to store a backtrace into a latency record entry
+ */
+static inline void store_stacktrace(struct task_struct *tsk,
+					struct latency_record *lat)
 {
 	struct stack_trace trace;
 
 	memset(&trace, 0, sizeof(trace));
 	trace.max_entries = LT_BACKTRACEDEPTH;
 	trace.entries = &lat->backtrace[0];
-	trace.skip = 0;
 	save_stack_trace_tsk(tsk, &trace);
 }
 
+/**
+ * __account_scheduler_latency - record an occured latency
+ * @tsk - the task struct of the task hitting the latency
+ * @usecs - the duration of the latency in microseconds
+ * @inter - 1 if the sleep was interruptible, 0 if uninterruptible
+ *
+ * This function is the main entry point for recording latency entries
+ * as called by the scheduler.
+ *
+ * This function has a few special cases to deal with normal 'non-latency'
+ * sleeps: specifically, interruptible sleep longer than 5 msec is skipped
+ * since this usually is caused by waiting for events via select() and co.
+ *
+ * Negative latencies (caused by time going backwards) are also explicitly
+ * skipped.
+ */
 void __sched
-account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
+__account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 {
 	unsigned long flags;
 	int i, q;
 	struct latency_record lat;
 
-	if (!latencytop_enabled)
-		return;
-
 	/* Long interruptible waits are generally user requested... */
 	if (inter && usecs > 5000)
 		return;
 
+	/* Negative sleeps are time going backwards */
+	/* Zero-time sleeps are non-interesting */
+	if (usecs <= 0)
+		return;
+
 	memset(&lat, 0, sizeof(lat));
 	lat.count = 1;
 	lat.time = usecs;
@@ -143,12 +202,12 @@ account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 	if (tsk->latency_record_count >= LT_SAVECOUNT)
 		goto out_unlock;
 
-	for (i = 0; i < LT_SAVECOUNT ; i++) {
+	for (i = 0; i < LT_SAVECOUNT; i++) {
 		struct latency_record *mylat;
 		int same = 1;
 
 		mylat = &tsk->latency_record[i];
-		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
+		for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
 			unsigned long record = lat.backtrace[q];
 
 			if (mylat->backtrace[q] != record) {
@@ -186,7 +245,7 @@ static int lstats_show(struct seq_file *m, void *v)
 	for (i = 0; i < MAXLR; i++) {
 		if (latency_record[i].backtrace[0]) {
 			int q;
-			seq_printf(m, "%i %li %li ",
+			seq_printf(m, "%i %lu %lu ",
 				latency_record[i].count,
 				latency_record[i].time,
 				latency_record[i].max);
@@ -223,7 +282,7 @@ static int lstats_open(struct inode *inode, struct file *filp)
 	return single_open(filp, lstats_show, NULL);
 }
 
-static struct file_operations lstats_fops = {
+static const struct file_operations lstats_fops = {
 	.open		= lstats_open,
 	.read		= seq_read,
 	.write		= lstats_write,
@@ -236,4 +295,4 @@ static int __init init_lstats_procfs(void)
 	proc_create("latency_stats", 0644, NULL, &lstats_fops);
 	return 0;
 }
-__initcall(init_lstats_procfs);
+device_initcall(init_lstats_procfs);
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
