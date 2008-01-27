Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYA0Spu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYA0Spu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYA0Spj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:45:39 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:33334 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYA0Sph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:45:37 -0500
Message-ID: <479CD13D.7070703@web.de>
Date: Sun, 27 Jan 2008 19:45:17 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH] KGDB: various refactorings
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE66F0AE056AEDB9F4F48951E"
X-Provags-ID: V01U2FsdGVkX1/nqo78BuTv8PQq/YJBMHryXgo+PbVdRDjX0DPW
	jjhiFEU5NVAKo89/ZcCwbVrBcSx8BzBCqCx7iDsrOZtcMerZQm
	3xOmpYzCE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE66F0AE056AEDB9F4F48951E
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jason,

this is a RFC about another round of refactoring for the KGDB version
in x86-git. It's a single patch so far, but I can break out individual
hunks on request.

Things I changed:
 - Reduce EXPORT_SYMBOLs, switch the rest to EXPORT_SYMBOL_GPL
 - Drop code that is (yet) unused
 - Rename variables, refactor their types (personal taste, for sure)
 - Remove "extern" for function prototypes
 - Remove MODULE_LICENSE/DESCRIPTION from kgdb core

Just cherry-pick what you like.

Jan


Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 arch/x86/kernel/kgdb.c |   10 +-
 include/linux/kgdb.h   |  109 ++++++++++++-----------
 kernel/kgdb.c          |  230 +++++++++++++++++++++---------------------=
-------
 3 files changed, 162 insertions(+), 187 deletions(-)

Index: b/include/linux/kgdb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -12,7 +12,6 @@
  * version 2. This program is licensed "as is" without any warranty of a=
ny
  * kind, whether express or implied.
  */
-#ifdef __KERNEL__
 #ifndef _KGDB_H_
 #define _KGDB_H_
=20
@@ -34,10 +33,10 @@ struct task_struct;
 struct uart_port;
=20
 /* To enter the debugger explicitly. */
-extern void breakpoint(void);
+void breakpoint(void);
+
 extern int kgdb_connected;
 extern int kgdb_may_fault;
-extern struct tasklet_struct kgdb_tasklet_breakpoint;
=20
 extern atomic_t kgdb_setting_breakpoint;
 extern atomic_t cpu_doing_single_step;
@@ -45,19 +44,27 @@ extern int kgdb_softlock_skip[NR_CPUS];
=20
 extern struct task_struct *kgdb_usethread, *kgdb_contthread;
=20
+enum kgdb_initstate {
+	KGDB_UNINITIALIZED =3D 0,
+	KGDB_SEMI_INITIALIZED,
+	KGDB_FULLY_INITIALIZED
+};
+
+extern enum kgdb_initstate kgdb_state;
+
 enum kgdb_bptype {
-	bp_breakpoint =3D '0',
-	bp_hardware_breakpoint,
-	bp_write_watchpoint,
-	bp_read_watchpoint,
-	bp_access_watchpoint
+	BP_BREAKPOINT =3D 0,
+	BP_HARDWARE_BREAKPOINT,
+	BP_WRITE_WATCHPOINT,
+	BP_READ_WATCHPOINT,
+	BP_ACCESS_WATCHPOINT
 };
=20
 enum kgdb_bpstate {
-	bp_none =3D 0,
-	bp_removed,
-	bp_set,
-	bp_active
+	BP_UNDEFINED =3D 0,
+	BP_REMOVED,
+	BP_SET,
+	BP_ACTIVE
 };
=20
 struct kgdb_bkpt {
@@ -68,10 +75,10 @@ struct kgdb_bkpt {
 };
=20
 /* The maximum number of KGDB I/O modules that can be loaded */
-#define MAX_KGDB_IO_HANDLERS 3
+#define KGDB_MAX_IO_HANDLERS 3
=20
-#ifndef MAX_BREAKPOINTS
-#define MAX_BREAKPOINTS		1000
+#ifndef KGDB_MAX_BREAKPOINTS
+#define KGDB_MAX_BREAKPOINTS	1000
 #endif
=20
 #define KGDB_HW_BREAKPOINT	1
@@ -83,20 +90,20 @@ struct kgdb_bkpt {
  *	This function will handle the initalization of any architecture
  *	specific hooks.
  */
-extern int kgdb_arch_init(void);
+int kgdb_arch_init(void);
=20
 /**
- *	regs_to_gdb_regs - Convert ptrace regs to GDB regs
+ *	pt_regs_to_gdb_regs - Convert ptrace regs to GDB regs
  *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
  *	@regs: The &struct pt_regs of the current process.
  *
  *	Convert the pt_regs in @regs into the format for registers that
  *	GDB expects, stored in @gdb_regs.
  */
-extern void regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *re=
gs);
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs);=

