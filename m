Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYICSv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYICSv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYICSvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:51:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57089 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYICSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:51:18 -0400
Date: Wed, 3 Sep 2008 20:54:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make taint bit reliable v2
Message-ID: <20080903185426.GU18288@one.firstfloor.org>
References: <20080901164632.GA18159@basil.nowhere.org> <20080902174246.0587a04a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902174246.0587a04a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I did most of your suggested changes and a bit more.
No get_tainted() because sysctl needs it.

-Andi

---


Make taint bit reliable v2

It's somewhat unlikely that it happens, but right now a race window 
between interrupts or machine checks or oopses could corrupt the tainted 
bitmap because it is modified in a non atomic fashion.

Convert the taint variable to an unsigned long and use only atomic bit
operations on it.

Unfortunately this means the intvec sysctl functions cannot be used on 
it anymore.

It turned out the taint sysctl handler could actually be simplified
a bit (since it only increases capabilities) so this patch actually
removes code.

v2: Rename tainted variable and switch to bit numbers
    Fix broken smpboot tainted usage
    The smpboot code was always broken BTW (num_online_cpus() is always > 0)
    Rewrite output code to be table driven

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kernel.h |    2 -
 kernel/panic.c         |    5 ++-
 kernel/sysctl.c        |   66 ++++++++++++++++++++-----------------------------
 3 files changed, 32 insertions(+), 41 deletions(-)

Index: linux/kernel/panic.c
===================================================================
--- linux.orig/kernel/panic.c
+++ linux/kernel/panic.c
@@ -21,9 +21,10 @@
 #include <linux/debug_locks.h>
 #include <linux/random.h>
 #include <linux/kallsyms.h>
+#include <linux/log2.h>
 
 int panic_on_oops;
-int tainted;
+unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -170,23 +171,41 @@ EXPORT_SYMBOL(panic);
  *	The string is overwritten by the next call to print_taint().
  */
 
+struct tnt {
+	u8 bit;
+	char true;
+	char false;
+};
+
+static const struct tnt tnts[] = {
+	{ TAINT_PROPRIETARY_MODULE, 'P', 'G' },
+	{ TAINT_FORCED_MODULE, 'F', ' ' },
+	{ TAINT_UNSAFE_SMP, 'S', ' ' },
+	{ TAINT_FORCED_RMMOD, 'R', ' ' },
+	{ TAINT_MACHINE_CHECK, 'M', ' ' },
+	{ TAINT_BAD_PAGE, 'B', ' ' },
+	{ TAINT_USER, 'U', ' ' },
+	{ TAINT_DIE, 'D', ' ' },
+	{ TAINT_OVERRIDDEN_ACPI_TABLE, 'A', ' ' },
+	{ TAINT_WARN, 'W', ' ' },
+};
+
 const char *print_tainted(void)
 {
-	static char buf[20];
-	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
-			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
-			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
-			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
-			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
-			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
-			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
-			tainted & TAINT_USER ? 'U' : ' ',
-			tainted & TAINT_DIE ? 'D' : ' ',
-			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
-			tainted & TAINT_WARN ? 'W' : ' ');
-	}
-	else
+	static char buf[ARRAY_SIZE(tnts) + sizeof("Tainted: ") + 1];
+
+	if (tainted_mask) {
+		char *s;
+		int i;
+
+		s = buf + sprintf(buf, "Tainted: ");
+		for (i = 0; i < ARRAY_SIZE(tnts); i++) {
+			const struct tnt *t = &tnts[i];
+			*s++ = test_bit(t->bit, &tainted_mask) ?
+					t->true : t->false;
+		}
+		*s = 0;
+	} else
 		snprintf(buf, sizeof(buf), "Not tainted");
 	return(buf);
 }
