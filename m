Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbYCWRRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbYCWRRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 13:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYCWRRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 13:17:10 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:32842 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbYCWRRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 13:17:08 -0400
Date: Sun, 23 Mar 2008 19:16:53 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tracing and mmiotrace
Message-ID: <20080323191653.388921ac@daedalus.pq.iki.fi>
In-Reply-To: <Pine.LNX.4.58.0803221609550.12942@gandalf.stny.rr.com>
References: <20080321233955.66e75a57@daedalus.pq.iki.fi>
	<20080322120746.GF13264@elte.hu>
	<20080322173245.01e69743@daedalus.pq.iki.fi>
	<Pine.LNX.4.58.0803221609550.12942@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here is a patch that makes mmiotrace work almost well within the tracing
framework. The patch applies on top of my previous patch. I have my own
output formatting in place now.

Summary of changes:
- fix the NULL dereference that was due to not calling tracing_reset()
- add print_line() callback into struct tracer
- implement print_line() for mmiotrace, producing up-to-spec text
- add my output header, but that is not really called in the right place
- rewrote the main structs in mmiotrace
- added two new trace entry types: TRACE_MMIO_RW and TRACE_MMIO_MAP
- made some functions in trace.c non-static
- check current==NULL in tracing_generic_entry_update()
- fix(?) comparison in trace_seq_printf()

Things seem to work fine except a few issues. Markers (text lines injected
into mmiotrace log) are missing, I did not feel hacking them in before we
have variable length entries. My output header is printed only for 'trace'
file, but not 'trace_pipe'. For some reason, despite my quick fix,
iter->trace is NULL in print_trace_line() when called from 'trace_pipe'
file, which means I don't get proper output formatting.

I only tried by loading nouveau.ko, which just detects the card, and that
is traced fine. I didn't try further. Map, two reads and unmap. Works
perfectly.

I am missing the information about overflows, I'd prefer to have a
counter for lost events. I didn't try, but I guess currently there is no
way of knowning when it overflows?

So, not too far from being fully operational, it seems :-)
And looking at the diffstat, there also is some 700-900 lines of user space
code that just became obsolete.

Cheers.


 arch/x86/Kconfig.debug         |    2 +-
 arch/x86/mm/mmio-mod.c         |  140 +++++++++++--------------------------
 include/linux/mmiotrace.h      |   85 +++++++----------------
 kernel/trace/trace.c           |   65 +++++++++++------
 kernel/trace/trace.h           |   29 ++++++++
 kernel/trace/trace_mmiotrace.c |  151 ++++++++++++++++++++++++++++++++--------
 6 files changed, 261 insertions(+), 211 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 127f1e9..f412908 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -186,7 +186,7 @@ config MMIOTRACE_HOOKS
 
 config MMIOTRACE
 	bool "Memory mapped IO tracing"
-	depends on DEBUG_KERNEL && RELAY
+	depends on DEBUG_KERNEL
 	select TRACING
 	select MMIOTRACE_HOOKS
 	default y
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index c7a67d7..62abc28 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -37,11 +37,6 @@
 
 #define NAME "mmiotrace: "
 
