Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYKSVZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYKSVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYKSVXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:23:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35886 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYKSVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:23:35 -0500
Message-Id: <20081119212333.303525813@goodmis.org>
References: <20081119212204.318400312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Nov 2008 16:22:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/9] NOT FOR MAINLINE ftrace: pass module struct to arch dynamic ftrace functions
Content-Disposition: inline; filename=0002-NOT-FOR-MAINLINE-ftrace-pass-module-struct-to-arch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow archs more flexibility on dynamic ftrace implementations

Dynamic ftrace has largly been developed on x86. Since x86 does not
have the same limitations as other architectures, the ftrace interaction
between the generic code and the architecture specific code was not
flexible enough to handle some of the issues that other architectures
have.

Most notably, module trampolines. Due to the limited branch distance
that archs make in calling kernel core code from modules, the module
load code must create a trampoline to jump to what will make the
larger jump into core kernel code.

The problem arises when this happens to a call to mcount. Ftrace checks
all code before modifying it and makes sure the current code is what
it expects. Right now, there is not enough information to handle modifying
module trampolines.

This patch changes the API between generic dynamic ftrace code and
the arch dependent code. There is now two functions for modifying code:

  ftrace_make_nop(mod, rec, addr) - convert the code at rec->ip into
       a nop, where the original text is calling addr. (mod is the
       module struct if called by module init)

  ftrace_make_caller(rec, addr) - convert the code rec->ip that should
       be a nop into a caller to addr.

The record "rec" now has a new field called "arch" where the architecture
can add any special attributes to each call site record.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Conflicts:

	arch/x86/include/asm/ftrace.h
	arch/x86/kernel/ftrace.c
	include/linux/ftrace.h
	kernel/trace/ftrace.c

ftrace: allow NULL pointers in mcount_loc

Impact: let archs insert NULL pointers in mcount_loc section

Due to the way different architecture linkers combine the data sections
of the mcount_loc (the section that lists all the locations that
call mcount), there may be zeros added in that section. This is usually
due to strange alignments that the linker performs, that pads in zeros.

This patch makes the conversion code to nops skip any pointer in
the mcount_loc section that is NULL.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/include/asm/ftrace.h |    9 ++-
 arch/x86/kernel/ftrace.c      |  168 +++++++++++++++++++++++++++++++++++++++--
 include/linux/ftrace.h        |   51 ++++++++++---
 kernel/module.c               |    2 +-
 kernel/trace/ftrace.c         |  137 +++++++++++++++++-----------------
 5 files changed, 280 insertions(+), 87 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 9e8bc29..1d8d16f 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -17,8 +17,15 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 	 */
 	return addr - 1;
 }
-#endif
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+struct dyn_arch_ftrace {
+	/* No extra data needed for x86 */
+};
+
+#endif /*  CONFIG_DYNAMIC_FTRACE */
+#endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 50ea0ac..d79e45d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -37,12 +37,7 @@ static int ftrace_calc_offset(long ip, long addr)
 	return (int)(addr - ip);
 }
 
-unsigned char *ftrace_nop_replace(void)
-{
-	return ftrace_nop;
-}
-
-unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static union ftrace_code_union calc;
 
