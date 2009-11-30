Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZK3MDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZK3MDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZK3MDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:03:47 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45739 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZK3MDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:03:44 -0500
Date: Mon, 30 Nov 2009 17:33:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       "utrace-devel" <utrace-devel@redhat.com>,
       "Roland McGrath" <roland@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091130120345.GA18879@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

This patch implements an in-kernel gdb stub.
It provides an interface between gdb and Linux Kernel by implementing
the remote serial protocol.  This gdbstub uses utrace infrastructure.
This patch provides register set access, signal mapping, process event
handling, input/output operations.

/proc/<pid>/gdb was chosen as file for gdb to interact with the
process through remote serial protocol. 

Hence users would have to use "target remote /proc/<pid>/gdb" command
on gdb prompt to start using this infrastructure.

For Breakpointing support, gdbstub needs User space breakpointing
layer and uprobes layer which will be posted later.

Here is an illustration of what all this can do.

$ pgrep zsh 
8865
$ gdb /bin/zsh 
GNU gdb (GDB) 7.0.0.20091030
..... <snipped gdb header > ...............
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /bin/zsh...Reading symbols from /usr/lib/debug/bin/zsh.debug...done.
(no debugging symbols found)...done.
(gdb) target remote /proc/8865/gdb
Remote debugging using /proc/8865/gdb
.... <snipped several "Reading symbols" and "Loaded symbols" > ......
Loaded symbols for /usr/lib64/zsh/4.2.6/zsh/zle.so
0x0000003f1dec5f00 in __read_nocancel () from /lib64/libc.so.6
(gdb) c
Continuing.
^C
Program received signal SIGINT, Interrupt.
0x0000003f1dec5f00 in __read_nocancel () from /lib64/libc.so.6
(gdb) info registers 
rax            0xfffffffffffffe00	-512
rbx            0x6a01c8	6947272
rcx            0xffffffffffffffff	-1
rdx            0x1	1
rsi            0x7fff507ad5ef	140734543615471
rdi            0xa	10
rbp            0x0	0x0
rsp            0x7fff507ad3e8	0x7fff507ad3e8
r8             0xffffffff	4294967295
r9             0xffffffff	4294967295
r10            0x7d	125
r11            0x246	582
r12            0x7f43b87a9398	139928834577304
r13            0x0	0
r14            0x0	0
r15            0xd	13
rip            0x3f1dec5f00	0x3f1dec5f00 <__read_nocancel+7>
eflags         0x246	[ PF ZF IF ]
cs             0x33	51
ss             0x2b	43
ds             0x0	0
es             0x0	0
fs             0x0	0
gs             0x0	0
fctrl          0x0	0
fstat          0x0	0
ftag           0x0	0
fiseg          0x0	0
fioff          0x0	0
foseg          0x0	0
fooff          0x0	0
fop            0x0	0
mxcsr          0x0	[ ]
(gdb) bt
#0  0x0000003f1dec5f00 in __read_nocancel () from /lib64/libc.so.6
#1  0x00007f43b858a39f in raw_getkey (keytmout=0) at /usr/include/bits/unistd.h:35
#2  getkey (keytmout=0) at zle_main.c:610
#3  0x00007f43b8584bf1 in getkeybuf (km=0x0, funcp=0x7fff507ad718, strp=0x7fff507ad710) at zle_keymap.c:1313
#4  getkeymapcmd (km=0x0, funcp=0x7fff507ad718, strp=0x7fff507ad710) at zle_keymap.c:1275
#5  0x00007f43b8584ef0 in getkeycmd () at zle_keymap.c:1349
#6  0x00007f43b8588281 in zlecore () at zle_main.c:695
#7  0x00007f43b85888f8 in zleread (lp=<value optimized out>, rp=<value optimized out>, flags=<value optimized out>, 
    context=<value optimized out>) at zle_main.c:863
#8  0x00000000004388a0 in inputline () at input.c:278
#9  ingetc () at input.c:214
#10 0x000000000043339d in ihgetc () at hist.c:241
#11 0x000000000044126b in gettok () at lex.c:631
#12 0x0000000000441a88 in yylex () at lex.c:347
#13 0x000000000045cec7 in parse_event () at parse.c:449
#14 0x0000000000437328 in loop (toplevel=1, justonce=0) at init.c:128
#15 0x0000000000438021 in zsh_main (argc=<value optimized out>, argv=0x7fff507ae048) at init.c:1280
#16 0x0000003f1de1d994 in __libc_start_main (main=<value optimized out>, argc=<value optimized out>, 
    ubp_av=<value optimized out>, init=<value optimized out>, fini=<value optimized out>, rtld_fini=<value optimized out>, 
    stack_end=Could not find the frame base for "__libc_start_main".
) at libc-start.c:231
#17 0x000000000040cc09 in _start ()
(gdb) c
Continuing.
^C
Program received signal SIGINT, Interrupt.
0x0000003f1dec5f00 in __read_nocancel () from /lib64/libc.so.6
(gdb) bt
#0  0x0000003f1dec5f00 in __read_nocancel () from /lib64/libc.so.6
#1  0x00007f43b858a39f in raw_getkey (keytmout=0) at /usr/include/bits/unistd.h:35
#2  getkey (keytmout=0) at zle_main.c:610
#3  0x00007f43b8584bf1 in getkeybuf (km=0x0, funcp=0x7fff507ad718, strp=0x7fff507ad710) at zle_keymap.c:1313
#4  getkeymapcmd (km=0x0, funcp=0x7fff507ad718, strp=0x7fff507ad710) at zle_keymap.c:1275
#5  0x00007f43b8584ef0 in getkeycmd () at zle_keymap.c:1349
#6  0x00007f43b8588281 in zlecore () at zle_main.c:695
#7  0x00007f43b85888f8 in zleread (lp=<value optimized out>, rp=<value optimized out>, flags=<value optimized out>, 
    context=<value optimized out>) at zle_main.c:863
#8  0x00000000004388a0 in inputline () at input.c:278
#9  ingetc () at input.c:214
#10 0x000000000043339d in ihgetc () at hist.c:241
#11 0x000000000044126b in gettok () at lex.c:631
#12 0x0000000000441a88 in yylex () at lex.c:347
#13 0x000000000045cec7 in parse_event () at parse.c:449
#14 0x0000000000437328 in loop (toplevel=1, justonce=0) at init.c:128
#15 0x0000000000438021 in zsh_main (argc=<value optimized out>, argv=0x7fff507ae048) at init.c:1280
#16 0x0000003f1de1d994 in __libc_start_main (main=<value optimized out>, argc=<value optimized out>, 
    ubp_av=<value optimized out>, init=<value optimized out>, fini=<value optimized out>, rtld_fini=<value optimized out>, 
    stack_end=Could not find the frame base for "__libc_start_main".
) at libc-start.c:231
#17 0x000000000040cc09 in _start ()
(gdb) b zrefresh
Breakpoint 1 at 0x7f43b858f600: file zle_refresh.c, line 278.
### Note: This is 
(gdb) c
Continuing.
^C
Program received signal SIGINT, Interrupt.
0x0000003f1dec5f00 in __read_nocancel () from /lib64/libc.so.6
(gdb)  info b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   <PENDING>          in zrefresh at zle_refresh.c:278
#### HERE breakpoint is still pending because, gdbstub needs more support for
#### breakpointing.
(gdb) 
(gdb) q
A debugging session is active.

	Inferior 1 [Remote target] will be killed.

Quit anyway? (y or n) y
$ pgrep zsh 
8865
$

I request you to please review this and lets us know your comments.

Signed-off-by: "Frank Ch. Eigler" <fche@redhat.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 fs/proc/base.c         |    4 +
 include/linux/utrace.h |    4 +
 init/Kconfig           |   26 +-
 kernel/Makefile        |    1 +
 kernel/utrace-gdb.c    | 1314 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1340 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index af643b5..98bf9b0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -77,6 +77,7 @@
 #include <linux/audit.h>
 #include <linux/poll.h>
 #include <linux/nsproxy.h>
