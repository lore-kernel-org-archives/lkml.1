Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZGGAaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZGGAaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758976AbZGGASu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:18:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33443 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962AbZGGASr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:18:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC PATCH -tip v3 3/7] kprobes: Jump optimization sysctl interface
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>
Date: Mon, 06 Jul 2009 20:21:10 -0400
Message-ID: <20090707002110.10694.54287.stgit@localhost.localdomain>
In-Reply-To: <20090707002051.10694.53741.stgit@localhost.localdomain>
References: <20090707002051.10694.53741.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add /proc/sys/debug/kprobes-optimization sysctl which enables and disables
kprobes jump optimization on the fly for debugging.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
---

 include/linux/kprobes.h |    9 +++++
 kernel/kprobes.c        |   85 +++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sysctl.c         |   13 +++++++
 3 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 6f75014..de592ea 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -283,6 +283,15 @@ extern int arch_within_optimized_kprobe(struct optimized_kprobe *op,
 					unsigned long addr);
 
 extern void opt_pre_handler(struct kprobe *p, struct pt_regs *regs);
+
+#ifdef CONFIG_SYSCTL
+extern int sysctl_kprobes_optimization;
+extern int proc_kprobes_optimization_handler(struct ctl_table *table,
+					     int write, struct file *file,
+					     void __user *buffer,
+					     size_t *length, loff_t *ppos);
+#endif
+
 #endif /* CONFIG_OPTPROBES */
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 0cbb607..1350e3d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -44,6 +44,7 @@
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
 #include <linux/memory.h>
+#include <linux/sysctl.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -374,6 +375,9 @@ static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
 }
 
 #ifdef CONFIG_OPTPROBES
+/* NOTE: change this value only with kprobe_mutex held */
+static bool kprobes_allow_optimization;
+
 /*
  * Call all pre_handler on the list, but ignores its return value.
  * This must be called from arch-dep optimized caller.
@@ -434,7 +438,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
 	mutex_lock(&kprobe_mutex);
-	if (kprobes_all_disarmed)
+	if (kprobes_all_disarmed || !kprobes_allow_optimization)
 		goto end;
 
 	/* Wait quiesence period for ensuring all interrupts are done */
@@ -458,7 +462,7 @@ static __kprobes void optimize_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 	/* Check if the kprobe is disabled or not ready for optimization. */
-	if (!kprobe_optready(p) ||
+	if (!kprobe_optready(p) || !kprobes_allow_optimization ||
 	    (kprobe_disabled(p) || kprobes_all_disarmed))
 		return;
 
@@ -570,6 +574,77 @@ static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
 	optimize_kprobe(ap);
 	return;
 }
+
+#ifdef CONFIG_SYSCTL
+static void __kprobes optimize_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	/* If optimization is already allowed, just return */
+	if (kprobes_allow_optimization)
+		return;
+
+	kprobes_allow_optimization = true;
+	mutex_lock(&text_mutex);
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist)
+			if (!kprobe_disabled(p))
+				optimize_kprobe(p);
+	}
+	mutex_unlock(&text_mutex);
+	printk(KERN_INFO "Kprobes globally optimized\n");
+}
+
+static void __kprobes unoptimize_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	/* If optimization is already prohibited, just return */
+	if (!kprobes_allow_optimization)
+		return;
+
+	kprobes_allow_optimization = false;
+	printk(KERN_INFO "Kprobes globally unoptimized\n");
+	mutex_lock(&text_mutex);
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist) {
+			if (!kprobe_disabled(p))
+				unoptimize_kprobe(p);
+		}
+	}
+
+	mutex_unlock(&text_mutex);
+	/* Allow all currently running kprobes to complete */
+	synchronize_sched();
+}
+
+int sysctl_kprobes_optimization;
+int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
+				      struct file *file, void __user *buffer,
+				      size_t *length, loff_t *ppos)
+{
+	int ret;
+	mutex_lock(&kprobe_mutex);
+	sysctl_kprobes_optimization = kprobes_allow_optimization ? 1 : 0;
+	ret = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
+
+	if (sysctl_kprobes_optimization)
+		optimize_all_kprobes();
+	else
+		unoptimize_all_kprobes();
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+#endif /* CONFIG_SYSCTL */
+
 #else /* !CONFIG_OPTPROBES */
 #define get_optimized_kprobe(addr)		(NULL)
 #define optimize_kprobe(p)			do {} while (0)
@@ -1550,10 +1625,14 @@ static int __init init_kprobes(void)
 		}
 	}
 
-#if defined(CONFIG_OPTPROBES) && defined(__ARCH_WANT_KPROBES_INSN_SLOT)
+#if defined(CONFIG_OPTPROBES)
+#if defined(__ARCH_WANT_KPROBES_INSN_SLOT)
 	/* Init kprobe_optinsn_slots */
 	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
 #endif
+	/* By default, kprobes can be optimized */
+	kprobes_allow_optimization = true;
+#endif
 
 	/* By default, kprobes are armed */
 	kprobes_all_disarmed = false;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 32460ea..4359d61 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -51,6 +51,7 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_counter.h>
+#include <linux/kprobes.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -1551,6 +1552,18 @@ static struct ctl_table debug_table[] = {
 		.proc_handler	= proc_dointvec
 	},
 #endif
+#if defined(CONFIG_OPTPROBES)
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kprobes-optimization",
+		.data		= &sysctl_kprobes_optimization,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_kprobes_optimization_handler,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