@@ -194,7 +213,7 @@ const char *print_tainted(void)
 void add_taint(unsigned flag)
 {
 	debug_locks = 0; /* can't trust the integrity of the kernel anymore */
-	tainted |= flag;
+	set_bit(flag, &tainted_mask);
 }
 EXPORT_SYMBOL(add_taint);
 
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -152,7 +152,7 @@ extern int max_lock_depth;
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
+static int proc_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
@@ -381,10 +381,10 @@ static struct ctl_table kern_table[] = {
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
-		.data		= &tainted,
-		.maxlen		= sizeof(int),
+		.data		= &tainted_mask,
+		.maxlen 	= sizeof(long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_taint,
+		.proc_handler	= &proc_taint,
 	},
 #endif
 #ifdef CONFIG_LATENCYTOP
@@ -2236,49 +2236,39 @@ int proc_dointvec(struct ctl_table *tabl
 		    	    NULL,NULL);
 }
 
-#define OP_SET	0
-#define OP_AND	1
-#define OP_OR	2
-
-static int do_proc_dointvec_bset_conv(int *negp, unsigned long *lvalp,
-				      int *valp,
-				      int write, void *data)
-{
-	int op = *(int *)data;
-	if (write) {
-		int val = *negp ? -*lvalp : *lvalp;
-		switch(op) {
-		case OP_SET:	*valp = val; break;
-		case OP_AND:	*valp &= val; break;
-		case OP_OR:	*valp |= val; break;
-		}
-	} else {
-		int val = *valp;
-		if (val < 0) {
-			*negp = -1;
-			*lvalp = (unsigned long)-val;
-		} else {
-			*negp = 0;
-			*lvalp = (unsigned long)val;
-		}
-	}
-	return 0;
-}
-
 /*
- *	Taint values can only be increased
+ * Taint values can only be increased
+ * This means we can safely use a temporary.
  */
-static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
+static int proc_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int op;
+	struct ctl_table t;
+	unsigned long tmptaint = tainted_mask;
+	int err;
 
 	if (write && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	op = OP_OR;
-	return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
-				do_proc_dointvec_bset_conv,&op);
+	t = *table;
+	t.data = &tmptaint;
+	err = proc_doulongvec_minmax(&t, write, filp, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	if (write) {
+		/*
+		 * Poor man's atomic or. Not worth adding a primitive
+		 * to everyone's atomic.h for this
+		 */
+		int i;
+		for (i = 0; i < BITS_PER_LONG && tmptaint >> i; i++) {
+			if ((tmptaint >> i) & 1)
+				set_bit(i, &tainted_mask);
+		}
+	}
+
+	return err;
 }
 
 struct do_proc_dointvec_minmax_conv_param {
Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -235,7 +235,7 @@ extern int oops_in_progress;		/* If set,
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
-extern int tainted;
+extern unsigned long tainted_mask;	/* warning TAINT_* has changed to bit numbers */
 extern const char *print_tainted(void);
 extern void add_taint(unsigned);
 extern int root_mountflags;
@@ -251,16 +251,16 @@ extern enum system_states {
 	SYSTEM_PANIC,
 } system_state;
 
-#define TAINT_PROPRIETARY_MODULE	(1<<0)
-#define TAINT_FORCED_MODULE		(1<<1)
-#define TAINT_UNSAFE_SMP		(1<<2)
-#define TAINT_FORCED_RMMOD		(1<<3)
-#define TAINT_MACHINE_CHECK		(1<<4)
-#define TAINT_BAD_PAGE			(1<<5)
-#define TAINT_USER			(1<<6)
-#define TAINT_DIE			(1<<7)
-#define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
-#define TAINT_WARN			(1<<9)
+#define TAINT_PROPRIETARY_MODULE	0
+#define TAINT_FORCED_MODULE		1
+#define TAINT_UNSAFE_SMP		2
+#define TAINT_FORCED_RMMOD		3
+#define TAINT_MACHINE_CHECK		4
+#define TAINT_BAD_PAGE			5
+#define TAINT_USER			6
+#define TAINT_DIE			7
+#define TAINT_OVERRIDDEN_ACPI_TABLE	8
+#define TAINT_WARN			9
 
 extern void dump_stack(void) __cold;
 
Index: linux/arch/x86/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot.c
+++ linux/arch/x86/kernel/smpboot.c
@@ -279,6 +279,8 @@ static void __cpuinit smp_callin(void)
 	cpu_set(cpuid, cpu_callin_map);
 }
 
