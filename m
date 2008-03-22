Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYCVPdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYCVPdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 11:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYCVPcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 11:32:52 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:47840 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbYCVPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 11:32:50 -0400
Date: Sat, 22 Mar 2008 17:32:45 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: tracing and mmiotrace
Message-ID: <20080322173245.01e69743@daedalus.pq.iki.fi>
In-Reply-To: <20080322120746.GF13264@elte.hu>
References: <20080321233955.66e75a57@daedalus.pq.iki.fi>
	<20080322120746.GF13264@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 13:07:47 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > > i'd suggest the following: pull x86.git and sched-devel.git into a 
> > > single tree [the two will combine without rejects]. Then try to add a 
> > > kernel/tracing/trace_mmiotrace.c ftrace plugin. The trace_sysprof.c 
> > > plugin might be a good example.
> > 
> > I did this and now I have mmiotrace enabled/disabled via the tracing 
> > framework (what do we call this, since ftrace is one of the tracers?). 
> 
> cool! could you send the patches for that? (even if they are not fully 
> functional yet)

Patch attached in the end. Nice to see how much code disappeared. I tried
to mark all the features I had to break with XXX-comments.

> > The elaborate testing is because I keep hitting a NULL pointer 
> > dereference in tracing_generic_entry_update() suggesting 'entry' is 
> > NULL. Is there some special init function I have to call or what 
> > gives?
> 
> that's weird - _entry_ is NULL?

Yes. See the patch, and my kernel log at
http://jumi.lut.fi/~paalanen/scratch/tracing-dmesg1.txt

First you see my check in __trace_special() trigger, and then NULL
pointer dereference BUG at ffffffff80259332 which translates to
kernel/trace/trace.c:639 in tracing_generic_entry_update(), line:
	entry->preempt_count	= pc & 0xff;
I don't understand why it tries to dereference NULL even when I
check for it.

---
Oh, and during bootup there is an error about -fstack-protector-all
test failed.

> > btw. currently 'cat /debug/tracing/trace' gives the 
> > print_func_help_header() and quits, it never stays waiting for more 
> > data.
> 
> yeah - try "cat /debug/tracing/trace_pipe" for the waiting variant - 
> does that work better?

Not really. IIRC it said "resource temporarily unavailable" until
mmiotrace actually tried to produce data. No header there. So I
cannot make "cat" ready to read and after that start tracing.

> 2.6.26 is still a bit away, i strongly feel that we should do this via 
> the ftrace framework. We could try this: we try to bring it up to full 
> functionality now, even via hacks like multiple trace_special() calls, 
> and then extend/clean-up the interacations and missing callbacks?

Okay, though personally I'm not such a big fan of "hack now, fix later
(if willing)" ;-)
Oops, I forgot the "depends on RELAY" there.


 arch/x86/Kconfig.debug         |    3 +-
 arch/x86/mm/mmio-mod.c         |  208 ++++++----------------------------------
 include/linux/mmiotrace.h      |    6 +
 kernel/trace/Makefile          |    1 +
 kernel/trace/trace.c           |    7 ++
 kernel/trace/trace_mmiotrace.c |   84 ++++++++++++++++
 6 files changed, 130 insertions(+), 179 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 4c4fea0..127f1e9 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -186,7 +186,8 @@ config MMIOTRACE_HOOKS
 
 config MMIOTRACE
 	bool "Memory mapped IO tracing"
-	depends on DEBUG_KERNEL && RELAY && DEBUG_FS
+	depends on DEBUG_KERNEL && RELAY
+	select TRACING
 	select MMIOTRACE_HOOKS
 	default y
 	help
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 7386440..c7a67d7 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -22,9 +22,8 @@
 #define DEBUG 1
 
 #include <linux/module.h>
-#include <linux/relay.h>
 #include <linux/debugfs.h>
