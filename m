Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZGVGJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZGVGJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 02:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbZGVGJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 02:09:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50593 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbZGVGJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 02:09:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 22 Jul 2009 15:08:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] kcore: build physical memory direct map information
 in proper way
Message-Id: <20090722150804.7dd4abaf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722060900.GD6281@cr0.nay.redhat.com>
References: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com>
	<20090722141024.0c6bf382.kamezawa.hiroyu@jp.fujitsu.com>
	<20090722060900.GD6281@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 14:09:00 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> >+static int kcore_update_ram(void)
> >+{
> >+	LIST_HEAD(head);
> >+	struct kcore_list *ent;
> >+	int ret = 0;
> >+
> >+	ent = kmalloc(sizeof(*head), GFP_KERNEL);
> 
yes, of course.

> 
> Shouldn't it be sizeof(*ent)? :)
> 
> 
> >+	if (!ent) {
> >+		ret = -ENOMEM;
> >+		goto unlock_out;
> 
> 
> Where is unlock_out? :)
> 
> 

Hmm...garbage from old patch, sorry.


> >+	}
> >+	ent->addr = __va(0);
> >+	ent->size = max_low_pfn << PAGE_SHIFT;
> >+	ent->type = SYSTEM_RAM;
> 
> 
> Huh? SYSTEM_RAM or KCORE_RAM?
> 
> 

KCORE_RAM ... ah, ok. I tested only on x86-64 and this HIGHMEM is wasn't 
compiled. Very sorry.

I"ll post fixed one soon.

Thanks,
-Kame


