Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZGUJnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZGUJnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 05:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZGUJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 05:43:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55113 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbZGUJnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 05:43:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Jul 2009 18:41:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       xiyou.wangcong@gmail.com, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com, y-goto@jp.fujitsu.com
Subject: [RFC][PATCH 3/3] kcore: rebuild RAM information based on io
 resource information
Message-Id: <20090721184117.bd9c44da.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090721183628.edbb7b99.kamezawa.hiroyu@jp.fujitsu.com>
References: <m11vpqvozl.fsf@fess.ebiederm.org>
	<20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
	<m1tz2ei54r.fsf@fess.ebiederm.org>
	<20090618044055.GB6133@cr0.nay.redhat.com>
	<m1prd2rtdf.fsf@fess.ebiederm.org>
	<20090622085405.GA6499@cr0.nay.redhat.com>
	<20090630100850.GD5873@cr0.nay.redhat.com>
	<20090701144742.6ce3535b.akpm@linux-foundation.org>
	<m14otwq94e.fsf@fess.ebiederm.org>
	<20090701171249.004968e8.akpm@linux-foundation.org>
	<20090702094138.f86ead92.kamezawa.hiroyu@jp.fujitsu.com>
	<20090717152955.6585cbf9.akpm@linux-foundation.org>
	<20090721183628.edbb7b99.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

For /proc/kcore, each arch registers its memory range by kclist_add().
In usual,
	- range of physical memory
	- range of vmalloc area
	- text, etc...
are registered but "range of physical memory" has some troubles.
It doesn't updated at memory hotplug and it tend to include
unnecessary memory holes. Now, /proc/iomem (kernel/resource.c)
includes required physical memory range information and it's
properly updated at memory hotplug. Then, it's good to avoid
using its own code(duplicating information) and to rebuild
kclist for physical memory based on /proc/iomem.

By this, per-arch kclist_add() for KCORE_RAM can be dropped.


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.31-Jul16/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/fs/proc/kcore.c	2009-07-20 20:44:57.000000000 +0900
+++ mmotm-2.6.31-Jul16/fs/proc/kcore.c	2009-07-20 22:01:52.000000000 +0900
@@ -21,6 +21,9 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/list.h>
+#include <linux/ioport.h>
+#include <linux/memory_hotplug.h>
+#include <linux/memory.h>
 
 #define CORE_STR "CORE"
 
@@ -30,17 +33,6 @@
 
 static struct proc_dir_entry *proc_root_kcore;
 
-static int open_kcore(struct inode * inode, struct file * filp)
-{
-	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
-}
-
-static ssize_t read_kcore(struct file *, char __user *, size_t, loff_t *);
-
-static const struct file_operations proc_kcore_operations = {
-	.read		= read_kcore,
-	.open		= open_kcore,
-};
 
 #ifndef kc_vaddr_to_offset
 #define	kc_vaddr_to_offset(v) ((v) - PAGE_OFFSET)
@@ -60,6 +52,7 @@
 
 static LIST_HEAD(kclist_head);
 static DEFINE_RWLOCK(kclist_lock);
+static int kcore_need_update;
 
 void
 kclist_add(struct kcore_list *new, void *addr, size_t size, int type)
@@ -98,6 +91,104 @@
 	return size + *elf_buflen;
 }
 
