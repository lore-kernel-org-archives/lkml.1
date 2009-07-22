Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZGVGGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZGVGGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 02:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZGVGGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 02:06:50 -0400
Received: from mail-px0-f186.google.com ([209.85.216.186]:58406 "EHLO
	mail-px0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbZGVGGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 02:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k2Co9EuGRKAP7wd6NTiCL6QVFm8WTDrOeCQSOOFLgesMi+hygkEAep3O7YpdGA4f3e
         cDe/dfxAHYtjNHOQTgisf9Xt9Sw0LDypTcCPhpEbAQzgoHQKBQP8ZUB0vXNiUf50DFIJ
         rQIYY+m6JXv30HlY3ydudFO43T1Jj9l/5W4Ls=
Date: Wed, 22 Jul 2009 14:09:00 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] kcore: build physical memory direct map
	information in proper way
Message-ID: <20090722060900.GD6281@cr0.nay.redhat.com>
References: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com> <20090722141024.0c6bf382.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722141024.0c6bf382.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 02:10:24PM +0900, KAMEZAWA Hiroyuki wrote:
>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>For /proc/kcore, each arch registers its memory range by kclist_add().
>In usual,
>	- range of physical memory
>	- range of vmalloc area
>	- text, etc...
>are registered but "range of physical memory" has some troubles.
>It doesn't updated at memory hotplug and it tend to include
>unnecessary memory holes. Now, /proc/iomem (kernel/resource.c)
>includes required physical memory range information and it's
>properly updated at memory hotplug. Then, it's good to avoid
>using its own code(duplicating information) and to rebuild
>kclist for physical memory based on /proc/iomem.
>


Please see my comments below.


>Note: walk_memory_resource() works based on lmb inforamtion in PPC
>but no problem. It's updated at memory hotplug.
>
>Changelog: v1 -> v2
> - removed -EBUSY at memory hotplug in read_kcore()
>   (continue reading is no problem in general.)
> - fixed initial value of kcore_need_update to be 1.
>
>Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>---
> arch/ia64/mm/init.c            |    1 
> arch/mips/mm/init.c            |    1 
> arch/powerpc/mm/init_32.c      |   24 ------
> arch/powerpc/mm/init_64.c      |   17 ----
> arch/sh/mm/init.c              |    1 
> arch/x86/mm/init_32.c          |    1 
> arch/x86/mm/init_64.c          |    1 
> fs/proc/kcore.c                |  151 ++++++++++++++++++++++++++++++++++++++---
> include/linux/ioport.h         |    8 ++
> include/linux/memory_hotplug.h |    7 -
> kernel/resource.c              |    2 
> 11 files changed, 149 insertions(+), 65 deletions(-)
>
>Index: mmotm-2.6.31-Jul16/fs/proc/kcore.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/fs/proc/kcore.c
>+++ mmotm-2.6.31-Jul16/fs/proc/kcore.c
>@@ -21,6 +21,9 @@
> #include <asm/uaccess.h>
> #include <asm/io.h>
> #include <linux/list.h>
>+#include <linux/ioport.h>
>+#include <linux/memory_hotplug.h>
>+#include <linux/memory.h>
> 
> #define CORE_STR "CORE"
> 
>@@ -30,17 +33,6 @@
> 
> static struct proc_dir_entry *proc_root_kcore;
> 
>-static int open_kcore(struct inode * inode, struct file * filp)
>-{
>-	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
>-}
>-
>-static ssize_t read_kcore(struct file *, char __user *, size_t, loff_t *);
>-
>-static const struct file_operations proc_kcore_operations = {
>-	.read		= read_kcore,
>-	.open		= open_kcore,
>-};
> 
> #ifndef kc_vaddr_to_offset
> #define	kc_vaddr_to_offset(v) ((v) - PAGE_OFFSET)
>@@ -60,6 +52,7 @@ struct memelfnote
> 
> static LIST_HEAD(kclist_head);
> static DEFINE_RWLOCK(kclist_lock);
>+static int kcore_need_update = 1;
> 
> void
> kclist_add(struct kcore_list *new, void *addr, size_t size, int type)
>@@ -98,6 +91,104 @@ static size_t get_kcore_size(int *nphdr,
> 	return size + *elf_buflen;
> }
> 
>+static void free_kclist_ents(struct list_head *head)
>+{
>+	struct kcore_list *tmp, *pos;
>+
>+	list_for_each_entry_safe(pos, tmp, head, list) {
>+		list_del(&pos->list);
>+		kfree(pos);
>+	}
>+}
>+/*
>+ * Replace all KCORE_RAM information with passed list.
>+ */
>+static void __kcore_update_ram(struct list_head *list)
>+{
>+	struct kcore_list *tmp, *pos;
>+	LIST_HEAD(garbage);
>+
>+	write_lock(&kclist_lock);
>+	if (kcore_need_update) {
>+		list_for_each_entry_safe(pos, tmp, &kclist_head, list) {
>+			if (pos->type == KCORE_RAM)
>+				list_move(&pos->list, &garbage);
>+		}
>+		list_splice(list, &kclist_head);
>+	} else
>+		list_splice(list, &garbage);
>+	kcore_need_update = 0;
>+	write_unlock(&kclist_lock);
>+
>+	free_kclist_ents(&garbage);
>+}
>+
>+
>+#ifdef CONFIG_HIGHMEM
>+/*
>+ * If no highmem, we can assume [0...max_low_pfn) continuous range of memory
>+ * because memory hole is not as big as !HIGHMEM case.
>+ * (HIGHMEM is special because part of memory is _invisible_ from the kernel.)
>+ */
>+static int kcore_update_ram(void)
>+{
>+	LIST_HEAD(head);
>+	struct kcore_list *ent;
>+	int ret = 0;
>+
>+	ent = kmalloc(sizeof(*head), GFP_KERNEL);


Shouldn't it be sizeof(*ent)? :)


>+	if (!ent) {
>+		ret = -ENOMEM;
>+		goto unlock_out;


Where is unlock_out? :)


>+	}
>+	ent->addr = __va(0);
>+	ent->size = max_low_pfn << PAGE_SHIFT;
>+	ent->type = SYSTEM_RAM;