+#include <linux/utrace.h>
 #include <linux/oom.h>
 #include <linux/elf.h>
 #include <linux/pid_namespace.h>
@@ -2562,6 +2563,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, proc_tgid_io_accounting),
 #endif
+#ifdef CONFIG_UTRACE_GDB
+	REG("gdb",	S_IRUSR|S_IWUSR, proc_gdb_operations),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
diff --git a/include/linux/utrace.h b/include/linux/utrace.h
index 23d934d..c78a365 100644
--- a/include/linux/utrace.h
+++ b/include/linux/utrace.h
@@ -726,4 +726,8 @@ static inline __must_check int utrace_barrier_pid(struct pid *pid,
 
 #endif	/* CONFIG_UTRACE */
 
+#ifdef CONFIG_UTRACE_GDB
+extern const struct file_operations proc_gdb_operations;
+#endif
+
 #endif	/* linux/utrace.h */
diff --git a/init/Kconfig b/init/Kconfig
index 10cbcf4..dd04f63 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -295,15 +295,6 @@ config AUDIT
 	  logging of avc messages output).  Does not do system-call
 	  auditing without CONFIG_AUDITSYSCALL.
 
-config UTRACE
-	bool "Infrastructure for tracing and debugging user processes"
-	depends on EXPERIMENTAL
-	depends on HAVE_ARCH_TRACEHOOK
-	help
-	  Enable the utrace process tracing interface.  This is an internal
-	  kernel interface exported to kernel modules, to track events in
-	  user threads, extract and change user thread state.
-
 config AUDITSYSCALL
 	bool "Enable system-call auditing support"
 	depends on AUDIT && (X86 || PPC || S390 || IA64 || UML || SPARC64 || SUPERH)
@@ -1214,6 +1205,23 @@ config STOP_MACHINE
 	help
 	  Need stop_machine() primitive.
 
+menuconfig UTRACE
+	bool "Infrastructure for tracing and debugging user processes"
+	depends on EXPERIMENTAL
+	depends on HAVE_ARCH_TRACEHOOK
+	help
+	  Enable the utrace process tracing interface.  This is an internal
+	  kernel interface exported to kernel modules, to track events in
+	  user threads, extract and change user thread state.
+
+config UTRACE_GDB
+	bool "/proc/<pid>/gdb file for gdb remote connection"
+	select UTRACE
+        default y
+	help
+	  Enable the utrace-based /proc/<pid>/gdb process debugging
+	  interface, for connection using the gdb remote protocol.
+
 source "block/Kconfig"
 
 config PREEMPT_NOTIFIERS