+static int __cpuinitdata unsafe_smp;
+
 /*
  * Activate a secondary processor.
  */
@@ -391,7 +393,7 @@ static void __cpuinit smp_apply_quirks(s
 				goto valid_k7;
 
 		/* If we get here, not a certified SMP capable AMD system. */
-		add_taint(TAINT_UNSAFE_SMP);
+		unsafe_smp = 1;
 	}
 
 valid_k7:
@@ -408,12 +410,10 @@ static void __cpuinit smp_checks(void)
 	 * Don't taint if we are running SMP kernel on a single non-MP
 	 * approved Athlon
 	 */
-	if (tainted & TAINT_UNSAFE_SMP) {
-		if (num_online_cpus())
-			printk(KERN_INFO "WARNING: This combination of AMD"
-				"processors is not suitable for SMP.\n");
-		else
-			tainted &= ~TAINT_UNSAFE_SMP;
+	if (unsafe_smp && num_online_cpus() > 1) {
+		printk(KERN_INFO "WARNING: This combination of AMD"
+			"processors is not suitable for SMP.\n");
+		add_taint(TAINT_UNSAFE_SMP);
 	}
 }
 
Index: linux/kernel/module.c
===================================================================
--- linux.orig/kernel/module.c
+++ linux/kernel/module.c
@@ -100,7 +100,7 @@ static inline int strong_try_module_get(
 static inline void add_taint_module(struct module *mod, unsigned flag)
 {
 	add_taint(flag);
-	mod->taints |= flag;
+	mod->taints |= (1U << flag);
 }
 
 /*
@@ -923,7 +923,7 @@ static const char vermagic[] = VERMAGIC_
 static int try_to_force_load(struct module *mod, const char *symname)
 {
 #ifdef CONFIG_MODULE_FORCE_LOAD
-	if (!(tainted & TAINT_FORCED_MODULE))
+	if (!test_bit(TAINT_FORCED_MODULE, &tainted_mask))
 		printk("%s: no version for \"%s\" found: kernel tainted.\n",
 		       mod->name, symname);
 	add_taint_module(mod, TAINT_FORCED_MODULE);
@@ -1033,7 +1033,7 @@ static unsigned long resolve_symbol(Elf_
 	const unsigned long *crc;
 
 	ret = find_symbol(name, &owner, &crc,
-			  !(mod->taints & TAINT_PROPRIETARY_MODULE), true);
+			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	if (!IS_ERR_VALUE(ret)) {
 		/* use_module can fail due to OOM,
 		   or module initialization or unloading */
@@ -1634,7 +1634,7 @@ static void set_license(struct module *m
 		license = "unspecified";
 
 	if (!license_is_gpl_compatible(license)) {
-		if (!(tainted & TAINT_PROPRIETARY_MODULE))
+		if (!test_bit(TAINT_PROPRIETARY_MODULE, &tainted_mask))
 			printk(KERN_WARNING "%s: module license '%s' taints "
 				"kernel.\n", mod->name, license);
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
@@ -2552,9 +2552,9 @@ static char *module_flags(struct module 
 	    mod->state == MODULE_STATE_GOING ||
 	    mod->state == MODULE_STATE_COMING) {
 		buf[bx++] = '(';
-		if (mod->taints & TAINT_PROPRIETARY_MODULE)
+		if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
 			buf[bx++] = 'P';
-		if (mod->taints & TAINT_FORCED_MODULE)
+		if (mod->taints & (1 << TAINT_FORCED_MODULE))
 			buf[bx++] = 'F';
 		/*
 		 * TAINT_FORCED_RMMOD: could be added.
Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -226,7 +226,7 @@ static void check_hung_uninterruptible_t
 	 * If the system crashed already then all bets are off,
 	 * do not report extra hung tasks:
 	 */
-	if ((tainted & TAINT_DIE) || did_panic)
+	if (test_bit(TAINT_DIE, &tainted_mask) || did_panic)
 		return;
 
 	read_lock(&tasklist_lock);
