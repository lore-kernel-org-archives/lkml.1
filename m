Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbXBFJzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbXBFJzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXBFJzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:55:42 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:65468 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbXBFJzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:55:40 -0500
Message-ID: <45C85097.1000106@in.ibm.com>
Date: Tue, 06 Feb 2007 15:25:35 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060918)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org,
       jkenisto@us.ibm.com, anil.s.keshavamurthy@intel.com,
       prasanna@in.ibm.com, ananth@in.ibm.com
Subject: [RFC] [PATCH] To list all active probes in the system
Content-Type: multipart/mixed;
 boundary="------------060907030302020508040207"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060907030302020508040207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi folks

        I have developed a patch, that lists all active probes in the
system. I have done this through /proc interface. Currently list is
available under /proc/kprobes/list. Any suggestions for better place and
name??

	My patch scans through kprobe_table[],lists out all the probes, in an
order it finds them. It also takes care of aggregate handlers. Type of
the probe is recognised by the kind of pre_handler it has. I have
assigned letter for each probe, like "k" for kprobes, "j" for jprobes,
"r" for kretprobes. Along with type of the probe,it also lists the
address of the instruction,its symbolic name(function name + offset) and
the module name.


Output of /proc/kprobes/list  looks like this
======================
[root@llm31 a]# cat /proc/kprobes/list
c0000000000c0720  r  .sys_write+0x0
c0000000000c0720  k  .sys_write+0x0
c00000000004c550  k  .do_fork+0x0
c00000000004c550  k  .do_fork+0x0
c00000000004c550  j  .do_fork+0x0
c0000000000bfed4  r  .vfs_read+0x0
c0000000000bddb4  r  .sys_open+0x0
c0000000000c0694  r  .sys_read+0x0
c0000000000c0694  k  .sys_read+0x0
c00000000004c554  k  .do_fork+0x4
d0000000000781b0  k  .autofs4_dentry_release+0x0  autofs4
c0000000000275d0  k  kretprobe_trampoline+0x0
c0000000000bfd18  k  .vfs_write+0x0
====================================

Please let me know your comments on this.

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>


--------------060907030302020508040207
Content-Type: text/x-patch;
 name="kp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kp.diff"

 fs/proc/root.c          |    4 ++
 include/linux/kprobes.h |    7 +++
 kernel/kprobes.c        |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

Index: linux-2.6.20/kernel/kprobes.c
===================================================================
--- linux-2.6.20.orig/kernel/kprobes.c
+++ linux-2.6.20/kernel/kprobes.c
@@ -39,6 +39,7 @@
 #include <linux/moduleloader.h>
 #include <linux/kallsyms.h>
 #include <linux/freezer.h>
+#include <linux/seq_file.h>
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
@@ -815,6 +816,92 @@ static int __init init_kprobes(void)
 	return err;
 }
 
+static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
+               const char *sym, int offset,char *modname)
+{
+	char *kprobe_type;
+
+	if (p->pre_handler == pre_handler_kretprobe)
+		kprobe_type = "r";
+	else if (p->pre_handler == setjmp_pre_handler)
+		kprobe_type = "j";
+	else
+		kprobe_type = "k";
+	if (sym)
+		seq_printf(pi, "%p  %s  %s+0x%x  %s\n", p->addr, kprobe_type,
+			sym, offset, (modname ? modname : " "));
+	else
+		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
+}
+
+void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
+}
+
+void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= KPROBE_TABLE_SIZE)
+		return NULL;
+	return pos;
+}
+
+void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p, *kp;
+	unsigned int i = *(loff_t *) v;
+	unsigned long size, offset = 0;
+	char *modname, namebuf[128];
+	const char *sym = NULL;
+
+	head = &kprobe_table[i];
+	preempt_disable();
+	hlist_for_each_entry_rcu(p, node, head, hlist) {
+		sym = kallsyms_lookup((unsigned long)p->addr, &size,
+					&offset, &modname, namebuf);
+		if (p->pre_handler == aggr_pre_handler) {
+			list_for_each_entry_rcu(kp, &p->list, list)
+				report_probe(pi, kp, sym, offset, modname);
+		} else
+			report_probe(pi, p, sym, offset, modname);
+	}
+	preempt_enable();
+	return 0;
+}
+
+struct seq_operations kprobes_seq_ops = {
+	.start = kprobe_seq_start,
+	.next  = kprobe_seq_next,
+	.stop  = kprobe_seq_stop,
+	.show  = show_kprobe_addr
+};
+
+static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &kprobes_seq_ops);
+}
+
+static struct file_operations proc_kprobes_operations = {
+	.open           = kprobes_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+void __kprobes proc_kprobe_init(void)
+{
+	proc_mkdir("kprobes", NULL);
+	create_seq_entry("kprobes/list", 0, &proc_kprobes_operations);
+}
+
 __initcall(init_kprobes);
 
 EXPORT_SYMBOL_GPL(register_kprobe);
Index: linux-2.6.20/include/linux/kprobes.h
===================================================================
--- linux-2.6.20.orig/include/linux/kprobes.h
+++ linux-2.6.20/include/linux/kprobes.h
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/proc_fs.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -167,6 +168,8 @@ extern void show_registers(struct pt_reg
 extern kprobe_opcode_t *get_insn_slot(void);
 extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
+extern void create_seq_entry(char *name, mode_t mode,
+		const struct file_operations *f);
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
 struct kprobe *get_kprobe(void *addr);
@@ -203,6 +206,7 @@ struct kretprobe_instance *get_free_rp_i
 void add_rp_inst(struct kretprobe_instance *ri);
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
+void proc_kprobe_init(void);
 #else /* CONFIG_KPROBES */
 
 #define __kprobes	/**/
@@ -240,5 +244,8 @@ static inline void unregister_kretprobe(
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
+static inline void proc_kprobe_init(void)
+{
+}
 #endif				/* CONFIG_KPROBES */
 #endif				/* _LINUX_KPROBES_H */
Index: linux-2.6.20/fs/proc/root.c
===================================================================
--- linux-2.6.20.orig/fs/proc/root.c
+++ linux-2.6.20/fs/proc/root.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/smp_lock.h>
 #include <linux/mount.h>
+#include <linux/kprobes.h>
 
 #include "internal.h"
 
@@ -85,6 +86,9 @@ void __init proc_root_init(void)
 	/* just give it a mountpoint */
 	proc_mkdir("openprom", NULL);
 #endif
+#ifdef CONFIG_KPROBES
+	proc_kprobe_init();
+#endif
 	proc_tty_init();
 #ifdef CONFIG_PROC_DEVICETREE
 	proc_device_tree_init();

--------------060907030302020508040207--