=20
 /**
- *	sleeping_regs_to_gdb_regs - Convert ptrace regs to GDB regs
+ *	sleeping_thread_to_gdb_regs - Convert ptrace regs to GDB regs
  *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
  *	@p: The &struct task_struct of the desired process.
  *
@@ -107,18 +114,18 @@ extern void regs_to_gdb_regs(unsigned lo
  *	@gdb_regs with what has	been saved in &struct thread_struct
  *	thread field during switch_to.
  */
-extern void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs,
-					struct task_struct *p);
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs,
+				 struct task_struct *p);
=20
 /**
- *	gdb_regs_to_regs - Convert GDB regs to ptrace regs.
+ *	gdb_regs_to_pt_regs - Convert GDB regs to ptrace regs.
  *	@gdb_regs: A pointer to hold the registers we've received from GDB.
  *	@regs: A pointer to a &struct pt_regs to hold these values in.
  *
  *	Convert the GDB regs in @gdb_regs into the pt_regs, and store them
  *	in @regs.
  */
-extern void gdb_regs_to_regs(unsigned long *gdb_regs, struct pt_regs *re=
gs);
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs);=

=20
 /**
  *	kgdb_arch_handle_exception - Handle architecture specific GDB packets=
=2E
@@ -136,10 +143,10 @@ extern void gdb_regs_to_regs(unsigned lo
  *	process more packets, and a %0 or %1 if it wants to exit from the
  *	kgdb hook.
  */
-extern int kgdb_arch_handle_exception(int vector, int signo, int err_cod=
e,
-				      char *remcom_in_buffer,
-				      char *remcom_out_buffer,
-				      struct pt_regs *regs);
+int kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			       char *remcom_in_buffer,
+			       char *remcom_out_buffer,
+			       struct pt_regs *regs);
=20
 /**
  * 	kgdb_roundup_cpus - Get other CPUs into a holding pattern
@@ -157,7 +164,7 @@ extern int kgdb_arch_handle_exception(in
  *
  *	On non-SMP systems, this is not called.
  */
-extern void kgdb_roundup_cpus(unsigned long flags);
+void kgdb_roundup_cpus(unsigned long flags);
=20
 #ifndef JMP_REGS_ALIGNMENT
 #define JMP_REGS_ALIGNMENT
@@ -173,7 +180,7 @@ extern unsigned long kgdb_fault_jmp_regs
  *	cause a fault.  When this happens, we trap it, restore state to
  *	this call, and let ourself know that something bad has happened.
  */
-extern asmlinkage int kgdb_fault_setjmp(unsigned long *curr_context);
+asmlinkage int kgdb_fault_setjmp(unsigned long *curr_context);
=20
 /**
  *	kgdb_fault_longjmp - Restore state when we have faulted.
@@ -183,12 +190,12 @@ extern asmlinkage int kgdb_fault_setjmp(
  *	restore the known good state, and set the return value to 1, so
  *	we know something bad happened.
  */
-extern asmlinkage void kgdb_fault_longjmp(unsigned long *curr_context);
+asmlinkage void kgdb_fault_longjmp(unsigned long *curr_context);
=20
 /* Optional functions. */
-extern int kgdb_validate_break_address(unsigned long addr);
-extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_inst=
r);
-extern int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)=
;
+int kgdb_validate_break_address(unsigned long addr);
+int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
+int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle);
=20
 /**
  * struct kgdb_arch - Describe architecture specific values.
@@ -259,31 +266,31 @@ struct kgdb_io {
=20
 extern struct kgdb_io kgdb_io_ops;
 extern struct kgdb_arch arch_kgdb_ops;
-extern int kgdb_initialized;
=20
-extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
-extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops)=
;
+int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
+void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
=20
-extern void kgdb8250_add_port(int i, struct uart_port *serial_req);
-extern void __init kgdb8250_add_platform_port(int i,
+void kgdb8250_add_port(int i, struct uart_port *serial_req);
+void __init kgdb8250_add_platform_port(int i,
 	struct plat_serial8250_port *serial_req);
=20
-extern int kgdb_hex2long(char **ptr, long *long_val);
-extern char *kgdb_mem2hex(char *mem, char *buf, int count);
-extern char *kgdb_hex2mem(char *buf, char *mem, int count);
-extern char *kgdb_get_mem(char *addr, unsigned char *buf, int count);
-extern char *kgdb_set_mem(char *addr, unsigned char *buf, int count);
+int kgdb_hex2long(char **ptr, long *long_val);
+char *kgdb_mem2hex(char *mem, char *buf, int count);
+char *kgdb_hex2mem(char *buf, char *mem, int count);
+char *kgdb_get_mem(char *addr, unsigned char *buf, int count);
+char *kgdb_set_mem(char *addr, unsigned char *buf, int count);
=20
 int kgdb_isremovedbreak(unsigned long addr);
=20
-extern int kgdb_handle_exception(int ex_vector, int signo, int err_code,=

-				struct pt_regs *regs);
-extern int kgdb_nmihook(int cpu, void *regs);
+int kgdb_handle_exception(int ex_vector, int signo, int err_code,
+			  struct pt_regs *regs);
+int kgdb_nmihook(int cpu, void *regs);
+
 extern int debugger_step;
 extern atomic_t debugger_active;
-#else
-/* Stubs for when KGDB is not set. */
+
+#else /* !CONFIG_KGDB */
 static const atomic_t debugger_active =3D ATOMIC_INIT(0);