-#include <linux/proc_fs.h>
+#include <linux/uaccess.h>
 #include <asm/io.h>
 #include <linux/version.h>
 #include <linux/kallsyms.h>
@@ -63,18 +62,18 @@ static const size_t subbuf_size = 256*1024;
 static DEFINE_PER_CPU(struct trap_reason, pf_reason);
 static DEFINE_PER_CPU(struct mm_io_header_rw, cpu_trace);
 
+#if 0 /* XXX: no way gather this info anymore */
 /* Access to this is not per-cpu. */
 static DEFINE_PER_CPU(atomic_t, dropped);
+#endif
 
 static struct dentry *dir;
-static struct dentry *enabled_file;
 static struct dentry *marker_file;
 
 static DEFINE_MUTEX(mmiotrace_mutex);
 static DEFINE_SPINLOCK(trace_lock);
 static atomic_t mmiotrace_enabled;
 static LIST_HEAD(trace_list);		/* struct remap_trace */
-static struct rchan *chan;
 
 /*
  * Locking in this file:
@@ -93,36 +92,24 @@ static unsigned long	filter_offset;
 static int		nommiotrace;
 static int		ISA_trace;
 static int		trace_pc;
-static int		enable_now;
 
 module_param(n_subbufs, uint, 0);
 module_param(filter_offset, ulong, 0);
 module_param(nommiotrace, bool, 0);
 module_param(ISA_trace, bool, 0);
 module_param(trace_pc, bool, 0);
-module_param(enable_now, bool, 0);
 
 MODULE_PARM_DESC(n_subbufs, "Number of 256kB buffers, default 128.");
 MODULE_PARM_DESC(filter_offset, "Start address of traced mappings.");
 MODULE_PARM_DESC(nommiotrace, "Disable actual MMIO tracing.");
 MODULE_PARM_DESC(ISA_trace, "Do not exclude the low ISA range.");
 MODULE_PARM_DESC(trace_pc, "Record address of faulting instructions.");
-MODULE_PARM_DESC(enable_now, "Start mmiotracing immediately on module load.");
 
 static bool is_enabled(void)
 {
 	return atomic_read(&mmiotrace_enabled);
 }
 
-static void record_timestamp(struct mm_io_header *header)
-{
-	struct timespec now;
-
-	getnstimeofday(&now);
-	header->sec = now.tv_sec;
-	header->nsec = now.tv_nsec;
-}
-
 /*
  * Write callback for the debugfs entry:
  * Read a marker and write it to the mmio trace log
@@ -141,7 +128,6 @@ static ssize_t write_marker(struct file *file, const char __user *buffer,
 	headp = (struct mm_io_header *)event;
 	headp->type = MMIO_MAGIC | (MMIO_MARKER << MMIO_OPCODE_SHIFT);
 	headp->data_len = len;
-	record_timestamp(headp);
 
 	if (copy_from_user(event + sizeof(*headp), buffer, len)) {
 		kfree(event);
@@ -149,9 +135,11 @@ static ssize_t write_marker(struct file *file, const char __user *buffer,
 	}
 
 	spin_lock_irq(&trace_lock);
+#if 0 /* XXX: convert this to use tracing */
 	if (is_enabled())
 		relay_write(chan, event, sizeof(*headp) + len);
 	else
+#endif
 		len = -EINVAL;
 	spin_unlock_irq(&trace_lock);
 	kfree(event);
@@ -242,7 +230,11 @@ static void pre(struct kmmio_probe *p, struct pt_regs *regs,
 	else
 		my_trace->rw.pc = 0;
 
-	record_timestamp(&my_trace->header);
+	/*
+	 * XXX: the timestamp recorded will be *after* the tracing has been
+	 * done, not at the time we hit the instruction. SMP implications
+	 * on event ordering?
+	 */
 
 	switch (type) {
 	case REG_READ:
@@ -295,77 +287,19 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 	default:
 		break;
 	}
-	relay_write(chan, my_trace, sizeof(*my_trace));
+
+	/*
+	 * XXX: Several required values are ignored:
+	 * - mapping id
+	 * - program counter
+	 * Also the address should be physical, not virtual.
+	 */
+	mmio_trace_record(my_trace->header.type, my_trace->rw.address,
+							my_trace->rw.value);
 	put_cpu_var(cpu_trace);
 	put_cpu_var(pf_reason);
 }
 
