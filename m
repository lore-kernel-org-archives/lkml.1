Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab0BYNbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:31:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533Ab0BYNbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:31:15 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3&10 04/18] kprobes: Jump optimization sysctl interface
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
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
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Date: Thu, 25 Feb 2010 08:34:15 -0500
Message-ID: <20100225133415.6725.8274.stgit@localhost6.localdomain6>
In-Reply-To: <20100225133342.6725.26971.stgit@localhost6.localdomain6>
References: <20100225133342.6725.26971.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add /proc/sys/debug/kprobes-optimization sysctl which enables and disables
kprobes jump optimization on the fly for debugging.

Changes in v7:
 - Remove ctl_name = CTL_UNNUMBERED for upstream compatibility.

Changes in v6:
- Update comments and coding style.


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
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
---

 include/linux/kprobes.h |    8 ++++
 kernel/kprobes.c        |   88 +++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sysctl.c         |   12 ++++++
 3 files changed, 105 insertions(+), 3 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index aed1f95..e7d1b2e 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -283,6 +283,14 @@ extern int arch_within_optimized_kprobe(struct optimized_kprobe *op,
 					unsigned long addr);
 
 extern void opt_pre_handler(struct kprobe *p, struct pt_regs *regs);
+
+#ifdef CONFIG_SYSCTL
+extern int sysctl_kprobes_optimization;
+extern int proc_kprobes_optimization_handler(struct ctl_table *table,
+					     int write, void __user *buffer,
+					     size_t *length, loff_t *ppos);
+#endif
+
 #endif /* CONFIG_OPTPROBES */
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 612af2d..fa034d2 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -42,6 +42,7 @@
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/sysctl.h>
 #include <linux/kdebug.h>
 #include <linux/memory.h>
 #include <linux/ftrace.h>
@@ -360,6 +361,9 @@ static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
 }
 
 #ifdef CONFIG_OPTPROBES
+/* NOTE: change this value only with kprobe_mutex held */
+static bool kprobes_allow_optimization;
+
 /*
  * Call all pre_handler on the list, but ignores its return value.
  * This must be called from arch-dep optimized caller.
@@ -428,7 +432,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
 	mutex_lock(&kprobe_mutex);
-	if (kprobes_all_disarmed)
+	if (kprobes_all_disarmed || !kprobes_allow_optimization)
 		goto end;
 
 	/*
@@ -471,7 +475,7 @@ static __kprobes void optimize_kprobe(struct kprobe *p)
 	struct optimized_kprobe *op;
 
 	/* Check if the kprobe is disabled or not ready for optimization. */
-	if (!kprobe_optready(p) ||
+	if (!kprobe_optready(p) || !kprobes_allow_optimization ||
 	    (kprobe_disabled(p) || kprobes_all_disarmed))
 		return;
 
@@ -588,6 +592,80 @@ static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
 	optimize_kprobe(ap);
 }
 
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
+	get_online_cpus();	/* For avoiding text_mutex deadlock */
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
+	put_online_cpus();
+	/* Allow all currently running kprobes to complete */
+	synchronize_sched();
+}
+
+int sysctl_kprobes_optimization;
+int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
+				      void __user *buffer, size_t *length,
+				      loff_t *ppos)
+{
+	int ret;
+
+	mutex_lock(&kprobe_mutex);
+	sysctl_kprobes_optimization = kprobes_allow_optimization ? 1 : 0;
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+
+	if (sysctl_kprobes_optimization)
+		optimize_all_kprobes();
+	else
+		unoptimize_all_kprobes();
+	mutex_unlock(&kprobe_mutex);
+
+	return ret;
+}
+#endif /* CONFIG_SYSCTL */
+
 static void __kprobes __arm_kprobe(struct kprobe *p)
 {
 	struct kprobe *old_p;
@@ -1610,10 +1688,14 @@ static int __init init_kprobes(void)
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
index ac72c9e..809e67a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -50,6 +50,7 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
+#include <linux/kprobes.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -1463,6 +1464,17 @@ static struct ctl_table debug_table[] = {
 		.proc_handler	= proc_dointvec
 	},
 #endif
+#if defined(CONFIG_OPTPROBES)
+	{
+		.procname	= "kprobes-optimization",
+		.data		= &sysctl_kprobes_optimization,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_kprobes_optimization_handler,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 	{ }
 };
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
