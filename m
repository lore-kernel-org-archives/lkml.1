Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbZHaKKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbZHaKKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZHaKKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:10:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40427 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZHaKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:10:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Aug 2009 19:08:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       jirislaby@gmail.com
Subject: [PATCH 6/8][mmotm] kcore use registerd physmem information
Message-Id: <20090831190812.02e390eb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: kcore: use registered physmem information
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

For /proc/kcore, each arch registers its memory range by kclist_add().
In usual,

	- range of physical memory
	- range of vmalloc area
	- text, etc...

are registered but "range of physical memory" has some troubles.  It
doesn't updated at memory hotplug and it tend to include unnecessary
memory holes.  Now, /proc/iomem (kernel/resource.c) includes required
physical memory range information and it's properly updated at memory
hotplug.  Then, it's good to avoid using its own code(duplicating
information) and to rebuild kclist for physical memory based on
/proc/iomem.

Changelog:
 - merged compile fix by Andrew Morton <akpm@linux-foundation.org>
 - fixed non-NUMA compile error pointed out by Jiri Slaby <jirislaby@gmail.com> 
 - fixed error path returns success code.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c       |    2 
 arch/powerpc/mm/init_32.c |   32 --------
 arch/powerpc/mm/init_64.c |   26 ------
 arch/sh/mm/init.c         |    4 -
 arch/x86/mm/init_32.c     |    4 -
 arch/x86/mm/init_64.c     |    3 
 fs/proc/kcore.c           |  179 ++++++++++++++++++++++++++++++++++++++++++----
 7 files changed, 168 insertions(+), 82 deletions(-)

Index: mmotm-2.6.31-Aug27/arch/mips/mm/init.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/mips/mm/init.c
+++ mmotm-2.6.31-Aug27/arch/mips/mm/init.c
@@ -352,7 +352,6 @@ void __init paging_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
-static struct kcore_list kcore_mem;
 #ifdef CONFIG_64BIT
 static struct kcore_list kcore_kseg0;
 #endif
@@ -412,7 +411,6 @@ void __init mem_init(void)
 		kclist_add(&kcore_kseg0, (void *) CKSEG0,
 				0x80000000 - 4, KCORE_TEXT);
 #endif
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
Index: mmotm-2.6.31-Aug27/arch/powerpc/mm/init_32.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/powerpc/mm/init_32.c
+++ mmotm-2.6.31-Aug27/arch/powerpc/mm/init_32.c
@@ -242,35 +242,3 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-#ifdef CONFIG_PROC_KCORE
-
-static int __init setup_kcore(void)
-{
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
-	return 0;
-}
-module_init(setup_kcore);
-#endif
Index: mmotm-2.6.31-Aug27/arch/powerpc/mm/init_64.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/powerpc/mm/init_64.c
+++ mmotm-2.6.31-Aug27/arch/powerpc/mm/init_64.c
@@ -109,32 +109,6 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-#ifdef CONFIG_PROC_KCORE
-
-static int __init setup_kcore(void)
-{
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
-	return 0;
-}
-module_init(setup_kcore);
-#endif
-
 static void pgd_ctor(void *addr)
 {
 	memset(addr, 0, PGD_TABLE_SIZE);
Index: mmotm-2.6.31-Aug27/arch/sh/mm/init.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/sh/mm/init.c
+++ mmotm-2.6.31-Aug27/arch/sh/mm/init.c
@@ -181,8 +181,6 @@ void __init paging_init(void)
 	set_fixmap_nocache(FIX_UNCACHED, __pa(&__uncached_start));
 }
 
-static struct kcore_list kcore_mem;
-
 void __init mem_init(void)
 {
 	int codesize, datasize, initsize;
@@ -218,8 +216,6 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 	       "%dk data, %dk init)\n",
 		nr_free_pages() << (PAGE_SHIFT-10),
Index: mmotm-2.6.31-Aug27/arch/x86/mm/init_32.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/x86/mm/init_32.c
+++ mmotm-2.6.31-Aug27/arch/x86/mm/init_32.c
@@ -857,8 +857,6 @@ static void __init test_wp_bit(void)
 	}
 }
 
