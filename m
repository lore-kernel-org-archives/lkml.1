Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbYKROrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYKROrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKROqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:46:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYKROqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:46:53 -0500
Date: Tue, 18 Nov 2008 15:46:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20081118144628.GA30090@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      tracing: fix mmiotrace resizing crash

Rakib Mullick (1):
      kernel/profile.c: fix section mismatch warning

Steven Rostedt (2):
      ring-buffer: buffer record on/off switch
      ring-buffer: no preempt for sched_clock()

walimis (1):
      function tracing: fix wrong pos computing when read buffer has been fulfilled


 include/linux/ring_buffer.h |    3 +
 kernel/profile.c            |    2 +-
 kernel/trace/ftrace.c       |   34 ++++++------
 kernel/trace/ring_buffer.c  |  115 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 135 insertions(+), 19 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 536b0ca..e097c2e 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -120,6 +120,9 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 u64 ring_buffer_time_stamp(int cpu);
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
 
+void tracing_on(void);
+void tracing_off(void);
+
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
 };
diff --git a/kernel/profile.c b/kernel/profile.c
index 9830a03..5b7d1ac 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -544,7 +544,7 @@ static const struct file_operations proc_profile_operations = {
 };
 
 #ifdef CONFIG_SMP
-static void __init profile_nop(void *unused)
+static inline void profile_nop(void *unused)
 {
 }
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4a39d24..e602057 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -185,7 +185,6 @@ enum {
 };
 
 static int ftrace_filtered;
-static int tracing_on;
 
 static LIST_HEAD(ftrace_new_addrs);
 
@@ -506,13 +505,10 @@ static int __ftrace_modify_code(void *data)
 {
 	int *command = data;
 
-	if (*command & FTRACE_ENABLE_CALLS) {
+	if (*command & FTRACE_ENABLE_CALLS)
 		ftrace_replace_code(1);
-		tracing_on = 1;
-	} else if (*command & FTRACE_DISABLE_CALLS) {
+	else if (*command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
-		tracing_on = 0;
-	}
 
 	if (*command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
@@ -677,7 +673,7 @@ static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 
 	cnt = num_to_init / ENTRIES_PER_PAGE;
 	pr_info("ftrace: allocating %ld entries in %d pages\n",
-		num_to_init, cnt);
+		num_to_init, cnt + 1);
 
 	for (i = 0; i < cnt; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
@@ -757,13 +753,11 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	void *p = NULL;
 	loff_t l = -1;
 
-	if (*pos != iter->pos) {
-		for (p = t_next(m, p, &l); p && l < *pos; p = t_next(m, p, &l))
-			;
-	} else {
-		l = *pos;
-		p = t_next(m, p, &l);
-	}
+	if (*pos > iter->pos)
+		*pos = iter->pos;
+
+	l = *pos;
+	p = t_next(m, p, &l);
 
 	return p;
 }
@@ -774,15 +768,21 @@ static void t_stop(struct seq_file *m, void *p)
 
 static int t_show(struct seq_file *m, void *v)
 {
+	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = v;
 	char str[KSYM_SYMBOL_LEN];
+	int ret = 0;
 
 	if (!rec)
 		return 0;
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 
-	seq_printf(m, "%s\n", str);
+	ret = seq_printf(m, "%s\n", str);
+	if (ret < 0) {
+		iter->pos--;
+		iter->idx--;
+	}
 
 	return 0;
 }
@@ -808,7 +808,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	iter->pg = ftrace_pages_start;
-	iter->pos = -1;
+	iter->pos = 0;
 
 	ret = seq_open(file, &show_ftrace_seq_ops);
 	if (!ret) {
@@ -895,7 +895,7 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
-		iter->pos = -1;
+		iter->pos = 0;
 		iter->flags = enable ? FTRACE_ITER_FILTER :
 			FTRACE_ITER_NOTRACE;
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2f76193..036456c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -16,14 +16,49 @@
 #include <linux/list.h>
 #include <linux/fs.h>
 
+#include "trace.h"
+
+/* Global flag to disable all recording to ring buffers */
+static int ring_buffers_off __read_mostly;
+
+/**
+ * tracing_on - enable all tracing buffers
+ *
+ * This function enables all tracing buffers that may have been
+ * disabled with tracing_off.
+ */
+void tracing_on(void)
+{
+	ring_buffers_off = 0;
+}
+
+/**
+ * tracing_off - turn off all tracing buffers
+ *
+ * This function stops all tracing buffers from recording data.
+ * It does not disable any overhead the tracers themselves may
+ * be causing. This function simply causes all recording to
+ * the ring buffers to fail.
+ */
+void tracing_off(void)
+{
+	ring_buffers_off = 1;
+}
+
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
 /* FIXME!!! */
 u64 ring_buffer_time_stamp(int cpu)
 {
+	u64 time;
+
+	preempt_disable_notrace();
 	/* shift to debug/test normalization and TIME_EXTENTS */
-	return sched_clock() << DEBUG_SHIFT;
+	time = sched_clock() << DEBUG_SHIFT;
+	preempt_enable_notrace();
+
+	return time;
 }
 
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
@@ -503,6 +538,12 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	LIST_HEAD(pages);
 	int i, cpu;
 
+	/*
+	 * Always succeed at resizing a non-existent buffer:
+	 */
+	if (!buffer)
+		return size;
+
 	size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	size *= BUF_PAGE_SIZE;
 	buffer_size = buffer->pages * BUF_PAGE_SIZE;
@@ -1133,6 +1174,9 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	int cpu, resched;
 
+	if (ring_buffers_off)
+		return NULL;
+
 	if (atomic_read(&buffer->record_disabled))
 		return NULL;
 
@@ -1249,6 +1293,9 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	int ret = -EBUSY;
 	int cpu, resched;
 
+	if (ring_buffers_off)
+		return -EBUSY;
+
 	if (atomic_read(&buffer->record_disabled))
 		return -EBUSY;
 
@@ -2070,3 +2117,69 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	return 0;
 }
 
+static ssize_t
+rb_simple_read(struct file *filp, char __user *ubuf,
+	       size_t cnt, loff_t *ppos)
+{
+	int *p = filp->private_data;
+	char buf[64];
+	int r;
+
+	/* !ring_buffers_off == tracing_on */
+	r = sprintf(buf, "%d\n", !*p);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+rb_simple_write(struct file *filp, const char __user *ubuf,
+		size_t cnt, loff_t *ppos)
+{
+	int *p = filp->private_data;
+	char buf[64];
+	long val;
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	/* !ring_buffers_off == tracing_on */
+	*p = !val;
+
+	(*ppos)++;
+
+	return cnt;
+}
+
+static struct file_operations rb_simple_fops = {
+	.open		= tracing_open_generic,
+	.read		= rb_simple_read,
+	.write		= rb_simple_write,
+};
+
+
+static __init int rb_init_debugfs(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	entry = debugfs_create_file("tracing_on", 0644, d_tracer,
+				    &ring_buffers_off, &rb_simple_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'tracing_on' entry\n");
+
+	return 0;
+}
+
+fs_initcall(rb_init_debugfs);
