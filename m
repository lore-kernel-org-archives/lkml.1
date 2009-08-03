Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbZHCOr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbZHCOr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932181AbZHCOr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:47:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52052 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbZHCOrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:47:24 -0400
Message-ID: <4A76F8A1.30503@cn.fujitsu.com>
Date: Mon, 03 Aug 2009 22:48:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Dave Anderson <anderson@redhat.com>
CC: crash-utility@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to analyze
 tracing from core-file (make tracing can act as a flight recorder)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We use tracing subsystem very well when kernel is alive.
But we also want to get help from tracing when kernel is core-dump.
This patch is for this purpose. It makes tracing can act as a
flight recorder, we can find what have happen from the events.

This patch is applied for crash-4.0-8.8.
It was tested for linux version 2.6.31-rc5-tip-00972-gd84b9d2 on i386.

The codes is not mature, comments are welcome.

And any request is welcome, it will be added to my plan.

Lai.

crash> help trace

NAME
  trace - show or dump the tracing info

SYNOPSIS
  trace [ <show [-c <cpulist>] [-f [no]<flagname>]> | <dump [-sm] <dest-dir>> ]

DESCRIPTION
trace
    shows the current tracer and other informations.

trace show [ -c <cpulist> ] [ -f [no]<flagename> ]
    shows all events with readability text(sorted by timestamp)
    -c: only shows specified CPUs' events.
        ex. trace show -c 1,2    - only shows cpu#1 and cpu#2 's events.
            trace show -c 0,2-7  - only shows cpu#0, cpu#2...cpu#7's events.
    -f: set or clear a flag
        available flags            default
        context_info               true
        sym_offset                 false
        sym_addr                   false
        graph_print_duration       true
        graph_print_overhead       true
        graph_print_abstime        false
        graph_print_cpu            true
        graph_print_proc           false
        graph_print_overrun        false

trace dump [-sm] <dest-dir>
    dump ring_buffers to dest-dir. Then you can parse it
    by other tracing tools. The dirs and files are generated
    the same as debugfs/tracing.
    -m: also dump metadata of ftrace.
    -s: also dump symbols of the kernel <not implemented>.


EXAMPLE, dump ring_buffer:

crash > trace dump -m dumped_tracing
(quit crash)
# ls -R dumped_tracing
dumped_tracing:
events  per_cpu  saved_cmdlines

dumped_tracing/events:
block  ftrace  irq  kmem  sched  skb  workqueue

dumped_tracing/events/block:
block_bio_backmerge  block_bio_frontmerge  block_plug      block_rq_complete  block_rq_requeue  block_unplug_io
block_bio_bounce     block_bio_queue       block_remap     block_rq_insert    block_sleeprq     block_unplug_timer
block_bio_complete   block_getrq           block_rq_abort  block_rq_issue     block_split

dumped_tracing/events/block/block_bio_backmerge:
format

dumped_tracing/events/block/block_bio_bounce:
format
....
dumped_tracing/per_cpu:
cpu0  cpu1

dumped_tracing/per_cpu/cpu0:
trace_pipe_raw

dumped_tracing/per_cpu/cpu1:
trace_pipe_raw


EXAMPLE, shows function tracer 
crash > trace show
           <...>-3677  [001]  6094.628402: pick_next_task_fair <-schedule
           <...>-3677  [001]  6094.628403: pick_next_task_rt <-schedule
           <...>-3677  [001]  6094.628404: pick_next_task_fair <-schedule
           <...>-3677  [001]  6094.628405: pick_next_task_idle <-schedule
           <...>-3677  [001]  6094.628406: calc_load_account_active <-pick_next_task_idle
           <...>-3677  [001]  6094.628407: perf_counter_task_sched_out <-schedule
       <swapper>-0     [001]  6094.628437: finish_task_switch <-schedule
       <swapper>-0     [001]  6094.628438: perf_counter_task_sched_in <-finish_task_switch
       <swapper>-0     [001]  6094.628439: _spin_unlock_irq <-finish_task_switch
       <swapper>-0     [001]  6094.628440: kretprobe_table_lock_ptr <-kretprobe_table_lock
       <swapper>-0     [001]  6094.628442: _spin_lock_irqsave <-kretprobe_table_lock
....
            bash-3580  [000]  6119.756585: native_apic_mem_read <-default_get_apic_id
            bash-3580  [000]  6119.756616: crash_save_cpu <-native_machine_crash_shutdown
            bash-3580  [000]  6119.756687: append_elf_note <-crash_save_cpu
            bash-3580  [000]  6119.756688: strlen <-append_elf_note
            bash-3580  [000]  6119.756712: final_note <-crash_save_cpu
            bash-3580  [000]  6119.756776: machine_kexec <-crash_kexec
            bash-3580  [000]  6119.756824: page_address <-machine_kexec

EXAMPLE, shows function_graph tracer
crash > trace show
 1)   1.187 us    |            }
 1)               |            hrtimer_forward() {
 1)   1.018 us    |              ktime_add_safe();
 1)   0.953 us    |              ktime_add_safe();
 1)   5.419 us    |            }
 1) + 87.322 us   |          }
 1)   1.028 us    |          _spin_lock();
 1)   1.779 us    |          enqueue_hrtimer();
 1) ! 100.743 us  |        }
 1)   1.043 us    |        _spin_unlock();
 1)               |        tick_program_event() {
 1)               |          tick_dev_program_event() {
 1)   1.148 us    |            ktime_get();

EXAMPLE, shows various events
crash > trace show
       <swapper>-0     [001]  9349.585217: softirq_exit: vec=1
       <swapper>-0     [001]  9349.585218: softirq_entry: vec=8
       <swapper>-0     [001]  9349.585226: kmem_cache_free: call_site=c015a221 ptr=0xcfb16200
       <swapper>-0     [001]  9349.585228: kmem_cache_free: call_site=c0151c32 ptr=0xcfb438c0
       <swapper>-0     [001]  9349.585230: sched_process_free: task dhclient-script:3749 [120]
       <swapper>-0     [001]  9349.585237: kfree: call_site=c017f13a ptr=(nil)
       <swapper>-0     [001]  9349.585239: kmem_cache_free: call_site=c013b8f1 ptr=0xcf056ed0
       <swapper>-0     [001]  9349.585241: softirq_exit: vec=8
           <...>-3752  [000]  9349.585717: kmem_cache_alloc: call_site=c01b6a34 ptr=0xcf2c50b0 bytes_req=88 bytes_alloc=88 gfp_flags=80d0
           <...>-3752  [000]  9349.585732: kmem_cache_alloc: call_site=c01b95fa ptr=0xcf2c61e0 bytes_req=12 bytes_alloc=16 gfp_flags=d0


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/Makefile b/Makefile
index 4996cb2..a14ecc3 100644
--- a/Makefile
+++ b/Makefile
@@ -97,7 +97,7 @@ OBJECT_FILES=main.o tools.o global_data.o memory.o filesys.o help.o task.o \
 	lkcd_x86_trace.o unwind_v1.o unwind_v2.o unwind_v3.o \
 	unwind_x86_32_64.o \
  	xen_hyper.o xen_hyper_command.o xen_hyper_global_data.o \
-	xen_hyper_dump_tables.o
+	xen_hyper_dump_tables.o ftrace.o
 
 # These are the current set of crash extensions sources.  They are not built
 # by default unless the third command line of the "all:" stanza is uncommented.
