Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbYHHV4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbYHHV4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757742AbYHHVxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:53:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761854AbYHHVxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o1erIO3Dr1gSm9yz4WRe/vNNhg6j+5B/CFBDZ7MCuNmmuvqChk//pIlMJLRmFUiJWl
         P3yK+h0sNLeGBle6cC53VDTN7Q2D6DLJLYw2co4ELVgK1j4Fcicu99y41jTvm8wcGq4q
         RkF9pNDDuMG5dPZfaY+VRymOSVS4mzAuPvpT0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 05/42] add per_cpu_dyn_array support
Date: Fri,  8 Aug 2008 14:52:11 -0700
Message-Id: <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could make array in per_cpu is allocated dynamically too

usage:
| /* in .h */
|struct kernel_stat {
|       struct cpu_usage_stat   cpustat;
|       unsigned int *irqs;
|};
|
| /* in .c */
|DEFINE_PER_CPU(struct kernel_stat, kstat);
|
|DEFINE_PER_CPU_DYN_ARRAY_ADDR(per_cpu__kstat_irqs, per_cpu__kstat.irqs, sizeof(unsigned int), nr_irqs, sizeof(unsigned long), NULL);

after setup_percpu()/per_cpu_alloc_dyn_array(), that dyn_array in per_cpu area is ready to use

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/setup_percpu.c    |    7 +++-
 include/asm-generic/vmlinux.lds.h |    6 +++
 include/linux/init.h              |   27 ++++++++++++++--
 init/main.c                       |   63 +++++++++++++++++++++++++++++++++++-
 4 files changed, 96 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 0e67f72..13ba7a8 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -140,7 +140,7 @@ static void __init setup_cpu_pda_map(void)
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
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1c3daac..e76244a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
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
diff --git a/include/linux/init.h b/include/linux/init.h
index c31cd94..9fbe61b 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
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
@@ -271,7 +272,27 @@ extern struct dyn_array *__dyn_array_start[], *__dyn_array_end[];
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
diff --git a/init/main.c b/init/main.c
index a53f1cf..18478d3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -394,17 +394,19 @@ EXPORT_SYMBOL(__per_cpu_offset);
 
 static void __init setup_per_cpu_areas(void)
 {
-	unsigned long size, i;
+	unsigned long size, i, old_size;
 	char *ptr;
 	unsigned long nr_possible_cpus = num_possible_cpus();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	old_size = PERCPU_ENOUGH_ROOM;
+	size = ALIGN(old_size + per_cpu_dyn_array_size(), PAGE_SIZE);
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		per_cpu_alloc_dyn_array(cpu, ptr + old_size);
 		ptr += size;
 	}
 }
@@ -562,6 +564,63 @@ void pre_alloc_dyn_array(void)
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
-- 
1.5.4.5

