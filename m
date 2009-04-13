Return-Path: <linux-kernel-owner+w=401wt.eu-S1751314AbZDMRdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbZDMRdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbZDMRcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:32:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZDMRcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:32:48 -0400
Date: Mon, 13 Apr 2009 19:32:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090413173232.GA30862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

[ Note the extension to include/linux/stringify.h - it's safe but 
  touches a generic header. ]

 Thanks,

	Ingo

------------------>
Lai Jiangshan (4):
      tracing: disable seeking for trace_pipe_raw
      tracing: allocate page when needed
      tracing: update file->f_pos when splice(2) it
      tracing: fix splice return too large

Li Zefan (5):
      tracing: fix document references
      tracing/filters: NIL-terminate user input filter
      tracing/filters: fix NULL pointer dereference
      tracing/filters: allow user input integer to be oct or hex
      tracing/filters: return proper error code when writing filter file

Zhaolei (2):
      Make __stringify support variable argument macros too
      ftrace: Output REC->var instead of __entry->var for trace format


 include/linux/stringify.h           |    4 +-
 kernel/trace/Kconfig                |    4 +-
 kernel/trace/trace.c                |   36 ++++++++++++++++++++--------------
 kernel/trace/trace_events.c         |   12 +++++++---
 kernel/trace/trace_events_filter.c  |   14 +++++++++---
 kernel/trace/trace_events_stage_2.h |    4 +-
 6 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/include/linux/stringify.h b/include/linux/stringify.h
index 0b43883..841cec8 100644
--- a/include/linux/stringify.h
+++ b/include/linux/stringify.h
@@ -6,7 +6,7 @@
  * converts to "bar".
  */
 
-#define __stringify_1(x)	#x
-#define __stringify(x)		__stringify_1(x)
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
 
 #endif	/* !__LINUX_STRINGIFY_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2246141..417d198 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -312,7 +312,7 @@ config KMEMTRACE
 	  and profile kernel code.
 
 	  This requires an userspace application to use. See
-	  Documentation/vm/kmemtrace.txt for more information.
+	  Documentation/trace/kmemtrace.txt for more information.
 
 	  Saying Y will make the kernel somewhat larger and slower. However,
 	  if you disable kmemtrace at run-time or boot-time, the performance
@@ -403,7 +403,7 @@ config MMIOTRACE
 	  implementation and works via page faults. Tracing is disabled by
 	  default and can be enabled at run-time.
 
-	  See Documentation/tracers/mmiotrace.txt.
+	  See Documentation/trace/mmiotrace.txt.
 	  If you are not helping to develop drivers, say N.
 
 config MMIOTRACE_TEST
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d28476..1ce5dc6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3277,19 +3277,13 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	info->tr	= &global_trace;
 	info->cpu	= cpu;
-	info->spare	= ring_buffer_alloc_read_page(info->tr->buffer);
+	info->spare	= NULL;
 	/* Force reading ring buffer for first read */
 	info->read	= (unsigned int)-1;
-	if (!info->spare)
-		goto out;
 
 	filp->private_data = info;
 
-	return 0;
-
- out:
-	kfree(info);
-	return -ENOMEM;
+	return nonseekable_open(inode, filp);
 }
 
 static ssize_t
@@ -3304,6 +3298,11 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (!count)
 		return 0;
 
+	if (!info->spare)
+		info->spare = ring_buffer_alloc_read_page(info->tr->buffer);
+	if (!info->spare)
+		return -ENOMEM;
+
 	/* Do we have previous read data to read? */
 	if (info->read < PAGE_SIZE)
 		goto read;
@@ -3342,7 +3341,8 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 {
 	struct ftrace_buffer_info *info = file->private_data;
 
-	ring_buffer_free_read_page(info->tr->buffer, info->spare);
+	if (info->spare)
+		ring_buffer_free_read_page(info->tr->buffer, info->spare);
 	kfree(info);
 
 	return 0;
@@ -3428,14 +3428,19 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	int size, i;
 	size_t ret;
 
-	/*
-	 * We can't seek on a buffer input
-	 */
-	if (unlikely(*ppos))
-		return -ESPIPE;
+	if (*ppos & (PAGE_SIZE - 1)) {
+		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
+		return -EINVAL;
+	}
 
+	if (len & (PAGE_SIZE - 1)) {
+		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
+		if (len < PAGE_SIZE)
+			return -EINVAL;
+		len &= PAGE_MASK;
+	}
 
-	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= size) {
+	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= PAGE_SIZE) {
 		struct page *page;
 		int r;
 
@@ -3474,6 +3479,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.partial[i].offset = 0;
 		spd.partial[i].private = (unsigned long)ref;
 		spd.nr_pages++;
+		*ppos += PAGE_SIZE;
 	}
 
 	spd.nr_pages = i;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 64ec4d2..576f4fa 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -503,6 +503,7 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
+	buf[cnt] = '\0';
 
 	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
 	if (!pred)
@@ -520,9 +521,10 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		return cnt;
 	}
 
-	if (filter_add_pred(call, pred)) {
+	err = filter_add_pred(call, pred);
+	if (err < 0) {
 		filter_free_pred(pred);
-		return -EINVAL;
+		return err;
 	}
 
 	*ppos += cnt;
@@ -569,6 +571,7 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
+	buf[cnt] = '\0';
 
 	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
 	if (!pred)
@@ -586,10 +589,11 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		return cnt;
 	}
 
-	if (filter_add_subsystem_pred(system, pred)) {
+	err = filter_add_subsystem_pred(system, pred);
+	if (err < 0) {
 		filter_free_subsystem_preds(system);
 		filter_free_pred(pred);
-		return -EINVAL;
+		return err;
 	}
 
 	*ppos += cnt;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 026be41..e03cbf1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -215,7 +215,7 @@ static int __filter_add_pred(struct ftrace_event_call *call,
 		}
 	}
 
-	return -ENOMEM;
+	return -ENOSPC;
 }
 
 static int is_string_field(const char *type)
@@ -319,7 +319,7 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 	}
 
 	if (i == MAX_FILTER_PRED)
-		return -EINVAL;
+		return -ENOSPC;
 
 	events_for_each(call) {
 		int err;
@@ -410,16 +410,22 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 		}
 	}
 
+	if (!val_str) {
+		pred->field_name = NULL;
+		return -EINVAL;
+	}
+
 	pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
 	if (!pred->field_name)
 		return -ENOMEM;
 
-	pred->val = simple_strtoull(val_str, &tmp, 10);
+	pred->val = simple_strtoull(val_str, &tmp, 0);
 	if (tmp == val_str) {
 		pred->str_val = kstrdup(val_str, GFP_KERNEL);
 		if (!pred->str_val)
 			return -ENOMEM;
-	}
+	} else if (*tmp != '\0')
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 30743f7..d363c66 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -105,10 +105,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 		return 0;
 
 #undef __entry
-#define __entry "REC"
+#define __entry REC
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, #args
+#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
