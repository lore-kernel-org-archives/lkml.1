Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYHAJnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYHAJnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYHAJjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:39:00 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:14084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYHAJi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fOkZnKS+LcNBdG70CoJkBAAAQ7L5g7z+Cm4rzMSXCWuZHGwxdWcY0N6UJpEWkaXAGo
         2r6o5uQ7X1TMzLmGfcdfclRd2l42kPjCVE6VP0/rPJQtgh39SzBBc0ZXnBU9309HRw6C
         eiSSzlXmRo1T7jw7y2hYHcaLWhVCji+6TfLe8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 16/16] x86: alloc dyn_array all alltogether
Date: Fri,  1 Aug 2008 02:37:44 -0700
Message-Id: <1217583464-28494-17-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-16-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-9-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-10-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-11-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-12-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-13-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-14-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-15-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-16-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also tighten the alignment checking..., and make print out less

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_percpu.c |   16 ++++++----
 include/linux/init.h           |    2 -
 init/main.c                    |   65 +++++++++++++++++++++++++++++++----------
 3 files changed, 62 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -140,26 +140,31 @@ static void __init setup_cpu_pda_map(voi
  */
 void __init setup_per_cpu_areas(void)
 {
-	ssize_t size, old_size;
+	ssize_t size, old_size, da_size;
 	char *ptr;
 	int cpu;
+	unsigned long align = 1;
 
 	/* Setup cpu_pda map */
 	setup_cpu_pda_map();
 
 	/* Copy section for each CPU (we discard the original) */
 	old_size = PERCPU_ENOUGH_ROOM;
-	size = old_size + per_cpu_dyn_array_size();
+	da_size = per_cpu_dyn_array_size(&align);
+	align = max_t(unsigned long, PAGE_SIZE, align);
+	size = roundup(old_size + da_size, align);
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-		ptr = alloc_bootmem_pages(size);
+		ptr = __alloc_bootmem_nopanic(size, align,
+				 __pa(MAX_DMA_ADDRESS));
 #else
 		int node = early_cpu_to_node(cpu);
 		if (!node_online(node) || !NODE_DATA(node)) {
-			ptr = alloc_bootmem_pages(size);
+			ptr = __alloc_bootmem_nopanic(size, align,
+					 __pa(MAX_DMA_ADDRESS));
 			printk(KERN_INFO
 			       "cpu %d has no node %d or node-local memory\n",
 				cpu, node);
@@ -168,7 +173,8 @@ void __init setup_per_cpu_areas(void)
 					 cpu, __pa(ptr));
 		}
 		else {
-			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
+			ptr = __alloc_bootmem_node(NODE_DATA(node), size, align,
+							__pa(MAX_DMA_ADDRESS));
 			if (ptr)
 				printk(KERN_DEBUG "per cpu data for cpu%d on node%d at %016lx\n",
 					 cpu, node, __pa(ptr));
Index: linux-2.6/include/linux/init.h
===================================================================
--- linux-2.6.orig/include/linux/init.h
+++ linux-2.6/include/linux/init.h
@@ -291,7 +291,7 @@ extern struct dyn_array *__per_cpu_dyn_a
 	DEFINE_PER_CPU_DYN_ARRAY_ADDR(nameX, nameX, nrX, alignX, init_workX)
 
 extern void pre_alloc_dyn_array(void);
-extern unsigned long per_cpu_dyn_array_size(void);
+extern unsigned long per_cpu_dyn_array_size(unsigned long *align);
 extern void per_cpu_alloc_dyn_array(int cpu, char *ptr);
 #endif /* __ASSEMBLY__ */
 
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -397,10 +397,14 @@ static void __init setup_per_cpu_areas(v
 	unsigned long size, i, old_size;
 	char *ptr;
 	unsigned long nr_possible_cpus = num_possible_cpus();
+	unsigned long align = 1;
+	unsigned da_size;
 
 	/* Copy section for each CPU (we discard the original) */
 	old_size = PERCPU_ENOUGH_ROOM;
-	size = ALIGN(old_size + per_cpu_dyn_array_size(), PAGE_SIZE);
+	da_size = per_cpu_dyn_array_size(&align);
+	align = max_t(unsigned long, PAGE_SIZE, align);
+	size = ALIGN(old_size + da_size, align);
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
@@ -544,45 +548,78 @@ void __init __weak thread_info_cache_ini
 void pre_alloc_dyn_array(void)
 {
 #ifdef CONFIG_HAVE_DYN_ARRAY
-	unsigned long size, phys = 0;
+	unsigned long total_size = 0, size, phys;
+	unsigned long max_align = 1;
 	struct dyn_array **daa;
+	char *ptr;
 
+	/* get the total size at first */
 	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
 		struct dyn_array *da = *daa;
 
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("dyna_array %s ", da->name);
-		printk(KERN_CONT "size:%#lx nr:%d align:%#lx",
+		print_fn_descriptor_symbol("dyn_array %s ", da->name);
+		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
 			da->size, *da->nr, da->align);
-		*da->name = __alloc_bootmem_nopanic(size, da->align, phys);
-		phys = virt_to_phys(*da->name);
+		total_size += roundup(size, da->align);
+		if (da->align > max_align)
+			max_align = da->align;
+	}
+	if (total_size)
+		printk(KERN_DEBUG "dyn_array total_size: %#lx\n",
+			 total_size);
+	else
+		return;
+
+	/* allocate them all together */
+	max_align = max_t(unsigned long, max_align, PAGE_SIZE);
+	ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
+	if (!ptr)
+		panic("Can not alloc dyn_alloc\n");
+
+	phys = virt_to_phys(ptr);
+	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		print_fn_descriptor_symbol("dyn_array %s ", da->name);
+
+		phys = roundup(phys, da->align);
+		*da->name = phys_to_virt(phys);
 		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
 
+		phys += size;
+
 		if (da->init_work)
 			da->init_work(da);
 	}
 #endif
 }
 
-unsigned long per_cpu_dyn_array_size(void)
+unsigned long per_cpu_dyn_array_size(unsigned long *align)
 {
 	unsigned long total_size = 0;
 #ifdef CONFIG_HAVE_DYN_ARRAY
 	unsigned long size;
 	struct dyn_array **daa;
+	unsigned max_align = 1;
 
 	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
 		struct dyn_array *da = *daa;
 
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("per_cpu_dyna_array %s ", da->name);
+		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
 		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
 			da->size, *da->nr, da->align);
 		total_size += roundup(size, da->align);
+		if (da->align > max_align)
+			max_align = da->align;
 	}
-	if (total_size)
-		printk(KERN_DEBUG "per_cpu_dyna_array total_size: %#lx\n",
+	if (total_size) {
+		printk(KERN_DEBUG "per_cpu_dyn_array total_size: %#lx\n",
 			 total_size);
+		*align = max_align;
+	}
 #endif
 	return total_size;
 }
@@ -596,14 +633,11 @@ void per_cpu_alloc_dyn_array(int cpu, ch
 	void **array;
 
 	phys = virt_to_phys(ptr);
-
 	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
 		struct dyn_array *da = *daa;
 
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("per_cpu_dyna_array %s ", da->name);
-		printk(KERN_CONT "size:%#lx nr:%d align:%#lx",
-			da->size, *da->nr, da->align);
+		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
 
 		phys = roundup(phys, da->align);
 		addr = (unsigned long)da->name;
@@ -611,7 +645,8 @@ void per_cpu_alloc_dyn_array(int cpu, ch
 		array = (void **)addr;
 		*array = phys_to_virt(phys);
 		*da->name = *array; /* so init_work could use it directly */
-		printk(KERN_CONT " %p ==> [%#lx - %#lx]\n", array, phys, phys + size);
+		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
+
 		phys += size;
 
 		if (da->init_work) {