@@ -56,7 +51,143 @@ unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
-int
+/*
+ * Modifying code must take extra care. On an SMP machine, if
+ * the code being modified is also being executed on another CPU
+ * that CPU will have undefined results and possibly take a GPF.
+ * We use kstop_machine to stop other CPUS from exectuing code.
+ * But this does not stop NMIs from happening. We still need
+ * to protect against that. We separate out the modification of
+ * the code to take care of this.
+ *
+ * Two buffers are added: An IP buffer and a "code" buffer.
+ *
+ * 1) Put the instruction pointer into the IP buffer
+ *    and the new code into the "code" buffer.
+ * 2) Set a flag that says we are modifying code
+ * 3) Wait for any running NMIs to finish.
+ * 4) Write the code
+ * 5) clear the flag.
+ * 6) Wait for any running NMIs to finish.
+ *
+ * If an NMI is executed, the first thing it does is to call
+ * "ftrace_nmi_enter". This will check if the flag is set to write
+ * and if it is, it will write what is in the IP and "code" buffers.
+ *
+ * The trick is, it does not matter if everyone is writing the same
+ * content to the code location. Also, if a CPU is executing code
+ * it is OK to write to that code location if the contents being written
+ * are the same as what exists.
+ */
+
+static atomic_t in_nmi = ATOMIC_INIT(0);
+static int mod_code_status;		/* holds return value of text write */
+static int mod_code_write;		/* set when NMI should do the write */
+static void *mod_code_ip;		/* holds the IP to write to */
+static void *mod_code_newcode;		/* holds the text to write to the IP */
+
+static unsigned nmi_wait_count;
+static atomic_t nmi_update_count = ATOMIC_INIT(0);
+
+int ftrace_arch_read_dyn_info(char *buf, int size)
+{
+	int r;
+
+	r = snprintf(buf, size, "%u %u",
+		     nmi_wait_count,
+		     atomic_read(&nmi_update_count));
+	return r;
+}
+
+static void ftrace_mod_code(void)
+{
+	/*
+	 * Yes, more than one CPU process can be writing to mod_code_status.
+	 *    (and the code itself)
+	 * But if one were to fail, then they all should, and if one were
+	 * to succeed, then they all should.
+	 */
+	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
+					     MCOUNT_INSN_SIZE);
+
+}
+
+void ftrace_nmi_enter(void)
+{
+	atomic_inc(&in_nmi);
+	/* Must have in_nmi seen before reading write flag */
+	smp_mb();
+	if (mod_code_write) {
+		ftrace_mod_code();
+		atomic_inc(&nmi_update_count);
+	}
+}
+
+void ftrace_nmi_exit(void)
+{
+	/* Finish all executions before clearing in_nmi */
+	smp_wmb();
+	atomic_dec(&in_nmi);
+}
+
+static void wait_for_nmi(void)
+{
+	int waited = 0;
+
+	while (atomic_read(&in_nmi)) {
+		waited = 1;
+		cpu_relax();
+	}
+
+	if (waited)
+		nmi_wait_count++;
+}
+
+static int
+do_ftrace_mod_code(unsigned long ip, void *new_code)
+{
+	mod_code_ip = (void *)ip;
+	mod_code_newcode = new_code;
+
+	/* The buffers need to be visible before we let NMIs write them */
+	smp_wmb();
+
+	mod_code_write = 1;
+
+	/* Make sure write bit is visible before we wait on NMIs */
+	smp_mb();
+
+	wait_for_nmi();
+
+	/* Make sure all running NMIs have finished before we write the code */
+	smp_mb();
+
+	ftrace_mod_code();
+
+	/* Make sure the write happens before clearing the bit */
+	smp_wmb();
+
+	mod_code_write = 0;
+
+	/* make sure NMIs see the cleared bit */
+	smp_mb();
+
+	wait_for_nmi();
+
+	return mod_code_status;
+}
+
+
+
+
+static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
+
+static unsigned char *ftrace_nop_replace(void)
+{
+	return ftrace_nop;
+}
+
+static int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
@@ -89,6 +220,29 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	return 0;
 }
 
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *new, *old;
+	unsigned long ip = rec->ip;
+
+	old = ftrace_call_replace(ip, addr);
+	new = ftrace_nop_replace();
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *new, *old;
+	unsigned long ip = rec->ip;
+
+	old = ftrace_nop_replace();
+	new = ftrace_call_replace(ip, addr);
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 703eb53..dc7b731 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -44,6 +44,8 @@ static inline void ftrace_kill(void) { }
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
+/* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
+#include <asm/ftrace.h>
 
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
@@ -59,6 +61,7 @@ struct dyn_ftrace {
 	struct list_head	list;
 	unsigned long		ip; /* address of mcount call-site */
 	unsigned long		flags;
