Return-Path: <linux-kernel-owner+w=401wt.eu-S2992880AbXDDMKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992880AbXDDMKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 08:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992879AbXDDMKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 08:10:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41916 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992880AbXDDMKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 08:10:23 -0400
Date: Wed, 4 Apr 2007 17:43:49 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, srinivasa@in.ibm.com,
       akpm@linux-foundation.org,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       hch@infradead.org, davem@davemloft.net, richardj_moore@uk.ibm.com
Subject: [RFC][PATCH] Kprobes: The ON/OFF knob thru debugfs
Message-ID: <20070404121349.GA26313@in.ibm.com>
Reply-To: ananth@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a debugfs knob to turn kprobes on/off

o A new file /debug/kprobes/enabled indicates if kprobes is enabled or
  not (default enabled)
o Echoing 0 to this file will disarm all installed probes
o Any new probe registration when disabled will register the probe but
  not arm it. A message will be printed out in such a case.
o When a value 1 is echoed to the file, all probes (including ones
  registered in the intervening period) will be enabled
o Unregistration will happen irrespective of whether probes are globally
  enabled or not.
o Update Documentation/kprobes.txt to reflect these changes. While there
  also update the doc to make it current.

Patch against 2.6.21-rc5-mm4

We are also looking at providing sysrq key support to tie to the
disabling feature provided by this patch.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>

---
 Documentation/kprobes.txt |   35 +++++++++-
 kernel/kprobes.c          |  160 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 183 insertions(+), 12 deletions(-)

Index: linux-2.6.21-rc5/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/kprobes.c
+++ linux-2.6.21-rc5/kernel/kprobes.c
@@ -46,6 +46,7 @@
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
+#include <asm/uaccess.h>
 
 #define KPROBE_HASH_BITS 6
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
@@ -64,6 +65,9 @@ static struct hlist_head kprobe_table[KP
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 static atomic_t kprobe_count;
 
+/* NOTE: change this value only with kprobe_mutex held */
+static bool kprobe_enabled;
+
 DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
 DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
@@ -564,11 +568,15 @@ static int __kprobes __register_kprobe(s
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (atomic_add_return(1, &kprobe_count) == \
+	if (kprobe_enabled == 1) {
+		if (atomic_add_return(1, &kprobe_count) == \
 				(ARCH_INACTIVE_KPROBE_COUNT + 1))
-		register_page_fault_notifier(&kprobe_page_fault_nb);
+			register_page_fault_notifier(&kprobe_page_fault_nb);
 
-	arch_arm_kprobe(p);
+		arch_arm_kprobe(p);
+	} else
+		printk("Kprobes are globally disabled. This kprobe [@ %p] "
+			"will be enabled with all other probes\n", p->addr);
 
 out:
 	mutex_unlock(&kprobe_mutex);
@@ -607,8 +615,13 @@ valid_p:
 	if (old_p == p ||
 	    (old_p->pre_handler == aggr_pre_handler &&
 	     p->list.next == &old_p->list && p->list.prev == &old_p->list)) {
-		/* Only probe on the hash list */
-		arch_disarm_kprobe(p);
+		/*
+		 * Only probe on the hash list. Disarm only if kprobes are
+		 * enabled - otherwise, the breakpoint would already have
+		 * been removed. We save on flushing icache.
+		 */
+		if (kprobe_enabled == 1)
+			arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
 		cleanup_p = 1;
 	} else {
@@ -797,6 +810,9 @@ static int __init init_kprobes(void)
 	}
 	atomic_set(&kprobe_count, 0);
 
+	/* By default, kprobes are enabled */
+	kprobe_enabled = 1;
+
 	err = arch_init_kprobes();
 	if (!err)
 		err = register_die_notifier(&kprobe_exceptions_nb);
@@ -806,7 +822,7 @@ static int __init init_kprobes(void)
 
 #ifdef CONFIG_DEBUG_FS
 static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
-               const char *sym, int offset,char *modname)
+		const char *sym, int offset,char *modname)
 {
 	char *kprobe_type;
 
@@ -817,10 +833,12 @@ static void __kprobes report_probe(struc
 	else
 		kprobe_type = "k";
 	if (sym)
-		seq_printf(pi, "%p  %s  %s+0x%x  %s\n", p->addr, kprobe_type,
-			sym, offset, (modname ? modname : " "));
+		seq_printf(pi, "%p  %s  %s+0x%x  %s  %d\n",
+			p->addr, kprobe_type, sym, offset,
+			(modname ? modname : " "), kprobe_enabled);
 	else
-		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
+		seq_printf(pi, "%p  %s  %p  %d\n", p->addr, kprobe_type,
+			p->addr, kprobe_enabled);
 }
 
 static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
@@ -885,9 +903,126 @@ static struct file_operations debugfs_kp
 	.release        = seq_release,
 };
 
+static void __kprobes enable_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* If kprobes are already enabled, just return */
+	if (kprobe_enabled == 1)
+		goto already_enabled;
+
+	/*
+	 * Re-register the page fault notifier only if there are any
+	 * active probes at the time of enabling kprobes globally
+	 */
+	if (atomic_read(&kprobe_count) > ARCH_INACTIVE_KPROBE_COUNT)
+		register_page_fault_notifier(&kprobe_page_fault_nb);
+
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist)
+			arch_arm_kprobe(p);
+	}
+
+	kprobe_enabled = 1;
+
+already_enabled:
+	mutex_unlock(&kprobe_mutex);
+	return;
+}
+
+static void __kprobes disable_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* If kprobes are already disabled, just return */
+	if (kprobe_enabled == 0)
+		goto already_disabled;
+
+	kprobe_enabled = 0;
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist)
+			arch_disarm_kprobe(p);
+	}
+
+	mutex_unlock(&kprobe_mutex);
+	/* Allow all currently running kprobes to complete */
+	synchronize_sched();
+
+	mutex_lock(&kprobe_mutex);
+	/* Unconditionally unregister the page_fault notifier */
+	unregister_page_fault_notifier(&kprobe_page_fault_nb);
+
+already_disabled:
+	mutex_unlock(&kprobe_mutex);
+	return;
+}
+
+/*
+ * XXX: The debugfs bool file interface doesn't allow for callbacks
+ * when the bool state is switched. We can reuse that facility when
+ * available
+ */
+static ssize_t read_enabled_file_bool(struct file *file,
+	       char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+
+	if (kprobe_enabled)
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t write_enabled_file_bool(struct file *file,
+	       const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		enable_all_kprobes();
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		disable_all_kprobes();
+		break;
+	}
+
+	return count;
+}
+
+static struct file_operations fops_kp = {
+	.read =         read_enabled_file_bool,
+	.write =        write_enabled_file_bool,
+};
+
 static int __kprobes debugfs_kprobe_init(void)
 {
 	struct dentry *dir, *file;
+	unsigned int value = 1;
 
 	dir = debugfs_create_dir("kprobes", NULL);
 	if (!dir)
@@ -900,6 +1035,13 @@ static int __kprobes debugfs_kprobe_init
 		return -ENOMEM;
 	}
 
