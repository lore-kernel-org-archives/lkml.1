Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYHSIEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYHSIEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYHSIDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:03:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:18746 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbYHSIDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uO/9a5KdmotRiXKRMx/ixIjgk97mYUTCy+xGyql3SF8pAoKRY9Lv3CYBdrMyHL955T
         z8yi7r44Or0YIDf9qdJ9zsk8zuKe64e9ly3HGzxOu/8Jc2pUyEgvZmb0E8hABXVCj5WS
         IF2EaPpsVgrxMaw7s+Ppatw8ELx7iD9/NvTq8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] dyn_array: split dyn_array functions from init/main.c
Date: Tue, 19 Aug 2008 01:03:03 -0700
Message-Id: <1219132983-20208-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 init/Makefile    |    2 
 init/dyn_array.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 init/main.c      |  118 ----------------------------------------------------
 3 files changed, 125 insertions(+), 119 deletions(-)

Index: linux-2.6/init/Makefile
===================================================================
--- linux-2.6.orig/init/Makefile
+++ linux-2.6/init/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y                          := main.o version.o mounts.o
+obj-y                          := main.o dyn_array.o version.o mounts.o
 ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
 else
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -545,124 +545,6 @@ void __init __weak thread_info_cache_ini
 {
 }
 
-void pre_alloc_dyn_array(void)
-{
-#ifdef CONFIG_HAVE_DYN_ARRAY
-	unsigned long total_size = 0, size, phys;
-	unsigned long max_align = 1;
-	struct dyn_array **daa;
-	char *ptr;
-
-	/* get the total size at first */
-	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
-		struct dyn_array *da = *daa;
-
-		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("dyn_array %s ", da->name);
-		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
-			da->size, *da->nr, da->align);
-		total_size += roundup(size, da->align);
-		if (da->align > max_align)
-			max_align = da->align;
-	}
-	if (total_size)
-		printk(KERN_DEBUG "dyn_array total_size: %#lx\n",
-			 total_size);
-	else
-		return;
-
-	/* allocate them all together */
-	max_align = max_t(unsigned long, max_align, PAGE_SIZE);
-	ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
-	if (!ptr)
-		panic("Can not alloc dyn_alloc\n");
-
-	phys = virt_to_phys(ptr);
-	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
-		struct dyn_array *da = *daa;
-
-		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("dyn_array %s ", da->name);
-
-		phys = roundup(phys, da->align);
-		*da->name = phys_to_virt(phys);
-		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
-
-		phys += size;
-
-		if (da->init_work)
-			da->init_work(da);
-	}
-#else
-#ifdef CONFIF_GENERIC_HARDIRQS
-	unsigned int i;
-
-	for (i = 0; i < NR_IRQS; i++)
-		irq_desc[i].irq = i;
-#endif
-#endif
-}
-
-unsigned long per_cpu_dyn_array_size(unsigned long *align)
-{
-	unsigned long total_size = 0;
-#ifdef CONFIG_HAVE_DYN_ARRAY
-	unsigned long size;
-	struct dyn_array **daa;
-	unsigned max_align = 1;
-
-	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
-		struct dyn_array *da = *daa;
-
-		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
-		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
-			da->size, *da->nr, da->align);
-		total_size += roundup(size, da->align);
-		if (da->align > max_align)
-			max_align = da->align;
-	}
-	if (total_size) {
-		printk(KERN_DEBUG "per_cpu_dyn_array total_size: %#lx\n",
-			 total_size);
-		*align = max_align;
-	}
-#endif
-	return total_size;
-}
-
-void per_cpu_alloc_dyn_array(int cpu, char *ptr)
-{
-#ifdef CONFIG_HAVE_DYN_ARRAY
-	unsigned long size, phys;
-	struct dyn_array **daa;
-	unsigned long addr;
-	void **array;
-
-	phys = virt_to_phys(ptr);
-	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
-		struct dyn_array *da = *daa;
-
-		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
-
-		phys = roundup(phys, da->align);
-		addr = (unsigned long)da->name;
-		addr += per_cpu_offset(cpu);
-		array = (void **)addr;
-		*array = phys_to_virt(phys);
-		*da->name = *array; /* so init_work could use it directly */
-		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
-
-		phys += size;
-
-		if (da->init_work) {
-			da->init_work(da);
-		}
-	}
-#endif
-}
-
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
Index: linux-2.6/init/dyn_array.c
===================================================================
--- /dev/null
+++ linux-2.6/init/dyn_array.c
@@ -0,0 +1,124 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/kallsyms.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/irq.h>
+
+void __init pre_alloc_dyn_array(void)
+{
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long total_size = 0, size, phys;
+	unsigned long max_align = 1;
+	struct dyn_array **daa;
+	char *ptr;
+
+	/* get the total size at first */
+	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		print_fn_descriptor_symbol("dyn_array %s ", da->name);
+		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
+			da->size, *da->nr, da->align);
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
+		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
+
+		phys += size;
+
+		if (da->init_work)
+			da->init_work(da);
+	}
+#else
+#ifdef CONFIF_GENERIC_HARDIRQS
+	unsigned int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		irq_desc[i].irq = i;
+#endif
+#endif
+}
+
+unsigned long __init per_cpu_dyn_array_size(unsigned long *align)
+{
+	unsigned long total_size = 0;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long size;
+	struct dyn_array **daa;
+	unsigned max_align = 1;
+
+	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
+		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
+			da->size, *da->nr, da->align);
+		total_size += roundup(size, da->align);
+		if (da->align > max_align)
+			max_align = da->align;
+	}
+	if (total_size) {
+		printk(KERN_DEBUG "per_cpu_dyn_array total_size: %#lx\n",
+			 total_size);
+		*align = max_align;
+	}
+#endif
+	return total_size;
+}
+
+void __init per_cpu_alloc_dyn_array(int cpu, char *ptr)
+{
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long size, phys;
+	struct dyn_array **daa;
+	unsigned long addr;
+	void **array;
+
+	phys = virt_to_phys(ptr);
+	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
+
+		phys = roundup(phys, da->align);
+		addr = (unsigned long)da->name;
+		addr += per_cpu_offset(cpu);
+		array = (void **)addr;
+		*array = phys_to_virt(phys);
+		*da->name = *array; /* so init_work could use it directly */
+		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
+
+		phys += size;
+
+		if (da->init_work) {
+			da->init_work(da);
+		}
+	}
+#endif
+}