+	struct dyn_arch_ftrace	arch;
 };
 
 int ftrace_force_update(void);
@@ -66,8 +69,6 @@ void ftrace_set_filter(unsigned char *buf, int len, int reset);
 
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
-extern unsigned char *ftrace_nop_replace(void);
-extern unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr);
 extern int ftrace_dyn_arch_init(void *data);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
@@ -75,10 +76,10 @@ extern void ftrace_call(void);
 extern void mcount_call(void);
 
 /**
- * ftrace_modify_code - modify code segment
- * @ip: the address of the code segment
- * @old_code: the contents of what is expected to be there
- * @new_code: the code to patch in
+ * ftrace_make_nop - convert code into top
+ * @mod: module structure if called by module load initialization
+ * @rec: the mcount call site record
+ * @addr: the address that the call site should be calling
  *
  * This is a very sensitive operation and great care needs
  * to be taken by the arch.  The operation should carefully
@@ -86,6 +87,31 @@ extern void mcount_call(void);
  * what we expect it to be, and then on success of the compare,
  * it should write to the location.
  *
+ * The code segment at @rec->ip should be a caller to @addr
+ *
+ * Return must be:
+ *  0 on success
+ *  -EFAULT on error reading the location
+ *  -EINVAL on a failed compare of the contents
+ *  -EPERM  on error writing to the location
+ * Any other value will be considered a failure.
+ */
+extern int ftrace_make_nop(struct module *mod,
+			   struct dyn_ftrace *rec, unsigned long addr);
+
+/**
+ * ftrace_make_call - convert a nop call site into a call to addr
+ * @rec: the mcount call site record
+ * @addr: the address that the call site should call
+ *
+ * This is a very sensitive operation and great care needs
+ * to be taken by the arch.  The operation should carefully
+ * read the location, check to see if what is read is indeed
+ * what we expect it to be, and then on success of the compare,
+ * it should write to the location.
+ *
+ * The code segment at @rec->ip should be a nop
+ *
  * Return must be:
  *  0 on success
  *  -EFAULT on error reading the location
@@ -93,8 +119,11 @@ extern void mcount_call(void);
  *  -EPERM  on error writing to the location
  * Any other value will be considered a failure.
  */
-extern int ftrace_modify_code(unsigned long ip, unsigned char *old_code,
-			      unsigned char *new_code);
+extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
+
+
+/* May be defined in arch */
+extern int ftrace_arch_read_dyn_info(char *buf, int size);
 
 extern int skip_trace(unsigned long ip);
 
@@ -221,11 +250,13 @@ static inline void ftrace_dump(void) { }
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
-extern void ftrace_init_module(unsigned long *start, unsigned long *end);
+extern void ftrace_init_module(struct module *mod,
+			       unsigned long *start, unsigned long *end);
 #else
 static inline void ftrace_init(void) { }
 static inline void
-ftrace_init_module(unsigned long *start, unsigned long *end) { }
+ftrace_init_module(struct module *mod,
+		   unsigned long *start, unsigned long *end) { }
 #endif
 
 
diff --git a/kernel/module.c b/kernel/module.c
index 1f4cc00..6979127 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2201,7 +2201,7 @@ static noinline struct module *load_module(void __user *umod,
 	/* sechdrs[0].sh_size is always zero */
 	mseg = section_objs(hdr, sechdrs, secstrings, "__mcount_loc",
 			    sizeof(*mseg), &num_mcount);
-	ftrace_init_module(mseg, mseg + num_mcount);
+	ftrace_init_module(mod, mseg, mseg + num_mcount);
 
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e602057..bdc05b0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -322,11 +322,47 @@ ftrace_record_ip(unsigned long ip)
 	return rec;
 }
 