-/* This app's relay channel files will appear in /debug/mmio-trace */
-static const char APP_DIR[] = "mmio-trace";
-/* the marker injection file in /debug/APP_DIR */
-static const char MARKER_FILE[] = "mmio-marker";
-
 struct trap_reason {
 	unsigned long addr;
 	unsigned long ip;
@@ -56,18 +51,15 @@ struct remap_trace {
 	unsigned long id;
 };
 
-static const size_t subbuf_size = 256*1024;
-
 /* Accessed per-cpu. */
 static DEFINE_PER_CPU(struct trap_reason, pf_reason);
-static DEFINE_PER_CPU(struct mm_io_header_rw, cpu_trace);
+static DEFINE_PER_CPU(struct mmiotrace_rw, cpu_trace);
 
 #if 0 /* XXX: no way gather this info anymore */
 /* Access to this is not per-cpu. */
 static DEFINE_PER_CPU(atomic_t, dropped);
 #endif
 
-static struct dentry *dir;
 static struct dentry *marker_file;
 
 static DEFINE_MUTEX(mmiotrace_mutex);
@@ -82,24 +74,21 @@ static LIST_HEAD(trace_list);		/* struct remap_trace */
  *   and trace_lock.
  * - Routines depending on is_enabled() must take trace_lock.
  * - trace_list users must hold trace_lock.
- * - is_enabled() guarantees that chan is valid.
+ * - is_enabled() guarantees that mmio_trace_record is allowed.
  * - pre/post callbacks assume the effect of is_enabled() being true.
  */
 
 /* module parameters */
-static unsigned int	n_subbufs = 32*4;
 static unsigned long	filter_offset;
 static int		nommiotrace;
 static int		ISA_trace;
 static int		trace_pc;
 
-module_param(n_subbufs, uint, 0);
 module_param(filter_offset, ulong, 0);
 module_param(nommiotrace, bool, 0);
 module_param(ISA_trace, bool, 0);
 module_param(trace_pc, bool, 0);
 
-MODULE_PARM_DESC(n_subbufs, "Number of 256kB buffers, default 128.");
 MODULE_PARM_DESC(filter_offset, "Start address of traced mappings.");
 MODULE_PARM_DESC(nommiotrace, "Disable actual MMIO tracing.");
 MODULE_PARM_DESC(ISA_trace, "Do not exclude the low ISA range.");
@@ -110,6 +99,7 @@ static bool is_enabled(void)
 	return atomic_read(&mmiotrace_enabled);
 }
 
+#if 0 /* XXX: needs rewrite */
 /*
  * Write callback for the debugfs entry:
  * Read a marker and write it to the mmio trace log
@@ -145,6 +135,7 @@ static ssize_t write_marker(struct file *file, const char __user *buffer,
 	kfree(event);
 	return len;
 }
+#endif
 
 static void print_pte(unsigned long address)
 {
@@ -198,9 +189,10 @@ static void pre(struct kmmio_probe *p, struct pt_regs *regs,
 						unsigned long addr)
 {
 	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
-	struct mm_io_header_rw *my_trace = &get_cpu_var(cpu_trace);
+	struct mmiotrace_rw *my_trace = &get_cpu_var(cpu_trace);
 	const unsigned long instptr = instruction_pointer(regs);
 	const enum reason_type type = get_ins_type(instptr);
+	struct remap_trace *trace = p->user_data;
 
 	/* it doesn't make sense to have more than one active trace per cpu */
 	if (my_reason->active_traces)