-/*
- * subbuf_start() relay callback.
- *
- * Defined so that we know when events are dropped due to the buffer-full
- * condition.
- */
-static int subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
-					void *prev_subbuf, size_t prev_padding)
-{
-	unsigned int cpu = buf->cpu;
-	atomic_t *drop = &per_cpu(dropped, cpu);
-	int count;
-	if (relay_buf_full(buf)) {
-		if (atomic_inc_return(drop) == 1)
-			pr_err(NAME "cpu %d buffer full!\n", cpu);
-		return 0;
-	}
-	count = atomic_read(drop);
-	if (count) {
-		pr_err(NAME "cpu %d buffer no longer full, missed %d events.\n",
-								cpu, count);
-		atomic_sub(count, drop);
-	}
-
-	return 1;
-}
-
-static struct file_operations mmio_fops = {
-	.owner = THIS_MODULE,
-};
-
-/* file_create() callback.  Creates relay file in debugfs. */
-static struct dentry *create_buf_file_handler(const char *filename,
-						struct dentry *parent,
-						int mode,
-						struct rchan_buf *buf,
-						int *is_global)
-{
-	struct dentry *buf_file;
-
-	mmio_fops.read = relay_file_operations.read;
-	mmio_fops.open = relay_file_operations.open;
-	mmio_fops.poll = relay_file_operations.poll;
-	mmio_fops.mmap = relay_file_operations.mmap;
-	mmio_fops.release = relay_file_operations.release;
-	mmio_fops.splice_read = relay_file_operations.splice_read;
-
-	buf_file = debugfs_create_file(filename, mode, parent, buf,
-								&mmio_fops);
-
-	return buf_file;
-}
-
-/* file_remove() default callback.  Removes relay file in debugfs. */
-static int remove_buf_file_handler(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-	return 0;
-}
-
-static struct rchan_callbacks relay_callbacks = {
-	.subbuf_start = subbuf_start_handler,
-	.create_buf_file = create_buf_file_handler,
-	.remove_buf_file = remove_buf_file_handler,
-};
-
 static void ioremap_trace_core(unsigned long offset, unsigned long size,
 							void __iomem *addr)
 {
@@ -387,7 +321,6 @@ static void ioremap_trace_core(unsigned long offset, unsigned long size,
 			.pc   = 0
 		}
 	};
-	record_timestamp(&event.header);
 
 	if (!trace) {
 		pr_err(NAME "kmalloc failed in ioremap\n");
@@ -410,7 +343,10 @@ static void ioremap_trace_core(unsigned long offset, unsigned long size,
 	if (!is_enabled())
 		goto not_enabled;
 
-	relay_write(chan, &event, sizeof(event));
+	/*
+	 * XXX: Insufficient data recorded!
+	 */
+	mmio_trace_record(event.header.type, event.map.addr, event.map.len);
 	list_add_tail(&trace->list, &trace_list);
 	if (!nommiotrace)
 		register_kmmio_probe(&trace->probe);
@@ -454,7 +390,6 @@ static void iounmap_trace_core(volatile void __iomem *addr)
 	struct remap_trace *found_trace = NULL;
 
 	pr_debug(NAME "Unmapping %p.\n", addr);
-	record_timestamp(&event.header);
 
 	spin_lock_irq(&trace_lock);
 	if (!is_enabled())
@@ -469,7 +404,8 @@ static void iounmap_trace_core(volatile void __iomem *addr)
 			break;
 		}
 	}