+static void print_ip_ins(const char *fmt, unsigned char *p)
+{
+	int i;
+
+	printk(KERN_CONT "%s", fmt);
+
+	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
+		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+}
+
+static void ftrace_bug(int failed, unsigned long ip)
+{
+	switch (failed) {
+	case -EFAULT:
+		FTRACE_WARN_ON_ONCE(1);
+		pr_info("ftrace faulted on modifying ");
+		print_ip_sym(ip);
+		break;
+	case -EINVAL:
+		FTRACE_WARN_ON_ONCE(1);
+		pr_info("ftrace failed to modify ");
+		print_ip_sym(ip);
+		print_ip_ins(" actual: ", (unsigned char *)ip);
+		printk(KERN_CONT "\n");
+		break;
+	case -EPERM:
+		FTRACE_WARN_ON_ONCE(1);
+		pr_info("ftrace faulted on writing ");
+		print_ip_sym(ip);
+		break;
+	default:
+		FTRACE_WARN_ON_ONCE(1);
+		pr_info("ftrace faulted on unknown error ");
+		print_ip_sym(ip);
+	}
+}
+
 #define FTRACE_ADDR ((long)(ftrace_caller))
 
 static int
-__ftrace_replace_code(struct dyn_ftrace *rec,
-		      unsigned char *old, unsigned char *new, int enable)
+__ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
 	unsigned long ip, fl;
 
@@ -368,12 +404,10 @@ __ftrace_replace_code(struct dyn_ftrace *rec,
 		 * otherwise enable it!
 		 */
 		if (fl & FTRACE_FL_ENABLED) {
-			/* swap new and old */
-			new = old;
-			old = ftrace_call_replace(ip, FTRACE_ADDR);
+			enable = 0;
 			rec->flags &= ~FTRACE_FL_ENABLED;
 		} else {
-			new = ftrace_call_replace(ip, FTRACE_ADDR);
+			enable = 1;
 			rec->flags |= FTRACE_FL_ENABLED;
 		}
 	} else {
@@ -386,10 +420,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec,
 			fl = rec->flags & (FTRACE_FL_NOTRACE | FTRACE_FL_ENABLED);
 			if (fl == FTRACE_FL_NOTRACE)
 				return 0;
-
-			new = ftrace_call_replace(ip, FTRACE_ADDR);
-		} else
-			old = ftrace_call_replace(ip, FTRACE_ADDR);
+		}
 
 		if (enable) {
 			if (rec->flags & FTRACE_FL_ENABLED)
@@ -402,21 +433,18 @@ __ftrace_replace_code(struct dyn_ftrace *rec,
 		}
 	}
 
-	return ftrace_modify_code(ip, old, new);
+	if (enable)
+		return ftrace_make_call(rec, FTRACE_ADDR);
+	else
+		return ftrace_make_nop(NULL, rec, FTRACE_ADDR);
 }
 
 static void ftrace_replace_code(int enable)
 {
 	int i, failed;
-	unsigned char *new = NULL, *old = NULL;
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 
-	if (enable)
-		old = ftrace_nop_replace();
-	else
-		new = ftrace_nop_replace();
-
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
 		for (i = 0; i < pg->index; i++) {
 			rec = &pg->records[i];
@@ -433,68 +461,30 @@ static void ftrace_replace_code(int enable)
 				unfreeze_record(rec);
 			}
 
-			failed = __ftrace_replace_code(rec, old, new, enable);
+			failed = __ftrace_replace_code(rec, enable);
 			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
 				rec->flags |= FTRACE_FL_FAILED;
 				if ((system_state == SYSTEM_BOOTING) ||
 				    !core_kernel_text(rec->ip)) {
 					ftrace_free_rec(rec);
-				}
+				} else
+					ftrace_bug(failed, rec->ip);
 			}
 		}
 	}
 }
 
-static void print_ip_ins(const char *fmt, unsigned char *p)
-{
-	int i;
-
-	printk(KERN_CONT "%s", fmt);
-
-	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
-		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
-}
-
 static int