diff --git a/kernel/Makefile b/kernel/Makefile
index 8f41620..eb3679c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_UTRACE) += utrace.o
+obj-$(CONFIG_UTRACE_GDB) += utrace-gdb.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o audit_watch.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
diff --git a/kernel/utrace-gdb.c b/kernel/utrace-gdb.c
new file mode 100644
index 0000000..e721ae4
--- /dev/null
+++ b/kernel/utrace-gdb.c
@@ -0,0 +1,1314 @@
+/*
+ * utrace-based gdb remote protocol server for user processes
+ *
+ * Copyright (C) 2009 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) IBM Corporation, 2009
+ *
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * Red Hat Author: Frank Ch. Eigler
+ */
+
+/*
+ * TODO list:
+ *
+ * floating-point register bank support for g/G/P/etc. packets
+ * multithreaded process support
+ * concurrent debugger support for same process
+ */
+#define DEBUG 1
+
+#include <asm/syscall.h>
+#include <linux/signal.h>
+#include <linux/ptrace.h>
+#include <linux/err.h>
+#include <linux/pid.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/proc_fs.h>
+#include <linux/ctype.h>
+#include <linux/regset.h>
+#include <linux/utrace.h>
+#include <linux/tracehook.h>
+
+/*
+ * struct gdb_connection - Tracks one active gdb-process session.
+ */
+
+#define GDB_BUFMAX 4096
+#define MAX_REG_WIDTH 16	/* Maximum Register Width */
+
+struct gdb_connection {
+	pid_t target;
+	struct utrace_engine *engine;
+
+	/* changed under output_mutex */
+	int at_quiesce_do;
+
+	/* set <=> at_quiesce_do = UTRACE_STOP */
+	unsigned char stopcode[GDB_BUFMAX];
+	int pass_signals;
+	int stop_signals;
+	/* XXX: per-thread later */
+
+	char output_buf[GDB_BUFMAX];
+	size_t output_buf_size;
+	loff_t output_buf_read;
+
+	/* Protects output_buf, at_quiesce_do */
+	struct mutex output_mutex;
+	wait_queue_head_t output_wait;
+
+	char input_buf[GDB_BUFMAX];
+	size_t input_buf_size;
+
+	/* Protects input_buf. */
+	struct mutex input_mutex;
+	wait_queue_head_t input_wait;
+
+	struct list_head link;
+};
+
+static LIST_HEAD(gdb_connections);
+static DEFINE_MUTEX(gdb_connections_mutex);
+static const struct utrace_engine_ops gdb_utrace_ops;
+
+/* ------------------------------------------------------------------------ */
+
+/*
+ * Map from kernel-side signal numbers (include/asm/signal.h) to gdb
+ * remote protocol signal numbers (include/gdb/signals.h).
+ */
+unsigned gdb_signal_map[] = {
+	[SIGHUP] = 1,
+	[SIGINT] = 2,
+	[SIGQUIT] = 3,
+	[SIGILL] = 4,
+	[SIGTRAP] = 5,
+	[SIGABRT] = 6,
+	[SIGBUS] = 10,
+	[SIGFPE] = 8,
+	[SIGKILL] = 9,
+	[SIGUSR1] = 30,
+	[SIGSEGV] = 11,
+	[SIGUSR2] = 31,
+	[SIGPIPE] = 13,
+	[SIGALRM] = 14,
+	[SIGTERM] = 15,
+	[SIGCHLD] = 20,
+	[SIGCONT] = 19,
+	[SIGSTOP] = 17,
+	[SIGTSTP] = 18,
+	[SIGTTIN] = 21,
+	[SIGTTOU] = 22,
+	[SIGURG] = 16,
+	[SIGXCPU] = 24,
+	[SIGXFSZ] = 25,
+	[SIGVTALRM] = 26,
+	[SIGPROF] = 27,
+	[SIGWINCH] = 28,
+	[SIGIO] = 23,
+	[SIGPWR] = 32,
+	[SIGSYS] = 12,
+};
+
+/*
+ * Map the incoming signo to TARGET_SIGNAL_foo, if possible.  If not,
+ * pass it through.
+ */
+static unsigned map_signal_kern2gdb(unsigned kernel_signo)
+{
+	if (kernel_signo < sizeof(gdb_signal_map) / sizeof(unsigned))
+		return gdb_signal_map[kernel_signo] ? : kernel_signo;
+	return kernel_signo;
+}
+
+static unsigned map_signal_gdb2kern(unsigned gdb_signo)
+{
+	unsigned i;
+	for (i = 0; i < sizeof(gdb_signal_map) / sizeof(unsigned); i++)
+		if (gdb_signal_map[i] == gdb_signo)
+			return i;
+	return gdb_signo;
+}
+
+/* ------------------------------------------------------------------------ */
+
+static unsigned byteme(unsigned char hex1, unsigned char hex2)
+{
+	return (isdigit(hex1) ? hex1 - '0' : tolower(hex1) - 'a' + 10) * 16 +
+		(isdigit(hex2) ? hex2 - '0' : tolower(hex2) - 'a' + 10);
+}
+
+/* ------------------------------------------------------------------------ */
+
+/*
+ * Begin a new packet.  Add the $, and remember where we put it.  Return
+ * the offset for later checksum addition via push_output_packet_end.
+ */
+static size_t push_output_packet_start(struct gdb_connection *p)
+{
+	size_t start = p->output_buf_size;
+
+	BUG_ON(p->output_buf_size + 1 >= GDB_BUFMAX);
+	p->output_buf[p->output_buf_size++] = '$';
+	return start;
+}
+
+/* Add a character to the output queue.  Assumes output_mutex held. */
+static void push_output(struct gdb_connection *p, unsigned char c)
+{
+	/*
+	 * We know some space must exist; we check for this in
+	 * proc_gdb_write() for example.
+	 */
+	BUG_ON(p->output_buf_size >= GDB_BUFMAX);
+	p->output_buf[p->output_buf_size++] = c;
+}
+
+/* Lower case use due to http://sourceware.org/bugzilla/show_bug.cgi?id=9665 */
+static char hex[] = "0123456789abcdef";
+
+/* Add a byte (hexified) to the output queue.  Assumes output_mutex held. */
+static void push_output_hex(struct gdb_connection *p, unsigned char c)
+{
+	/*
+	 * We know some space must exist; we check for this in
+	 * proc_gdb_write() for example.
+	 */
+	BUG_ON(p->output_buf_size >= GDB_BUFMAX);
+	p->output_buf[p->output_buf_size++] = hex[(c & 0xf0) >> 4];
+	p->output_buf[p->output_buf_size++] = hex[(c & 0x0f) >> 0];
+}
+
+/*
+ * Finish the last packet.  Starting after the given '$' offset, compute
+ * the checksum and append it.
+ */
+static void push_output_packet_end(struct gdb_connection *p, size_t start)
+{
+	unsigned char checksum = 0;
+	int i;
+
+	BUG_ON(p->output_buf_size + 3 >= GDB_BUFMAX);
+	BUG_ON(p->output_buf[start] != '$');
+
+	for (i = start + 1; i < p->output_buf_size; i++)
+		checksum += p->output_buf[i];
+
+	p->output_buf[p->output_buf_size++] = '#';
+	p->output_buf[p->output_buf_size++] = hex[(checksum & 0xf0) >> 4];
+	p->output_buf[p->output_buf_size++] = hex[(checksum & 0x0f) >> 0];
+}
+
+/* Add a complete packet payload to the output queue.  */
+static void push_output_packet(struct gdb_connection *p, const char *s)
+{
+	size_t ss = strlen(s);
+	size_t start;
+	int i;
+
+	start = push_output_packet_start(p);
+	for (i = 0; i < ss; i++)
+		push_output(p, s[i]);
+	push_output_packet_end(p, start);
+}
+
+static inline struct gdb_connection *find_gdb_connection(
+						struct task_struct *task)
+{
+	struct gdb_connection *gc = NULL;
+
+	mutex_lock(&gdb_connections_mutex);
+	list_for_each_entry(gc, &gdb_connections, link) {
+		if (gc->target == task_tgid_nr(task))
+			goto out_connection;
+	}
+
+out_connection:
+	mutex_unlock(&gdb_connections_mutex);
+	return gc;
+}
+
+/* utrace callbacks */
+
+u32 gdb_utrace_report_quiesce(enum utrace_resume_action action,
+				struct utrace_engine *engine,
+				struct task_struct *task, unsigned long event)
+{
+	struct gdb_connection *p = engine->data;
+
+	pr_debug("report_quiesce %d event 0x%lx 0x%x->0x%x\n", task->pid,
+				event, action, p->at_quiesce_do);
+
+	return p->at_quiesce_do;
+}
+
+u32 gdb_utrace_report_clone(enum utrace_resume_action action,
+				struct utrace_engine *engine,
+				struct task_struct *parent,
+				unsigned long clone_flags,
+				struct task_struct *child)
+{
+	pr_debug("report_clone %d->%d\n", parent->pid, child->pid);
+
+	if (clone_flags & CLONE_THREAD) {
+		printk(KERN_WARNING
+			"unsupported multithreading on /proc/%d/gdb.\n",
+			task_pid_nr(parent));
+	}
+	/* XXX: is there anything else to do here? */
+	return UTRACE_RESUME;
+}
+
+u32 gdb_utrace_report_exec(enum utrace_resume_action action,
+					struct utrace_engine *engine,
+					struct task_struct *task,
+					const struct linux_binfmt *fmt,
+					const struct linux_binprm *bprm,
+					struct pt_regs *regs)
+{
+	/* XXX: Model an exec as if it were an exit. */
+	struct gdb_connection *p = engine->data;
+
+	pr_debug("report_exec %d->%s\n", task->pid, task->comm);
+
+	mutex_lock(&p->output_mutex);
+
+	p->at_quiesce_do = UTRACE_STOP;
+	snprintf(p->stopcode, GDB_BUFMAX, "W%02x", 0);
+	push_output_packet(p, p->stopcode);
+
+	mutex_unlock(&p->output_mutex);
+	wake_up(&p->output_wait);
+
+	/*
+	 * Suspend the exec operation, to ensure that the connected gdb
+	 * receives the notification packet, and lets us go.
+	 */
+	return UTRACE_STOP;
+}
+
+u32 gdb_utrace_report_signal(u32 action,
+				struct utrace_engine *engine,
+				struct task_struct *task,
+				struct pt_regs *regs,
+				siginfo_t *info,
+				const struct k_sigaction *orig_ka,
+				struct k_sigaction *return_ka)
+{
+	struct gdb_connection *p = engine->data;
+	u32 ret = action;
+
+	mutex_lock(&p->output_mutex);
+
+	pr_debug("report_signal %d (0x%x) skip %d stop %d\n",
+		 task->pid, action, p->pass_signals, p->stop_signals);
+
+	/*
+	 * The target is about to receive a signal.  There are several
+	 * cases:
+	 *
+	 * 1) This is an ordinary signal.  We UTRACE_STOP to notify gdb.
+	 *
+	 * 2a) This is a SIGTRAP arising from a singlestep arising from
+	 *     another tracing entity.  Or a breakpoint is disarmed.
+	 *     We UTRACE_RESUME.
+	 *
+	 * 2b) This is a SIGTRAP but not from a singlestep.
+	 *     We UTRACE_STOP to pass it to gdb.
+	 *
+	 *  Both case 2a, 2b are yet to be implemented.
+	 *
+	 * 3) This is a UTRACE_SIGNAL_REPORT our code injected to stop the
+	 *     process, as per UTRACE_INTERRUPT.
+	 *     We UTRACE_STOP | UTRACE_SIGNAL_IGN.
+	 *
+	 * 4) This is a signal our code injected on behalf of gdb via the
+	 *    C/S/I packets. We recognize this from p->pass_signals.
+	 *    We UTRACE_RESUME.
+	 *
+	 * 5) This is a UTRACE_SIGNAL_HANDLER event.  UTRACE_RESUME.
+	 */
+
+	switch (utrace_signal_action(action)) {
+	case UTRACE_SIGNAL_HANDLER:	/* case 5 */
+		p->at_quiesce_do = UTRACE_RESUME;
+		ret = UTRACE_RESUME | utrace_signal_action(action);
+		break;
+
+	case UTRACE_SIGNAL_REPORT:
+	case UTRACE_SIGNAL_DELIVER:
+	case UTRACE_SIGNAL_IGN:	/* XXX: bother notify? */
+	case UTRACE_SIGNAL_TERM:
+	case UTRACE_SIGNAL_CORE:
+	case UTRACE_SIGNAL_STOP:
+	case UTRACE_SIGNAL_TSTP:
+		if (!orig_ka) {	/* case 3 */
+			/* This should be UTRACE_SIGNAL_REPORT */
+			if (p->stop_signals > 0) {
+				p->stop_signals = 0;
+				/* Indicate as if thread received a SIGINT */
+				snprintf(p->stopcode, GDB_BUFMAX, "S%02x", 2);
+				push_output_packet(p, p->stopcode);
+				p->at_quiesce_do = UTRACE_STOP;
+				ret = UTRACE_STOP | UTRACE_SIGNAL_IGN;
+			} else
+				ret = p->at_quiesce_do |
+						utrace_signal_action(action);
+
+			break;
+		}
+		if (p->pass_signals > 0) {	/* case 4 */
+			p->pass_signals--;
+			p->at_quiesce_do = UTRACE_RESUME;
+			ret = UTRACE_RESUME | utrace_signal_action(action);
+		} else {	/* case 1 */
+			snprintf(p->stopcode, GDB_BUFMAX, "S%02x",
+				 map_signal_kern2gdb(info->si_signo));
+			push_output_packet(p, p->stopcode);
+			p->at_quiesce_do = UTRACE_STOP;
+			ret = UTRACE_STOP | utrace_signal_action(action);
+		}
+		break;
+	}
+
+	pr_debug("action 0x%x\n", ret);
+
+	mutex_unlock(&p->output_mutex);
+	wake_up(&p->output_wait);
+
+	return ret;
+}
+
+u32 gdb_utrace_report_exit(enum utrace_resume_action action,
+					struct utrace_engine *engine,
+					struct task_struct *task,
+					long orig_code, long *code)
+{
+	struct gdb_connection *p = engine->data;
+
+	pr_debug("report_exit %d (%lx)\n", task->pid, orig_code);
+
+	mutex_lock(&p->output_mutex);
+
+	p->at_quiesce_do = UTRACE_STOP;
+	snprintf(p->stopcode, GDB_BUFMAX,
+		 "W%02x", (unsigned)(orig_code & 0xFF));
+	push_output_packet(p, p->stopcode);
+
+	mutex_unlock(&p->output_mutex);
+	wake_up(&p->output_wait);
+
+	/*
+	 * Suspend the exit operation, to ensure that the connected gdb
+	 * receives the notification packet, and lets us go.
+	 */
+	return UTRACE_STOP;
+}
+
+u32 gdb_utrace_report_death(struct utrace_engine *engine,
+			struct task_struct *task, bool group_dead, int signal)
+{
+	struct gdb_connection *p = engine->data;
+
+	pr_debug("report_death %d (%d)\n", task->pid, signal);
+
+	mutex_lock(&p->output_mutex);
+
+	p->at_quiesce_do = UTRACE_DETACH;
+	snprintf(p->stopcode, GDB_BUFMAX, "X%2x", (unsigned)(signal & 0xFF));
+	push_output_packet(p, p->stopcode);
+
+	mutex_unlock(&p->output_mutex);
+	wake_up(&p->output_wait);
+	return UTRACE_DETACH;
+}
+
+static const struct utrace_engine_ops gdb_utrace_ops = {
+	.report_quiesce = gdb_utrace_report_quiesce,
+	.report_signal = gdb_utrace_report_signal,
+	.report_death = gdb_utrace_report_death,
+	.report_exit = gdb_utrace_report_exit,
+	.report_exec = gdb_utrace_report_exec,
+	.report_clone = gdb_utrace_report_clone,
+	/* XXX: syscall trapping is also possible. */
+};
+
+/*
+ * XXX: arch-dependent lookup of gdb remote protocol register
+ * numbering.  The register numbers (user-side) & expected sizes come
+ * from gdb's regformats/FOO-linux.dat.  The regset (kernel-side)
+ * numbers could come from offsetof/sizeof constructs based upon each
+ * arch's asm/user*.h.
+ */
+
+struct gdb_map_regset {
+	unsigned pos;		/* regset offset */
+	unsigned count;		/* regset byte count */
+	unsigned rsn;		/* regset number */
+	unsigned bytes;		/* gdb's view of register width; <= count */
+};
+
+struct gdb_map_regset arch_i386_map_regset[] = {
+	[0] = { /* eax */ 6 * 4, 4, NT_PRSTATUS, 4,},
+	[1] = { /* ecx */ 1 * 4, 4, NT_PRSTATUS, 4,},
+	[2] = { /* edx */ 2 * 4, 4, NT_PRSTATUS, 4,},
+	[3] = { /* ebx */ 0 * 4, 4, NT_PRSTATUS, 4,},
+	[4] = { /* esp */ 15 * 4, 4, NT_PRSTATUS, 4,},
+	[5] = { /* ebp */ 5 * 4, 4, NT_PRSTATUS, 4,},
+	[6] = { /* esi */ 3 * 4, 4, NT_PRSTATUS, 4,},
+	[7] = { /* edi */ 4 * 4, 4, NT_PRSTATUS, 4,},
+	[8] = { /* eip */ 12 * 4, 4, NT_PRSTATUS, 4,},
+	[9] = { /* eflags */ 14 * 4, 4, NT_PRSTATUS, 4,},
+	[10] = { /* cs */ 13 * 4, 4, NT_PRSTATUS, 4,},
+	[11] = { /* ss */ 16 * 4, 4, NT_PRSTATUS, 4,},
+	[12] = { /* ds */ 7 * 4, 4, NT_PRSTATUS, 4,},
+	[13] = { /* es */ 8 * 4, 4, NT_PRSTATUS, 4,},
+	[14] = { /* fs */ 9 * 4, 4, NT_PRSTATUS, 4,},
+	[15] = { /* gs */ 10 * 4, 4, NT_PRSTATUS, 4,},
+	[16] = { /* st0 */ 0, 0, NT_PRFPREG, 10,},
+	[17] = { /* st1 */ 0, 0, NT_PRFPREG, 10,},
+	[18] = { /* st2 */ 0, 0, NT_PRFPREG, 10,},
+	[19] = { /* st3 */ 0, 0, NT_PRFPREG, 10,},
+	[20] = { /* st4 */ 0, 0, NT_PRFPREG, 10,},
+	[21] = { /* st5 */ 0, 0, NT_PRFPREG, 10,},
+	[22] = { /* st6 */ 0, 0, NT_PRFPREG, 10,},
+	[23] = { /* st7 */ 0, 0, NT_PRFPREG, 10,},
+	[24] = { /* fctrl */ 0, 0, NT_PRFPREG, 4,},
+	[25] = { /* fstat */ 0, 0, NT_PRFPREG, 4,},
+	[26] = { /* ftag */ 0, 0, NT_PRFPREG, 4,},
+	[27] = { /* fiseg */ 0, 0, NT_PRFPREG, 4,},
+	[28] = { /* fioff */ 0, 0, NT_PRFPREG, 4,},
+	[29] = { /* foseg */ 0, 0, NT_PRFPREG, 4,},
+	[30] = { /* fooff */ 0, 0, NT_PRFPREG, 4,},
+	[31] = { /* fop */ 0, 0, NT_PRFPREG, 4,},
+	[32] = { /* xmm0 */ 0, 0, NT_PRFPREG, 16,},
+	[33] = { /* xmm1 */ 0, 0, NT_PRFPREG, 16,},
+	[34] = { /* xmm2 */ 0, 0, NT_PRFPREG, 16,},
+	[35] = { /* xmm3 */ 0, 0, NT_PRFPREG, 16,},
+	[36] = { /* xmm4 */ 0, 0, NT_PRFPREG, 16,},
+	[37] = { /* xmm5 */ 0, 0, NT_PRFPREG, 16,},
+	[38] = { /* xmm6 */ 0, 0, NT_PRFPREG, 16,},
+	[39] = { /* xmm7 */ 0, 0, NT_PRFPREG, 16,},
+	[40] = { /* mxcsr */ 0, 0, NT_PRFPREG, 4,},
+	[41] = { /* orig_eax */ 0, 0, NT_PRSTATUS, 4,},
+};
+
+struct gdb_map_regset arch_x86_64_map_regset[] = {
+	[0] = { /* rax */ 10 * 8, 8, NT_PRSTATUS, 8,},
+	[1] = { /* rbx */ 5 * 8, 8, NT_PRSTATUS, 8,},
+	[2] = { /* rcx */ 11 * 8, 8, NT_PRSTATUS, 8,},
+	[3] = { /* rdx */ 12 * 8, 8, NT_PRSTATUS, 8,},
+	[4] = { /* rsi */ 13 * 8, 8, NT_PRSTATUS, 8,},
+	[5] = { /* rdi */ 14 * 8, 8, NT_PRSTATUS, 8,},
+	[6] = { /* rbp */ 4 * 8, 8, NT_PRSTATUS, 8,},
+	[7] = { /* rsp */ 19 * 8, 8, NT_PRSTATUS, 8,},
+	[8] = { /* r8 */ 9 * 8, 8, NT_PRSTATUS, 8,},
+	[9] = { /* r9 */ 8 * 8, 8, NT_PRSTATUS, 8,},
+	[10] = { /* r10 */ 7 * 8, 8, NT_PRSTATUS, 8,},
+	[11] = { /* r11 */ 6 * 8, 8, NT_PRSTATUS, 8,},
+	[12] = { /* r12 */ 3 * 8, 8, NT_PRSTATUS, 8,},
+	[13] = { /* r13 */ 2 * 8, 8, NT_PRSTATUS, 8,},
+	[14] = { /* r14 */ 1 * 8, 8, NT_PRSTATUS, 8,},
+	[15] = { /* r15 */ 0 * 8, 8, NT_PRSTATUS, 8,},
+	[16] = { /* rip */ 16 * 8, 8, NT_PRSTATUS, 8,},
+	[17] = { /* flags */ 18 * 8, 8, NT_PRSTATUS, 4,},
+	[18] = { /* cs */ 17 * 8, 8, NT_PRSTATUS, 4,},
+	[19] = { /* ss */ 20 * 8, 8, NT_PRSTATUS, 4,},
+	[20] = { /* ds */ 23 * 8, 8, NT_PRSTATUS, 4,},
+	[21] = { /* es */ 24 * 8, 8, NT_PRSTATUS, 4,},
+	[22] = { /* fs */ 25 * 8, 8, NT_PRSTATUS, 4,},
+	[23] = { /* gs */ 26 * 8, 8, NT_PRSTATUS, 4,},
+	[24] = { /* st0 */ 0, 0, NT_PRFPREG, 10,},
+	[25] = { /* st1 */ 0, 0, NT_PRFPREG, 10,},
+	[26] = { /* st2 */ 0, 0, NT_PRFPREG, 10,},
+	[27] = { /* st3 */ 0, 0, NT_PRFPREG, 10,},
+	[28] = { /* st4 */ 0, 0, NT_PRFPREG, 10,},
+	[29] = { /* st5 */ 0, 0, NT_PRFPREG, 10,},
+	[30] = { /* st6 */ 0, 0, NT_PRFPREG, 10,},
+	[31] = { /* st7 */ 0, 0, NT_PRFPREG, 10,},
+	[32] = { /* fctrl */ 0, 0, NT_PRFPREG, 4,},
+	[33] = { /* fstat */ 0, 0, NT_PRFPREG, 4,},
+	[34] = { /* ftag */ 0, 0, NT_PRFPREG, 4,},
+	[35] = { /* fiseg */ 0, 0, NT_PRFPREG, 4,},
+	[36] = { /* fioff */ 0, 0, NT_PRFPREG, 4,},
+	[37] = { /* foseg */ 0, 0, NT_PRFPREG, 4,},
+	[38] = { /* fooff */ 0, 0, NT_PRFPREG, 4,},
+	[39] = { /* fop */ 0, 0, NT_PRFPREG, 4,},
+	[40] = { /* xmm0 */ 0, 0, NT_PRFPREG, 16,},
+	[41] = { /* xmm1 */ 0, 0, NT_PRFPREG, 16,},
+	[42] = { /* xmm2 */ 0, 0, NT_PRFPREG, 16,},
+	[43] = { /* xmm3 */ 0, 0, NT_PRFPREG, 16,},
+	[44] = { /* xmm4 */ 0, 0, NT_PRFPREG, 16,},
+	[45] = { /* xmm5 */ 0, 0, NT_PRFPREG, 16,},
+	[46] = { /* xmm6 */ 0, 0, NT_PRFPREG, 16,},
+	[47] = { /* xmm7 */ 0, 0, NT_PRFPREG, 16,},
+	[48] = { /* xmm8 */ 0, 0, NT_PRFPREG, 16,},
+	[49] = { /* xmm9 */ 0, 0, NT_PRFPREG, 16,},
+	[50] = { /* xmm10 */ 0, 0, NT_PRFPREG, 16,},
+	[51] = { /* xmm11 */ 0, 0, NT_PRFPREG, 16,},
+	[52] = { /* xmm12 */ 0, 0, NT_PRFPREG, 16,},
+	[53] = { /* xmm13 */ 0, 0, NT_PRFPREG, 16,},
+	[54] = { /* xmm14 */ 0, 0, NT_PRFPREG, 16,},
+	[55] = { /* xmm15 */ 0, 0, NT_PRFPREG, 16,},
+	[56] = { /* mxcsr */ 0, 0, NT_PRFPREG, 4,},
+	[57] = { /* orig_rax */ 15 * 8, 8, NT_PRSTATUS, 8,},
+};
+
+static int gdb_remote_register_info(struct gdb_connection *p,
+					struct task_struct *task,
+					unsigned number,
+					unsigned *pos, unsigned *count,
+					unsigned *bytes)
+{
+	const struct user_regset_view *rs = task_user_regset_view(task);
+	int rsn = -1;
+
+	if (rs == 0)
+		return -ENOENT;
+
+#define GMRSIZE (sizeof(struct gdb_map_regset))
+
+	if (rs->e_machine == EM_386) {
+		if (number < sizeof(arch_i386_map_regset) / GMRSIZE) {
+			*pos = arch_i386_map_regset[number].pos;
+			*count = arch_i386_map_regset[number].count;
+			*bytes = arch_i386_map_regset[number].bytes;
+			rsn = arch_i386_map_regset[number].rsn;
+		}
+	} else if (rs->e_machine == EM_X86_64) {
+		if (number < sizeof(arch_x86_64_map_regset) / GMRSIZE) {
+			*pos = arch_x86_64_map_regset[number].pos;
+			*count = arch_x86_64_map_regset[number].count;
+			*bytes = arch_x86_64_map_regset[number].bytes;
+			rsn = arch_x86_64_map_regset[number].rsn;
+		}
+	}
+	/* else ... rsn stays -1. */
+#undef GMRSIZE
+
+	/*
+	 * Now map to the per-architecture regset index, based on the
+	 * elf core_note_type we found.
+	 */
+	if (rsn >= 0) {
+		unsigned j;
+		for (j = 0; j < rs->n; j++) {
+			if (rs->regsets[j].core_note_type == rsn)
+				return j;
+		}
+	}
+
+	/*
+	 * Invalid machines, register numbers, rsns, or unset rsns all
+	 * fall through here.
+	 */
+	return -ENOENT;
+}
+
+static inline int fetch_remote_register_info(struct gdb_connection *p,
+					struct task_struct *task,
+					int index,
+					unsigned *pos,
+					unsigned *count,
+					unsigned *bytes)
+{
+	int rsn;
+
+	rsn = gdb_remote_register_info(p, task, index, pos, count, bytes);
+	pr_debug("gdb register %u => rsn %d p%u c%u b%u\n", index, rsn,
+							*pos, *count, *bytes);
+	if (rsn > 0) {
+		/*
+		 * If we want to extract register data, make sure we're
+		 * fetching at least that much.
+		 */
+		BUG_ON(*count > 0 && *count < *bytes);
+		/* Assert reg_contents size is right. */
+		BUG_ON(MAX_REG_WIDTH < *bytes || MAX_REG_WIDTH < *count);
+	}
+	return rsn;
+}
+
+static inline int get_set_regset_view(struct task_struct *task,
+			unsigned pos, unsigned count,
+			unsigned char *reg_contents,
+			int rsn, bool set)
+{
+	int rc;
+	const struct user_regset_view *rsv;
+	const struct user_regset *rs;
+
+	if (!count) {
+		if (!set)
+			memset(reg_contents, 0, MAX_REG_WIDTH);
+		return 0;
+	}
+
+	/* real register */
+	if (set)
+		BUG_ON(count > MAX_REG_WIDTH);
+
+	rsv = task_user_regset_view(task);
+	BUG_ON(rsn >= rsv->n);
+	rs = &rsv->regsets[rsn];
+
+	/* Extract the register values into reg_contents[]. */
+	if (set)
+		rc = (rs->set)(task, rs, pos, count, reg_contents, NULL);
+	else
+		rc = (rs->get)(task, rs, pos, count, reg_contents, NULL);
+
+	return rc;
+}
+
+static inline void prepare_regset_set(struct gdb_connection *p,
+				unsigned char *reg_contents,
+				size_t *start, unsigned bytes)
+{
+	int j;
+
+	/*
+	 * 0-fill the register copy.
+	 * XXX initialize it from rs->get() instead?
+	 */
+	memset(reg_contents, 0, MAX_REG_WIDTH);
+
+	/*
+	 * Hex-unconvert all the bytes.
+	 * XXX: endianness adjust for count != bytes
+	 */
+	for (j = 0; j < bytes; j++)
+		reg_contents[j] = byteme(p->input_buf[*start + 2 * j],
+					   p->input_buf[*start + 2 * j + 1]);
+	*start += 2 * bytes;
+}
+
+/*
+ * Process an entire, checksum-confirmed $command# at the front of
+ * p->input_buf[].  The input and output mutexes are being held.
+ */
+static void handle_gdb_command_packet(struct gdb_connection *p,
+						struct task_struct *task)
+{
+	unsigned long arg1, arg2, arg3;
+	size_t op_start;
+	int rc = 0;
+	int i, j;
+
+	pr_debug("gdb packet code %c\n", p->input_buf[1]);
+
+	switch (p->input_buf[1]) {
+	case '?':
+		if (p->at_quiesce_do != UTRACE_STOP) {
+			/* shouldn't happen */
+			p->stop_signals++;
+			rc = utrace_control(task, p->engine, UTRACE_INTERRUPT);
+			if (rc == -EINPROGRESS)
+				rc = utrace_barrier(task, p->engine);
+			/*
+			 * Note that we don't enqueue a reply packet here,
+			 * but make gdb wait for a response from the
+			 * utrace report_FOO callbacks.
+			 */
+		} else {
+			push_output_packet(p, p->stopcode);
+		}
+		break;
+
+	case 'i':		/* [ADDR[,NNN]] */
+	case 's':		/* [ADDR] */
+		/* XXX: if !arch_has_single_step() ... then what? */
+	case 'c':		/* [ADDR] */
+		rc = sscanf(&p->input_buf[2], "%lx,%lx", &arg1, &arg2);
+		/* XXX: args ignored */
+		p->stopcode[0] = '\0';
+		p->at_quiesce_do =
+		    ((p->input_buf[1] == 'c' || !arch_has_single_step())
+		     ? UTRACE_RESUME : UTRACE_SINGLESTEP);
+		if (p->at_quiesce_do == UTRACE_SINGLESTEP)
+			p->stop_signals++;
+		rc = utrace_control(task, p->engine, p->at_quiesce_do);
+		if (rc == -EINPROGRESS)
+			rc = utrace_barrier(task, p->engine);
+		break;
+	case 'C':		/* SIG[;ADDR] */
+	case 'S':		/* SIG[;ADDR] */
+		/* XXX: if !arch_has_single_step() ... then what? */
+	case 'I':		/* SIG[;ADDR[,NNN?]] */
+		rc = sscanf(&p->input_buf[2], "%lx;%lx,%lx", &arg1, &arg2,
+			    &arg3);
+		if (rc >= 1)	/* SIG present */
+			send_sig(map_signal_gdb2kern(arg1), task, 1);
+
+		p->pass_signals++;
+		p->stopcode[0] = '\0';
+		p->at_quiesce_do =
+		    ((p->input_buf[1] == 'C' || !arch_has_single_step())
+		     ? UTRACE_RESUME : UTRACE_SINGLESTEP);
+		if (p->at_quiesce_do == UTRACE_SINGLESTEP)
+			p->stop_signals++;
+
+		rc = utrace_control(task, p->engine, p->at_quiesce_do);
+		if (rc == -EINPROGRESS)
+			rc = utrace_barrier(task, p->engine);
+
+		/* Response will come at next report_signal. */
+		break;
+	case 'D':
+		push_output_packet(p, "OK");
+		/* NB: proc_gdb_release() performs actual utrace detach. */
+		break;
+	case 'g':
+		op_start = push_output_packet_start(p);
+
+		/*
+		 * GDB_BUFMAX stands for some random large number,
+		 * known to be larger than the number of gdb indexed
+		 * registers.
+		 */
+		for (i = 0; i < GDB_BUFMAX; i++) {
+			unsigned rs_count;
+			unsigned rs_pos;
+			unsigned bytes;
+			int rsn;
+			unsigned char reg_contents[MAX_REG_WIDTH];
+
+			rsn = fetch_remote_register_info(p, task, i,
+					   &rs_pos, &rs_count, &bytes);
+			if (rsn < 0)
+				break;
+
+			rc = get_set_regset_view(task, rs_pos, rs_count,
+						reg_contents, rsn, false);
+			if (rc)
+				break;
+
+			/*
+			 * Hex-dump it.
+			 * XXX: endianness adjust for count != bytes
+			 */
+			for (j = 0; j < bytes; j++) {
+				/* pr_debug("%02x", reg_contents[j]); */
+				push_output_hex(p, reg_contents[j]);
+			}
+			/* pr_debug(")\n"); */
+
+		}
+		push_output_packet_end(p, op_start);
+		break;
+	case 'G':
+		i = 0;
+		op_start = 2;	/* use as input pointer, past $G in command */
+		while (p->input_buf[op_start] != '#' &&
+				       op_start < p->input_buf_size) {
+			unsigned rs_count;
+			unsigned rs_pos;
+			unsigned bytes;
+			int rsn;
+			unsigned char reg_contents[MAX_REG_WIDTH];
+
+			rsn = fetch_remote_register_info(p, task, i,
+					   &rs_pos, &rs_count, &bytes);
+			if (rsn < 0)
+				break;
+
+			/* Remaining packet too short? */
+			if ((op_start + 2 * bytes + 3) < p->input_buf_size)
+				break;
+
+			prepare_regset_set(p, reg_contents, &op_start, bytes);
+			rc = get_set_regset_view(task, rs_pos, rs_count,
+						reg_contents, rsn, true);
+			if (rc)
+				break;
+		}
+		if (p->input_buf[op_start] == '#' && rc == 0)
+			push_output_packet(p, "OK");
+		else
+			push_output_packet(p, "E01");
+
+		break;
+	case 'p':		/* REG */
+		push_output_packet(p, "E01");
+		break;
+	case 'P':		/* REG=VAL */
+		/* `i' will index p->input_buf to consume VAL hex bytes. */
+		rc = sscanf(&p->input_buf[2], "%lx=%n", &arg1, &i);
+		op_start = i + 2;	/* Skip the leading $P also */
+		if (rc != 1) {
+			push_output_packet(p, "E01");
+		} else {
+			unsigned rs_count;
+			unsigned rs_pos;
+			unsigned bytes;
+			int rsn;
+			unsigned char reg_contents[MAX_REG_WIDTH];
+
+			rsn = fetch_remote_register_info(p, task, arg1,
+					   &rs_pos, &rs_count, &bytes);
+			if (rsn < 0)
+				break;
+
+			/* Remaining packet too short? */
+			if ((op_start + 2 * bytes + 3) < p->input_buf_size)
+				break;
+
+			prepare_regset_set(p, reg_contents, &op_start, bytes);
+			rc = get_set_regset_view(task, rs_pos, rs_count,
+						reg_contents, rsn, true);
+			WARN_ON(rc);
+			if (p->input_buf[op_start] == '#' && rc == 0)
+				push_output_packet(p, "OK");
+			else
+				push_output_packet(p, "E01");
+		}
+		break;
+	case 'm':		/* ADDR,LENGTH */
+		rc = sscanf(&p->input_buf[2], "%lx,%lx", &arg1, &arg2);
+		if (rc != 2)
+			push_output_packet(p, "E01");
+		else {
+			size_t o = push_output_packet_start(p);
+			while (arg2 > 0) {
+				unsigned char value;
+
+				/*
+				 * Simply stop looping if requested length
+				 * was too large.  gdb will probably retry
+				 * from this point on.
+				 */
+				if (p->output_buf_size + 5 > GDB_BUFMAX)
+					break;
+
+				rc = access_process_vm(task, arg1, &value, 1,
+						       0);
+				if (rc != 1)
+					break;	/* EFAULT */
+				else
+					push_output_hex(p, value);
+
+				arg1++;
+				arg2--;
+			}
+			push_output_packet_end(p, o);
+		}
+		break;
+	case 'M':		/* ADDR,LENGTH:XX */
+		/* `i' will index p->input_buf to consume XX hex bytes. */
+		rc = sscanf(&p->input_buf[2], "%lx,%lx:%n", &arg1, &arg2, &i);
+		op_start = i + 2;	/* Skip the leading $M also. */
+		if (rc < 2) {
+			push_output_packet(p, "E01");
+			break;
+		}
+		while (arg2 > 0) {
+			unsigned char value;
+
+			/*
+			 * Check that enough input bytes left for
+			 * these two hex chars, plus the #XX checksum.
+			 */
+			if (i + 4 >= p->input_buf_size)
+				break;
+
+			value = byteme(p->input_buf[i], p->input_buf[i + 1]);
+			rc = access_process_vm(task, arg1, &value, 1, 1);
+			if (rc != 1)
+				break;	/* EFAULT */
+
+			i += 2;
+			arg1++;
+			arg2--;
+		}
+		if (arg2 != 0)
+			push_output_packet(p, "E02");
+		else
+			push_output_packet(p, "OK");
+
+		break;
+	case 'Z':               /* TYPE,ADDR,LENGTH */
+		/* Not yet implemented */
+		push_output_packet(p, "E03");
+		break;
+	case 'z':               /* TYPE,ADDR,LENGTH */
+		/* Not yet implemented */
+		push_output_packet(p, "E03");
+		break;
+
+	default:
+		push_output_packet(p, "");
+	}
+}
+
+/* ------------------------------------------------------------------------ */
+
+/* gdb control callbacks */
+
+#define get_proc_task(inode) get_pid_task(PROC_I((inode))->pid, PIDTYPE_PID)
+
+static int proc_gdb_open(struct inode *inode, struct file *filp)
+{
+	struct task_struct *task = get_proc_task(inode);
+	int ret = -EBUSY;
+	struct gdb_connection *p;
+
+	pr_debug("opened /proc/%d/gdb\n", task->pid);
+
+	/* Reject kernel threads. */
+	if (task->flags & PF_KTHREAD) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Reject if connection is for other than tg-leader thread. */
+	if (task_pid_nr(task) != task_tgid_nr(task)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	mutex_lock(&gdb_connections_mutex);
+
+	/*
+	 * Reject if a connection exists for the thread group
+	 * leader.
+	 */
+	list_for_each_entry(p, &gdb_connections, link) {
+		if (p->target == task_tgid_nr(task)) {
+			ret = -EBUSY;
+			goto out_mutex;
+		}
+	}
+	/* (Don't unlock yet, to defeat a race of two concurrent opens.) */
+
+	p = kzalloc(sizeof(struct gdb_connection), GFP_KERNEL);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out_mutex;
+	}
+
+	/* Send initial ping to gdb. */
+	push_output_packet(p, "");
+
+	mutex_init(&p->output_mutex);
+	init_waitqueue_head(&p->output_wait);
+
+	mutex_init(&p->input_mutex);
+	init_waitqueue_head(&p->input_wait);
+
+	/*
+	 * NB: During attach, we don't want to bother the target.
+	 * Soon though a send_sig will interrupt it.
+	 */
+	p->at_quiesce_do = UTRACE_RESUME;
+	p->target = task->tgid;
+
+	p->engine = utrace_attach_task(task,
+					UTRACE_ATTACH_CREATE |
+					UTRACE_ATTACH_EXCLUSIVE |
+					UTRACE_ATTACH_MATCH_OPS,
+					&gdb_utrace_ops, p);
+	if (IS_ERR(p->engine) || p->engine == NULL) {
+		ret = -EBUSY;
+		goto out_free;
+	}
+
+	ret = utrace_set_events(task, p->engine,
+				UTRACE_EVENT_SIGNAL_ALL |
+				UTRACE_EVENT(QUIESCE) |
+				UTRACE_EVENT(DEATH) |
+				UTRACE_EVENT(EXIT) |
+				UTRACE_EVENT(EXEC) | UTRACE_EVENT(CLONE));
+	pr_debug("utrace_set_events sent, ret=%d\n", ret);
+	utrace_engine_put(p->engine);
+	filp->private_data = p;
+
+	INIT_LIST_HEAD(&p->link);
+	list_add_tail(&p->link, &gdb_connections);
+
+	p->stop_signals++;
+	ret = utrace_control(task, p->engine, UTRACE_INTERRUPT);
+	if (ret == -EINPROGRESS)
+		ret = utrace_barrier(task, p->engine);
+
+	goto out_mutex;
+
+out_free:
+	kfree(p);
+out_mutex:
+	mutex_unlock(&gdb_connections_mutex);
+out:
+	return ret;
+}
+
+static int proc_gdb_release(struct inode *inode, struct file *filp)
+{
+	struct task_struct *task = get_proc_task(inode);
+	struct gdb_connection *p = filp->private_data;
+	int ret = 0;
+
+	mutex_lock(&gdb_connections_mutex);
+	if (task == NULL) {
+		/* Thread is already gone; report_death was already called. */
+		pr_debug("gdb %d releasing old\n", p->target);
+	} else if (p->at_quiesce_do != UTRACE_DETACH) {
+		pr_debug("gdb %d releasing current\n", p->target);
+
+		ret = utrace_set_events(task, p->engine, 0);
+		if (ret == -EINPROGRESS)
+			ret = utrace_barrier(task, p->engine);
+
+		/*
+		 * No more callbacks will be received!
+		 * Detach implies Resume
+		 */
+		ret = utrace_control(task, p->engine, UTRACE_DETACH);
+		if (ret == -EINPROGRESS)
+			ret = utrace_barrier(task, p->engine);
+	}
+
+	list_del(&p->link);
+	mutex_unlock(&gdb_connections_mutex);
+
+	kfree(p);
+	return ret;
+}
+
+static int proc_gdb_ioctl(struct inode *inode, struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	/*
+	 * XXX: GDB usually thinks that a file name for "target
+	 * remote" implies a serial port with tty-ish ioctl's
+	 * available.  We pretend to accept them all.
+	 */
+	return 0;
+}
+
+static ssize_t proc_gdb_read(struct file *filp, char __user * buf,
+					size_t count, loff_t *ppos)
+{
+	struct gdb_connection *p = filp->private_data;
+	struct task_struct *task;
+	int rc = 0;
+	size_t len;
+
+	task = find_task_by_vpid(p->target);
+	if (!task)
+		return -EINVAL;
+
+	if ((p->output_buf_size <= p->output_buf_read) &&
+	    filp->f_flags & O_NONBLOCK)
+		return -EAGAIN;
+
+again:
+	rc = wait_event_interruptible(p->output_wait,
+				      (p->output_buf_size >
+				       p->output_buf_read));
+	if (rc)
+		goto out;
+
+	mutex_lock(&p->output_mutex);
+
+	if (p->output_buf_size <= p->output_buf_read) {
+		mutex_unlock(&p->output_mutex);
+		goto again;
+	}
+	len = min(count, (size_t) (p->output_buf_size - p->output_buf_read));
+	if (copy_to_user(buf, &p->output_buf[p->output_buf_read], len)) {
+		rc = -EFAULT;
+		goto out_unlock;
+	}
+
+	pr_debug("sent %u bytes (%ld left) data (%.*s)\n",
+		(unsigned)len,
+		((long)p->output_buf_size - (long)p->output_buf_read) - len,
+		(int)len, &p->output_buf[p->output_buf_read]);
+
+	p->output_buf_read += len;
+	rc = len;
+
+	/* If whole packet is consumed, reset for next one. */
+	BUG_ON(p->output_buf_read > p->output_buf_size);
+	if (p->output_buf_read == p->output_buf_size) {
+		p->output_buf_read = 0;
+		p->output_buf_size = 0;
+	}
+
+out_unlock:
+	mutex_unlock(&p->output_mutex);
+
+out:
+	return rc;
+}
+
+static ssize_t proc_gdb_write(struct file *filp, const char __user * buf,
+					size_t count, loff_t *ppos)
+{
+	struct gdb_connection *p = filp->private_data;
+	size_t last_input_buf_size;
+	struct task_struct *task;
+	size_t len;
+	int ret = 0;
+
+	task = find_task_by_vpid(p->target);
+	if (!task)
+		return -EINVAL;
+
+again:
+	ret = wait_event_interruptible(p->input_wait,
+				       (p->input_buf_size < GDB_BUFMAX));
+	if (ret)
+		goto out;
+
+	mutex_lock(&p->input_mutex);
+	if (p->input_buf_size == GDB_BUFMAX) {
+		mutex_unlock(&p->input_mutex);
+		goto again;
+	}
+	mutex_lock(&p->output_mutex);
+
+	/* We now know there is some room in the input buffer.  Upon
+	   entry, the input_buf will either be empty, or contain a
+	   partial gdb request packet. */
+
+	/* Copy the data. */
+	len = min(count, (size_t) (GDB_BUFMAX - p->input_buf_size));
+	if (copy_from_user(&p->input_buf[p->input_buf_size], buf, len)) {
+		ret = -EFAULT;
+		goto out_unlock;
+	}
+
+	/*
+	 * pr_debug("received data %.*s\n", (int)len,
+	 *				&p->input_buf[p->input_buf_size]);
+	 */
+
+	p->input_buf_size += len;
+	ret = len;
+
+	/*
+	 * Process any packets in the buffer to restore the incoming
+	 * invariant.  (Normal GDB will not send more than one packet before
+	 * waiting for a response.)
+	 */
+
+	/*
+	 * We iterate until we can no longer shrink the input buffer.
+	 * Usually we will not iterate more than once, since there may be
+	 * one +/- ack byte and/or one gdb packet.
+	 */
+	last_input_buf_size = 0;
+	while (p->input_buf_size && p->input_buf_size != last_input_buf_size) {
+		last_input_buf_size = p->input_buf_size;
+
+		if (p->input_buf[0] == '+') {
+			/*
+			 * This must have been an ack to our
+			 * previously output packet.
+			 * Consume the input.
+			 */
+			memmove(&p->input_buf[0], &p->input_buf[1],
+				--p->input_buf_size);
+		} else if (p->input_buf[0] == '-') {
+			/*
+			 * Whoops, a nak.  Unfortunately, we don't
+			 * handle transmission errors by
+			 * retransmitting the last output_buf; it's
+			 * already gone.  OTOH we should not encounter
+			 * transmission errors on a reliable channel
+			 * such as a read syscall.
+			 * Consume the input.
+			 */
+			printk(KERN_WARNING "Unexpected NAK received"
+			       "on /proc/%d/gdb connection.\n",
+			       task_pid_nr(task));
+			memmove(&p->input_buf[0], &p->input_buf[1],
+				--p->input_buf_size);
+		} else if (p->input_buf[0] == 3) {	/* ^C == INTR */
+			int rc;	/* NB: don't overwrite 'ret'. */
+			pr_debug("received gdb interrupt\n");
+			p->stop_signals++;
+			rc = utrace_control(task, p->engine, UTRACE_INTERRUPT);
+			if (rc == -EINPROGRESS)
+				rc = utrace_barrier(task, p->engine);
+
+			/*
+			 * p->at_quiesce_do will be set in
+			 * report_signal(SIGNAL_REPORT).  NB: this packet
+			 * does not generate an +/- ack. Consume the input.
+			 */
+			memmove(&p->input_buf[0], &p->input_buf[1],
+				--p->input_buf_size);
+		} else if (p->input_buf[0] == '$') {	/* command packet */
+			int j;
+			unsigned char checksum = 0;
+			unsigned char checksum2;
+			for (j = 1; j < p->input_buf_size - 2; j++) {
+				if (p->input_buf[j] != '#') {
+					checksum += p->input_buf[j];
+					continue;
+				}
+				checksum2 = byteme(p->input_buf[j + 1],
+						   p->input_buf[j + 2]);
+				pr_debug("received gdb packet %.*s\n",
+						 j + 3, &p->input_buf[0]);
+				if (checksum == checksum2) {
+					push_output(p, '+');
+					handle_gdb_command_packet(p, task);
+				} else
+					push_output(p, '-');
+
+				/* Consume the whole packet. */
+				p->input_buf_size -= (j + 3);
+				memmove(&p->input_buf[0], &p->input_buf[j + 3],
+							p->input_buf_size);
+				break;
+			}	/* End searching for end of packet */
+
+			/*
+			 * We may not have found the #<hex><hex>
+			 * checksum.  If so, leave the partial packet
+			 * in input_buf.  Since input_buf_size will
+			 * not have decreased, the while() loop above
+			 * will detect a fixpoint and exit.
+			 *
+			 * Alternately, there could be another gdb packet
+			 * just behind the one we just consumed.  In this
+			 * we'll iterate one more time in this loop.
+			 */
+		} else {	/* junk character */
+			printk(KERN_WARNING "Unexpected character (%x) "
+			       "received on /proc/%d/gdb connection.\n",
+			       (int)p->input_buf[0], task_pid_nr(task));
+			/* Consume the input. */
+			memmove(&p->input_buf[0], &p->input_buf[1],
+				--p->input_buf_size);
+		}
+	}
+
+out_unlock:
+	/* Probably have more room in input_buf. */
+	wake_up(&p->input_wait);
+	/* Probably have data in output_buf. */
+	wake_up(&p->output_wait);
+
+	mutex_unlock(&p->output_mutex);
+	mutex_unlock(&p->input_mutex);
+out:
+	return ret;
+}
+
+const struct file_operations proc_gdb_operations = {
+	.open = proc_gdb_open,
+	.read = proc_gdb_read,
+	.write = proc_gdb_write,
+	.release = proc_gdb_release,
+	.ioctl = proc_gdb_ioctl,
+};