-#endif				/* CONFIG_KGDB */
-#endif				/* _KGDB_H_ */
-#endif				/* __KERNEL__ */
+#endif /* !CONFIG_KGDB */
+
+#endif /* _KGDB_H_ */
Index: b/kernel/kgdb.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -71,16 +71,11 @@ extern int pid_max;
 	}							\
 	}
=20
-/*
- * kgdb_initialized with a value of 1 indicates that kgdb is setup and i=
s
- * all ready to serve breakpoints and other kernel exceptions.  A value =
of
- * -1 indicates that we have tried to initialize early, and need to try
- * again later.
- */
-int kgdb_initialized;
+enum kgdb_initstate kgdb_state;
+
 /* Is a host GDB connected to us? */
 int kgdb_connected;
-EXPORT_SYMBOL(kgdb_connected);
+EXPORT_SYMBOL_GPL(kgdb_connected);
=20
 /* Could we be about to try and access a bad memory location?
  * If so we also need to flag this has happened. */
@@ -91,8 +86,6 @@ int kgdb_from_module_registered;
 /* Guard for recursive entry */
 static int exception_level;
=20
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Common architecture KGDB stub");
 #ifdef CONFIG_KGDB_ATTACH_WAIT
 static int attachwait =3D 1;
 #else
@@ -101,35 +94,32 @@ static int attachwait;
 module_param(attachwait, int, 0644);
 MODULE_PARM_DESC(attachwait, "Wait for remote debugger"
 		" after an exception");
-MODULE_LICENSE("GPL");
=20
 /* We provide a kgdb_io_ops structure that may be overriden. */
 struct kgdb_io __attribute__((weak)) kgdb_io_ops;
-EXPORT_SYMBOL(kgdb_io_ops);
+EXPORT_SYMBOL_GPL(kgdb_io_ops);
=20
-static struct kgdb_io kgdb_io_ops_prev[MAX_KGDB_IO_HANDLERS];
+static struct kgdb_io kgdb_io_ops_prev[KGDB_MAX_IO_HANDLERS];
 static int kgdb_io_handler_cnt;
=20
 /*
  * Holds information about breakpoints in a kernel. These breakpoints ar=
e
  * added and removed by gdb.
  */
-struct kgdb_bkpt kgdb_break[MAX_BREAKPOINTS];
+struct kgdb_bkpt kgdb_break[KGDB_MAX_BREAKPOINTS];
=20
 struct kgdb_arch *kgdb_ops =3D &arch_kgdb_ops;
=20
 static const char hexchars[] =3D "0123456789abcdef";
=20
-static spinlock_t slavecpulocks[NR_CPUS];
-static atomic_t procindebug[NR_CPUS];
+static spinlock_t slave_cpu_locks[NR_CPUS];
+static atomic_t cpu_in_debugger[NR_CPUS];
 atomic_t kgdb_setting_breakpoint;
-EXPORT_SYMBOL(kgdb_setting_breakpoint);
 struct task_struct *kgdb_usethread, *kgdb_contthread;
=20
 int debugger_step;
 static atomic_t kgdb_sync =3D ATOMIC_INIT(-1);
 atomic_t debugger_active;
-EXPORT_SYMBOL(debugger_active);
=20
 /* Our I/O buffers. */
 static char remcom_in_buffer[BUFMAX];