+static void free_kclist_ents(struct list_head *head)
+{
+	struct kcore_list *tmp, *pos;
+
+	list_for_each_entry_safe(pos, tmp, head, list) {
+		list_del(&pos->list);
+		kfree(pos);
+	}
+}
+/*
+ * Replace all KCORE_RAM information with passed list.
+ */
+static void __kcore_update_ram(struct list_head *list)
+{
+	struct kcore_list *tmp, *pos;
+	LIST_HEAD(garbage);
+
+	write_lock(&kclist_lock);
+	if (kcore_need_update) {
+		list_for_each_entry_safe(pos, tmp, &kclist_head, list) {
+			if (pos->type == KCORE_RAM)
+				list_move(&pos->list, &garbage);
+		}
+		list_splice(list, &kclist_head);
+	} else
+		list_splice(list, &garbage);
+	kcore_need_update = 0;
+	write_unlock(&kclist_lock);
+
+	free_kclist_ents(&garbage);
+}
+
+
+#ifdef CONFIG_HIGHMEM
+/*
+ * If no highmem, we can assume [0...max_low_pfn) continuous range of memory
+ * because memory hole is not as big as !HIGHMEM case.
+ * (HIGHMEM is special because part of memory is _invisible_ from the kernel.)
+ */
+static int kcore_update_ram(void)
+{
+	LIST_HEAD(head);
+	struct kcore_list *ent;
+	int ret = 0;
+
+	ent = kmalloc(sizeof(*head), GFP_KERNEL);
+	if (!ent) {
+		ret = -ENOMEM;
+		goto unlock_out;
+	}
+	ent->addr = __va(0);
+	ent->size = max_low_pfn << PAGE_SHIFT;
+	ent->type = SYSTEM_RAM;
+	list_add(&ent->list, &head);
+	__kcore_update_ram(&head);
+	return ret;
+}
+
+#else /* !CONFIG_HIGHMEM */
+
+static int
+kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
+{
+	struct list_head *head = (struct list_head *)arg;
+	struct kcore_list *ent;
+
+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+	ent->addr = (unsigned long)__va((pfn << PAGE_SHIFT));
+	ent->size = nr_pages << PAGE_SHIFT;
+	ent->type = KCORE_RAM;
+	list_add(&ent->list, head);
+	return 0;
+}
+
+static int kcore_update_ram(void)
+{
+	int nid, ret;
+	unsigned long end_pfn;
+	LIST_HEAD(head);
+
+	/* Not inialized....update now */
+	/* find out "max pfn" */
+	end_pfn = 0;
+	for_each_node_state(nid, N_HIGH_MEMORY)
+		if (end_pfn < node_end_pfn(nid))
+			end_pfn = node_end_pfn(nid);
+	/* scan 0 to max_pfn */
+	ret = walk_memory_resource(0, end_pfn, &head, kclist_add_private);
+	if (ret) {
+		free_kclist_ents(&head);
+		return -ENOMEM;
+	}
+	__kcore_update_ram(&head);
+	return ret;
+}
+#endif /* CONFIG_HIGH_MEM */
 
 /*****************************************************************************/
 /*
@@ -271,6 +362,11 @@
 		read_unlock(&kclist_lock);
 		return 0;
 	}
+	/* memory hotplug ?? */
+	if (kcore_need_update) {
+		read_unlock(&kclist_lock);
+		return -EBUSY;
+	}
 
 	/* trim buflen to not go beyond EOF */
 	if (buflen > size - *fpos)
@@ -406,9 +502,42 @@
 	return acc;
 }
 
+static int open_kcore(struct inode * inode, struct file *filp)
+{
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+	if (kcore_need_update)
+		kcore_update_ram();
+	return 0;
+}
+
+
+static const struct file_operations proc_kcore_operations = {
+	.read		= read_kcore,
+	.open		= open_kcore,
+};
+
+/* just remember that we have to update kcore */
+static int __meminit kcore_callback(struct notifier_block *self,
+				    unsigned long action, void *arg)
+{
+	switch (action) {
+	case MEM_ONLINE:
+	case MEM_OFFLINE:
+		write_lock(&kclist_lock);
+		kcore_need_update = 1;
+		write_unlock(&kclist_lock);
+	}
+	return NOTIFY_OK;
+}
+
+
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
+	kcore_update_ram();
+	hotplug_memory_notifier(kcore_callback, 0);
 	return 0;
 }
 module_init(proc_kcore_init);
+
Index: mmotm-2.6.31-Jul16/include/linux/ioport.h
===================================================================
--- mmotm-2.6.31-Jul16.orig/include/linux/ioport.h	2009-07-20 20:44:57.000000000 +0900
+++ mmotm-2.6.31-Jul16/include/linux/ioport.h	2009-07-20 20:45:10.000000000 +0900
@@ -186,5 +186,13 @@
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
 extern int iomem_is_exclusive(u64 addr);
 