-ftrace_code_disable(struct dyn_ftrace *rec)
+ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
 {
 	unsigned long ip;
-	unsigned char *nop, *call;
 	int ret;
 
 	ip = rec->ip;
 
-	nop = ftrace_nop_replace();
-	call = ftrace_call_replace(ip, mcount_addr);
-
-	ret = ftrace_modify_code(ip, call, nop);
+	ret = ftrace_make_nop(mod, rec, mcount_addr);
 	if (ret) {
-		switch (ret) {
-		case -EFAULT:
-			FTRACE_WARN_ON_ONCE(1);
-			pr_info("ftrace faulted on modifying ");
-			print_ip_sym(ip);
-			break;
-		case -EINVAL:
-			FTRACE_WARN_ON_ONCE(1);
-			pr_info("ftrace failed to modify ");
-			print_ip_sym(ip);
-			print_ip_ins(" expected: ", call);
-			print_ip_ins(" actual: ", (unsigned char *)ip);
-			print_ip_ins(" replace: ", nop);
-			printk(KERN_CONT "\n");
-			break;
-		case -EPERM:
-			FTRACE_WARN_ON_ONCE(1);
-			pr_info("ftrace faulted on writing ");
-			print_ip_sym(ip);
-			break;
-		default:
-			FTRACE_WARN_ON_ONCE(1);
-			pr_info("ftrace faulted on unknown error ");
-			print_ip_sym(ip);
-		}
-
+		ftrace_bug(ret, ip);
 		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
 	}
@@ -613,7 +603,7 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
-static int ftrace_update_code(void)
+static int ftrace_update_code(struct module *mod)
 {
 	struct dyn_ftrace *p, *t;
 	cycle_t start, stop;
@@ -630,7 +620,7 @@ static int ftrace_update_code(void)
 		list_del_init(&p->list);
 
 		/* convert record (i.e, patch mcount-call with NOP) */
-		if (ftrace_code_disable(p)) {
+		if (ftrace_code_disable(mod, p)) {
 			p->flags |= FTRACE_FL_CONVERTED;
 			ftrace_update_cnt++;
 		} else
@@ -1273,7 +1263,8 @@ static __init int ftrace_init_debugfs(void)
 
 fs_initcall(ftrace_init_debugfs);
 
-static int ftrace_convert_nops(unsigned long *start,
+static int ftrace_convert_nops(struct module *mod,
+			       unsigned long *start,
 			       unsigned long *end)
 {
 	unsigned long *p;
@@ -1284,23 +1275,32 @@ static int ftrace_convert_nops(unsigned long *start,
 	p = start;
 	while (p < end) {
 		addr = ftrace_call_adjust(*p++);
+		/*
+		 * Some architecture linkers will pad between
+		 * the different mcount_loc sections of different
+		 * object files to satisfy alignments.
+		 * Skip any NULL pointers.
+		 */
+		if (!addr)
+			continue;
 		ftrace_record_ip(addr);
 	}
 
 	/* disable interrupts to prevent kstop machine */
 	local_irq_save(flags);
-	ftrace_update_code();
+	ftrace_update_code(mod);
 	local_irq_restore(flags);
 	mutex_unlock(&ftrace_start_lock);
 
 	return 0;
 }
 
-void ftrace_init_module(unsigned long *start, unsigned long *end)
+void ftrace_init_module(struct module *mod,
+			unsigned long *start, unsigned long *end)
 {
 	if (ftrace_disabled || start == end)
 		return;
-	ftrace_convert_nops(start, end);
+	ftrace_convert_nops(mod, start, end);
 }
 
 extern unsigned long __start_mcount_loc[];
@@ -1330,7 +1330,8 @@ void __init ftrace_init(void)
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
-	ret = ftrace_convert_nops(__start_mcount_loc,
+	ret = ftrace_convert_nops(NULL,
+				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
 	return;
-- 
1.5.6.5

-- 