@@ -212,23 +204,17 @@ static void pre(struct kmmio_probe *p, struct pt_regs *regs,
 	my_reason->addr = addr;
 	my_reason->ip = instptr;
 
-	my_trace->header.type = MMIO_MAGIC;
-	my_trace->header.pid = 0;
-	my_trace->header.data_len = sizeof(struct mm_io_rw);
-	my_trace->rw.address = addr;
-	/*
-	 * struct remap_trace *trace = p->user_data;
-	 * phys = addr - trace->probe.addr + trace->phys;
-	 */
+	my_trace->phys = addr - trace->probe.addr + trace->phys;
+	my_trace->map_id = trace->id;
 
 	/*
 	 * Only record the program counter when requested.
 	 * It may taint clean-room reverse engineering.
 	 */
 	if (trace_pc)
-		my_trace->rw.pc = instptr;
+		my_trace->pc = instptr;
 	else
-		my_trace->rw.pc = 0;
+		my_trace->pc = 0;
 
 	/*
 	 * XXX: the timestamp recorded will be *after* the tracing has been
@@ -238,28 +224,25 @@ static void pre(struct kmmio_probe *p, struct pt_regs *regs,
 
 	switch (type) {
 	case REG_READ:
-		my_trace->header.type |=
-			(MMIO_READ << MMIO_OPCODE_SHIFT) |
-			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
+		my_trace->opcode = MMIO_READ;
+		my_trace->width = get_ins_mem_width(instptr);
 		break;
 	case REG_WRITE:
-		my_trace->header.type |=
-			(MMIO_WRITE << MMIO_OPCODE_SHIFT) |
-			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
-		my_trace->rw.value = get_ins_reg_val(instptr, regs);
+		my_trace->opcode = MMIO_WRITE;
+		my_trace->width = get_ins_mem_width(instptr);
+		my_trace->value = get_ins_reg_val(instptr, regs);
 		break;
 	case IMM_WRITE:
-		my_trace->header.type |=
-			(MMIO_WRITE << MMIO_OPCODE_SHIFT) |
-			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
-		my_trace->rw.value = get_ins_imm_val(instptr);
+		my_trace->opcode = MMIO_WRITE;
+		my_trace->width = get_ins_mem_width(instptr);
+		my_trace->value = get_ins_imm_val(instptr);
 		break;
 	default:
 		{
 			unsigned char *ip = (unsigned char *)instptr;
-			my_trace->header.type |=
-					(MMIO_UNKNOWN_OP << MMIO_OPCODE_SHIFT);
-			my_trace->rw.value = (*ip) << 16 | *(ip + 1) << 8 |
+			my_trace->opcode = MMIO_UNKNOWN_OP;
+			my_trace->width = 0;
+			my_trace->value = (*ip) << 16 | *(ip + 1) << 8 |
 								*(ip + 2);
 		}
 	}
@@ -271,7 +254,7 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 							struct pt_regs *regs)
 {
 	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
-	struct mm_io_header_rw *my_trace = &get_cpu_var(cpu_trace);
+	struct mmiotrace_rw *my_trace = &get_cpu_var(cpu_trace);
 
 	/* this should always return the active_trace count to 0 */
 	my_reason->active_traces--;
@@ -282,20 +265,13 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 
 	switch (my_reason->type) {
 	case REG_READ:
-		my_trace->rw.value = get_ins_reg_val(my_reason->ip, regs);
+		my_trace->value = get_ins_reg_val(my_reason->ip, regs);
 		break;
 	default:
 		break;
 	}
 
-	/*
-	 * XXX: Several required values are ignored:
-	 * - mapping id
-	 * - program counter
-	 * Also the address should be physical, not virtual.
-	 */
-	mmio_trace_record(my_trace->header.type, my_trace->rw.address,
-							my_trace->rw.value);
+	mmio_trace_rw(my_trace);
 	put_cpu_var(cpu_trace);
 	put_cpu_var(pf_reason);
 }