Huh? SYSTEM_RAM or KCORE_RAM?


>+	list_add(&ent->list, &head);
>+	__kcore_update_ram(&head);
>+	return ret;
>+}
>+
>+#else /* !CONFIG_HIGHMEM */
>+
>+static int
>+kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
>+{
>+	struct list_head *head = (struct list_head *)arg;
>+	struct kcore_list *ent;
>+
>+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
>+	if (!ent)
>+		return -ENOMEM;
>+	ent->addr = (unsigned long)__va((pfn << PAGE_SHIFT));
>+	ent->size = nr_pages << PAGE_SHIFT;
>+	ent->type = KCORE_RAM;
>+	list_add(&ent->list, head);
>+	return 0;
>+}
>+
>+static int kcore_update_ram(void)
>+{
>+	int nid, ret;
>+	unsigned long end_pfn;
>+	LIST_HEAD(head);
>+
>+	/* Not inialized....update now */
>+	/* find out "max pfn" */
>+	end_pfn = 0;
>+	for_each_node_state(nid, N_HIGH_MEMORY)
>+		if (end_pfn < node_end_pfn(nid))
>+			end_pfn = node_end_pfn(nid);
>+	/* scan 0 to max_pfn */
>+	ret = walk_memory_resource(0, end_pfn, &head, kclist_add_private);
>+	if (ret) {
>+		free_kclist_ents(&head);
>+		return -ENOMEM;
>+	}
>+	__kcore_update_ram(&head);
>+	return ret;
>+}
>+#endif /* CONFIG_HIGH_MEM */
> 
> /*****************************************************************************/
> /*
>@@ -271,6 +362,11 @@ read_kcore(struct file *file, char __use
> 		read_unlock(&kclist_lock);
> 		return 0;
> 	}
>+	/* memory hotplug ?? */
>+	if (kcore_need_update) {
>+		read_unlock(&kclist_lock);
>+		return -EBUSY;
>+	}
> 
> 	/* trim buflen to not go beyond EOF */
> 	if (buflen > size - *fpos)
>@@ -406,9 +502,42 @@ read_kcore(struct file *file, char __use
> 	return acc;
> }
> 
>+static int open_kcore(struct inode * inode, struct file *filp)
>+{
>+	if (!capable(CAP_SYS_RAWIO))
>+		return -EPERM;
>+	if (kcore_need_update)
>+		kcore_update_ram();
>+	return 0;
>+}
>+
>+
>+static const struct file_operations proc_kcore_operations = {
>+	.read		= read_kcore,
>+	.open		= open_kcore,
>+};
>+
>+/* just remember that we have to update kcore */
>+static int __meminit kcore_callback(struct notifier_block *self,
>+				    unsigned long action, void *arg)
>+{
>+	switch (action) {
>+	case MEM_ONLINE:
>+	case MEM_OFFLINE:
>+		write_lock(&kclist_lock);
>+		kcore_need_update = 1;
>+		write_unlock(&kclist_lock);
>+	}
>+	return NOTIFY_OK;
>+}
>+
>+
> static int __init proc_kcore_init(void)
> {
> 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
>+	kcore_update_ram();
>+	hotplug_memory_notifier(kcore_callback, 0);
> 	return 0;
> }
> module_init(proc_kcore_init);
>+
>Index: mmotm-2.6.31-Jul16/include/linux/ioport.h
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/include/linux/ioport.h
>+++ mmotm-2.6.31-Jul16/include/linux/ioport.h
>@@ -186,5 +186,13 @@ extern void __devm_release_region(struct
> extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
> extern int iomem_is_exclusive(u64 addr);
> 
>+/*
>+ * Walk through all SYSTEM_RAM which is registered as resource.
>+ * arg is (start_pfn, nr_pages, private_arg_pointer)
>+ */
>+extern int walk_memory_resource(unsigned long start_pfn,
>+			unsigned long nr_pages, void *arg,
>+			int (*func)(unsigned long, unsigned long, void *));
>+
> #endif /* __ASSEMBLY__ */
> #endif	/* _LINUX_IOPORT_H */
>Index: mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/include/linux/memory_hotplug.h
>+++ mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
>@@ -191,13 +191,6 @@ static inline void register_page_bootmem
> 
> #endif /* ! CONFIG_MEMORY_HOTPLUG */
> 
>-/*
>- * Walk through all memory which is registered as resource.
>- * arg is (start_pfn, nr_pages, private_arg_pointer)
>- */
>-extern int walk_memory_resource(unsigned long start_pfn,
>-			unsigned long nr_pages, void *arg,
>-			int (*func)(unsigned long, unsigned long, void *));
> 
> #ifdef CONFIG_MEMORY_HOTREMOVE
> 
>Index: mmotm-2.6.31-Jul16/kernel/resource.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/kernel/resource.c
>+++ mmotm-2.6.31-Jul16/kernel/resource.c
>@@ -234,7 +234,7 @@ int release_resource(struct resource *ol
> 
> EXPORT_SYMBOL(release_resource);
> 
>-#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
>+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
> /*
>  * Finds the lowest memory reosurce exists within [res->start.res->end)
>  * the caller must specify res->start, res->end, res->flags.
>Index: mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/ia64/mm/init.c
>+++ mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
>@@ -639,7 +639,6 @@ mem_init (void)
> 
> 	high_memory = __va(max_low_pfn * PAGE_SIZE);
> 
>-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
> 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
> 			VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
>Index: mmotm-2.6.31-Jul16/arch/mips/mm/init.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/mips/mm/init.c
>+++ mmotm-2.6.31-Jul16/arch/mips/mm/init.c
>@@ -412,7 +412,6 @@ void __init mem_init(void)
> 		kclist_add(&kcore_kseg0, (void *) CKSEG0,
> 				0x80000000 - 4, KCORE_TEXT);
> #endif
>-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
> 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 
>Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/init_32.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/init_32.c
>+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/init_32.c
>@@ -249,30 +249,6 @@ static struct kcore_list kcore_vmem;
> 
> static int __init setup_kcore(void)
> {
>-	int i;
>-
>-	for (i = 0; i < lmb.memory.cnt; i++) {
>-		unsigned long base;
>-		unsigned long size;
>-		struct kcore_list *kcore_mem;
>-
>-		base = lmb.memory.region[i].base;
>-		size = lmb.memory.region[i].size;
>-
>-		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
>-		if (!kcore_mem)
>-			panic("%s: kmalloc failed\n", __func__);
>-
>-		/* must stay under 32 bits */
>-		if ( 0xfffffffful - (unsigned long)__va(base) < size) {
>-			size = 0xfffffffful - (unsigned long)(__va(base));
>-			printk(KERN_DEBUG "setup_kcore: restrict size=%lx\n",
>-						size);
>-		}
>-
>-		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
>-	}
>-
> 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
> 		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 
>Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/init_64.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/init_64.c
>+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/init_64.c
>@@ -114,23 +114,6 @@ static struct kcore_list kcore_vmem;
> 
> static int __init setup_kcore(void)
> {
>-	int i;
>-
>-	for (i=0; i < lmb.memory.cnt; i++) {
>-		unsigned long base, size;
>-		struct kcore_list *kcore_mem;
>-
>-		base = lmb.memory.region[i].base;
>-		size = lmb.memory.region[i].size;
>-
>-		/* GFP_ATOMIC to avoid might_sleep warnings during boot */
>-		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
>-		if (!kcore_mem)
>-			panic("%s: kmalloc failed\n", __func__);
>-
>-		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
>-	}
>-
> 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
> 		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 
>Index: mmotm-2.6.31-Jul16/arch/sh/mm/init.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/sh/mm/init.c
>+++ mmotm-2.6.31-Jul16/arch/sh/mm/init.c
>@@ -218,7 +218,6 @@ void __init mem_init(void)
> 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
> 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> 
>-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
> 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> 		   VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
> 
>Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_32.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_32.c
>+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_32.c
>@@ -886,7 +886,6 @@ void __init mem_init(void)
> 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
> 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> 
>-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
> 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 
>Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_64.c
>+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
>@@ -677,7 +677,6 @@ void __init mem_init(void)
> 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> 
> 	/* Register memory areas for /proc/kcore */
>-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
> 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