+	file = debugfs_create_file("enabled", 0600, dir,
+					&value, &fops_kp);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
Index: linux-2.6.21-rc5/Documentation/kprobes.txt
===================================================================
--- linux-2.6.21-rc5.orig/Documentation/kprobes.txt
+++ linux-2.6.21-rc5/Documentation/kprobes.txt
@@ -14,6 +14,7 @@ CONTENTS
 8. Kprobes Example
 9. Jprobes Example
 10. Kretprobes Example
+Appendix A: The kprobes debugfs interface
 
 1. Concepts: Kprobes, Jprobes, Return Probes
 
@@ -349,9 +350,12 @@ for instrumentation and error reporting.
 
 If the number of times a function is called does not match the number
 of times it returns, registering a return probe on that function may
-produce undesirable results.  We have the do_exit() case covered.
-do_execve() and do_fork() are not an issue.  We're unaware of other
-specific cases where this could be a problem.
+produce undesirable results. In such a case, a line:
+kretprobe BUG!: Processing kretprobe d000000000041aa8 @ c00000000004f48c
+gets printed. With this information, one will be able to correlate the
+exact instance of the kretprobe that caused the problem. We have the
+do_exit() case covered. do_execve() and do_fork() are not an issue.
+We're unaware of other specific cases where this could be a problem.
 
 If, upon entry to or exit from a function, the CPU is running on
 a stack other than that of the current task, registering a return
@@ -614,3 +618,28 @@ http://www-106.ibm.com/developerworks/li
 http://www.redhat.com/magazine/005mar05/features/kprobes/
 http://www-users.cs.umn.edu/~boutcher/kprobes/
 http://www.linuxsymposium.org/2006/linuxsymposium_procv2.pdf (pages 101-115)
+
+
+Appendix A: The kprobes debugfs interface
+
+With recent kernels (> 2.6.20) the list of registered kprobes is visible
+under the /debug/kprobes/ directory (assuming debugfs is mounted at /debug).
+
+/debug/kprobes/list: Lists all registered probes on the system
+
+c015d71a  k  vfs_read+0x0     1
+c011a316  j  do_fork+0x0     1
+c03dedc5  r  tcp_v4_rcv+0x0     1
+
+The first column provides the kernel address where the probe is inserted.
+The second column identifies the type of probe (k - kprobe, r - kretprobe
+and j - jprobe), while the third column specifies the symbol+offset of
+the probe. If the probed function belongs to a module, the module name
+is also specified. The last column indicates whether the probe is
+enabled or not.
+
+/debug/kprobes/enabled: Turn kprobes ON/OFF
+
+Provides a knob to globally turn registered kprobes ON or OFF. By default,
+all kprobes are enabled. By echoing "0" to this file, all registered probes
+will be disarmed, till such time a "1" is echoed to this file.