@@ -152,7 +142,7 @@ struct kgdb_state {
 	int ex_vector;
 	int signo;
 	int err_code;
-	int processor;
+	int cpu;
 	int pass_exception;
 	long threadid;
 	long kgdb_usethreadid;
@@ -658,44 +648,43 @@ static struct task_struct *getthread(str
 static void kgdb_wait(struct pt_regs *regs)
 {
 	unsigned long flags;
-	int processor;
+	int cpu;
=20
 	local_irq_save(flags);
-	processor =3D raw_smp_processor_id();
-	kgdb_info[processor].debuggerinfo =3D regs;
-	kgdb_info[processor].task =3D current;
-	atomic_set(&procindebug[processor], 1);
+	cpu =3D raw_smp_processor_id();
+	kgdb_info[cpu].debuggerinfo =3D regs;
+	kgdb_info[cpu].task =3D current;
+	atomic_set(&cpu_in_debugger[cpu], 1);
=20
-	/* The master processor must be active to enter here, but this is
-	 * gaurd in case the master processor had not been selected if
+	/* The master CPU must be active to enter here, but this is
+	 * gaurd in case the master CPU had not been selected if
 	 * this was an entry via nmi.
 	 */
 	while (!atomic_read(&debugger_active))
 		cpu_relax();
=20
-	/* Wait till master processor goes completely into the debugger.
-	 */
-	while (!atomic_read(&procindebug[atomic_read(&debugger_active) - 1])) {=

+	/* Wait till master CPU goes completely into the debugger. */
+	while (!atomic_read(&cpu_in_debugger[atomic_read(&debugger_active) - 1]=
)) {
 		int i =3D 10;	/* an arbitrary number */
=20
 		while (--i)
 			cpu_relax();
 	}
=20
-	/* Wait till master processor is done with debugging */
-	spin_lock(&slavecpulocks[processor]);
+	/* Wait till master CPU is done with debugging */
+	spin_lock(&slave_cpu_locks[cpu]);
=20
-	kgdb_info[processor].debuggerinfo =3D NULL;
-	kgdb_info[processor].task =3D NULL;
+	kgdb_info[cpu].debuggerinfo =3D NULL;
+	kgdb_info[cpu].task =3D NULL;
=20
 	/* fix up hardware debug registers on local cpu */
 	if (kgdb_ops->correct_hw_break)
 		kgdb_ops->correct_hw_break();
-	/* Signal the master processor that we are done */
-	atomic_set(&procindebug[processor], 0);
-	spin_unlock(&slavecpulocks[processor]);
+	/* Signal the master CPU that we are done */
+	atomic_set(&cpu_in_debugger[cpu], 0);
+	spin_unlock(&slave_cpu_locks[cpu]);
 	clocksource_touch_watchdog();
-	kgdb_softlock_skip[processor] =3D 1;
+	kgdb_softlock_skip[cpu] =3D 1;
 	local_irq_restore(flags);
 }
 #endif
@@ -742,8 +731,8 @@ int kgdb_activate_sw_breakpoints(void)
 	int i;
 	int error =3D 0;
 	unsigned long addr;
-	for (i =3D 0; i < MAX_BREAKPOINTS; i++) {
-		if (kgdb_break[i].state !=3D bp_set)
+	for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state !=3D BP_SET)
 			continue;
 		addr =3D kgdb_break[i].bpt_addr;
 		error =3D kgdb_arch_set_breakpoint(addr,
@@ -760,7 +749,7 @@ int kgdb_activate_sw_breakpoints(void)
 						BREAK_INSTR_SIZE);
 		}
=20
-		kgdb_break[i].state =3D bp_active;
+		kgdb_break[i].state =3D BP_ACTIVE;
 	}
 	return 0;
 }