@@ -305,21 +281,11 @@ static void ioremap_trace_core(unsigned long offset, unsigned long size,
 {
 	static atomic_t next_id;
 	struct remap_trace *trace = kmalloc(sizeof(*trace), GFP_KERNEL);
-	struct mm_io_header_map event = {
-		.header = {
-			.type = MMIO_MAGIC |
-					(MMIO_PROBE << MMIO_OPCODE_SHIFT),
-			.sec = 0,
-			.nsec = 0,
-			.pid = 0,
-			.data_len = sizeof(struct mm_io_map)
-		},
-		.map = {
-			.phys = offset,
-			.addr = (unsigned long)addr,
-			.len  = size,
-			.pc   = 0
-		}
+	struct mmiotrace_map map = {
+		.phys = offset,
+		.virt = (unsigned long)addr,
+		.len = size,
+		.opcode = MMIO_PROBE
 	};
 
 	if (!trace) {
@@ -338,15 +304,13 @@ static void ioremap_trace_core(unsigned long offset, unsigned long size,
 		.phys = offset,
 		.id = atomic_inc_return(&next_id)
 	};
+	map.map_id = trace->id;
 
 	spin_lock_irq(&trace_lock);
 	if (!is_enabled())
 		goto not_enabled;
 
-	/*
-	 * XXX: Insufficient data recorded!
-	 */
-	mmio_trace_record(event.header.type, event.map.addr, event.map.len);
+	mmio_trace_mapping(&map);
 	list_add_tail(&trace->list, &trace_list);
 	if (!nommiotrace)
 		register_kmmio_probe(&trace->probe);
@@ -369,21 +333,11 @@ mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr)
 
 static void iounmap_trace_core(volatile void __iomem *addr)
 {
-	struct mm_io_header_map event = {
-		.header = {
-			.type = MMIO_MAGIC |
-				(MMIO_UNPROBE << MMIO_OPCODE_SHIFT),
-			.sec = 0,
-			.nsec = 0,
-			.pid = 0,
-			.data_len = sizeof(struct mm_io_map)
-		},
-		.map = {
-			.phys = 0,
-			.addr = (unsigned long)addr,
-			.len  = 0,
-			.pc   = 0
-		}
+	struct mmiotrace_map map = {
+		.phys = 0,
+		.virt = (unsigned long)addr,
+		.len = 0,
+		.opcode = MMIO_UNPROBE
 	};
 	struct remap_trace *trace;
 	struct remap_trace *tmp;
@@ -404,8 +358,8 @@ static void iounmap_trace_core(volatile void __iomem *addr)
 			break;
 		}
 	}
-	mmio_trace_record(event.header.type, event.map.addr,
-					found_trace ? found_trace->id : -1);
+	map.map_id = (found_trace) ? found_trace->id : -1;
+	mmio_trace_mapping(&map);
 
 not_enabled:
 	spin_unlock_irq(&trace_lock);
@@ -448,10 +402,12 @@ static void clear_trace_list(void)
 	}
 }
 
+#if 0 /* XXX: out of order */
 static struct file_operations fops_marker = {
 	.owner =	THIS_MODULE,
 	.write =	write_marker
 };
+#endif
 
 void enable_mmiotrace(void)
 {
@@ -464,9 +420,9 @@ void enable_mmiotrace(void)
 #if 0 /* XXX: tracing does not support text entries */
 	marker_file = debugfs_create_file("marker", 0660, dir, NULL,
 								&fops_marker);
-#endif
 	if (!marker_file)
 		pr_err(NAME "marker file creation failed.\n");
+#endif
 
 	if (nommiotrace)
 		pr_info(NAME "MMIO tracing disabled.\n");
@@ -502,17 +458,3 @@ void disable_mmiotrace(void)
 out:
 	mutex_unlock(&mmiotrace_mutex);
 }
-
-int __init init_mmiotrace(void)
-{
-	pr_debug(NAME "load...\n");
-	if (n_subbufs < 2)
-		return -EINVAL;
-
-	dir = debugfs_create_dir(APP_DIR, NULL);
-	if (!dir) {
-		pr_err(NAME "Couldn't create relay app directory.\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index 579b3b0..c88a9c1 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -54,73 +54,38 @@ static inline void mmiotrace_iounmap(volatile void __iomem *addr)
 }
 #endif /* CONFIG_MMIOTRACE_HOOKS */
 
-/* in kernel/trace/trace_mmiotrace.c */
-extern int __init init_mmiotrace(void);
-extern void enable_mmiotrace(void);
-extern void disable_mmiotrace(void);
-extern void mmio_trace_record(u32 type, unsigned long addr, unsigned long arg);
-
-#endif /* __KERNEL__ */
-
-
-/*
- * If you change anything here, you must bump MMIO_VERSION.
- * This is the relay data format for user space.
- */
-#define MMIO_VERSION 0x04
-
-/* mm_io_header.type */
-#define MMIO_OPCODE_MASK 0xff
-#define MMIO_OPCODE_SHIFT 0
-#define MMIO_WIDTH_MASK 0xff00
-#define MMIO_WIDTH_SHIFT 8
-#define MMIO_MAGIC (0x6f000000 | (MMIO_VERSION<<16))
-#define MMIO_MAGIC_MASK 0xffff0000
-
-enum mm_io_opcode {          /* payload type: */
-	MMIO_READ = 0x1,     /* struct mm_io_rw */
-	MMIO_WRITE = 0x2,    /* struct mm_io_rw */
-	MMIO_PROBE = 0x3,    /* struct mm_io_map */
-	MMIO_UNPROBE = 0x4,  /* struct mm_io_map */
+enum mm_io_opcode {
+	MMIO_READ = 0x1,     /* struct mmiotrace_rw */
+	MMIO_WRITE = 0x2,    /* struct mmiotrace_rw */
+	MMIO_PROBE = 0x3,    /* struct mmiotrace_map */
+	MMIO_UNPROBE = 0x4,  /* struct mmiotrace_map */
 	MMIO_MARKER = 0x5,   /* raw char data */
-	MMIO_UNKNOWN_OP = 0x6, /* struct mm_io_rw */
+	MMIO_UNKNOWN_OP = 0x6, /* struct mmiotrace_rw */
 };
 
-struct mm_io_header {
-	__u32 type;     /* see MMIO_* macros above */
-	__u32 sec;      /* timestamp */
-	__u32 nsec;
-	__u32 pid;      /* PID of the process, or 0 for kernel core */
-	__u16 data_len; /* length of the following payload */
+struct mmiotrace_rw {
+	unsigned long phys;	/* PCI address of register */
+	unsigned long value;
+	unsigned long pc;	/* optional program counter */
+	int map_id;
+	unsigned char opcode;	/* one of MMIO_{READ,WRITE,UNKNOWN_OP} */
+	unsigned char width;	/* size of register access in bytes */
 };
 
-struct mm_io_rw {
-	__u64 address; /* virtual address of register */
-	__u64 value;
-	__u64 pc;      /* optional program counter */
+struct mmiotrace_map {
+	unsigned long phys;	/* base address in PCI space */
+	unsigned long virt;	/* base virtual address */
+	unsigned long len;	/* mapping size */
+	int map_id;
+	unsigned char opcode;	/* MMIO_PROBE or MMIO_UNPROBE */
 };
 
-struct mm_io_map {
-	__u64 phys;  /* base address in PCI space */
-	__u64 addr;  /* base virtual address */
-	__u64 len;   /* mapping size */
-	__u64 pc;    /* optional program counter */
-};
-
-
-/*
- * These structures are used to allow a single relay_write()
- * call to write a full packet.
- */
-
-struct mm_io_header_rw {
-	struct mm_io_header header;
-	struct mm_io_rw rw;
-} __attribute__((packed));
+/* in kernel/trace/trace_mmiotrace.c */
+extern void enable_mmiotrace(void);
+extern void disable_mmiotrace(void);
+extern void mmio_trace_rw(struct mmiotrace_rw *rw);
+extern void mmio_trace_mapping(struct mmiotrace_map *map);
 
-struct mm_io_header_map {
-	struct mm_io_header header;
-	struct mm_io_map map;
-} __attribute__((packed));
+#endif /* __KERNEL__ */
 
 #endif /* MMIOTRACE_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 05444b0..d7547fb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -37,7 +37,7 @@ unsigned long __read_mostly	tracing_thresh;
 
 static int tracing_disabled = 1;
 
-static long
+long
 ns2usecs(cycle_t nsec)
 {
 	nsec += 500;
@@ -96,18 +96,6 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
 	return nsecs / 1000;
 }
 
-enum trace_type {
-	__TRACE_FIRST_TYPE = 0,
-
-	TRACE_FN,
-	TRACE_CTX,
-	TRACE_WAKE,
-	TRACE_STACK,
-	TRACE_SPECIAL,
-
-	__TRACE_LAST_TYPE
-};
-
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
 	TRACE_FLAG_NEED_RESCHED		= 0x02,
@@ -189,7 +177,7 @@ void *head_page(struct trace_array_cpu *data)
 	return page_address(page);
 }
 
-static int
+int
 trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
 	int len = (PAGE_SIZE - 1) - s->len;
@@ -204,7 +192,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	va_end(ap);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret > len)
+	if (ret >= len)
 		return 0;
 
 	s->len += ret;
@@ -637,7 +625,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags)
 	pc = preempt_count();
 
 	entry->preempt_count	= pc & 0xff;
-	entry->pid		= tsk->pid;
+	entry->pid		= (tsk) ? tsk->pid : 0;
 	entry->t		= ftrace_now(raw_smp_processor_id());
 	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
@@ -682,13 +670,6 @@ __trace_special(void *__tr, void *__data,
 
 	spin_lock_irqsave(&data->lock, irq_flags);
 	entry			= tracing_get_trace_entry(tr, data);
-	if (!entry) {
-		static unsigned limit;
-		if (limit++ < 12)
-			pr_err("%s: Dereferencing NULL, arrr!\n", __func__);
-		spin_unlock_irqrestore(&data->lock, irq_flags);
-		return;
-	}
 	tracing_generic_entry_update(entry, 0);
 	entry->type		= TRACE_SPECIAL;
 	entry->special.arg1	= arg1;
@@ -699,6 +680,40 @@ __trace_special(void *__tr, void *__data,
 	trace_wake_up();
 }
 
+#ifdef CONFIG_MMIOTRACE
+void __trace_mmiotrace_rw(struct trace_array *tr, struct trace_array_cpu *data,
+						struct mmiotrace_rw *rw)
+{
+	struct trace_entry *entry;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&data->lock, irq_flags);
+	entry			= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, 0);
+	entry->type		= TRACE_MMIO_RW;
+	entry->mmiorw		= *rw;
+	spin_unlock_irqrestore(&data->lock, irq_flags);
+
+	trace_wake_up();
+}
+
+void __trace_mmiotrace_map(struct trace_array *tr, struct trace_array_cpu *data,
+						struct mmiotrace_map *map)
+{
+	struct trace_entry *entry;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&data->lock, irq_flags);
+	entry			= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, 0);
+	entry->type		= TRACE_MMIO_MAP;
+	entry->mmiomap		= *map;
+	spin_unlock_irqrestore(&data->lock, irq_flags);
+
+	trace_wake_up();
+}
+#endif
+
 void __trace_stack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long flags,