+/*
+ * Walk through all SYSTEM_RAM which is registered as resource.
+ * arg is (start_pfn, nr_pages, private_arg_pointer)
+ */
+extern int walk_memory_resource(unsigned long start_pfn,
+			unsigned long nr_pages, void *arg,
+			int (*func)(unsigned long, unsigned long, void *));
+
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
Index: mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
===================================================================
--- mmotm-2.6.31-Jul16.orig/include/linux/memory_hotplug.h	2009-07-20 20:44:57.000000000 +0900
+++ mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h	2009-07-20 20:45:10.000000000 +0900
@@ -191,13 +191,6 @@
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
-/*
- * Walk through all memory which is registered as resource.
- * arg is (start_pfn, nr_pages, private_arg_pointer)
- */
-extern int walk_memory_resource(unsigned long start_pfn,
-			unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *));
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
Index: mmotm-2.6.31-Jul16/kernel/resource.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/kernel/resource.c	2009-07-20 20:44:57.000000000 +0900
+++ mmotm-2.6.31-Jul16/kernel/resource.c	2009-07-20 20:45:10.000000000 +0900
@@ -234,7 +234,7 @@
 
 EXPORT_SYMBOL(release_resource);
 
-#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
 /*
  * Finds the lowest memory reosurce exists within [res->start.res->end)
  * the caller must specify res->start, res->end, res->flags.
Index: mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/arch/ia64/mm/init.c	2009-07-20 19:29:53.000000000 +0900
+++ mmotm-2.6.31-Jul16/arch/ia64/mm/init.c	2009-07-20 21:20:24.000000000 +0900
@@ -639,7 +639,6 @@
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
 			VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
Index: mmotm-2.6.31-Jul16/arch/mips/mm/init.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/arch/mips/mm/init.c	2009-07-20 19:39:16.000000000 +0900
+++ mmotm-2.6.31-Jul16/arch/mips/mm/init.c	2009-07-20 21:20:55.000000000 +0900
@@ -412,7 +412,6 @@
 		kclist_add(&kcore_kseg0, (void *) CKSEG0,
 				0x80000000 - 4, KCORE_TEXT);
 #endif
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/init_32.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/init_32.c	2009-07-20 19:41:13.000000000 +0900
+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/init_32.c	2009-07-20 21:21:54.000000000 +0900
@@ -249,30 +249,6 @@
 
 static int __init setup_kcore(void)
 {
-	int i;
-
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		unsigned long base;
-		unsigned long size;
-		struct kcore_list *kcore_mem;
-
-		base = lmb.memory.region[i].base;
-		size = lmb.memory.region[i].size;
-
-		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
-		if (!kcore_mem)
-			panic("%s: kmalloc failed\n", __func__);
-
-		/* must stay under 32 bits */
-		if ( 0xfffffffful - (unsigned long)__va(base) < size) {
-			size = 0xfffffffful - (unsigned long)(__va(base));
-			printk(KERN_DEBUG "setup_kcore: restrict size=%lx\n",
-						size);
-		}
-
-		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
-	}
-
 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
 		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/init_64.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/init_64.c	2009-07-20 19:42:06.000000000 +0900
+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/init_64.c	2009-07-20 21:22:20.000000000 +0900
@@ -114,23 +114,6 @@
 
 static int __init setup_kcore(void)
 {
-	int i;
-
-	for (i=0; i < lmb.memory.cnt; i++) {
-		unsigned long base, size;
-		struct kcore_list *kcore_mem;
-
-		base = lmb.memory.region[i].base;
-		size = lmb.memory.region[i].size;
-
-		/* GFP_ATOMIC to avoid might_sleep warnings during boot */
-		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
-		if (!kcore_mem)
-			panic("%s: kmalloc failed\n", __func__);
-
-		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
-	}
-
 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
 		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
Index: mmotm-2.6.31-Jul16/arch/sh/mm/init.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/arch/sh/mm/init.c	2009-07-20 19:43:19.000000000 +0900
+++ mmotm-2.6.31-Jul16/arch/sh/mm/init.c	2009-07-20 21:22:52.000000000 +0900
@@ -218,7 +218,6 @@
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		   VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
 
Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_32.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_32.c	2009-07-20 19:44:21.000000000 +0900
+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_32.c	2009-07-20 21:23:36.000000000 +0900
@@ -886,7 +886,6 @@
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_64.c	2009-07-20 19:45:45.000000000 +0900
+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c	2009-07-20 21:24:28.000000000 +0900
@@ -677,7 +677,6 @@
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);