@@ -772,13 +761,13 @@ static int kgdb_set_sw_break(unsigned lo
 	int error =3D kgdb_validate_break_address(addr);
 	if (error < 0)
 		return error;
-	for (i =3D 0; i < MAX_BREAKPOINTS; i++) {
-		if ((kgdb_break[i].state =3D=3D bp_set) &&
+	for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if ((kgdb_break[i].state =3D=3D BP_SET) &&
 			(kgdb_break[i].bpt_addr =3D=3D addr))
 			return -EEXIST;
 	}
-	for (i =3D 0; i < MAX_BREAKPOINTS; i++) {
-		if (kgdb_break[i].state =3D=3D bp_removed &&
+	for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state =3D=3D BP_REMOVED &&
 				kgdb_break[i].bpt_addr =3D=3D addr) {
 			breakno =3D i;
 			break;
@@ -786,8 +775,8 @@ static int kgdb_set_sw_break(unsigned lo
 	}
=20
 	if (breakno =3D=3D -1) {
-		for (i =3D 0; i < MAX_BREAKPOINTS; i++) {
-			if (kgdb_break[i].state =3D=3D bp_none) {
+		for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+			if (kgdb_break[i].state =3D=3D BP_UNDEFINED) {
 				breakno =3D i;
 				break;
 			}
@@ -796,8 +785,8 @@ static int kgdb_set_sw_break(unsigned lo
 	if (breakno =3D=3D -1)
 		return -E2BIG;
=20
-	kgdb_break[breakno].state =3D bp_set;
-	kgdb_break[breakno].type =3D bp_breakpoint;
+	kgdb_break[breakno].state =3D BP_SET;
+	kgdb_break[breakno].type =3D BP_BREAKPOINT;
 	kgdb_break[breakno].bpt_addr =3D addr;
=20
 	return 0;
@@ -808,8 +797,8 @@ int kgdb_deactivate_sw_breakpoints(void)
 	int i;
 	int error =3D 0;
 	unsigned long addr;
-	for (i =3D 0; i < MAX_BREAKPOINTS; i++) {
-		if (kgdb_break[i].state !=3D bp_active)
+	for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state !=3D BP_ACTIVE)
 			continue;
 		addr =3D kgdb_break[i].bpt_addr;
 		error =3D kgdb_arch_remove_breakpoint(addr,
@@ -824,7 +813,7 @@ int kgdb_deactivate_sw_breakpoints(void)
 		else if (CACHE_FLUSH_IS_SAFE)
 			flush_icache_range(addr,
 					addr + BREAK_INSTR_SIZE);
-		kgdb_break[i].state =3D bp_set;
+		kgdb_break[i].state =3D BP_SET;
 	}
 	return 0;
 }
@@ -833,10 +822,10 @@ static int kgdb_remove_sw_break(unsigned
 {
 	int i;
=20
-	for (i =3D 0; i < MAX_BREAKPOINTS; i++) {
-		if ((kgdb_break[i].state =3D=3D bp_set) &&
+	for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if ((kgdb_break[i].state =3D=3D BP_SET) &&
 			(kgdb_break[i].bpt_addr =3D=3D addr)) {
-			kgdb_break[i].state =3D bp_removed;
+			kgdb_break[i].state =3D BP_REMOVED;
 			return 0;
 		}
 	}
@@ -846,8 +835,8 @@ static int kgdb_remove_sw_break(unsigned
 int kgdb_isremovedbreak(unsigned long addr)
 {
 	int i;
-	for (i =3D 0; i < MAX_BREAKPOINTS; i++) {
-		if ((kgdb_break[i].state =3D=3D bp_removed) &&
+	for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if ((kgdb_break[i].state =3D=3D BP_REMOVED) &&
 			(kgdb_break[i].bpt_addr =3D=3D addr))
 			return 1;
 	}
@@ -861,15 +850,15 @@ int remove_all_break(void)
 	unsigned long addr;
=20
 	/* Clear memory breakpoints. */
-	for (i =3D 0; i < MAX_BREAKPOINTS; i++) {
-		if (kgdb_break[i].state !=3D bp_set)
+	for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state !=3D BP_SET)
 			continue;
 		addr =3D kgdb_break[i].bpt_addr;
 		error =3D kgdb_arch_remove_breakpoint(addr,
 				kgdb_break[i].saved_instr);
 		if (error)
 			return error;
-		kgdb_break[i].state =3D bp_removed;
+		kgdb_break[i].state =3D BP_REMOVED;
 	}
=20
 	/* Clear hardware breakpoints. */
@@ -977,9 +966,9 @@ static void gdb_cmd_getregs(struct kgdb_
=20
 	thread =3D kgdb_usethread;
 	if (!thread) {
-		thread =3D kgdb_info[ks->processor].task;
+		thread =3D kgdb_info[ks->cpu].task;
 		local_debuggerinfo =3D
-			kgdb_info[ks->processor].debuggerinfo;
+			kgdb_info[ks->cpu].debuggerinfo;
 	} else {
 		local_debuggerinfo =3D NULL;
 		for (i =3D 0; i < NR_CPUS; i++) {
@@ -1008,9 +997,9 @@ static void gdb_cmd_getregs(struct kgdb_
 						 -EINVAL);
 			return;
 		}
-		regs_to_gdb_regs(gdb_regs, shadowregs);
+		pt_regs_to_gdb_regs(gdb_regs, shadowregs);
 	} else if (local_debuggerinfo)
-		regs_to_gdb_regs(gdb_regs, local_debuggerinfo);
+		pt_regs_to_gdb_regs(gdb_regs, local_debuggerinfo);
 	else {
 		/* Pull stuff saved during
 		 * switch_to; nothing else is
@@ -1031,7 +1020,7 @@ static void gdb_cmd_setregs(struct kgdb_
 	if (kgdb_usethread && kgdb_usethread !=3D current)
 		error_packet(remcom_out_buffer, -EINVAL);
 	else {
-		gdb_regs_to_regs(gdb_regs, ks->linux_regs);
+		gdb_regs_to_pt_regs(gdb_regs, ks->linux_regs);
 		strcpy(remcom_out_buffer, "OK");
 	}
 }
@@ -1387,8 +1376,8 @@ static int gdb_serial_stub(struct kgdb_s
 		put_packet(remcom_out_buffer);
 	}
=20
-	kgdb_usethread =3D kgdb_info[ks->processor].task;
-	ks->kgdb_usethreadid =3D shadow_pid(kgdb_info[ks->processor].task->pid)=
;
+	kgdb_usethread =3D kgdb_info[ks->cpu].task;
+	ks->kgdb_usethreadid =3D shadow_pid(kgdb_info[ks->cpu].task->pid);
 	ks->pass_exception =3D 0;
=20
 	while (kgdb_io_ops.read_char) {
@@ -1541,12 +1530,12 @@ int kgdb_handle_exception(int evector, i
 {
 	unsigned long flags;
 	unsigned i;
-	unsigned procid;
+	int cpu;
 	int error =3D 0;
 	struct kgdb_state kgdb_var;
 	struct kgdb_state *ks =3D &kgdb_var;
=20
-	ks->processor =3D raw_smp_processor_id();
+	ks->cpu =3D raw_smp_processor_id();
 	ks->all_cpus_synced =3D 0;
 	ks->ex_vector =3D evector;
 	ks->signo =3D signo;
@@ -1566,7 +1555,7 @@ int kgdb_handle_exception(int evector, i
 	 */
 	local_irq_save(flags);
=20
-	procid =3D raw_smp_processor_id();
+	cpu =3D raw_smp_processor_id();
=20
 	/* Being the process of declaring a master debug processor, the
 	 * goal is to have only one single processor set debugger_active
@@ -1577,7 +1566,7 @@ int kgdb_handle_exception(int evector, i
 		int i =3D 25;	/* an arbitrary number */
 		if (atomic_read(&kgdb_sync) < 0 &&
 			atomic_inc_and_test(&kgdb_sync)) {
-			atomic_set(&debugger_active, procid + 1);
+			atomic_set(&debugger_active, cpu + 1);
 			break;
 		}
=20
@@ -1585,7 +1574,7 @@ int kgdb_handle_exception(int evector, i
 			cpu_relax();
=20
 		if (atomic_read(&cpu_doing_single_step) !=3D -1 &&
-				atomic_read(&cpu_doing_single_step) !=3D procid)
+				atomic_read(&cpu_doing_single_step) !=3D cpu)
 			udelay(1);
 	}
=20
@@ -1595,11 +1584,11 @@ int kgdb_handle_exception(int evector, i
 	 * debugger on a different CPU via a single step
 	 */
 	if (atomic_read(&cpu_doing_single_step) !=3D -1 &&
-	    atomic_read(&cpu_doing_single_step) !=3D procid) {
+	    atomic_read(&cpu_doing_single_step) !=3D cpu) {
 		atomic_set(&debugger_active, 0);
 		atomic_set(&kgdb_sync, -1);
 		clocksource_touch_watchdog();
-		kgdb_softlock_skip[procid] =3D 1;
+		kgdb_softlock_skip[cpu] =3D 1;
 		local_irq_restore(flags);
 		goto acquirelock;
 	}
@@ -1619,17 +1608,17 @@ int kgdb_handle_exception(int evector, i
 	if (kgdb_io_ops.pre_exception)
 		kgdb_io_ops.pre_exception();
=20
-	kgdb_info[ks->processor].debuggerinfo =3D ks->linux_regs;
-	kgdb_info[ks->processor].task =3D current;
+	kgdb_info[ks->cpu].debuggerinfo =3D ks->linux_regs;
+	kgdb_info[ks->cpu].task =3D current;
=20
 	kgdb_disable_hw_debug(ks->linux_regs);
=20
 	/* Get the slave CPU lock which will hold all the non-master
-	 * processors in a spin state while the debugger is active
+	 * CPU in a spin state while the debugger is active
 	 */
 	if (!debugger_step || !kgdb_contthread)
 		for (i =3D 0; i < NR_CPUS; i++)
-			spin_lock(&slavecpulocks[i]);
+			spin_lock(&slave_cpu_locks[i]);
=20
 #ifdef CONFIG_SMP
 	/* Signal the other CPUs to enter kgdb_wait() */
@@ -1639,16 +1628,16 @@ int kgdb_handle_exception(int evector, i
=20
 	/* spin_lock code is good enough as a barrier so we don't
 	 * need one here */
-	atomic_set(&procindebug[ks->processor], 1);
+	atomic_set(&cpu_in_debugger[ks->cpu], 1);
=20
 	/* Wait a reasonable time for the other CPUs to be notified and
 	 * be waiting for us.  Very early on this could be imperfect
 	 * as num_online_cpus() could be 0.*/
 	for (i =3D 0; i < ROUNDUP_WAIT; i++) {
-		int cpu;
+		int n;
 		int num =3D 0;
-		for (cpu =3D 0; cpu < NR_CPUS; cpu++) {
-			if (atomic_read(&procindebug[cpu]))
+		for (n =3D 0; n < NR_CPUS; n++) {
+			if (atomic_read(&cpu_in_debugger[n]))
 				num++;
 		}
 		if (num >=3D num_online_cpus()) {
@@ -1671,17 +1660,17 @@ int kgdb_handle_exception(int evector, i
 	if (kgdb_io_ops.post_exception)
 		kgdb_io_ops.post_exception();
=20
-	kgdb_info[ks->processor].debuggerinfo =3D NULL;
-	kgdb_info[ks->processor].task =3D NULL;
-	atomic_set(&procindebug[ks->processor], 0);
+	kgdb_info[ks->cpu].debuggerinfo =3D NULL;
+	kgdb_info[ks->cpu].task =3D NULL;
+	atomic_set(&cpu_in_debugger[ks->cpu], 0);
=20
 	if (!debugger_step || !kgdb_contthread) {
 		for (i =3D 0; i < NR_CPUS; i++)
-			spin_unlock(&slavecpulocks[i]);
-		/* Wait till all the processors have quit
+			spin_unlock(&slave_cpu_locks[i]);
+		/* Wait till all the CPUs have quit
 		 * from the debugger. */
 		for (i =3D 0; i < NR_CPUS; i++) {
-			while (atomic_read(&procindebug[i])) {
+			while (atomic_read(&cpu_in_debugger[i])) {
 				int j =3D 10;	/* an arbitrary number */
=20
 				while (--j)
@@ -1693,13 +1682,12 @@ int kgdb_handle_exception(int evector, i
 #ifdef CONFIG_SMP
 	/* This delay has a real purpose.  The problem is that if you
 	 * are single-stepping, you are sending an NMI to all the
-	 * other processors to stop them.  Interrupts come in, but
-	 * don't get handled.  Then you let them go just long enough
-	 * to get into their interrupt routines and use up some stack.
-	 * You stop them again, and then do the same thing.  After a
-	 * while you blow the stack on the other processors.  This
-	 * delay gives some time for interrupts to be cleared out on
-	 * the other processors.
+	 * other CPUs to stop them.  Interrupts come in, but don't get
+	 * handled.  Then you let them go just long enough to get into
+	 * their interrupt routines and use up some stack. You stop them
+	 * again, and then do the same thing.  After a while you blow
+	 * the stack on the other CPUs. This delay gives some time for
+	 * interrupts to be cleared out on the other CPUs.
 	 */
 	if (debugger_step)
 		mdelay(2);
@@ -1709,7 +1697,7 @@ int kgdb_handle_exception(int evector, i
 	atomic_set(&debugger_active, 0);
 	atomic_set(&kgdb_sync, -1);
 	clocksource_touch_watchdog();
-	kgdb_softlock_skip[ks->processor] =3D 1;
+	kgdb_softlock_skip[ks->cpu] =3D 1;
 	local_irq_restore(flags);
=20
 	return error;
@@ -1733,7 +1721,7 @@ static struct notifier_block kgdb_module
 int kgdb_nmihook(int cpu, void *regs)
 {
 #ifdef CONFIG_SMP
-	if (!atomic_read(&procindebug[cpu]) &&
+	if (!atomic_read(&cpu_in_debugger[cpu]) &&
 		atomic_read(&debugger_active) !=3D (cpu + 1)) {
 		kgdb_wait((struct pt_regs *)regs);
 		return 0;
@@ -1796,10 +1784,10 @@ static void __init kgdb_internal_init(vo
=20
 	/* Initialize our spinlocks. */
 	for (i =3D 0; i < NR_CPUS; i++)
-		spin_lock_init(&slavecpulocks[i]);
+		spin_lock_init(&slave_cpu_locks[i]);
=20
-	for (i =3D 0; i < MAX_BREAKPOINTS; i++)
-		kgdb_break[i].state =3D bp_none;
+	for (i =3D 0; i < KGDB_MAX_BREAKPOINTS; i++)
+		kgdb_break[i].state =3D BP_UNDEFINED;
=20
 	/* Initialize the I/O handles */
 	memset(&kgdb_io_ops_prev, 0, sizeof(kgdb_io_ops_prev));
@@ -1811,7 +1799,7 @@ static void __init kgdb_internal_init(vo
 	register_console(&kgdbcons);
 #endif
=20
-	kgdb_initialized =3D 1;
+	kgdb_state =3D KGDB_FULLY_INITIALIZED;
 }
=20
 static void kgdb_register_for_panic(void)
@@ -1852,7 +1840,7 @@ int kgdb_register_io_module(struct kgdb_
 	}
=20
 	/* Save the old values so they can be restored */
-	if (kgdb_io_handler_cnt >=3D MAX_KGDB_IO_HANDLERS) {
+	if (kgdb_io_handler_cnt >=3D KGDB_MAX_IO_HANDLERS) {
 		printk(KERN_ERR "kgdb: No more I/O handles available.\n");
 		return -EINVAL;
 	}
@@ -1876,7 +1864,7 @@ int kgdb_register_io_module(struct kgdb_
=20
 	return 0;
 }
-EXPORT_SYMBOL(kgdb_register_io_module);
+EXPORT_SYMBOL_GPL(kgdb_register_io_module);
=20
 void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops)
 {
@@ -1935,23 +1923,7 @@ void kgdb_unregister_io_module(struct kg
 		memset(&kgdb_io_ops, 0, sizeof(struct kgdb_io));
 	}
 }
-EXPORT_SYMBOL(kgdb_unregister_io_module);
-
-/*
- * There are times we need to call a tasklet to cause a breakpoint
- * as calling breakpoint() at that point might be fatal.  We have to
- * check that the exception stack is setup, as tasklets may be scheduled=

- * prior to this.  When that happens, it is up to the architecture to
- * schedule this when it is safe to run.
- */
-static void kgdb_tasklet_bpt(unsigned long ing)
-{
-	if (CHECK_EXCEPTION_STACK())
-		breakpoint();
-}
-EXPORT_SYMBOL(kgdb_tasklet_breakpoint);
-
-DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);
+EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
=20
 /*
  * This function can be called very early, either via early_param() or
@@ -1969,7 +1941,7 @@ static void __init kgdb_early_entry(void
 	 */
=20
 	if (!CHECK_EXCEPTION_STACK()) {
-		kgdb_initialized =3D -1;
+		kgdb_state =3D KGDB_SEMI_INITIALIZED;
 		/* any kind of break point is deferred to late_init */
 		return;
 	}
@@ -1978,7 +1950,7 @@ static void __init kgdb_early_entry(void
 	/* For early entry kgdb_io_ops.init must be defined */
 	if (!kgdb_io_ops.init || kgdb_io_ops.init()) {
 		/* Try again later. */
-		kgdb_initialized =3D -1;
+		kgdb_state =3D KGDB_SEMI_INITIALIZED;
 		return;
 	}
=20
@@ -2002,20 +1974,16 @@ static void __init kgdb_early_entry(void
  */
 static int __init kgdb_late_entry(void)
 {
-	int need_break =3D 0;
-
-	/* If kgdb_initialized is -1 then we were passed kgdbwait. */
-	if (kgdb_initialized =3D=3D -1)
-		need_break =3D 1;
+	int need_break =3D (kgdb_state =3D=3D KGDB_SEMI_INITIALIZED);
=20
 	/*
 	 * If we haven't tried to initialize KGDB yet, we need to call
 	 * kgdb_arch_init before moving onto the I/O.
 	 */
-	if (!kgdb_initialized)
+	if (kgdb_state =3D=3D KGDB_UNINITIALIZED)
 		kgdb_arch_init();
=20
-	if (kgdb_initialized !=3D 1) {
+	if (kgdb_state !=3D KGDB_FULLY_INITIALIZED) {
 		if (kgdb_io_ops.init && kgdb_io_ops.init()) {
 			/* When KGDB allows I/O via modules and the core
 			 * I/O init fails KGDB must default to defering the
@@ -2072,7 +2040,7 @@ void breakpoint(void)
 	wmb(); /* Sync point after breakpoint */
 	atomic_set(&kgdb_setting_breakpoint, 0);
 }
-EXPORT_SYMBOL(breakpoint);
+EXPORT_SYMBOL_GPL(breakpoint);
=20
 #ifdef CONFIG_MAGIC_SYSRQ
 static void sysrq_handle_gdb(int key, struct tty_struct *tty)
@@ -2128,12 +2096,12 @@ static int __init opt_kgdb_attachwait(ch
 static int __init opt_kgdb_enter(char *str)
 {
 	/* We've already done this by an explicit breakpoint() call. */
-	if (kgdb_initialized)
+	if (kgdb_state !=3D KGDB_UNINITIALIZED)
 		return 0;
=20
 	kgdb_early_entry();
 	attachwait =3D 1;
-	if (kgdb_initialized =3D=3D 1)
+	if (kgdb_state =3D=3D KGDB_FULLY_INITIALIZED)
 		printk(KERN_CRIT "Waiting for connection from remote "
 		       "gdb...\n");
 	else {
Index: b/arch/x86/kernel/kgdb.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -57,7 +57,7 @@ static int gdb_x86errcode;
    number through the usual means, and that's not very specific).  */
 static int gdb_x86vector =3D -1;
=20
-void regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 {
 	gdb_regs[_AX] =3D regs->ax;
 	gdb_regs[_BX] =3D regs->bx;
@@ -122,7 +122,7 @@ void sleeping_thread_to_gdb_regs(unsigne
 	gdb_regs[_SP] =3D p->thread.sp;
 }
=20
-void gdb_regs_to_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 {
 	regs->ax =3D gdb_regs[_AX];
 	regs->bx =3D gdb_regs[_BX];
@@ -241,14 +241,14 @@ static int kgdb_set_hw_break(unsigned lo
 		return -1;
=20
 	switch (bptype) {
-	case bp_hardware_breakpoint:
+	case BP_HARDWARE_BREAKPOINT:
 		type =3D 0;
 		len  =3D 1;
 		break;
-	case bp_write_watchpoint:
+	case BP_WRITE_WATCHPOINT:
 		type =3D 1;
 		break;
-	case bp_access_watchpoint:
+	case BP_ACCESS_WATCHPOINT:
 		type =3D 3;
 		break;
 	default:


--------------enigE66F0AE056AEDB9F4F48951E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHnNFKniDOoMHTA+kRArq3AJ9lmtSJB/6JQrrXpVK6EY2RiGIDRgCfRO6L
D1ECjALfrxdxO/HFpkq1mT8=
=e4TL
-----END PGP SIGNATURE-----

--------------enigE66F0AE056AEDB9F4F48951E--