@@ -1539,6 +1554,9 @@ static int trace_empty(struct trace_iterator *iter)
 
 static int print_trace_line(struct trace_iterator *iter)
 {
+	if (iter->trace && iter->trace->print_line)
+		return iter->trace->print_line(iter);
+
 	if (trace_flags & TRACE_ITER_BIN)
 		return print_bin_fmt(iter);
 
@@ -2158,6 +2176,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		return -ENOMEM;
 
 	iter->tr = &global_trace;
+	iter->trace = current_trace;
 
 	filp->private_data = iter;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fd1febd..408d2da 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -5,6 +5,21 @@
 #include <asm/atomic.h>
 #include <linux/sched.h>
 #include <linux/clocksource.h>
+#include <linux/mmiotrace.h>
+
+enum trace_type {
+	__TRACE_FIRST_TYPE = 0,
+
+	TRACE_FN,
+	TRACE_CTX,
+	TRACE_WAKE,
+	TRACE_STACK,
+	TRACE_SPECIAL,
+	TRACE_MMIO_RW,
+	TRACE_MMIO_MAP,
+
+	__TRACE_LAST_TYPE
+};
 
 /*
  * Function trace entry - function address and parent function addres:
@@ -63,6 +78,8 @@ struct trace_entry {
 		struct ctx_switch_entry		ctx;
 		struct special_entry		special;
 		struct stack_entry		stack;
+		struct mmiotrace_rw		mmiorw;
+		struct mmiotrace_map		mmiomap;
 	};
 };
 
@@ -130,6 +147,7 @@ struct tracer {
 	int			(*selftest)(struct tracer *trace,
 					    struct trace_array *tr);
 #endif
+	int			(*print_line)(struct trace_iterator *iter);
 	struct tracer		*next;
 	int			print_max;
 };
@@ -248,6 +266,15 @@ extern int unregister_tracer_switch(struct tracer_switch_ops *ops);
 extern unsigned long ftrace_update_tot_cnt;
 #endif
 
+#ifdef CONFIG_MMIOTRACE
+extern void __trace_mmiotrace_rw(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct mmiotrace_rw *rw);
+extern void __trace_mmiotrace_map(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct mmiotrace_map *map);
+#endif
+
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 #ifdef CONFIG_FTRACE
 extern int trace_selftest_startup_function(struct tracer *trace,
@@ -280,6 +307,8 @@ extern int trace_selftest_startup_sysprof(struct tracer *trace,
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+extern long ns2usecs(cycle_t nsec);
 
 extern unsigned long trace_flags;
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index e4dd03c..3a12b1a 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -11,19 +11,26 @@
 
 #include "trace.h"
 
-extern void
-__trace_special(void *__tr, void *__data,
-		unsigned long arg1, unsigned long arg2, unsigned long arg3);
-
 static struct trace_array *mmio_trace_array;
 
+static void mmio_reset_data(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr->data[cpu]);
+}
 
 static void mmio_trace_init(struct trace_array *tr)
 {
 	pr_debug("in %s\n", __func__);
 	mmio_trace_array = tr;
-	if (tr->ctrl)
+	if (tr->ctrl) {
+		mmio_reset_data(tr);
 		enable_mmiotrace();
+	}
 }
 
 static void mmio_trace_reset(struct trace_array *tr)
@@ -31,15 +38,110 @@ static void mmio_trace_reset(struct trace_array *tr)
 	pr_debug("in %s\n", __func__);
 	if (tr->ctrl)
 		disable_mmiotrace();
+	mmio_reset_data(tr);
+	mmio_trace_array = NULL;
 }
 
 static void mmio_trace_ctrl_update(struct trace_array *tr)
 {
 	pr_debug("in %s\n", __func__);
-	if (tr->ctrl)
+	if (tr->ctrl) {
+		mmio_reset_data(tr);
 		enable_mmiotrace();
-	else
+	} else {
 		disable_mmiotrace();
+	}
+}
+
+/* XXX: This is not called for trace_pipe file! */
+void mmio_print_header(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	trace_seq_printf(s, "VERSION broken 20070824\n");
+	/* TODO: print /proc/bus/pci/devices contents as PCIDEV lines */
+}
+
+static int mmio_print_rw(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct mmiotrace_rw *rw	= &entry->mmiorw;
+	struct trace_seq *s	= &iter->seq;
+	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned secs		= (unsigned long)t;
+	int ret = 1;
+
+	switch (entry->mmiorw.opcode) {
+	case MMIO_READ:
+		ret = trace_seq_printf(s,
+			"R %d %lu.%06lu %d 0x%lx 0x%lx 0x%lx %d\n",
+			rw->width, secs, usec_rem, rw->map_id, rw->phys,
+			rw->value, rw->pc, entry->pid);
+		break;
+	case MMIO_WRITE:
+		ret = trace_seq_printf(s,
+			"W %d %lu.%06lu %d 0x%lx 0x%lx 0x%lx %d\n",
+			rw->width, secs, usec_rem, rw->map_id, rw->phys,
+			rw->value, rw->pc, entry->pid);
+		break;
+	case MMIO_UNKNOWN_OP:
+		ret = trace_seq_printf(s,
+			"UNKNOWN %lu.%06lu %d 0x%lx %02x,%02x,%02x 0x%lx %d\n",
+			secs, usec_rem, rw->map_id, rw->phys,
+			(rw->value >> 16) & 0xff, (rw->value >> 8) & 0xff,
+			(rw->value >> 0) & 0xff, rw->pc, entry->pid);
+		break;
+	default:
+		ret = trace_seq_printf(s, "rw what?\n");
+		break;
+	}
+	if (ret)
+		return 1;
+	return 0;
+}
+
+static int mmio_print_map(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct mmiotrace_map *m	= &entry->mmiomap;
+	struct trace_seq *s	= &iter->seq;
+	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned secs		= (unsigned long)t;
+	int ret = 1;
+
+	switch (entry->mmiorw.opcode) {
+	case MMIO_PROBE:
+		ret = trace_seq_printf(s,
+			"MAP %lu.%06lu %d 0x%lx 0x%lx 0x%lx 0x%lx %d\n",
+			secs, usec_rem, m->map_id, m->phys, m->virt, m->len,
+			0UL, entry->pid);
+		break;
+	case MMIO_UNPROBE:
+		ret = trace_seq_printf(s,
+			"UNMAP %lu.%06lu %d 0x%lx %d\n",
+			secs, usec_rem, m->map_id, 0UL, entry->pid);
+		break;
+	default:
+		ret = trace_seq_printf(s, "map what?\n");
+		break;
+	}
+	if (ret)
+		return 1;
+	return 0;
+}
+
+/* return 0 to abort printing without consuming current entry in pipe mode */
+static int mmio_print_line(struct trace_iterator *iter)
+{
+	switch (iter->ent->type) {
+	case TRACE_MMIO_RW:
+		return mmio_print_rw(iter);
+	case TRACE_MMIO_MAP:
+		return mmio_print_map(iter);
+	default:
+		return 1; /* ignore unknown entries */
+	}
 }
 
 static struct tracer mmio_tracer __read_mostly =
@@ -47,38 +149,31 @@ static struct tracer mmio_tracer __read_mostly =
 	.name		= "mmiotrace",
 	.init		= mmio_trace_init,
 	.reset		= mmio_trace_reset,
+	.open		= mmio_print_header,
 	.ctrl_update	= mmio_trace_ctrl_update,
+	.print_line	= mmio_print_line,
 };
 
 __init static int init_mmio_trace(void)
 {
-	int ret = init_mmiotrace();
-	if (ret)
-		return ret;
 	return register_tracer(&mmio_tracer);
 }
 device_initcall(init_mmio_trace);
 
-void mmio_trace_record(u32 type, unsigned long addr, unsigned long arg)
+void mmio_trace_rw(struct mmiotrace_rw *rw)
 {
 	struct trace_array *tr = mmio_trace_array;
 	struct trace_array_cpu *data = tr->data[smp_processor_id()];
+	__trace_mmiotrace_rw(tr, data, rw);
+}
 
-	if (!current || current->pid == 0) {
-		/*
-		 * XXX: This is a problem. We need to able to record, no
-		 * matter what. tracing_generic_entry_update() would crash.
-		 */
-		static unsigned limit;
-		if (limit++ < 12)
-			pr_err("Error in %s: no current.\n", __func__);
-		return;
-	}
-	if (!tr || !data) {
-		static unsigned limit;
-		if (limit++ < 12)
-			pr_err("%s: no tr or data\n", __func__);
-		return;
-	}
-	__trace_special(tr, data, type, addr, arg);
+void mmio_trace_mapping(struct mmiotrace_map *map)
+{
+	struct trace_array *tr = mmio_trace_array;
+	struct trace_array_cpu *data;
+
+	preempt_disable();
+	data = tr->data[smp_processor_id()];
+	__trace_mmiotrace_map(tr, data, map);
+	preempt_enable();
 }