-	relay_write(chan, &event, sizeof(event));
+	mmio_trace_record(event.header.type, event.map.addr,
+					found_trace ? found_trace->id : -1);
 
 not_enabled:
 	spin_unlock_irq(&trace_lock);
@@ -512,77 +448,23 @@ static void clear_trace_list(void)
 	}
 }
 
-static ssize_t read_enabled_file_bool(struct file *file,
-		char __user *user_buf, size_t count, loff_t *ppos)
-{
-	char buf[3];
-
-	if (is_enabled())
-		buf[0] = '1';
-	else
-		buf[0] = '0';
-	buf[1] = '\n';
-	buf[2] = '\0';
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
-}
-
-static void enable_mmiotrace(void);
-static void disable_mmiotrace(void);
-
-static ssize_t write_enabled_file_bool(struct file *file,
-		const char __user *user_buf, size_t count, loff_t *ppos)
-{
-	char buf[32];
-	int buf_size = min(count, (sizeof(buf)-1));
-
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
-	switch (buf[0]) {
-	case 'y':
-	case 'Y':
-	case '1':
-		enable_mmiotrace();
-		break;
-	case 'n':
-	case 'N':
-	case '0':
-		disable_mmiotrace();
-		break;
-	}
-
-	return count;
-}
-
-/* this ripped from kernel/kprobes.c */
-static struct file_operations fops_enabled = {
-	.owner =	THIS_MODULE,
-	.read =		read_enabled_file_bool,
-	.write =	write_enabled_file_bool
-};
-
 static struct file_operations fops_marker = {
 	.owner =	THIS_MODULE,
 	.write =	write_marker
 };
 
-static void enable_mmiotrace(void)
+void enable_mmiotrace(void)
 {
 	mutex_lock(&mmiotrace_mutex);
 	if (is_enabled())
 		goto out;
 
-	chan = relay_open("cpu", dir, subbuf_size, n_subbufs,
-						&relay_callbacks, NULL);
-	if (!chan) {
-		pr_err(NAME "relay app channel creation failed.\n");
-		goto out;
-	}
-
 	reference_kmmio();
 
+#if 0 /* XXX: tracing does not support text entries */
 	marker_file = debugfs_create_file("marker", 0660, dir, NULL,
 								&fops_marker);
+#endif
 	if (!marker_file)
 		pr_err(NAME "marker file creation failed.\n");
 
@@ -598,7 +480,7 @@ out:
 	mutex_unlock(&mmiotrace_mutex);
 }
 
-static void disable_mmiotrace(void)
+void disable_mmiotrace(void)
 {
 	mutex_lock(&mmiotrace_mutex);
 	if (!is_enabled())
@@ -615,17 +497,13 @@ static void disable_mmiotrace(void)
 		debugfs_remove(marker_file);
 		marker_file = NULL;
 	}
-	if (chan) {
-		relay_close(chan);
-		chan = NULL;
-	}
 
 	pr_info(NAME "disabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
 }
 
-static int __init init(void)
+int __init init_mmiotrace(void)
 {
 	pr_debug(NAME "load...\n");
 	if (n_subbufs < 2)
@@ -636,31 +514,5 @@ static int __init init(void)
 		pr_err(NAME "Couldn't create relay app directory.\n");
 		return -ENOMEM;
 	}
-
-	enabled_file = debugfs_create_file("enabled", 0600, dir, NULL,
-								&fops_enabled);
-	if (!enabled_file) {
-		pr_err(NAME "Couldn't create enabled file.\n");
-		debugfs_remove(dir);
-		return -ENOMEM;
-	}
-
-	if (enable_now)
-		enable_mmiotrace();
-
 	return 0;
 }