> >+	list_add(&ent->list, &head);
> >+	__kcore_update_ram(&head);
> >+	return ret;
> >+}
> >+
> >+#else /* !CONFIG_HIGHMEM */
> >+
> >+static int
> >+kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
> >+{
> >+	struct list_head *head = (struct list_head *)arg;
> >+	struct kcore_list *ent;
> >+
> >+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
> >+	if (!ent)
> >+		return -ENOMEM;
> >+	ent->addr = (unsigned long)__va((pfn << PAGE_SHIFT));
> >+	ent->size = nr_pages << PAGE_SHIFT;
> >+	ent->type = KCORE_RAM;
> >+	list_add(&ent->list, head);
> >+	return 0;
> >+}
> >+
> >+static int kcore_update_ram(void)
> >+{
> >+	int nid, ret;
> >+	unsigned long end_pfn;
> >+	LIST_HEAD(head);
> >+
> >+	/* Not inialized....update now */
> >+	/* find out "max pfn" */
> >+	end_pfn = 0;
> >+	for_each_node_state(nid, N_HIGH_MEMORY)
> >+		if (end_pfn < node_end_pfn(nid))
> >+			end_pfn = node_end_pfn(nid);
> >+	/* scan 0 to max_pfn */
> >+	ret = walk_memory_resource(0, end_pfn, &head, kclist_add_private);
> >+	if (ret) {
> >+		free_kclist_ents(&head);
> >+		return -ENOMEM;
> >+	}
> >+	__kcore_update_ram(&head);
> >+	return ret;
> >+}
> >+#endif /* CONFIG_HIGH_MEM */
> > 
> > /*****************************************************************************/
> > /*
> >@@ -271,6 +362,11 @@ read_kcore(struct file *file, char __use
> > 		read_unlock(&kclist_lock);
> > 		return 0;
> > 	}
> >+	/* memory hotplug ?? */
> >+	if (kcore_need_update) {
> >+		read_unlock(&kclist_lock);
> >+		return -EBUSY;
> >+	}
> > 
> > 	/* trim buflen to not go beyond EOF */
> > 	if (buflen > size - *fpos)
> >@@ -406,9 +502,42 @@ read_kcore(struct file *file, char __use
> > 	return acc;
> > }
> > 
> >+static int open_kcore(struct inode * inode, struct file *filp)
> >+{
> >+	if (!capable(CAP_SYS_RAWIO))
> >+		return -EPERM;
> >+	if (kcore_need_update)
> >+		kcore_update_ram();
> >+	return 0;
> >+}
> >+
> >+
> >+static const struct file_operations proc_kcore_operations = {
> >+	.read		= read_kcore,
> >+	.open		= open_kcore,
> >+};
> >+
> >+/* just remember that we have to update kcore */
> >+static int __meminit kcore_callback(struct notifier_block *self,
> >+				    unsigned long action, void *arg)
> >+{
> >+	switch (action) {
> >+	case MEM_ONLINE:
> >+	case MEM_OFFLINE:
> >+		write_lock(&kclist_lock);
> >+		kcore_need_update = 1;
> >+		write_unlock(&kclist_lock);
> >+	}
> >+	return NOTIFY_OK;
> >+}
> >+
> >+
> > static int __init proc_kcore_init(void)
> > {
> > 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
> >+	kcore_update_ram();
> >+	hotplug_memory_notifier(kcore_callback, 0);
> > 	return 0;
> > }
> > module_init(proc_kcore_init);
> >+
> >Index: mmotm-2.6.31-Jul16/include/linux/ioport.h
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/include/linux/ioport.h
> >+++ mmotm-2.6.31-Jul16/include/linux/ioport.h
> >@@ -186,5 +186,13 @@ extern void __devm_release_region(struct
> > extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
> > extern int iomem_is_exclusive(u64 addr);
> > 
> >+/*
> >+ * Walk through all SYSTEM_RAM which is registered as resource.
> >+ * arg is (start_pfn, nr_pages, private_arg_pointer)
> >+ */
> >+extern int walk_memory_resource(unsigned long start_pfn,
> >+			unsigned long nr_pages, void *arg,
> >+			int (*func)(unsigned long, unsigned long, void *));
> >+
> > #endif /* __ASSEMBLY__ */
> > #endif	/* _LINUX_IOPORT_H */
> >Index: mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/include/linux/memory_hotplug.h
> >+++ mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
> >@@ -191,13 +191,6 @@ static inline void register_page_bootmem
> > 
> > #endif /* ! CONFIG_MEMORY_HOTPLUG */
> > 
> >-/*
> >- * Walk through all memory which is registered as resource.
> >- * arg is (start_pfn, nr_pages, private_arg_pointer)
> >- */
> >-extern int walk_memory_resource(unsigned long start_pfn,
> >-			unsigned long nr_pages, void *arg,
> >-			int (*func)(unsigned long, unsigned long, void *));
> > 
> > #ifdef CONFIG_MEMORY_HOTREMOVE
> > 
> >Index: mmotm-2.6.31-Jul16/kernel/resource.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/kernel/resource.c
> >+++ mmotm-2.6.31-Jul16/kernel/resource.c
> >@@ -234,7 +234,7 @@ int release_resource(struct resource *ol
> > 
> > EXPORT_SYMBOL(release_resource);
> > 
> >-#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
> >+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
> > /*
> >  * Finds the lowest memory reosurce exists within [res->start.res->end)
> >  * the caller must specify res->start, res->end, res->flags.
> >Index: mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/arch/ia64/mm/init.c
> >+++ mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
> >@@ -639,7 +639,6 @@ mem_init (void)
> > 
> > 	high_memory = __va(max_low_pfn * PAGE_SIZE);
> > 
> >-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
> > 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
> > 			VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> > 	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
> >Index: mmotm-2.6.31-Jul16/arch/mips/mm/init.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/arch/mips/mm/init.c
> >+++ mmotm-2.6.31-Jul16/arch/mips/mm/init.c
> >@@ -412,7 +412,6 @@ void __init mem_init(void)
> > 		kclist_add(&kcore_kseg0, (void *) CKSEG0,
> > 				0x80000000 - 4, KCORE_TEXT);
> > #endif
> >-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
> > 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> > 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> > 
> >Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/init_32.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/init_32.c
> >+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/init_32.c
> >@@ -249,30 +249,6 @@ static struct kcore_list kcore_vmem;
> > 
> > static int __init setup_kcore(void)
> > {
> >-	int i;
> >-
> >-	for (i = 0; i < lmb.memory.cnt; i++) {
> >-		unsigned long base;
> >-		unsigned long size;
> >-		struct kcore_list *kcore_mem;
> >-
> >-		base = lmb.memory.region[i].base;
> >-		size = lmb.memory.region[i].size;
> >-
> >-		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
> >-		if (!kcore_mem)
> >-			panic("%s: kmalloc failed\n", __func__);
> >-
> >-		/* must stay under 32 bits */
> >-		if ( 0xfffffffful - (unsigned long)__va(base) < size) {
> >-			size = 0xfffffffful - (unsigned long)(__va(base));
> >-			printk(KERN_DEBUG "setup_kcore: restrict size=%lx\n",
> >-						size);
> >-		}
> >-
> >-		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
> >-	}
> >-
> > 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
> > 		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> > 
> >Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/init_64.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/init_64.c
> >+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/init_64.c
> >@@ -114,23 +114,6 @@ static struct kcore_list kcore_vmem;
> > 
> > static int __init setup_kcore(void)
> > {
> >-	int i;
> >-
> >-	for (i=0; i < lmb.memory.cnt; i++) {
> >-		unsigned long base, size;
> >-		struct kcore_list *kcore_mem;
> >-
> >-		base = lmb.memory.region[i].base;
> >-		size = lmb.memory.region[i].size;
> >-
> >-		/* GFP_ATOMIC to avoid might_sleep warnings during boot */
> >-		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
> >-		if (!kcore_mem)
> >-			panic("%s: kmalloc failed\n", __func__);
> >-
> >-		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
> >-	}
> >-
> > 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
> > 		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> > 
> >Index: mmotm-2.6.31-Jul16/arch/sh/mm/init.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/arch/sh/mm/init.c
> >+++ mmotm-2.6.31-Jul16/arch/sh/mm/init.c
> >@@ -218,7 +218,6 @@ void __init mem_init(void)
> > 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
> > 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> > 
> >-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
> > 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> > 		   VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
> > 
> >Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_32.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_32.c
> >+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_32.c
> >@@ -886,7 +886,6 @@ void __init mem_init(void)
> > 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
> > 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> > 
> >-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
> > 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> > 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> > 
> >Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_64.c
> >+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
> >@@ -677,7 +677,6 @@ void __init mem_init(void)
> > 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> > 
> > 	/* Register memory areas for /proc/kcore */
> >-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
> > 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
> > 		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> > 	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> 