diff --git a/defs.h b/defs.h
index 1b0950e..3bb54eb 100755
--- a/defs.h
+++ b/defs.h
@@ -512,6 +512,7 @@ struct kernel_table {                   /* kernel data */
 	uint kernel_version[3];
 	uint gcc_version[3];
 	int runq_siblings;
+	int nr_cpu_ids;
 	int kernel_NR_CPUS;
 	long __per_cpu_offset[NR_CPUS];
 	long *__rq_idx;
@@ -3091,6 +3092,7 @@ void cmd_sys(void);          /* kernel.c */
 void cmd_irq(void);          /* kernel.c */
 void cmd_timer(void);        /* kernel.c */
 void cmd_waitq(void);        /* kernel.c */
+void cmd_ftrace(void);       /* ftrace.c */
 void cmd_sym(void);          /* symbols.c */
 void cmd_struct(void);       /* symbols.c */
 void cmd_union(void);        /* symbols.c */
@@ -3272,6 +3274,8 @@ int endian_mismatch(char *, char, ulong);
 uint16_t swap16(uint16_t, int);
 uint32_t swap32(uint32_t, int);
 
+void ftrace_init(void);
+
 /* 
  *  symbols.c 
  */
@@ -3526,6 +3530,7 @@ extern char *help_repeat[];
 extern char *help_runq[];
 extern char *help_search[];
 extern char *help_set[];
+extern char *help_ftrace[];
 extern char *help_sig[];
 extern char *help_struct[];
 extern char *help_swap[];
diff --git a/ftrace.c b/ftrace.c
new file mode 100644
index 0000000..febcd05
--- /dev/null
+++ b/ftrace.c
@@ -0,0 +1,2161 @@
+#define _GNU_SOURCE
+#include "defs.h"
+#include <stdio.h>
+#include <ctype.h>
+#include <stdbool.h>
+#include <setjmp.h>
+
+/* TODO: use more correct way to handle the return value of readmem() */
+
+static int verbose = 0;
+
+/*
+ * lockless ring_buffer and old non-lockless ring_buffer are both supported.
+ */
+#define koffset(struct, member) struct##_##member##_offset
+
+static int ftrace_initialized;
+static int ftrace_no_ftrace;
+
+static int koffset(trace_array, buffer);
+static int koffset(tracer, name);
+
+static int lockless_ring_buffer;
+
+static int koffset(ring_buffer, pages);
+static int koffset(ring_buffer, flags);
+static int koffset(ring_buffer, cpus);
+static int koffset(ring_buffer, buffers);
+
+static int koffset(ring_buffer_per_cpu, cpu);
+static int koffset(ring_buffer_per_cpu, pages);
+static int koffset(ring_buffer_per_cpu, head_page);
+static int koffset(ring_buffer_per_cpu, tail_page);
+static int koffset(ring_buffer_per_cpu, commit_page);
+static int koffset(ring_buffer_per_cpu, reader_page);
+static int koffset(ring_buffer_per_cpu, overrun);
+static int koffset(ring_buffer_per_cpu, entries);
+
+static int koffset(buffer_page, read);
+static int koffset(buffer_page, list);
+static int koffset(buffer_page, page);
+
+static int koffset(list_head, next);
+
+static int koffset(ftrace_event_call, list);
+static int koffset(ftrace_event_call, name);
+static int koffset(ftrace_event_call, system);
+static int koffset(ftrace_event_call, id);
+static int koffset(ftrace_event_call, fields);
+
+static int koffset(ftrace_event_field, link);
+static int koffset(ftrace_event_field, name);
+static int koffset(ftrace_event_field, type);
+static int koffset(ftrace_event_field, offset);
+static int koffset(ftrace_event_field, size);
+static int koffset(ftrace_event_field, is_signed);
+
+static int koffset(POINTER_SYM, POINTER) = 0;
+
+struct ring_buffer_per_cpu {
+	ulong kaddr;
+
+	ulong head_page;
+	ulong tail_page;
+	ulong commit_page;
+	ulong reader_page;
+	ulong real_head_page;
+
+	ulong *pages;
+	int head_page_index;
+
+	ulong overrun;
+	ulong entries;
+};
+
+static ulong global_trace;
+static ulong max_tr_trace;
+
+static ulong global_ring_buffer;
+static ulong max_tr_ring_buffer;
+
+static unsigned global_pages;
+static unsigned max_tr_pages;
+
+static struct ring_buffer_per_cpu *global_buffers;
+static struct ring_buffer_per_cpu *max_tr_buffers;
+
+static ulong ftrace_events;
+static ulong current_trace;
+static const char *current_trace_name;
+
+static void *page_tmp;
+
+/* at = ((struct *)ptr)->member */
+#define read_value(at, ptr, struct, member)				\
+	do {								\
+		if (!readmem(ptr + koffset(struct, member), KVADDR,	\
+				&at, sizeof(at), #struct " " #member,	\
+				RETURN_ON_ERROR | QUIET))		\
+			error(FATAL, "cannot read value, ptr%lu, %d\n", ptr, __LINE__);\
+	} while (0)
+
+static void init_offsets(void)
+{
+#define init_offset(struct, member) koffset(struct, member)		\
+	= MEMBER_OFFSET(#struct, #member);
+
+	init_offset(trace_array, buffer);
+	init_offset(tracer, name);
+
+	init_offset(ring_buffer, pages);
+	init_offset(ring_buffer, flags);
+	init_offset(ring_buffer, cpus);
+	init_offset(ring_buffer, buffers);
+
+	if (MEMBER_SIZE("ring_buffer_per_cpu", "pages") == sizeof(ulong)) {
+		lockless_ring_buffer = 1;
+		if (verbose)
+			fprintf(fp, "lockless\n");
+	}
+
+	init_offset(ring_buffer_per_cpu, cpu);
+	init_offset(ring_buffer_per_cpu, pages);
+	init_offset(ring_buffer_per_cpu, head_page);
+	init_offset(ring_buffer_per_cpu, tail_page);
+	init_offset(ring_buffer_per_cpu, commit_page);
+	init_offset(ring_buffer_per_cpu, reader_page);
+	init_offset(ring_buffer_per_cpu, overrun);
+	init_offset(ring_buffer_per_cpu, entries);
+
+	init_offset(buffer_page, read);
+	init_offset(buffer_page, list);
+	init_offset(buffer_page, page);
+
+	init_offset(list_head, next);
+
+	init_offset(ftrace_event_call, list);
+	init_offset(ftrace_event_call, name);
+	init_offset(ftrace_event_call, system);
+	init_offset(ftrace_event_call, id);
+	init_offset(ftrace_event_call, fields);
+
+	init_offset(ftrace_event_field, link);
+	init_offset(ftrace_event_field, name);
+	init_offset(ftrace_event_field, type);
+	init_offset(ftrace_event_field, offset);
+	init_offset(ftrace_event_field, size);
+	init_offset(ftrace_event_field, is_signed);
+#undef init_offset
+}
+
+static void print_offsets(void)
+{
+	if (!verbose)
+		return;
+
+#define print_offset(struct, member) fprintf(fp,			\
+	"koffset(" #struct ", " #member ") = %d\n", koffset(struct, member))
+
+	print_offset(trace_array, buffer);
+	print_offset(tracer, name);
+
+	print_offset(ring_buffer, pages);
+	print_offset(ring_buffer, flags);
+	print_offset(ring_buffer, cpus);
+	print_offset(ring_buffer, buffers);
+
+	print_offset(ring_buffer_per_cpu, cpu);
+	print_offset(ring_buffer_per_cpu, pages);
+	print_offset(ring_buffer_per_cpu, head_page);
+	print_offset(ring_buffer_per_cpu, tail_page);
+	print_offset(ring_buffer_per_cpu, commit_page);
+	print_offset(ring_buffer_per_cpu, reader_page);
+	print_offset(ring_buffer_per_cpu, overrun);
+	print_offset(ring_buffer_per_cpu, entries);
+
+	print_offset(buffer_page, read);
+	print_offset(buffer_page, list);
+	print_offset(buffer_page, page);
+
+	print_offset(list_head, next);
+
+	print_offset(ftrace_event_call, list);
+	print_offset(ftrace_event_call, name);
+	print_offset(ftrace_event_call, system);
+	print_offset(ftrace_event_call, id);
+	print_offset(ftrace_event_call, fields);
+
+	print_offset(ftrace_event_field, link);
+	print_offset(ftrace_event_field, name);
+	print_offset(ftrace_event_field, type);
+	print_offset(ftrace_event_field, offset);
+	print_offset(ftrace_event_field, size);
+	print_offset(ftrace_event_field, is_signed);
+#undef print_offset
+}
+
+static void ftrace_init_pages(struct ring_buffer_per_cpu *cpu_buffer,
+		unsigned nr_pages)
+{
+	unsigned j;
+	ulong head, page;
+	ulong real_head_page = cpu_buffer->head_page;
+
+
+	j = 0;
+	cpu_buffer->pages = calloc(sizeof(ulong), nr_pages);
+
+	if (lockless_ring_buffer) {
+		read_value(head, cpu_buffer->kaddr, ring_buffer_per_cpu, pages);
+		cpu_buffer->pages[j++] = head - koffset(buffer_page, list);
+	} else
+		head = cpu_buffer->kaddr + koffset(ring_buffer_per_cpu, pages);
+
+	page = head;
+	for (;;) {
+		read_value(page, page, list_head, next);
+		if (page & 3) {
+			/* lockless_ring_buffer */
+			page &= ~3;
+			real_head_page = page - koffset(buffer_page, list);
+		}
+
+		if (j == nr_pages)
+			break;
+
+		if (page == head)
+			error(FATAL, "pages 1\n");
+
+		cpu_buffer->pages[j++] = page - koffset(buffer_page, list);
+	}
+
+	if (page != head)
+		error(FATAL, "pages 2\n");
+
+	cpu_buffer->real_head_page = real_head_page;
+	cpu_buffer->head_page_index = -1;
+
+	for (j = 0; j < nr_pages; j++) {
+		if (cpu_buffer->pages[j] == real_head_page) {
+			cpu_buffer->head_page_index = j;
+			break;
+		}
+	}
+
+	if (cpu_buffer->head_page_index == -1)
+		error(FATAL, "error for resolve head_page_index\n");
+}
+
+static void ftrace_init_buffers(struct ring_buffer_per_cpu *buffers,
+		ulong ring_buffer, unsigned pages)
+{
+	int i;
+	ulong buffers_array;
+	ulong *tmp = calloc(sizeof(ulong), kt->nr_cpu_ids);
+
+	read_value(buffers_array, ring_buffer, ring_buffer, buffers);
+
+	if (!readmem(buffers_array, KVADDR, tmp, sizeof(ulong) * kt->nr_cpu_ids,
+			"ring_buffer, buffers, array", RETURN_ON_ERROR|QUIET))
+		error(FATAL, "cannot read ring_buffer's buffers-array\n");
+
+	for (i = 0; i < kt->nr_cpu_ids; i++) {
+		if (!tmp[i])
+			continue;
+
+		buffers[i].kaddr = tmp[i];
+
+#define buffer_read_value(member) read_value(buffers[i].member,		\
+			buffers[i].kaddr, ring_buffer_per_cpu, member)
+
+		buffer_read_value(head_page);
+		buffer_read_value(tail_page);
+		buffer_read_value(commit_page);
+		buffer_read_value(reader_page);
+		buffer_read_value(overrun);
+		buffer_read_value(entries);
+#undef buffer_read_value
+
+		ftrace_init_pages(buffers + i, pages);
+
+		if (verbose) {
+			fprintf(fp, "overrun=%lu\n", buffers[i].overrun);
+			fprintf(fp, "entries=%lu\n", buffers[i].entries);
+		}
+	}
+
+	free(tmp);
+}
+
+static void ftrace_init_event_types(void);
+static void ftrace_show_init(void);
+
+void ftrace_init(void)
+{
+	ulong addr;
+	char tmp[128];
+
+	if (!symbol_exists("global_trace")) {
+		ftrace_no_ftrace = 1;
+		ftrace_initialized = 1;
+		return;
+	}
+
+	global_trace = symbol_value("global_trace");
+	max_tr_trace = symbol_value("global_trace");
+
+	init_offsets();
+	print_offsets();
+
+	read_value(global_ring_buffer, global_trace, trace_array, buffer);
+	read_value(max_tr_ring_buffer, max_tr_trace, trace_array, buffer);
+
+	read_value(global_pages, global_ring_buffer, ring_buffer, pages);
+	read_value(max_tr_pages, max_tr_ring_buffer, ring_buffer, pages);
+
+	global_buffers = calloc(sizeof(*global_buffers), kt->nr_cpu_ids);
+	max_tr_buffers = calloc(sizeof(*max_tr_buffers), kt->nr_cpu_ids);
+
+	ftrace_init_buffers(global_buffers, global_ring_buffer, global_pages);
+	ftrace_init_buffers(max_tr_buffers, max_tr_ring_buffer, max_tr_pages);
+
+	page_tmp = malloc(PAGESIZE());
+
+	ftrace_events = symbol_value("ftrace_events");
+	ftrace_init_event_types();
+
+	addr = symbol_value("current_trace");
+	read_value(current_trace, addr, POINTER_SYM, POINTER);
+	read_value(addr, current_trace, tracer, name);
+	read_string(addr, tmp, 128);
+	current_trace_name = strdup(tmp);
+
+	ftrace_initialized = 1;
+
+	ftrace_show_init();
+}
+
+static void ftrace_dump_page(FILE *out, ulong page)
+{
+	ulong raw_page;
+
+	read_value(raw_page, page, buffer_page, page);
+
+	if (!readmem(raw_page, KVADDR, page_tmp, PAGESIZE(), "get page context",
+			RETURN_ON_ERROR | QUIET))
+		error(FATAL, "cannot get page context\n");
+
+	fwrite(page_tmp, 1, PAGESIZE(), out);
+}
+
+static void ftrace_dump_buffer(FILE *out, struct ring_buffer_per_cpu *cpu_buffer,
+		unsigned pages)
+{
+	unsigned i;
+
+	ftrace_dump_page(out, cpu_buffer->reader_page);
+
+	if (cpu_buffer->reader_page == cpu_buffer->commit_page)
+		return;
+
+	i = cpu_buffer->head_page_index;
+	for (;;) {
+		ftrace_dump_page(out, cpu_buffer->pages[i]);
+
+		if (cpu_buffer->pages[i] == cpu_buffer->commit_page)
+			break;
+
+		i++;
+		if (i == pages)
+			i = 0;
+
+		if (i == cpu_buffer->head_page_index) {
+			/* cpu_buffer->commit_page may be corrupted */
+			break;
+		}
+	}
+}
+
+static void ftrace_dump_buffers(const char *per_cpu_path)
+{
+	int i;
+
+	for (i = 0; i < kt->nr_cpu_ids; i++) {
+		char *path;
+		FILE *out;
+
+		if (!global_buffers[i].kaddr)
+			continue;
+
+		asprintf(&path, "%s/cpu%d", per_cpu_path, i);
+		mkdir(path, 0755);
+		free(path);
+
+		asprintf(&path, "%s/cpu%d/trace_pipe_raw", per_cpu_path, i);
+		out = fopen(path, "wb");
+		free(path);
+
+		ftrace_dump_buffer(out, global_buffers + i, global_pages);
+		fclose(out);
+	}
+}
+
+typedef uint64_t u64;
+typedef int64_t s64;
+typedef uint32_t u32;
+
+#define MAX_CACHE_ID	256
+
+struct ftrace_field;
+typedef u64 (*access_op)(struct ftrace_field *aop, void *data);
+static void ftrace_field_access_init(struct ftrace_field *f);
+
+struct ftrace_field {
+	const char *name;
+	const char *type;
+	access_op op;
+	int offset;
+	int size;
+	int is_signed;
+};
+
+struct event_type;
+struct format_context;
+typedef void (*event_printer)(struct event_type *t, struct format_context *fc);
+
+ /* SIGH, we cann't get "print fmt" from core-file */
+
+struct event_type {
+	struct event_type *next;
+	const char *system;
+	const char *name;
+	int plugin;
+	event_printer printer;
+	const char *print_fmt;
+	int id;
+	int nfields;
+	struct ftrace_field *fields;
+};
+
+static struct event_type *event_type_cache[MAX_CACHE_ID];
+static struct event_type **event_types;
+static int nr_event_types;
+
+/*
+ * TODO: implement event_generic_print_fmt_print() when the print fmt
+ * in tracing/events/$SYSTEM/$TRACE/format becomes a will-defined
+ * language.
+ */
+static void event_generic_print_fmt_print(struct event_type *t,
+		struct format_context *fc);
+static void event_default_print(struct event_type *t,
+		struct format_context *fc);
+
+static void ftrace_init_event_type(ulong call, struct event_type *aevent_type)
+{
+	ulong fields_addr, pos;
+
+	int nfields = 0, max_fields = 16;
+	struct ftrace_field *fields;
+
+
+	fields_addr = call + koffset(ftrace_event_call, fields);
+	read_value(pos, fields_addr, list_head, next);
+
+	if (pos == 0) {
+		aevent_type->nfields = 0;
+		aevent_type->fields = NULL;
+		if (verbose)
+			fprintf(fp, "no field %lu\n", call);
+		return;
+	}
+
+	fields = malloc(sizeof(*fields) * max_fields);
+
+	while (pos != fields_addr) {
+		ulong field = pos - koffset(ftrace_event_field, link);
+		ulong name_addr, type_addr;
+		char field_name[128], field_type[128];
+		int offset, size, is_signed;
+
+		read_value(name_addr, field, ftrace_event_field, name);
+		read_value(type_addr, field, ftrace_event_field, type);
+		read_value(offset, field, ftrace_event_field, offset);
+		read_value(size, field, ftrace_event_field, size);
+		read_value(is_signed, field, ftrace_event_field, is_signed);
+
+		read_string(name_addr, field_name, 128);
+		read_string(type_addr, field_type, 128);
+
+		if (nfields >= max_fields) {
+			max_fields *= 2;
+			fields = realloc(fields, sizeof(*fields) * max_fields);
+		}
+
+		fields[nfields].name = strdup(field_name);
+		fields[nfields].type = strdup(field_type);
+		fields[nfields].offset = offset;
+		fields[nfields].size = size;
+		fields[nfields].is_signed = is_signed;
+		ftrace_field_access_init(&fields[nfields]);
+		nfields++;
+
+		read_value(pos, pos, list_head, next);
+	}
+
+	aevent_type->nfields = nfields;
+	aevent_type->fields = fields;
+}
+
+static void ftrace_init_event_types(void)
+{
+	ulong event;
+	int max_types = 128;
+
+	event_types = malloc(sizeof(*event_types) * max_types);
+
+	read_value(event, ftrace_events, list_head, next);
+	while (event != ftrace_events) {
+		ulong call = event - koffset(ftrace_event_call, list);
+		ulong name_addr, system_addr;
+		char name[128], system[128];
+		int id;
+
+		struct event_type *aevent_type = malloc(sizeof(*aevent_type));
+
+		read_value(id, call, ftrace_event_call, id);
+		read_value(name_addr, call, ftrace_event_call, name);
+		read_value(system_addr, call, ftrace_event_call, system);
+
+		read_string(name_addr, name, 128);
+		read_string(system_addr, system, 128);
+
+		aevent_type->system = strdup(system);
+		aevent_type->name = strdup(name);
+		aevent_type->id = id;
+
+		if (id < MAX_CACHE_ID)
+			event_type_cache[id] = aevent_type;
+
+		if (nr_event_types >= max_types) {
+			max_types *= 2;
+			event_types = realloc(event_types,
+					sizeof(*event_types) * max_types);
+		}
+		event_types[nr_event_types++] = aevent_type;
+
+		ftrace_init_event_type(call, aevent_type);
+		if (!strcmp("ftrace", aevent_type->system))
+			aevent_type->plugin = 1;
+		else
+			aevent_type->plugin = 0;
+		aevent_type->printer = event_default_print;
+
+		read_value(event, event, list_head, next);
+	}
+}
+
+static struct ftrace_field *find_event_field(struct event_type *t, const char *name)
+{
+	int i;
+	struct ftrace_field *f;
+
+	for (i = 0; i < t->nfields; i++) {
+		f = &t->fields[i];
+		if (!strcmp(name, f->name))
+			return f;
+	}
+
+	return NULL;
+}
+
+static struct event_type *find_event_type(int id)
+{
+	int i;
+
+	if ((unsigned int)id < MAX_CACHE_ID)
+		return event_type_cache[id];
+
+	for (i = 0; i < nr_event_types; i++) {
+		if (event_types[i]->id == id)
+			return event_types[i];
+	}
+
+	return NULL;
+}
+
+static
+struct event_type *find_event_type_by_name(const char *system, const char *name)
+{
+	int i;
+
+	for (i = 0; i < nr_event_types; i++) {
+		if (system && strcmp(system, event_types[i]->system))
+			continue;
+		if (!strcmp(name, event_types[i]->name))
+			return event_types[i];
+	}
+
+	return NULL;
+}
+
+static void ftrace_dump_event_type(struct event_type *t, const char *path)
+{
+	char *format_path;
+	FILE *out;
+	int i;
+
+	asprintf(&format_path, "%s/format", path);
+	out = fopen(format_path, "w");
+	free(format_path);
+
+	fprintf(out, "name: %s\n", t->name);
+	fprintf(out, "ID: %d\n", t->id);
+	fprintf(out, "format:\n");
+
+	for (i = 0; i < t->nfields; i++) {
+		struct ftrace_field *f = &t->fields[i];
+
+		fprintf(out, "\tfield:%s %s;\toffset:%d;\tsize:%d;\n",
+				f->type, f->name, f->offset, f->size);
+	}
+
+	/* TODO */
+	fprintf(out, "\nprint fmt: \"unknow fmt from dump\"\n");
+	fclose(out);
+}
+
+static void ftrace_dump_event_types(const char *events_path)
+{
+	int i;
+
+	for (i = 0; i < nr_event_types; i++) {
+		char *path;
+		struct event_type *t = event_types[i];
+
+		asprintf(&path, "%s/%s", events_path, t->system);
+		mkdir(path, 0755);
+		free(path);
+
+		asprintf(&path, "%s/%s/%s", events_path, t->system, t->name);
+		mkdir(path, 0755);
+
+		ftrace_dump_event_type(t, path);
+		free(path);
+	}
+}
+
+struct ring_buffer_per_cpu_stream {
+	ulong *pages;
+	void *page_tmp;
+	int available_pages;
+	int curr_page_indx;
+
+	uint64_t ts;
+	uint32_t *offset;
+	uint32_t *commit;
+};
+
+static
+int ring_buffer_per_cpu_stream_init(struct ring_buffer_per_cpu *cpu_buffer,
+		unsigned pages, struct ring_buffer_per_cpu_stream *s)
+{
+	unsigned i, count = 0;
+
+	s->page_tmp = malloc(PAGESIZE());
+	if (!s->page_tmp)
+		return -1;
+
+	s->pages = malloc(sizeof(ulong) * (pages + 1));
+	if (!s->pages) {
+		free(s->page_tmp);
+		return -1;
+	}
+
+	s->pages[count++] = cpu_buffer->reader_page;
+
+	if (cpu_buffer->reader_page == cpu_buffer->commit_page)
+		goto pages_done;
+
+	i = cpu_buffer->head_page_index;
+	for (;;) {
+		s->pages[count++] = cpu_buffer->pages[i];
+		
+		if (cpu_buffer->pages[i] == cpu_buffer->commit_page)
+			break;
+
+		i++;
+		if (i == pages)
+			i = 0;
+
+		if (i == cpu_buffer->head_page_index) {
+			/* cpu_buffer->commit_page may be corrupted */
+			break;
+		}
+	}
+
+pages_done:
+	s->available_pages = count;
+	s->curr_page_indx = -1;
+	return 0;
+}
+
+static
+void ring_buffer_per_cpu_stream_destroy(struct ring_buffer_per_cpu_stream *s)
+{
+	free(s->page_tmp);
+	free(s->pages);
+}
+
+struct ftrace_event {
+	uint64_t ts;
+	int length;
+	void *data;
+};
+
+struct event {
+	u32 type_len:5, time_delta:27;
+};
+
+#define RINGBUF_TYPE_PADDING		29
+#define RINGBUF_TYPE_TIME_EXTEND	30
+#define RINGBUF_TYPE_TIME_STAMP		31
+#define RINGBUF_TYPE_DATA		0 ... 28
+
+#define sizeof_local_t (sizeof(ulong))
+#define PAGE_HEADER_LEN (8 + sizeof_local_t)
+
+static
+void ring_buffer_per_cpu_stream_get_page(struct ring_buffer_per_cpu_stream *s)
+{
+	ulong raw_page;
+
+	read_value(raw_page, s->pages[s->curr_page_indx], buffer_page, page);
+
+	if (!readmem(raw_page, KVADDR, s->page_tmp, PAGESIZE(),
+			"get page context", RETURN_ON_ERROR | QUIET))
+		error(FATAL, "cannot get page context\n");
+
+	s->ts = *(u64 *)s->page_tmp;
+	s->offset = s->page_tmp + PAGE_HEADER_LEN;
+	s->commit = s->offset + *(ulong *)(s->page_tmp + 8) / 4;
+}
+
+static
+int ring_buffer_per_cpu_stream_pop_event(struct ring_buffer_per_cpu_stream *s,
+		struct ftrace_event *res)
+{
+	struct event *event;
+
+	res->data = NULL;
+
+	if (s->curr_page_indx >= s->available_pages)
+		return -1;
+
+again:
+	if ((s->curr_page_indx == -1) || (s->offset >= s->commit)) {
+		s->curr_page_indx++;
+		if (s->curr_page_indx == s->available_pages)
+			return -1;
+
+		ring_buffer_per_cpu_stream_get_page(s);
+		if (s->offset >= s->commit)
+			goto again;
+	}
+
+	event = (void *)s->offset;
+
+	switch (event->type_len) {
+	case RINGBUF_TYPE_PADDING:
+		if (event->time_delta)
+			s->offset += 1 + ((*(s->offset + 1) + 3) / 4);
+		else
+			s->offset = s->commit;
+		goto again;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		s->ts +=event->time_delta;
+		s->ts += ((u64)*(s->offset + 1)) << 27;
+		s->offset += 2;
+		goto again;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		/* FIXME: not implemented */
+		s->offset += 4;
+		goto again;
+
+	case RINGBUF_TYPE_DATA:
+		if (!event->type_len) {
+			res->data = s->offset + 2;
+			res->length = *(s->offset + 1) - 4;
+
+			s->offset += 1 + ((*(s->offset + 1) + 3) / 4);
+		} else {
+			res->data = s->offset + 1;
+			res->length = event->type_len * 4;
+
+			s->offset += 1 + event->type_len;
+		}
+
+		if (s->offset > s->commit) {
+			fprintf(fp, "corrupt\n");
+			res->data = NULL;
+			goto again;
+		}
+
+		s->ts += event->time_delta;
+		res->ts = s->ts;
+
+		return 0;
+
+	default:;
+	}
+
+	return -1;
+}
+
+struct ring_buffer_stream {
+	struct ring_buffer_per_cpu_stream *ss;
+	struct ftrace_event *es;
+	u64 ts;
+	int popped_cpu;
+	int pushed;
+};
+
+static
+void ring_buffer_stream_init(struct ring_buffer_stream *s, bool *cpulist)
+{
+	int cpu;
+
+	s->ss = malloc(sizeof(*s->ss) * kt->nr_cpu_ids);
+	s->es = malloc(sizeof(*s->es) * kt->nr_cpu_ids);
+
+	for (cpu = 0; cpu < kt->nr_cpu_ids; cpu++) {
+		s->es[cpu].data = NULL;
+
+		if (!global_buffers[cpu].kaddr)
+			continue;
+
+		if (cpulist && !cpulist[cpu])
+			continue;
+
+		ring_buffer_per_cpu_stream_init(global_buffers + cpu,
+				global_pages, s->ss + cpu);
+	}
+
+	s->ts = 0;
+	s->popped_cpu = kt->nr_cpu_ids;
+	s->pushed = 0;
+}
+
+static
+void ring_buffer_stream_destroy(struct ring_buffer_stream *s, bool *cpulist)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < kt->nr_cpu_ids; cpu++) {
+		if (!global_buffers[cpu].kaddr)
+			continue;
+		if (cpulist && !cpulist[cpu])
+			continue;
+		ring_buffer_per_cpu_stream_destroy(s->ss + cpu);
+	}
+
+	free(s->ss);
+	free(s->es);
+}
+
+/* make current event be returned again at next pop */
+static void ring_buffer_stream_push_current_event(struct ring_buffer_stream *s)
+{
+	if ((s->popped_cpu < 0) || (s->popped_cpu == kt->nr_cpu_ids))
+		return;
+
+	s->pushed = 1;
+}
+
+/* return the cpu# of this event */
+static int ring_buffer_stream_pop_event(struct ring_buffer_stream *s,
+		struct ftrace_event *res)
+{
+	int cpu, min_cpu = -1;
+	u64 ts, min_ts;
+
+	res->data = NULL;
+
+	if (s->popped_cpu < 0)
+		return -1;
+
+	if (s->popped_cpu == kt->nr_cpu_ids) {
+		for (cpu = 0; cpu < kt->nr_cpu_ids; cpu++) {
+			if (!global_buffers[cpu].kaddr)
+				continue;
+
+			ring_buffer_per_cpu_stream_pop_event(s->ss + cpu,
+					s->es + cpu);
+
+			if (!s->es[cpu].data)
+				continue;
+
+			/*
+			 * We do not have start point of time,
+			 * determine the min_ts with heuristic way.
+			 */
+			ts = s->es[cpu].ts;
+			if (min_cpu < 0 || (s64)(ts - min_ts) < 0) {
+				min_ts = ts;
+				min_cpu = cpu;
+			}
+		}
+
+		s->pushed = 0;
+		goto done;
+	}
+
+	if (s->pushed) {
+		s->pushed = 0;
+		*res = s->es[s->popped_cpu];
+		return s->popped_cpu;
+	}
+
+	ring_buffer_per_cpu_stream_pop_event(&s->ss[s->popped_cpu],
+			&s->es[s->popped_cpu]);
+
+	for (cpu = 0; cpu < kt->nr_cpu_ids; cpu++) {
+		if (!s->es[cpu].data)
+			continue;
+
+		/* we have start point of time(s->ts) */
+		ts = s->es[cpu].ts - s->ts;
+		if (min_cpu < 0 || ts < min_ts) {
+			min_ts = ts;
+			min_cpu = cpu;
+		}
+	}
+
+done:
+	s->popped_cpu = min_cpu;
+
+	if (min_cpu < 0)
+		return -1;
+
+	s->ts = s->es[min_cpu].ts;
+	*res = s->es[min_cpu];
+
+	return min_cpu;
+}
+
+static u64 access_error(struct ftrace_field *f, void *data)
+{
+	return 0;
+}
+
+static u64 access_8(struct ftrace_field *f, void *data)
+{
+	return *(int8_t *)(data + f->offset);
+}
+
+static u64 access_16(struct ftrace_field *f, void *data)
+{
+	return *(int16_t *)(data + f->offset);
+}
+
+static u64 access_32(struct ftrace_field *f, void *data)
+{
+	return *(int32_t *)(data + f->offset);
+}
+
+static u64 access_64(struct ftrace_field *f, void *data)
+{
+	return *(int64_t *)(data + f->offset);
+}
+
+static u64 access_string_local(struct ftrace_field *f, void *data)
+{
+	return (long)(data + *(int16_t *)(data + f->offset));
+}
+
+static u64 access_string(struct ftrace_field *f, void *data)
+{
+	return (long)(data + f->offset);
+}
+
+static u64 access_other_local(struct ftrace_field *f, void *data)
+{
+	return (long)(data + *(int16_t *)(data + f->offset));
+}
+
+static u64 access_other(struct ftrace_field *f, void *data)
+{
+	return (long)(data + f->offset);
+}
+
+static void ftrace_field_access_init(struct ftrace_field *f)
+{
+	/* guess whether it is string array */
+	if (!strncmp(f->type, "__data_loc", sizeof("__data_loc") - 1)) {
+		if (f->size != 2) {
+			/* TODO: kernel side may be changed, need fix */
+			f->op = access_error;
+		} else if (strstr(f->type, "char")) {
+			/* TODO: finish kernel side. */
+			f->op = access_string_local;
+		} else {
+			/* TODO: finish kernel side. */
+			f->op = access_other;
+		}
+	} else if (strchr(f->type, '[')) {
+		if (strstr(f->type, "char"))
+			f->op = access_string;
+		else
+			f->op = access_other;
+	} else {
+		switch (f->size) {
+		case 1: f->op = access_8; break;
+		case 2: f->op = access_16; break;
+		case 4: f->op = access_32; break;
+		case 8: f->op = access_64; break;
+		default: f->op = access_other; break;
+		}
+	}
+}
+
+static void show_basic_info(void)
+{
+	fprintf(fp, "current tracer is %s\n", current_trace_name);
+}
+
+static void dump_saved_cmdlines(const char *dump_tracing_dir)
+{
+	char *path;
+	FILE *out;
+	int i;
+	struct task_context *tc;
+
+	asprintf(&path, "%s/saved_cmdlines", dump_tracing_dir);
+	out = fopen(path, "w");
+	free(path);
+
+	tc = FIRST_CONTEXT();
+        for (i = 0; i < RUNNING_TASKS(); i++)
+		fprintf(out, "%d %s\n", (int)tc[i].pid, tc[i].comm);
+
+	fclose(out);
+}
+
+static void ftrace_dump(int argc, char *argv[])
+{
+	int c;
+	int dump_meta_data = 0;
+	int dump_symbols = 0;
+	char *dump_tracing_dir;
+	char *path;
+	int ret;
+
+        while ((c = getopt(argc, argv, "sm")) != EOF) {
+                switch(c)
+		{
+		case 's':
+			dump_symbols = 1;
+			break;
+		case 'm':
+			dump_meta_data = 1;
+			break;
+		default:
+			cmd_usage(pc->curcmd, SYNOPSIS);
+			return;
+		}
+	}
+
+	if (argc - optind == 0) {
+		dump_tracing_dir = "dump_tracing_dir";
+	} else if (argc - optind == 1) {
+		dump_tracing_dir = argv[optind];
+	} else {
+		cmd_usage(pc->curcmd, SYNOPSIS);
+		return;
+	}
+
+	ret = mkdir(dump_tracing_dir, 0755);
+	if (ret < 0)
+		return;
+
+	asprintf(&path, "%s/per_cpu", dump_tracing_dir);
+	mkdir(path, 0755);
+	ftrace_dump_buffers(path);
+	free(path);
+
+	if (dump_meta_data) {
+		asprintf(&path, "%s/events", dump_tracing_dir);
+		mkdir(path, 0755);
+		ftrace_dump_event_types(path);
+		free(path);
+
+		dump_saved_cmdlines(dump_tracing_dir);
+	}
+
+	if (dump_symbols) {
+		fprintf(fp, "\n-s option hasn't been implemented.\n");
+		fprintf(fp, "symbols is not dumpped.\n");
+		fprintf(fp, "You can use `sym -l > %s/kallsyms`\n\n",
+				dump_tracing_dir);
+	}
+}
+
+static char show_event_buf[4096];
+static int show_event_pos;
+
+#define INVALID_ACCESS_FIELD 1
+static jmp_buf show_event_env;
+
+struct format_context {
+	struct ring_buffer_stream stream;
+	struct ftrace_event event;
+	int cpu;
+};
+
+static struct format_context format_context;
+
+/* !!!! @event_type and @field_name should be const for every call */
+#define access_field(event_type, data, field_name)			\
+({									\
+	static struct ftrace_field *__access_field##_field;		\
+									\
+	if (!__access_field##_field) {					\
+		__access_field##_field = find_event_field(event_type,	\
+				field_name);				\
+	}								\
+									\
+	if (!__access_field##_field) {					\
+		event_type->printer = event_default_print;		\
+		ring_buffer_stream_push_current_event(&format_context.stream);\
+		longjmp(show_event_env, INVALID_ACCESS_FIELD);		\
+	}								\
+									\
+	__access_field##_field->op(__access_field##_field, data);	\
+})
+
+static int ftrace_event_get_id(void *data)
+{
+	return access_field(event_types[0], data, "common_type");
+}
+
+static int ftrace_event_get_pid(void *data)
+{
+	return access_field(event_types[0], data, "common_pid");
+}
+
+#define event_printf(fmt, args...)					\
+do {									\
+	show_event_pos += snprintf(show_event_buf + show_event_pos,	\
+			sizeof(show_event_buf) - show_event_pos,	\
+			fmt, ##args);					\
+} while (0)
+
+
+static void event_field_print(struct ftrace_field *f, u64 value)
+{
+	if (f->op == access_error) {
+		event_printf("<Error>");
+	} else if (f->op == access_8) {
+		if (f->is_signed)
+			event_printf("%d", (int8_t)value);
+		else
+			event_printf("%u", (uint8_t)value);
+	} else if (f->op == access_16) {
+		if (f->is_signed)
+			event_printf("%d", (int16_t)value);
+		else
+			event_printf("%u", (uint16_t)value);
+	} else if (f->op == access_32) {
+		if (f->is_signed)
+			event_printf("%d", (int32_t)value);
+		else
+			event_printf("%u", (uint32_t)value);
+	} else if (f->op == access_64) {
+		if (f->is_signed)
+			event_printf("%lld", (long long)value);
+		else
+			event_printf("%llu", (unsigned long long)value);
+	} else if (f->op == access_string_local) {
+		event_printf("%s", (char *)(long)value);
+	} else if (f->op == access_string) {
+		event_printf("%.*s", f->size, (char *)(long)value);
+	} else if (f->op == access_other) {
+		/* TODO */
+	} else if (f->op == access_other_local) {
+		/* TODO */
+	} else {
+		/* TODO */
+	}
+}
+
+static void get_comm_from_pid(int pid, char *comm)
+{
+	int li, hi;
+	struct task_context *tc;
+
+	if (pid == 0) {
+		strcpy(comm, "<swapper>");
+		return;
+	}
+
+	tc = FIRST_CONTEXT();
+
+	li = 0;
+	hi = RUNNING_TASKS();
+	while (li < hi) {
+		int mid = (li + hi) / 2;
+
+		if (tc[mid].pid > pid)
+			hi = mid;
+		else if (tc[mid].pid < pid)
+			li = mid + 1;
+		else {
+			strcpy(comm, tc[mid].comm);
+			return;
+		}
+	}
+
+	strcpy(comm, "<...>");
+}
+
+static void event_context_print(struct event_type *t, struct format_context *fc)
+{
+	u64 time = fc->event.ts / 1000;
+	ulong sec = time / 1000000;
+	ulong usec = time % 1000000;
+	int pid = ftrace_event_get_pid(fc->event.data);
+	char comm[20];
+
+	get_comm_from_pid(pid, comm);
+	event_printf("%16s-%-5d [%03d] %5lu.%06lu: ",
+			comm, pid, fc->cpu, sec, usec);
+}
+
+static int gopt_context_info;
+static int gopt_sym_offset;
+static int gopt_sym_addr;
+
+static int gopt_graph_print_duration;
+static int gopt_graph_print_overhead;
+static int gopt_graph_print_abstime;
+static int gopt_graph_print_cpu;
+static int gopt_graph_print_proc;
+static int gopt_graph_print_overrun;
+
+static void set_all_flags_default(void)
+{
+	gopt_context_info = 1;
+	gopt_sym_offset = 0;
+	gopt_sym_addr = 0;
+
+	gopt_graph_print_duration = 1;
+	gopt_graph_print_overhead = 1;
+	gopt_graph_print_abstime = 0;
+	gopt_graph_print_cpu = 1;
+	gopt_graph_print_proc = 0;
+	gopt_graph_print_overrun = 0;
+}
+
+static void set_clear_flag(const char *flag_name, int set)
+{
+	if (!strcmp(flag_name, "context_info"))
+		gopt_context_info = set;
+	else if (!strcmp(flag_name, "sym_offset"))
+		gopt_sym_offset = set;
+	else if (!strcmp(flag_name, "sym_addr"))
+		gopt_sym_addr = set;
+	else if (!strcmp(flag_name, "graph_print_duration"))
+		gopt_graph_print_duration = set;
+	else if (!strcmp(flag_name, "graph_print_overhead"))
+		gopt_graph_print_overhead = set;
+	else if (!strcmp(flag_name, "graph_print_abstime"))
+		gopt_graph_print_abstime = set;
+	else if (!strcmp(flag_name, "graph_print_cpu"))
+		gopt_graph_print_cpu = set;
+	else if (!strcmp(flag_name, "graph_print_proc"))
+		gopt_graph_print_proc = set;
+	else if (!strcmp(flag_name, "graph_print_overrun"))
+		gopt_graph_print_overrun = set;
+	/* invalid flage_name is omitted. */
+}
+
+static int tracer_no_event_context;
+static int ftrace_show_disabled;
+
+static void ftrace_show_function_graph_init(void);
+static void ftrace_show_function_init(void);
+static void ftrace_show_trace_event_init(void);
+
+static void ftrace_show_init(void)
+{
+	/* ftrace_event_get_id(), ftrace_event_get_pid() should not failed. */
+	if (!find_event_field(event_types[0], "common_type")) {
+		ftrace_show_disabled = 1;
+		return;
+	}
+
+	if (!find_event_field(event_types[0], "common_pid")) {
+		ftrace_show_disabled = 1;
+		return;
+	}
+
+	ftrace_show_function_init();
+	ftrace_show_function_graph_init();
+	ftrace_show_trace_event_init();
+}
+
+void show_event(struct format_context *fc)
+{
+	struct event_type *etype;
+	int id;
+
+	id = ftrace_event_get_id(fc->event.data);
+	etype = find_event_type(id);
+
+	if (!etype) {
+		event_printf("<Unknown event type>\n");
+		return;
+	}
+
+	if (!tracer_no_event_context && gopt_context_info)
+		event_context_print(etype, fc);
+	if (!etype->plugin)
+		event_printf("%s: ", etype->name);
+	etype->printer(etype, fc);
+}
+
+static int parse_cpulist(bool *cpulist, const char *cpulist_str, int len)
+{
+	unsigned a, b;
+	const char *s = cpulist_str;
+
+	memset(cpulist, 0, sizeof(bool) * len);
+
+	do {
+		if (!isdigit(*s))
+			return -1;
+		b = a = strtoul(s, (char **)&s, 10);
+		if (*s == '-') {
+			s++;
+			if (!isdigit(*s))
+				return -1;
+			b = strtoul(s, (char **)&s, 10);
+		}
+		if (!(a <= b))
+			return -1;
+		if (b >= len)
+			return -1;
+		while (a <= b) {
+			cpulist[a] = true;
+			a++;
+		}
+		if (*s == ',')
+			s++;
+	} while (*s != '\0' && *s != '\n');
+
+	return 0;
+}
+
+static void ftrace_show_function_graph_start(void);
+
+static void ftrace_show(int argc, char *argv[])
+{
+	int c;
+	bool *cpulist = NULL;
+
+	if (ftrace_show_disabled) {
+		fprintf(fp, "trace show is disabled.");
+		return;
+	}
+
+	set_all_flags_default();
+	ftrace_show_function_graph_start();
+
+        while ((c = getopt(argc, argv, "f:c:")) != EOF) {
+                switch(c)
+		{
+		case 'f':
+			if (optarg[0] == 'n' && optarg[1] == 'o')
+				set_clear_flag(optarg + 2, 0);
+			else
+				set_clear_flag(optarg, 1);
+			break;
+		case 'c':
+			if (cpulist)
+				goto err_arg;
+			cpulist = alloca(sizeof(bool) * kt->nr_cpu_ids);
+			if (parse_cpulist(cpulist, optarg, kt->nr_cpu_ids) < 0)
+				goto err_arg;
+			break;
+		default:
+			goto err_arg;
+		}
+	}
+
+	if (argc - optind != 0) {
+err_arg:
+		cmd_usage(pc->curcmd, SYNOPSIS);
+		return;
+	}
+
+	ring_buffer_stream_init(&format_context.stream, cpulist);
+
+	/* Ignore setjmp()'s return value, no special things to do. */
+	setjmp(show_event_env);
+
+	for (;;) {
+		show_event_pos = 0;
+		format_context.cpu = ring_buffer_stream_pop_event(
+				&format_context.stream, &format_context.event);
+		if (format_context.cpu < 0)
+			break;
+
+		show_event(&format_context);
+		fprintf(fp, "%s", show_event_buf);
+	}
+
+	ring_buffer_stream_destroy(&format_context.stream, cpulist);
+
+}
+
+void cmd_ftrace(void)
+{
+	if (ftrace_no_ftrace) {
+		fprintf(fp, "No tracing in this kernel\n");
+		return;
+	}
+
+	if (!ftrace_initialized) {
+		fprintf(fp, "failed to init tracing\n");
+		return;
+	}
+
+	if (argcnt == 1)
+		show_basic_info();
+	else if (!strcmp(args[1], "dump"))
+		ftrace_dump(argcnt - 1, args + 1);
+	else if (!strcmp(args[1], "show"))
+		ftrace_show(argcnt - 1, args + 1);
+	else
+		cmd_usage(pc->curcmd, SYNOPSIS);
+}
+
+static void event_default_print(struct event_type *t, struct format_context *fc)
+{
+	int i;
+
+	/* Skip the common types */
+	for (i = t->nfields - 6; i >= 0; i--) {
+		struct ftrace_field *f;
+		u64 value;
+
+		f = &t->fields[i];
+		value = f->op(f, fc->event.data);
+		event_printf("%s=", f->name);
+		event_field_print(f, value);
+		if (i)
+			event_printf(", ");
+	}
+
+	event_printf("\n");
+}
+
+static void sym_print(ulong sym, int opt_offset)
+{
+	if (!sym) {
+		event_printf("0");
+	} else {
+		ulong offset;
+		struct syment *se;
+
+		se = value_search(sym, &offset);
+		if (se) {
+			event_printf("%s", se->name);
+			if (opt_offset)
+				event_printf("+%lu", offset);
+		}
+	}
+}
+
+static void event_fn_print(struct event_type *t, struct format_context *fc)
+{
+	unsigned long ip = access_field(t, fc->event.data, "ip");
+	unsigned long parent_ip = access_field(t, fc->event.data, "parent_ip");
+
+	sym_print(ip, gopt_sym_offset);
+	if (gopt_sym_addr)
+		event_printf("<%lx>", ip);
+
+	event_printf(" <-");
+
+	sym_print(parent_ip, gopt_sym_offset);
+	if (gopt_sym_addr)
+		event_printf("<%lx>", parent_ip);
+
+	event_printf("\n");
+}
+
+static void ftrace_show_function_init(void)
+{
+	struct event_type *t = find_event_type_by_name("ftrace", "function");
+
+	if (t)
+		t->printer = event_fn_print;
+}
+
+#if 0
+/* simple */
+static void event_fn_entry_print(struct event_type *t, struct format_context *fc)
+{
+	ulong func = access_field(t, fc->event.data, "graph_ent.func");
+	int depth = access_field(t, fc->event.data, "graph_ent.depth");
+
+	event_printf("%*s", depth, " ");
+	sym_print(func, gopt_sym_offset);
+	if (gopt_sym_addr)
+		event_printf("<%lx>", func);
+	event_printf("() {");
+}
+
+static void event_fn_return_print(struct event_type *t, struct format_context *fc)
+{
+	ulong func = access_field(t, fc->event.data, "ret.func");
+	u64 calltime = access_field(t, fc->event.data, "ret.calltime");
+	u64 rettime = access_field(t, fc->event.data, "ret.rettime");
+	int depth = access_field(t, fc->event.data, "ret.depth");
+
+	event_printf("%*s} %lluns", depth, " ",
+			(unsigned long long)(rettime - calltime));
+}
+
+static void ftrace_show_function_graph_init(void)
+{
+	struct event_type *t1 = find_event_type_by_name(
+			"ftrace", "funcgraph_entry");
+	struct event_type *t2 = find_event_type_by_name(
+			"ftrace", "funcgraph_exit");
+
+	if (!t1 || !t2)
+		return;
+
+	t1->printer = event_fn_entry_print;
+	t2->printer = event_fn_return_print;
+}
+#endif
+
+
+#define TRACE_GRAPH_PROCINFO_LENGTH	14
+#define TRACE_GRAPH_INDENT		2
+
+static int max_bytes_for_cpu;
+static int *cpus_prev_pid;
+
+static int function_graph_entry_id;
+static int function_graph_return_id;
+static struct event_type *function_graph_entry_type;
+static struct event_type *function_graph_return_type;
+
+static void ftrace_show_function_graph_start(void)
+{
+	int i;
+
+	if (!cpus_prev_pid)
+		return;
+
+	for (i = 0; i < kt->nr_cpu_ids; i++)
+		cpus_prev_pid[i] = -1;
+}
+
+static void fn_graph_proc_print(int pid)
+{
+	int pid_strlen, comm_strlen;
+	char pid_str[20];
+	char comm[20] = "<...>";
+
+	pid_strlen = sprintf(pid_str, "%d", pid);
+	comm_strlen = TRACE_GRAPH_PROCINFO_LENGTH - 1 - pid_strlen;
+
+	get_comm_from_pid(pid, comm);
+	event_printf("%*.*s-%s", comm_strlen, comm_strlen, comm, pid_str);
+}
+
+/* If the pid changed since the last trace, output this event */
+static void fn_graph_proc_switch_print(int pid, int cpu)
+{
+	int prev_pid = cpus_prev_pid[cpu];
+
+	cpus_prev_pid[cpu] = pid;
+	if ((prev_pid == pid) || (prev_pid == -1))
+		return;
+
+/*
+ * Context-switch trace line:
+
+ ------------------------------------------
+ | 1)  migration/0--1  =>  sshd-1755
+ ------------------------------------------
+
+ */
+
+	event_printf(" ------------------------------------------\n");
+	event_printf(" %*d) ", max_bytes_for_cpu, cpu);
+	fn_graph_proc_print(prev_pid);
+	event_printf(" => ");
+	fn_graph_proc_print(pid);
+	event_printf("\n ------------------------------------------\n\n");
+}
+
+/* Signal a overhead of time execution to the output */
+static void fn_graph_overhead_print(unsigned long long duration)
+{
+	const char *s = "  ";
+
+	/* If duration disappear, we don't need anything */
+	if (!gopt_graph_print_duration)
+		return;
+
+	/* duration == -1 is for non nested entry or return */
+	if ((duration != -1) && gopt_graph_print_overhead) {
+		/* Duration exceeded 100 msecs */
+		if (duration > 100000ULL)
+			s = "! ";
+		/* Duration exceeded 10 msecs */
+		else if (duration > 10000ULL)
+			s = "+ ";
+	}
+
+	event_printf(s);
+}
+
+static void fn_graph_abstime_print(u64 ts)
+{
+	u64 time = ts / 1000;
+	unsigned long sec = time / 1000000;
+	unsigned long usec = time % 1000000;
+
+	event_printf("%5lu.%06lu |  ", sec, usec);
+}
+
+static void fn_graph_irq_print(int type)
+{
+	/* TODO: implement it. */
+}
+
+static void fn_graph_duration_print(unsigned long long duration)
+{
+	/* log10(ULONG_MAX) + '\0' */
+	char msecs_str[21];
+	char nsecs_str[5];
+	int len;
+	unsigned long nsecs_rem = duration % 1000;
+
+	duration = duration / 1000;
+	len = sprintf(msecs_str, "%lu", (unsigned long) duration);
+
+	/* Print msecs */
+	event_printf("%s", msecs_str);
+
+	/* Print nsecs (we don't want to exceed 7 numbers) */
+	if (len < 7) {
+		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
+		event_printf(".%s", nsecs_str);
+
+		len += strlen(nsecs_str);
+	}
+
+	if (len > 7)
+		len = 7;
+
+	event_printf(" us %*s|  ", 7 - len, "");
+}
+
+/* Case of a leaf function on its call entry */
+static void fn_graph_entry_leaf_print(void *entry_data, void *exit_data)
+{
+	struct event_type *t = function_graph_return_type;
+
+	u64 calltime = access_field(t, exit_data, "ret.calltime");
+	u64 rettime = access_field(t, exit_data, "ret.rettime");
+	u64 duration = rettime - calltime;
+	int depth = access_field(t, exit_data, "ret.depth");
+	ulong func = access_field(t, exit_data, "ret.func");
+
+	fn_graph_overhead_print(duration);
+	if (gopt_graph_print_duration)
+		fn_graph_duration_print(duration);
+
+	event_printf("%*s", depth * TRACE_GRAPH_INDENT, "");
+	sym_print(func, 0);
+	event_printf("();\n");
+}
+
+static void fn_graph_entry_nested_print(struct event_type *t, void *data)
+{
+	int depth = access_field(t, data, "graph_ent.depth");
+	ulong func = access_field(t, data, "graph_ent.func");
+
+	fn_graph_overhead_print(-1);
+
+	/* No time */
+	if (gopt_graph_print_duration)
+		event_printf("            |  ");
+
+	event_printf("%*s", depth * TRACE_GRAPH_INDENT, "");
+	sym_print(func, 0);
+	event_printf("() {\n");
+}
+
+static void fn_graph_prologue_print(int cpu, u64 ts, int pid, int type)
+{
+	fn_graph_proc_switch_print(pid, cpu);
+
+	if (type)
+		fn_graph_irq_print(type);
+
+	if (gopt_graph_print_abstime)
+		fn_graph_abstime_print(ts);
+
+	if (gopt_graph_print_cpu)
+		 event_printf(" %*d) ", max_bytes_for_cpu, cpu);
+
+	if (gopt_graph_print_proc) {
+		fn_graph_proc_print(pid);
+		event_printf(" | ");
+	}
+}
+
+static void *get_return_for_leaf(struct event_type *t,
+		struct format_context *fc, void *curr_data)
+{
+	int cpu;
+	struct ftrace_event next;
+	ulong entry_func, exit_func;
+
+	cpu = ring_buffer_stream_pop_event(&fc->stream, &next);
+
+	if (cpu < 0)
+		goto not_leaf;
+
+	if (ftrace_event_get_id(next.data) != function_graph_return_id)
+		goto not_leaf;
+
+	if (ftrace_event_get_pid(curr_data) != ftrace_event_get_pid(next.data))
+		goto not_leaf;
+
+	entry_func = access_field(t, curr_data, "graph_ent.func");
+	exit_func = access_field(function_graph_return_type, next.data,
+			"ret.func");
+
+	if (entry_func != exit_func)
+		goto not_leaf;
+
+	return next.data;
+
+not_leaf:
+	ring_buffer_stream_push_current_event(&fc->stream);
+	return NULL;
+}
+
+static
+void event_fn_entry_print(struct event_type *t, struct format_context *fc)
+{
+	void *leaf_ret_data = NULL, *curr_data = fc->event.data, *data;
+	int pid = ftrace_event_get_pid(curr_data);
+
+	fn_graph_prologue_print(fc->cpu, fc->event.ts, pid, 1);
+
+	data = alloca(fc->event.length);
+	if (data) {
+		memcpy(data, fc->event.data, fc->event.length);
+		curr_data = data;
+		leaf_ret_data = get_return_for_leaf(t, fc, curr_data);
+	}
+
+	if (leaf_ret_data)
+		return fn_graph_entry_leaf_print(curr_data, leaf_ret_data);
+	else
+		return fn_graph_entry_nested_print(t, curr_data);
+}
+
+static
+void event_fn_return_print(struct event_type *t, struct format_context *fc)
+{
+	void *data = fc->event.data;
+	int pid = ftrace_event_get_pid(data);
+
+	u64 calltime = access_field(t, data, "ret.calltime");
+	u64 rettime = access_field(t, data, "ret.rettime");
+	u64 duration = rettime - calltime;
+	int depth = access_field(t, data, "ret.depth");
+
+	fn_graph_prologue_print(fc->cpu, fc->event.ts, pid, 0);
+	fn_graph_overhead_print(duration);
+
+	if (gopt_graph_print_duration)
+		fn_graph_duration_print(duration);
+
+	event_printf("%*s}\n", depth * TRACE_GRAPH_INDENT, "");
+
+	if (gopt_graph_print_overrun) {
+		unsigned long overrun = access_field(t, data, "ret.overrun");
+		event_printf(" (Overruns: %lu)\n", overrun);
+	}
+
+	fn_graph_irq_print(0);
+}
+
+static void ftrace_show_function_graph_init(void)
+{
+	if (strcmp(current_trace_name, "function_graph"))
+		return;
+
+	function_graph_entry_type = find_event_type_by_name(
+			"ftrace", "funcgraph_entry");
+	function_graph_return_type = find_event_type_by_name(
+			"ftrace", "funcgraph_exit");
+
+	if (!function_graph_entry_type || !function_graph_return_type)
+		return;
+
+	/*
+	 * Because of get_return_for_leaf(), the exception handling
+	 * of access_field() is not work for function_graph. So we need
+	 * to ensure access_field() will not failed for these fields.
+	 *
+	 * I know these will not failed. I just ensure it.
+	 */
+
+	if (!find_event_field(function_graph_entry_type, "graph_ent.func"))
+		return;
+
+	if (!find_event_field(function_graph_entry_type, "graph_ent.depth"))
+		return;
+
+	if (!find_event_field(function_graph_return_type, "ret.func"))
+		return;
+
+	if (!find_event_field(function_graph_return_type, "ret.calltime"))
+		return;
+
+	if (!find_event_field(function_graph_return_type, "ret.rettime"))
+		return;
+
+	if (!find_event_field(function_graph_return_type, "ret.overrun"))
+		return;
+
+	if (!find_event_field(function_graph_return_type, "ret.depth"))
+		return;
+
+	cpus_prev_pid = malloc(sizeof(int) * kt->nr_cpu_ids);
+	if (!cpus_prev_pid)
+		return;
+
+	max_bytes_for_cpu = snprintf(NULL, 0, "%d", kt->nr_cpu_ids - 1);
+
+	function_graph_entry_id = function_graph_entry_type->id;
+	function_graph_return_id = function_graph_return_type->id;
+
+	/* OK, set the printer for function_graph. */
+	tracer_no_event_context = 1;
+	function_graph_entry_type->printer = event_fn_entry_print;
+	function_graph_return_type->printer = event_fn_return_print;
+}
+
+static void event_sched_kthread_stop_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("task %s:%d\n",
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"));
+}
+
+static void event_sched_kthread_stop_ret_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("ret %d\n", (int)access_field(t, fc->event.data, "ret"));
+}
+
+static void event_sched_wait_task_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("task %s:%d [%d]\n",
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"),
+			(int)access_field(t, fc->event.data, "prio"));
+}
+
+static void event_sched_wakeup_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("task %s:%d [%d] success=%d\n",
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"),
+			(int)access_field(t, fc->event.data, "prio"),
+			(int)access_field(t, fc->event.data, "success"));
+}
+
+static void event_sched_wakeup_new_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("task %s:%d [%d] success=%d\n",
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"),
+			(int)access_field(t, fc->event.data, "prio"),
+			(int)access_field(t, fc->event.data, "success"));
+}
+
+static void event_sched_switch_print(struct event_type *t,
+		struct format_context *fc)
+{
+	char *prev_comm = (char *)(long)access_field(t, fc->event.data,
+			"prev_comm");
+	int prev_pid = access_field(t, fc->event.data, "prev_pid");
+	int prev_prio = access_field(t, fc->event.data, "prev_prio");
+
+	int prev_state = access_field(t, fc->event.data, "prev_state");
+
+	char *next_comm = (char *)(long)access_field(t, fc->event.data,
+			"next_comm");
+	int next_pid = access_field(t, fc->event.data, "next_pid");
+	int next_prio = access_field(t, fc->event.data, "next_prio");
+
+	event_printf("task %s:%d [%d] (", prev_comm, prev_pid, prev_prio);
+
+	if (prev_state == 0) {
+		event_printf("R");
+	} else {
+		if (prev_state & 1)
+			event_printf("S");
+		if (prev_state & 2)
+			event_printf("D");
+		if (prev_state & 4)
+			event_printf("T");
+		if (prev_state & 8)
+			event_printf("t");
+		if (prev_state & 16)
+			event_printf("Z");
+		if (prev_state & 32)
+			event_printf("X");
+		if (prev_state & 64)
+			event_printf("x");
+		if (prev_state & 128)
+			event_printf("W");
+	}
+
+	event_printf(") ==> %s:%d [%d]\n", next_comm, next_pid, next_prio);
+}
+
+static void event_sched_migrate_task_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("task %s:%d [%d] from: %d  to: %d\n",
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"),
+			(int)access_field(t, fc->event.data, "prio"),
+			(int)access_field(t, fc->event.data, "orig_cpu"),
+			(int)access_field(t, fc->event.data, "dest_cpu"));
+}
+
+static void event_sched_process_free_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("task %s:%d [%d]\n",
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"),
+			(int)access_field(t, fc->event.data, "prio"));
+}
+
+static void event_sched_process_exit_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("task %s:%d [%d]\n",
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"),
+			(int)access_field(t, fc->event.data, "prio"));
+}
+
+static void event_sched_process_wait_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("task %s:%d [%d]\n",
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"),
+			(int)access_field(t, fc->event.data, "prio"));
+}
+
+static void event_sched_process_fork_print(struct event_type *t,
+		struct format_context *fc)
+{
+	char *parent_comm = (char *)(long)access_field(t, fc->event.data,
+			"parent_comm");
+	int parent_pid = access_field(t, fc->event.data, "parent_pid");
+
+	char *child_comm = (char *)(long)access_field(t, fc->event.data,
+			"child_comm");
+	int child_pid = access_field(t, fc->event.data, "child_pid");
+
+	event_printf("parent %s:%d  child %s:%d\n", parent_comm, parent_pid,
+			child_comm, child_pid);
+}
+
+static void event_sched_signal_send_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("sig: %d  task %s:%d\n",
+			(int)access_field(t, fc->event.data, "sig"),
+			(char *)(long)access_field(t, fc->event.data, "comm"),
+			(int)access_field(t, fc->event.data, "pid"));
+}
+
+static void event_kmalloc_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu "
+			"gfp_flags=%lx\n",
+			(long)access_field(t, fc->event.data, "call_site"),
+			(void *)(long)access_field(t, fc->event.data, "ptr"),
+			(size_t)access_field(t, fc->event.data, "bytes_req"),
+			(size_t)access_field(t, fc->event.data, "bytes_alloc"),
+			(long)access_field(t, fc->event.data, "gfp_flags"));
+}
+
+static void event_kmem_cache_alloc_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu "
+			"gfp_flags=%lx\n",
+			(long)access_field(t, fc->event.data, "call_site"),
+			(void *)(long)access_field(t, fc->event.data, "ptr"),
+			(size_t)access_field(t, fc->event.data, "bytes_req"),
+			(size_t)access_field(t, fc->event.data, "bytes_alloc"),
+			(long)access_field(t, fc->event.data, "gfp_flags"));
+}
+
+static void event_kmalloc_node_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu "
+			"gfp_flags=%lx node=%d\n",
+			(long)access_field(t, fc->event.data, "call_site"),
+			(void *)(long)access_field(t, fc->event.data, "ptr"),
+			(size_t)access_field(t, fc->event.data, "bytes_req"),
+			(size_t)access_field(t, fc->event.data, "bytes_alloc"),
+			(long)access_field(t, fc->event.data, "gfp_flags"),
+			(int)access_field(t, fc->event.data, "node"));
+}
+
+static void event_kmem_cache_alloc_node_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu "
+			"gfp_flags=%lx node=%d\n",
+			(long)access_field(t, fc->event.data, "call_site"),
+			(void *)(long)access_field(t, fc->event.data, "ptr"),
+			(size_t)access_field(t, fc->event.data, "bytes_req"),
+			(size_t)access_field(t, fc->event.data, "bytes_alloc"),
+			(long)access_field(t, fc->event.data, "gfp_flags"),
+			(int)access_field(t, fc->event.data, "node"));
+}
+
+static void event_kfree_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("call_site=%lx ptr=%p\n",
+			(long)access_field(t, fc->event.data, "call_site"),
+			(void *)(long)access_field(t, fc->event.data, "ptr"));
+}
+
+static void event_kmem_cache_free_print(struct event_type *t,
+		struct format_context *fc)
+{
+	event_printf("call_site=%lx ptr=%p\n",
+			(long)access_field(t, fc->event.data, "call_site"),
+			(void *)(long)access_field(t, fc->event.data, "ptr"));
+}
+
+static void event_workqueue_insertion_print(struct event_type *t,
+		struct format_context *fc)
+{
+	char *thread_comm = (char *)(long)access_field(t, fc->event.data,
+			"thread_comm");
+	int thread_pid = access_field(t, fc->event.data, "thread_pid");
+	ulong func = access_field(t, fc->event.data, "func");
+
+	event_printf("thread=%s:%d func=", thread_comm, thread_pid);
+	sym_print(func, 1);
+	event_printf("\n");
+}
+
+static void event_workqueue_execution_print(struct event_type *t,
+		struct format_context *fc)
+{
+	char *thread_comm = (char *)(long)access_field(t, fc->event.data,
+			"thread_comm");
+	int thread_pid = access_field(t, fc->event.data, "thread_pid");
+	ulong func = access_field(t, fc->event.data, "func");
+
+	event_printf("thread=%s:%d func=", thread_comm, thread_pid);
+	sym_print(func, 1);
+	event_printf("\n");
+}
+
+static void event_workqueue_creation_print(struct event_type *t,
+		struct format_context *fc)
+{
+	char *thread_comm = (char *)(long)access_field(t, fc->event.data,
+			"thread_comm");
+	int thread_pid = access_field(t, fc->event.data, "thread_pid");
+	int cpu = access_field(t, fc->event.data, "cpu");
+
+	event_printf("thread=%s:%d cpu=%d\n", thread_comm, thread_pid, cpu);
+}
+
+static void event_workqueue_destruction_print(struct event_type *t,
+		struct format_context *fc)
+{
+	char *thread_comm = (char *)(long)access_field(t, fc->event.data,
+			"thread_comm");
+	int thread_pid = access_field(t, fc->event.data, "thread_pid");
+
+	event_printf("thread=%s:%d\n", thread_comm, thread_pid);
+}
+
+static void ftrace_show_trace_event_init(void)
+{
+#define init_trace_event(system, name)					\
+do {									\
+	struct event_type *t = find_event_type_by_name(#system, #name);	\
+	if (t)								\
+		t->printer = event_ ## name ## _print;			\
+} while (0)
+
+	init_trace_event(sched, sched_kthread_stop);
+	init_trace_event(sched, sched_kthread_stop_ret);
+	init_trace_event(sched, sched_wait_task);
+	init_trace_event(sched, sched_wakeup);
+	init_trace_event(sched, sched_wakeup_new);
+	init_trace_event(sched, sched_switch);
+	init_trace_event(sched, sched_migrate_task);
+	init_trace_event(sched, sched_process_free);
+	init_trace_event(sched, sched_process_exit);
+	init_trace_event(sched, sched_process_wait);
+	init_trace_event(sched, sched_process_fork);
+	init_trace_event(sched, sched_signal_send);
+
+	init_trace_event(kmem, kmalloc);
+	init_trace_event(kmem, kmem_cache_alloc);
+	init_trace_event(kmem, kmalloc_node);
+	init_trace_event(kmem, kmem_cache_alloc_node);
+	init_trace_event(kmem, kfree);
+	init_trace_event(kmem, kmem_cache_free);
+
+	init_trace_event(workqueue, workqueue_insertion);
+	init_trace_event(workqueue, workqueue_execution);
+	init_trace_event(workqueue, workqueue_creation);
+	init_trace_event(workqueue, workqueue_destruction);
+#undef init_trace_event
+}
+
diff --git a/global_data.c b/global_data.c
index 581deb2..2c14d69 100755
--- a/global_data.c
+++ b/global_data.c
@@ -103,6 +103,7 @@ struct command_table_entry linux_command_table[] = {
 	{"runq",    cmd_runq,    help_runq,    REFRESH_TASK_TABLE},
         {"search",  cmd_search,  help_search,  0},
         {"set",     cmd_set,     help_set,     REFRESH_TASK_TABLE},
+	{"trace",   cmd_ftrace,  help_ftrace,  0},
         {"sig",     cmd_sig,     help_sig,     REFRESH_TASK_TABLE},
         {"struct",  cmd_struct,  help_struct,  0},
 	{"swap",    cmd_swap,    help_swap,    0},
diff --git a/help.c b/help.c
index 5f0189f..f8ddb84 100755
--- a/help.c
+++ b/help.c
@@ -2899,6 +2899,39 @@ char *help_task[] = {
 NULL               
 };
 
+char *help_ftrace[] = {
+"trace",
+"show or dump the tracing info",
+"[ <show [-c <cpulist>] [-f [no]<flagname>]> | <dump [-sm] <dest-dir>> ]",
+"trace",
+"    shows the current tracer and other informations.",
+"",
+"trace show [ -c <cpulist> ] [ -f [no]<flagename> ]",
+"    shows all events with readability text(sorted by timestamp)",
+"    -c: only shows specified CPUs' events.",
+"        ex. trace show -c 1,2    - only shows cpu#1 and cpu#2 's events.",
+"            trace show -c 0,2-7  - only shows cpu#0, cpu#2...cpu#7's events.",
+"    -f: set or clear a flag",
+"        available flags            default",
+"        context_info               true",
+"        sym_offset                 false",
+"        sym_addr                   false",
+"        graph_print_duration       true",
+"        graph_print_overhead       true",
+"        graph_print_abstime        false",
+"        graph_print_cpu            true",
+"        graph_print_proc           false",
+"        graph_print_overrun        false",
+"",
+"trace dump [-sm] <dest-dir>",
+"    dump ring_buffers to dest-dir. Then you can parse it",
+"    by other tracing tools. The dirs and files are generated",
+"    the same as debugfs/tracing.",
+"    -m: also dump metadata of ftrace.",
+"    -s: also dump symbols of the kernel <not implemented>.",
+NULL
+};
+
 char *help_sig[] = {
 "sig",
 "task signal handling",
diff --git a/kernel.c b/kernel.c
index 603b6e9..dd4563d 100755
--- a/kernel.c
+++ b/kernel.c
@@ -132,6 +132,14 @@ kernel_init()
 	} else 
 		kt->cpus = 1;
 
+	if (symbol_exists("nr_cpu_ids"))
+		get_symbol_data("nr_cpu_ids", sizeof(int), &kt->nr_cpu_ids);
+	else
+		kt->nr_cpu_ids = 1;
+
+	if (kt->cpus < kt->nr_cpu_ids)
+		kt->cpus = kt->nr_cpu_ids;
+
 	if ((sp1 = symbol_search("__per_cpu_start")) &&
  	    (sp2 = symbol_search("__per_cpu_end")) &&
 	    (sp1->type == 'A' || sp1->type == 'D') && 
diff --git a/main.c b/main.c
index 5d79eef..9831539 100755
--- a/main.c
+++ b/main.c
@@ -516,6 +516,7 @@ main_loop(void)
 			net_init();
 			dev_init();
 			machdep_init(POST_INIT);
+			ftrace_init();
 		}
 	} else
 		SIGACTION(SIGINT, restart, &pc->sigaction, NULL);

