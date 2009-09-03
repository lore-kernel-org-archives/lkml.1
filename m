Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZICU0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZICU0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbZICU0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:26:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374AbZICU0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:26:11 -0400
Date: Thu, 3 Sep 2009 16:26:03 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, roland@redhat.com, rth@redhat.com,
       mingo@elte.hu
Message-Id: <8f1d67665174e923ac79138741cce762b1b65137.1252007851.git.jbaron@redhat.com>
In-Reply-To: <cover.1252007851.git.jbaron@redhat.com>
References: <cover.1252007851.git.jbaron@redhat.com>
Subject: [PATCH 4/4] RFC: performance testing harness
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not intended to be merged just a harness for micro-testing tracepoint performance.



Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 include/linux/tracepoint.h |   12 ++++
 kernel/tracepoint.c        |  125 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index fdd2d8b..da657bf 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -27,6 +27,8 @@ struct tracepoint {
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	void **funcs;
+	unsigned long cycle_total;
+	unsigned long count;
 } __attribute__((aligned(32)));		/*
 					 * Aligned on 32 bytes because it is
 					 * globally visible and gcc happily
@@ -69,12 +71,22 @@ struct tracepoint {
 	extern const char __sjstrtab_##name[];				     \
 	static inline void trace_##name(proto)				     \
 	{								     \
+		unsigned long profile_flags;				     \
+		u64 t1, t2;						     \
+		local_irq_save(profile_flags);				     \
+		preempt_disable();					     \
+		t1 = get_cycles();					     \
 		JUMP_LABEL_IF(name, trace_label, __tracepoint_##name.state); \
 		if (0) {						     \
 trace_label:								     \
 			__DO_TRACE(&__tracepoint_##name,		     \
 				TP_PROTO(proto), TP_ARGS(args));	     \
 		}							     \
+		t2 = get_cycles();					     \
+		local_irq_restore(profile_flags);			     \
+		preempt_enable();					     \
+		__tracepoint_##name.count += 1;				     \
+		__tracepoint_##name.cycle_total += (t2 - t1);		     \
 	}								     \
 	static inline int register_trace_##name(void (*probe)(proto))	     \
 	{								     \
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 1b4acc0..4be3991 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -26,6 +26,9 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/jump_label.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -563,6 +566,78 @@ void tracepoint_iter_reset(struct tracepoint_iter *iter)
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
+static void *tracepoint_seq_next(struct seq_file *seqf, void *v, loff_t *pos)
+{
+	struct tracepoint_iter *iter;
+	iter = seqf->private;
+
+        tracepoint_iter_next(iter);
+	if (iter->tracepoint) {
+		(*pos)++;
+                return iter->tracepoint;
+	}
+
+        return NULL;
+}
+
+static void tracepoint_seq_stop(struct seq_file *seqf, void *v)
+{
+        struct tracepoint_iter *iter = seqf->private;
+
+        /* stop is called even after start failed :-( */
+        if (iter) 
+                kfree(iter);
+        
+}
+
+static void *tracepoint_seq_start(struct seq_file *seqf, loff_t *pos)
+{
+	struct tracepoint_iter *iter;
+	loff_t skip = *pos;
+
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+        if (!iter)
+                return ERR_PTR(-ENOMEM);
+        seqf->private = iter;
+
+	tracepoint_iter_reset(iter);
+	tracepoint_iter_start(iter);
+        do {
+                tracepoint_iter_next(iter);
+                if (!iter->tracepoint)
+                        return NULL;
+        } while (skip--);
+
+	return iter->tracepoint;
+}
+
+static int show_tracepoint(struct seq_file *seqf, void *v)
+{
+        struct tracepoint *tp = v;
+
+	seq_printf(seqf, "%s %lu %lu %lu\n", tp->name, tp->cycle_total, tp->count, tp->count ? tp->cycle_total / tp->count : 0 );
+        return 0;
+}
+
+static struct seq_operations tracepoints_seq_ops = {
+        .start = tracepoint_seq_start,
+        .next  = tracepoint_seq_next,
+        .stop  = tracepoint_seq_stop,
+        .show  = show_tracepoint
+};
+
+static int tracepoints_open(struct inode *inode, struct file *filp)
+{
+        return seq_open(filp, &tracepoints_seq_ops);
+}
+
+static struct file_operations debugfs_tracepoint_operations = {
+        .open           = tracepoints_open,
+        .read           = seq_read,
+        .llseek         = seq_lseek,
+        .release        = seq_release,
+};
+
 #ifdef CONFIG_MODULES
 
 int tracepoint_module_notify(struct notifier_block *self,
@@ -585,8 +660,57 @@ struct notifier_block tracepoint_module_nb = {
 	.priority = 0,
 };
 
+static ssize_t write_enabled_file_bool(struct file *file,
+               const char __user *user_buf, size_t count, loff_t *ppos)
+{
+        struct tracepoint_iter *iter;
+
+        iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+        if (!iter)
+                return ERR_PTR(-ENOMEM);
+
+        tracepoint_iter_reset(iter);
+        tracepoint_iter_start(iter);
+        do {
+                tracepoint_iter_next(iter);
+                if (!iter->tracepoint)
+                        break;
+		iter->tracepoint->count = 0;
+		iter->tracepoint->cycle_total = 0;
+        } while (1);
+
+        kfree(iter);
+        return count;
+}
+
+static struct file_operations fops_kp = {
+        .write =        write_enabled_file_bool,
+};
+
+
+
 static int init_tracepoints(void)
 {
+        struct dentry *dir, *file;
+
+        dir = debugfs_create_dir("tracepoints", NULL);
+        if (!dir)
+                return -ENOMEM;
+
+        file = debugfs_create_file("list", 0444, dir, NULL,
+                                &debugfs_tracepoint_operations);
+        if (!file) {
+                debugfs_remove(dir);
+                return -ENOMEM;
+        }
+
+        file = debugfs_create_file("clear", 0600, dir,
+                                        NULL, &fops_kp);
+        if (!file) {
+                debugfs_remove(dir);
+                return -ENOMEM;
+        }
+
 	return register_module_notifier(&tracepoint_module_nb);
 }
 __initcall(init_tracepoints);
@@ -630,3 +754,4 @@ void syscall_unregfunc(void)
 	}
 }
 #endif
+
-- 
1.6.2.5

