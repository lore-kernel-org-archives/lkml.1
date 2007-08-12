Return-Path: <linux-kernel-owner+w=401wt.eu-S937021AbXHLPRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937021AbXHLPRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936547AbXHLPLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:11:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47792 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936534AbXHLPKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:10:55 -0400
Message-Id: <20070812151039.996081605@polymtl.ca>
References: <20070812150844.305211039@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:08:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/2] Sort module list by pointer address to get coherent sleepable seq_file iterators
Content-Disposition: inline; filename=module.c-sort-module-list.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:10:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A race that appears both in /proc/modules and in kallsyms: if, between the
seq file reads, the process is put to sleep and at this moment a module is
or removed from the module list, the listing will skip an amount of
modules/symbols corresponding to the amount of elements present in the unloaded
module, but at the current position in the list if the iteration is located
after the removed module.

The cleanest way I found to deal with this problem is to sort the module list.
We can then keep the old struct module * as the old iterator, knowing the it may
be removed between the seq file reads, but we only use it as "get next". If it
is not present in the module list, the next pointer will be used.

By doing this, removing a given module will now only fuzz the output related to
this specific module, not any random module anymore. Since modprobe uses
/proc/modules, it might be important to make sure multiple concurrent running
modprobes won't interfere with each other.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/module.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-08-12 10:05:39.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-08-12 10:22:05.000000000 -0400
@@ -63,8 +63,10 @@ extern int module_sysfs_initialized;
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
 
-/* List of modules, protected by module_mutex or preempt_disable
- * (add/delete uses stop_machine). */
+/*
+ * List of modules, protected by module_mutex or preempt_disable
+ * (add/delete uses stop_machine). Sorted by ascending list node address.
+ */
 DEFINE_MUTEX(module_mutex);
 LIST_HEAD(modules);
 static DECLARE_MUTEX(notify_mutex);
@@ -2134,10 +2136,24 @@ nomodsectinfo:
 /*
  * link the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
+ * We sort the modules by struct module pointer address to permit correct
+ * iteration over modules of, at least, kallsyms for preemptible operations,
+ * such as read(). Sorting by struct module pointer address is equivalent to
+ * sort by list node address.
  */
 static int __link_module(void *_mod)
 {
-	struct module *mod = _mod;
+	struct module *mod = _mod, *iter;
+
+	list_for_each_entry_reverse(iter, &modules, list) {
+		BUG_ON(iter == mod);	/* Should never be in the list twice */
+		if (iter < mod) {
+			/* We belong to the location right after iter. */
+			list_add(&mod->list, &iter->list);
+			return 0;
+		}
+	}
+	/* We should be added at the head of the list */
 	list_add(&mod->list, &modules);
 	return 0;
 }
@@ -2402,12 +2418,14 @@ unsigned long module_kallsyms_lookup_nam
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	mutex_lock(&module_mutex);
-	return seq_list_start(&modules, *pos);
+	if (!*pos)
+		m->private = NULL;
+	return seq_sorted_list_start(&modules, m->private);
 }
 
 static void *m_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	return seq_list_next(p, &modules, pos);
+	return seq_sorted_list_next(p, &modules, &m->private);
 }
 
 static void m_stop(struct seq_file *m, void *p)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
