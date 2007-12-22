Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbXLVMrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbXLVMrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 07:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXLVMr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 07:47:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58010 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbXLVMr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 07:47:27 -0500
Date: Sat, 22 Dec 2007 14:47:25 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       clameter@sgi.com, a.p.zijlstra@chello.nl
Subject: [PATCH] slub: /proc/slabinfo ABI compatibility
Message-ID: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This adds a read-only /proc/slabinfo file that is ABI compatible with SLAB for
SLUB.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/proc/proc_misc.c      |   17 ++++++++++
 include/linux/slub_def.h |    2 +
 mm/slub.c                |   79 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

Index: linux-2.6/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_misc.c	2007-12-22 14:43:48.000000000 +0200
+++ linux-2.6/fs/proc/proc_misc.c	2007-12-22 14:44:11.000000000 +0200
@@ -451,6 +451,20 @@
 #endif
 #endif
 
+#ifdef CONFIG_SLUB
+static int slabinfo_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &slabinfo_op);
+}
+
+static const struct file_operations proc_slabinfo_operations = {
+	.open		= slabinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+#endif
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i;
@@ -734,6 +748,9 @@
 	create_seq_entry("slab_allocators", 0 ,&proc_slabstats_operations);
 #endif
 #endif
+#ifdef CONFIG_SLUB
+	create_seq_entry("slabinfo", S_IWUSR|S_IRUGO, &proc_slabinfo_operations);
+#endif
 	create_seq_entry("buddyinfo",S_IRUGO, &fragmentation_file_operations);
 	create_seq_entry("pagetypeinfo", S_IRUGO, &pagetypeinfo_file_ops);
 	create_seq_entry("vmstat",S_IRUGO, &proc_vmstat_file_operations);
Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-12-22 14:43:48.000000000 +0200
+++ linux-2.6/include/linux/slub_def.h	2007-12-22 14:44:11.000000000 +0200
@@ -200,4 +200,6 @@
 }
 #endif
 
+extern const struct seq_operations slabinfo_op;
+
 #endif /* _LINUX_SLUB_DEF_H */
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-12-22 14:43:48.000000000 +0200
+++ linux-2.6/mm/slub.c	2007-12-22 14:44:37.000000000 +0200
@@ -4123,3 +4123,82 @@
 
 __initcall(slab_sysfs_init);
 #endif
+
+/*
+ * The /proc/slabinfo ABI
+ */
+#ifdef CONFIG_PROC_FS
+
+static void print_slabinfo_header(struct seq_file *m)
+{
+	seq_puts(m, "slabinfo - version: 2.1\n");
+	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> "
+		 "<objperslab> <pagesperslab>");
+	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
+	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
+	seq_putc(m, '\n');
+}
+
+static void *s_start(struct seq_file *m, loff_t *pos)
+{
+	loff_t n = *pos;
+
+	down_read(&slub_lock);
+	if (!n)
+		print_slabinfo_header(m);
+
+	return seq_list_start(&slab_caches, *pos);
+}
+
+static void *s_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	return seq_list_next(p, &slab_caches, pos);
+}
+
+static void s_stop(struct seq_file *m, void *p)
+{
+	up_read(&slub_lock);
+}
+
+static int s_show(struct seq_file *m, void *p)
+{
+	unsigned long nr_partials = 0;
+	unsigned long nr_slabs = 0;
+	unsigned long nr_inuse = 0;
+	unsigned long nr_objs;
+	struct kmem_cache *s;
+	int node;
+
+	s = list_entry(p, struct kmem_cache, list);
+
+	for_each_online_node(node) {
+		struct kmem_cache_node *n = get_node(s, node);
+
+		if (!n)
+			continue;
+
+		nr_partials += n->nr_partial;
+		nr_slabs += atomic_long_read(&n->nr_slabs);
+		nr_inuse += count_partial(n);
+	}
+
+	nr_objs = nr_slabs * s->objects;
+	nr_inuse += (nr_slabs - nr_partials) * s->objects;
+
+	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d", s->name, nr_inuse,
+		   nr_objs, s->size, s->objects, (1 << s->order));
+	seq_printf(m, " : tunables %4u %4u %4u", 0, 0, 0);
+	seq_printf(m, " : slabdata %6lu %6lu %6lu", nr_slabs, nr_slabs,
+		   0UL);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+const struct seq_operations slabinfo_op = {
+	.start = s_start,
+	.next = s_next,
+	.stop = s_stop,
+	.show = s_show,
+};
+
+#endif /* CONFIG_PROC_FS */