-
-static void __exit cleanup(void)
-{
-	pr_debug(NAME "unload...\n");
-	if (enabled_file)
-		debugfs_remove(enabled_file);
-	disable_mmiotrace();
-	if (dir)
-		debugfs_remove(dir);
-}
-
-module_init(init);
-module_exit(cleanup);
-MODULE_LICENSE("GPL");
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index cb5efd0..579b3b0 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -54,6 +54,12 @@ static inline void mmiotrace_iounmap(volatile void __iomem *addr)
 }
 #endif /* CONFIG_MMIOTRACE_HOOKS */
 
+/* in kernel/trace/trace_mmiotrace.c */
+extern int __init init_mmiotrace(void);
+extern void enable_mmiotrace(void);
+extern void disable_mmiotrace(void);
+extern void mmio_trace_record(u32 type, unsigned long addr, unsigned long arg);
+
 #endif /* __KERNEL__ */
 
 
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 4ec1f52..fd8c5a4 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -15,5 +15,6 @@ obj-$(CONFIG_FTRACE) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_PREEMPT_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
+obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 64ea829..05444b0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -682,6 +682,13 @@ __trace_special(void *__tr, void *__data,
 
 	spin_lock_irqsave(&data->lock, irq_flags);
 	entry			= tracing_get_trace_entry(tr, data);
+	if (!entry) {
+		static unsigned limit;
+		if (limit++ < 12)
+			pr_err("%s: Dereferencing NULL, arrr!\n", __func__);
+		spin_unlock_irqrestore(&data->lock, irq_flags);
+		return;
+	}
 	tracing_generic_entry_update(entry, 0);
 	entry->type		= TRACE_SPECIAL;
 	entry->special.arg1	= arg1;
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
new file mode 100644
index 0000000..e4dd03c
--- /dev/null
+++ b/kernel/trace/trace_mmiotrace.c
@@ -0,0 +1,84 @@
+/*
+ * Memory mapped I/O tracing
+ *
+ * Copyright (C) 2008 Pekka Paalanen <pq@iki.fi>
+ */
+
+#define DEBUG 1
+
+#include <linux/kernel.h>
+#include <linux/mmiotrace.h>
+
+#include "trace.h"
+
+extern void
+__trace_special(void *__tr, void *__data,
+		unsigned long arg1, unsigned long arg2, unsigned long arg3);
+
+static struct trace_array *mmio_trace_array;
+
+
+static void mmio_trace_init(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	mmio_trace_array = tr;
+	if (tr->ctrl)
+		enable_mmiotrace();
+}
+
+static void mmio_trace_reset(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	if (tr->ctrl)
+		disable_mmiotrace();
+}
+
+static void mmio_trace_ctrl_update(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	if (tr->ctrl)
+		enable_mmiotrace();
+	else
+		disable_mmiotrace();
+}
+
+static struct tracer mmio_tracer __read_mostly =
+{
+	.name		= "mmiotrace",
+	.init		= mmio_trace_init,
+	.reset		= mmio_trace_reset,
+	.ctrl_update	= mmio_trace_ctrl_update,
+};
+
+__init static int init_mmio_trace(void)
+{
+	int ret = init_mmiotrace();
+	if (ret)
+		return ret;
+	return register_tracer(&mmio_tracer);
+}
+device_initcall(init_mmio_trace);
+
+void mmio_trace_record(u32 type, unsigned long addr, unsigned long arg)
+{
+	struct trace_array *tr = mmio_trace_array;
+	struct trace_array_cpu *data = tr->data[smp_processor_id()];
+
+	if (!current || current->pid == 0) {
+		/*
+		 * XXX: This is a problem. We need to able to record, no
+		 * matter what. tracing_generic_entry_update() would crash.
+		 */
+		static unsigned limit;
+		if (limit++ < 12)
+			pr_err("Error in %s: no current.\n", __func__);
+		return;
+	}
+	if (!tr || !data) {
+		static unsigned limit;
+		if (limit++ < 12)
+			pr_err("%s: no tr or data\n", __func__);
+		return;
+	}
+	__trace_special(tr, data, type, addr, arg);
+}