-static struct kcore_list kcore_mem;
-
 void __init mem_init(void)
 {
 	int codesize, reservedpages, datasize, initsize;
@@ -886,8 +884,6 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
 		nr_free_pages() << (PAGE_SHIFT-10),
Index: mmotm-2.6.31-Aug27/arch/x86/mm/init_64.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/x86/mm/init_64.c
+++ mmotm-2.6.31-Aug27/arch/x86/mm/init_64.c
@@ -647,7 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static struct kcore_list kcore_mem, kcore_modules, kcore_vsyscall;
+static struct kcore_list kcore_modules, kcore_vsyscall;
 
 void __init mem_init(void)
 {
@@ -676,7 +676,6 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
 			KCORE_OTHER);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
Index: mmotm-2.6.31-Aug27/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Aug27/fs/proc/kcore.c
@@ -17,10 +17,14 @@
 #include <linux/elfcore.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
+#include <linux/bootmem.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/list.h>
+#include <linux/ioport.h>
+#include <linux/mm.h>
+#include <linux/memory.h>
 #include <asm/sections.h>
 
 #define CORE_STR "CORE"
@@ -31,17 +35,6 @@
 
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
@@ -61,6 +54,7 @@ struct memelfnote
 
 static LIST_HEAD(kclist_head);
 static DEFINE_RWLOCK(kclist_lock);
+static int kcore_need_update = 1;
 
 void
 kclist_add(struct kcore_list *new, void *addr, size_t size, int type)
@@ -99,6 +93,126 @@ static size_t get_kcore_size(int *nphdr,
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
+		list_splice_tail(list, &kclist_head);
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
+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+	ent->addr = (unsigned long)__va(0);
+	ent->size = max_low_pfn << PAGE_SHIFT;
+	ent->type = KCORE_RAM;
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
+
+	/* Sanity check: Can happen in 32bit arch...maybe */
+	if (ent->addr < (unsigned long) __va(0))
+		goto free_out;
+
+	/* cut not-mapped area. ....from ppc-32 code. */
+	if (ULONG_MAX - ent->addr < ent->size)
+		ent->size = ULONG_MAX - ent->addr;
+
+	/* cut when vmalloc() area is higher than direct-map area */
+	if (VMALLOC_START > (unsigned long)__va(0)) {
+		if (ent->addr > VMALLOC_START)
+			goto free_out;
+		if (VMALLOC_START - ent->addr < ent->size)
+			ent->size = VMALLOC_START - ent->addr;
+	}
+
+	ent->type = KCORE_RAM;
+	list_add_tail(&ent->list, head);
+	return 0;
+free_out:
+	kfree(ent);
+	return 1;
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
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		unsigned long node_end;
+		node_end  = NODE_DATA(nid)->node_start_pfn +
+			NODE_DATA(nid)->node_spanned_pages;
+		if (end_pfn < node_end)
+			end_pfn = node_end;
+	}
+	/* scan 0 to max_pfn */
+	ret = walk_system_ram_range(0, end_pfn, &head, kclist_add_private);
+	if (ret) {
+		free_kclist_ents(&head);
+		return -ENOMEM;
+	}
+	__kcore_update_ram(&head);
+	return ret;
+}
+#endif /* CONFIG_HIGHMEM */
 
 /*****************************************************************************/
 /*
@@ -373,6 +487,39 @@ read_kcore(struct file *file, char __use
 	return acc;
 }
 
+
+static int open_kcore(struct inode *inode, struct file *filp)
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
+#ifdef CONFIG_MEMORY_HOTPLUG
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
+#endif
+
+
 static struct kcore_list kcore_vmalloc;
 
 #ifdef CONFIG_ARCH_PROC_KCORE_TEXT
@@ -393,10 +540,18 @@ static void __init proc_kcore_text_init(
 
 static int __init proc_kcore_init(void)
 {
-	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
+	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
+				      &proc_kcore_operations);
+	/* Store text area if it's special */
 	proc_kcore_text_init();
+	/* Store vmalloc area */
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
+	/* Store direct-map area from physical memory map */
+	kcore_update_ram();
+	hotplug_memory_notifier(kcore_callback, 0);
+	/* Other special area, area-for-module etc is arch specific. */
+
 	return 0;
 }
 module_init(proc_kcore_init);

