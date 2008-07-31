Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYGaEN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYGaEN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYGaENR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:13:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:33079 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYGaENQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kayubExjK8EVYiBP3VwkQ/rBgKF9lFMS2FrAcIo//6AXhm9j1BEnVMDtCX+5xe/LBo
         qPspkv094gLa/rPOF/O4tCsXarfotcyhtW6jObJXwFZAKMKh5pOSp3+CERUM3FUzQnsw
         apde483gIzNTqcQnuDRUb1Vk1o1uzC6SiV2uk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] add per_cpu_dyn_array support
Date: Wed, 30 Jul 2008 21:11:10 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com> <200807302109.21519.yhlu.kernel@gmail.com>
In-Reply-To: <200807302109.21519.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302111.10726.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so could make array in per_cpu is allocated dynamically too

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_percpu.c    |    7 +++-
 include/asm-generic/vmlinux.lds.h |    6 ++++
 include/linux/init.h              |   27 ++++++++++++++++--
 init/main.c                       |   57 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -140,7 +140,7 @@ static void __init setup_cpu_pda_map(voi
  */
 void __init setup_per_cpu_areas(void)
 {
-	ssize_t size = PERCPU_ENOUGH_ROOM;
+	ssize_t size, old_size;
 	char *ptr;
 	int cpu;
 
@@ -148,7 +148,8 @@ void __init setup_per_cpu_areas(void)
 	setup_cpu_pda_map();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = PERCPU_ENOUGH_ROOM;
+	old_size = PERCPU_ENOUGH_ROOM;
+	size = old_size + per_cpu_dyn_array_size();
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
@@ -176,6 +177,8 @@ void __init setup_per_cpu_areas(void)
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 
+		per_cpu_alloc_dyn_array(cpu, ptr + old_size);
+
 	}
 
 	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6/include/asm-generic/vmlinux.lds.h
@@ -220,6 +220,12 @@
 		VMLINUX_SYMBOL(__dyn_array_start) = .;			\
 		*(.dyn_array.init)					\
 		VMLINUX_SYMBOL(__dyn_array_end) = .;			\
+	}								\
+	. = ALIGN((align));						\
+	.per_cpu_dyn_array.init : AT(ADDR(.per_cpu_dyn_array.init) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__per_cpu_dyn_array_start) = .;		\
+		*(.per_cpu_dyn_array.init)				\
+		VMLINUX_SYMBOL(__per_cpu_dyn_array_end) = .;		\
 	}
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
Index: linux-2.6/include/linux/init.h
===================================================================
--- linux-2.6.orig/include/linux/init.h
+++ linux-2.6/include/linux/init.h
@@ -258,12 +258,13 @@ struct dyn_array {
         void (*init_work)(void *);
 };
 extern struct dyn_array *__dyn_array_start[], *__dyn_array_end[];
+extern struct dyn_array *__per_cpu_dyn_array_start[], *__per_cpu_dyn_array_end[];
 
-#define DEFINE_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
+#define DEFINE_DYN_ARRAY_ADDR(nameX, addrX, sizeX, nrX, alignX, init_workX) \
 		static struct dyn_array __dyn_array_##nameX __initdata = \
-		{	.name = (void **)&nameX,\
+		{	.name = (void **)&(nameX),\
 			.size = sizeX,\
-			.nr   = &nrX,\
+			.nr   = &(nrX),\
 			.align = alignX,\
 			.init_work = init_workX,\
 		}; \
@@ -271,7 +272,27 @@ extern struct dyn_array *__dyn_array_sta
 		__attribute__((__section__(".dyn_array.init"))) = \
 			&__dyn_array_##nameX
 
+#define DEFINE_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
+	DEFINE_DYN_ARRAY_ADDR(nameX, nameX, sizeX, nrX, alignX, init_workX)
+
+#define DEFINE_PER_CPU_DYN_ARRAY_ADDR(nameX, addrX, sizeX, nrX, alignX, init_workX) \
+		static struct dyn_array __per_cpu_dyn_array_##nameX __initdata = \
+		{	.name = (void **)&(addrX),\
+			.size = sizeX,\
+			.nr   = &(nrX),\
+			.align = alignX,\
+			.init_work = init_workX,\
+		}; \
+		static struct dyn_array *__per_cpu_dyn_array_ptr_##nameX __used \
+		__attribute__((__section__(".per_cpu_dyn_array.init"))) = \
+			&__per_cpu_dyn_array_##nameX
+
+#define DEFINE_PER_CPU_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
+	DEFINE_PER_CPU_DYN_ARRAY_ADDR(nameX, nameX, nrX, alignX, init_workX)
+
 extern void pre_alloc_dyn_array(void);
+extern unsigned long per_cpu_dyn_array_size(void);
+extern void per_cpu_alloc_dyn_array(int cpu, char *ptr);
 #endif /* __ASSEMBLY__ */
 
 /**
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -562,6 +562,63 @@ void pre_alloc_dyn_array(void)
 #endif
 }
 
+unsigned long per_cpu_dyn_array_size(void)
+{
+	unsigned long total_size = 0;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long size;
+	struct dyn_array **daa;
+
+	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		print_fn_descriptor_symbol("per_cpu_dyna_array %s ", da->name);
+		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
+			da->size, *da->nr, da->align);
+		total_size += roundup(size, da->align);
+	}
+	if (total_size)
+		printk(KERN_DEBUG "per_cpu_dyna_array total_size: %#lx\n",
+			 total_size);
+#endif
+	return total_size;
+}
+
+void per_cpu_alloc_dyn_array(int cpu, char *ptr)
+{
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long size, phys;
+	struct dyn_array **daa;
+	unsigned long addr;
+	void **array;
+
+	phys = virt_to_phys(ptr);
+
+	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		print_fn_descriptor_symbol("per_cpu_dyna_array %s ", da->name);
+		printk(KERN_CONT "size:%#lx nr:%d align:%#lx",
+			da->size, *da->nr, da->align);
+
+		phys = roundup(phys, da->align);
+		addr = (unsigned long)da->name;
+		addr += per_cpu_offset(cpu);
+		array = (void **)addr;
+		*array = phys_to_virt(phys);
+		*da->name = *array; /* so init_work could use it directly */
+		printk(KERN_CONT " %p ==> [%#lx - %#lx]\n", array, phys, phys + size);
+		phys += size;
+
+		if (da->init_work) {
+			da->init_work(da);
+		}
+	}
+#endif
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
