Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXIYI7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXIYI7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXIYI7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:59:37 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:55120 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbXIYI7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:59:36 -0400
Message-Id: <46F8CDF1.3030106@mxs.nes.nec.co.jp>
Date: Tue, 25 Sep 2007 17:59:29 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] [-mm patch]  Add a prefix "VMCOREINFO_" to the vmcoreinfo
 macros.
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp>	<46E9F942.5070007@mxs.nes.nec.co.jp> <20070914190350.011cdadb.akpm@linux-foundation.org>
In-Reply-To: <20070914190350.011cdadb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> > I plan on folding all of
> > 
> > add-vmcoreinfo.patch
> > add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch
> > add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch
> > add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch
> > add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch
> > 
> > into a single patch for upstream.

I created a new single add-vmcoreinfo.patch with the following cleanup patches.

* Cleanup patches:
  1. add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch
  2. add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch
  3. add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch
  4. add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch
  5. Re: [PATCH 5/4] [-mm patch] Rename macros returning the size.
     from Ken'ichi Ohmichi, 2007/09/25
     http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0582.html
  6. Re: [PATCH 6/4] [-mm patch] use the existing offsetof().
     from Ken'ichi Ohmichi, 2007/09/25
     http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0584.html

Thanks
Ken'ichi Ohmichi 

---
Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

---
diff -rpuN a/arch/i386/kernel/machine_kexec.c b/arch/i386/kernel/machine_kexec.c
--- a/arch/i386/kernel/machine_kexec.c	2007-09-21 13:56:02.000000000 +0900
+++ b/arch/i386/kernel/machine_kexec.c	2007-09-21 13:56:13.000000000 +0900
@@ -10,6 +10,7 @@
 #include <linux/kexec.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/numa.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
@@ -169,3 +170,15 @@ static int __init parse_crashkernel(char
 	return 0;
 }
 early_param("crashkernel", parse_crashkernel);
+
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
+#endif
+#ifdef CONFIG_X86_PAE
+	VMCOREINFO_CONFIG(X86_PAE);
+#endif
+}
+
diff -rpuN a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c	2007-09-21 13:56:02.000000000 +0900
+++ b/arch/ia64/kernel/machine_kexec.c	2007-09-21 14:00:15.000000000 +0900
@@ -15,10 +15,13 @@
 #include <linux/cpu.h>
 #include <linux/irq.h>
 #include <linux/efi.h>
+#include <linux/numa.h>
+#include <linux/mmzone.h>
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/delay.h>
 #include <asm/meminit.h>
+#include <asm/processor.h>
 
 typedef NORET_TYPE void (*relocate_new_kernel_t)(
 					unsigned long indirection_page,
@@ -125,3 +128,28 @@ void machine_kexec(struct kimage *image)
 	unw_init_running(ia64_machine_kexec, image);
 	for(;;);
 }
+
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+	VMCOREINFO_SYMBOL(pgdat_list);
+	VMCOREINFO_LENGTH(pgdat_list, MAX_NUMNODES);
+
+	VMCOREINFO_SYMBOL(node_memblk);
+	VMCOREINFO_LENGTH(node_memblk, NR_NODE_MEMBLKS);
+	VMCOREINFO_STRUCT_SIZE(node_memblk_s);
+	VMCOREINFO_OFFSET(node_memblk_s, start_paddr);
+	VMCOREINFO_OFFSET(node_memblk_s, size);
+#endif
+#ifdef CONFIG_PGTABLE_3
+	VMCOREINFO_CONFIG(PGTABLE_3);
+#elif CONFIG_PGTABLE_4
+	VMCOREINFO_CONFIG(PGTABLE_4);
+#endif
+}
+
+unsigned long paddr_vmcoreinfo_note(void)
+{
+	return ia64_tpa((unsigned long)(char *)&vmcoreinfo_note);
+}
+
diff -rpuN a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c	2007-09-21 13:56:02.000000000 +0900
+++ b/arch/ia64/mm/discontig.c	2007-09-21 13:56:14.000000000 +0900
@@ -48,7 +48,7 @@ struct early_node_data {
 static struct early_node_data mem_data[MAX_NUMNODES] __initdata;
 static nodemask_t memory_less_mask __initdata;
 
-static pg_data_t *pgdat_list[MAX_NUMNODES];
+pg_data_t *pgdat_list[MAX_NUMNODES];
 
 /*
  * To prevent cache aliasing effects, align per-node structures so that they
diff -rpuN a/arch/x86_64/kernel/machine_kexec.c b/arch/x86_64/kernel/machine_kexec.c
--- a/arch/x86_64/kernel/machine_kexec.c	2007-09-21 13:56:02.000000000 +0900
+++ b/arch/x86_64/kernel/machine_kexec.c	2007-09-21 13:56:14.000000000 +0900
@@ -10,6 +10,7 @@
 #include <linux/kexec.h>
 #include <linux/string.h>
 #include <linux/reboot.h>
+#include <linux/numa.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -257,3 +258,11 @@ static int __init setup_crashkernel(char
 }
 early_param("crashkernel", setup_crashkernel);
 
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
+#endif
+}
+
diff -rpuN a/include/asm-ia64/numa.h b/include/asm-ia64/numa.h
--- a/include/asm-ia64/numa.h	2007-09-21 13:56:02.000000000 +0900
+++ b/include/asm-ia64/numa.h	2007-09-21 13:56:12.000000000 +0900
@@ -24,6 +24,7 @@
 
 extern u16 cpu_to_node_map[NR_CPUS] __cacheline_aligned;
 extern cpumask_t node_to_cpu_mask[MAX_NUMNODES] __cacheline_aligned;
+extern pg_data_t *pgdat_list[MAX_NUMNODES];
 
 /* Stuff below this line could be architecture independent */
 
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-09-21 13:56:02.000000000 +0900
+++ b/include/linux/kexec.h	2007-09-21 13:56:30.000000000 +0900
@@ -121,6 +121,32 @@ extern struct page *kimage_alloc_control
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
+void crash_save_vmcoreinfo(void);
+void arch_crash_save_vmcoreinfo(void);
+void vmcoreinfo_append_str(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+unsigned long paddr_vmcoreinfo_note(void);
+
+#define VMCOREINFO_OSRELEASE(name) \
+	vmcoreinfo_append_str("OSRELEASE=%s\n", #name)
+#define VMCOREINFO_PAGESIZE(value) \
+	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
+#define VMCOREINFO_SYMBOL(name) \
+	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
+#define VMCOREINFO_SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%zu\n", #name, sizeof(name))
+#define VMCOREINFO_STRUCT_SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%zu\n", #name, sizeof(struct name))
+#define VMCOREINFO_OFFSET(name, field) \
+	vmcoreinfo_append_str("OFFSET(%s.%s)=%zu\n", #name, #field, \
+			      offsetof(struct name, field))
+#define VMCOREINFO_LENGTH(name, value) \
+	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
+#define VMCOREINFO_NUMBER(name) \
+	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
+#define VMCOREINFO_CONFIG(name) \
+	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
+
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
 
@@ -148,11 +174,20 @@ extern struct kimage *kexec_crash_image;
 
 #define KEXEC_FLAGS    (KEXEC_ON_CRASH)  /* List of defined/legal kexec flags */
 
+#define VMCOREINFO_BYTES           (4096)
+#define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
+#define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
+#define VMCOREINFO_NOTE_SIZE       (KEXEC_NOTE_HEAD_BYTES*2 + VMCOREINFO_BYTES \
+				    + VMCOREINFO_NOTE_NAME_BYTES)
+
 /* Location of a reserved region to hold the crash kernel.
  */
 extern struct resource crashk_res;
 typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
 extern note_buf_t *crash_notes;
+extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+extern size_t vmcoreinfo_size;
+extern size_t vmcoreinfo_max_size;
 
 
 #else /* !CONFIG_KEXEC */
diff -rpuN a/kernel/kexec.c b/kernel/kexec.c
--- a/kernel/kexec.c	2007-09-21 13:56:02.000000000 +0900
+++ b/kernel/kexec.c	2007-09-21 13:56:30.000000000 +0900
@@ -21,16 +21,26 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/numa.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/semaphore.h>
+#include <asm/sections.h>
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t* crash_notes;
 
+/* vmcoreinfo stuff */
+unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
+u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+size_t vmcoreinfo_size;
+size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -1060,6 +1070,7 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 			crash_setup_regs(&fixed_regs, regs);
+			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
@@ -1134,3 +1145,104 @@ static int __init crash_notes_memory_ini
 	return 0;
 }
 module_init(crash_notes_memory_init)
+
+void crash_save_vmcoreinfo(void)
+{
+	u32 *buf;
+
+	if (!vmcoreinfo_size)
+		return;
+
+	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
+
+	buf = (u32 *)vmcoreinfo_note;
+
+	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
+			      vmcoreinfo_size);
+
+	final_note(buf);
+}
+
+void vmcoreinfo_append_str(const char *fmt, ...)
+{
+	va_list args;
+	char buf[0x50];
+	int r;
+
+	va_start(args, fmt);
+	r = vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+
+	if (r + vmcoreinfo_size > vmcoreinfo_max_size)
+		r = vmcoreinfo_max_size - vmcoreinfo_size;
+
+	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
+
+	vmcoreinfo_size += r;
+}
+
+/*
+ * provide an empty default implementation here -- architecture
+ * code may override this
+ */
+void __attribute__ ((weak)) arch_crash_save_vmcoreinfo(void)
+{}
+
+unsigned long __attribute__ ((weak)) paddr_vmcoreinfo_note(void)
+{
+	return __pa((unsigned long)(char *)&vmcoreinfo_note);
+}
+
+static int __init crash_save_vmcoreinfo_init(void)
+{
+	VMCOREINFO_OSRELEASE(init_uts_ns.name.release);
+	VMCOREINFO_PAGESIZE(PAGE_SIZE);
+
+	VMCOREINFO_SYMBOL(init_uts_ns);
+	VMCOREINFO_SYMBOL(node_online_map);
+	VMCOREINFO_SYMBOL(swapper_pg_dir);
+	VMCOREINFO_SYMBOL(_stext);
+
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+	VMCOREINFO_SYMBOL(mem_map);
+	VMCOREINFO_SYMBOL(contig_page_data);
+#endif
+#ifdef CONFIG_SPARSEMEM
+	VMCOREINFO_SYMBOL(mem_section);
+	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
+	VMCOREINFO_STRUCT_SIZE(mem_section);
+	VMCOREINFO_OFFSET(mem_section, section_mem_map);
+#endif
+	VMCOREINFO_STRUCT_SIZE(page);
+	VMCOREINFO_STRUCT_SIZE(pglist_data);
+	VMCOREINFO_STRUCT_SIZE(zone);
+	VMCOREINFO_STRUCT_SIZE(free_area);
+	VMCOREINFO_STRUCT_SIZE(list_head);
+	VMCOREINFO_SIZE(nodemask_t);
+	VMCOREINFO_OFFSET(page, flags);
+	VMCOREINFO_OFFSET(page, _count);
+	VMCOREINFO_OFFSET(page, mapping);
+	VMCOREINFO_OFFSET(page, lru);
+	VMCOREINFO_OFFSET(pglist_data, node_zones);
+	VMCOREINFO_OFFSET(pglist_data, nr_zones);
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
+	VMCOREINFO_OFFSET(pglist_data, node_mem_map);
+#endif
+	VMCOREINFO_OFFSET(pglist_data, node_start_pfn);
+	VMCOREINFO_OFFSET(pglist_data, node_spanned_pages);
+	VMCOREINFO_OFFSET(pglist_data, node_id);
+	VMCOREINFO_OFFSET(zone, free_area);
+	VMCOREINFO_OFFSET(zone, vm_stat);
+	VMCOREINFO_OFFSET(zone, spanned_pages);
+	VMCOREINFO_OFFSET(free_area, free_list);
+	VMCOREINFO_OFFSET(list_head, next);
+	VMCOREINFO_OFFSET(list_head, prev);
+	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
+	VMCOREINFO_NUMBER(NR_FREE_PAGES);
+
+	arch_crash_save_vmcoreinfo();
+
+	return 0;
+}
+
+module_init(crash_save_vmcoreinfo_init)
diff -rpuN a/kernel/ksysfs.c b/kernel/ksysfs.c
--- a/kernel/ksysfs.c	2007-09-21 13:56:02.000000000 +0900
+++ b/kernel/ksysfs.c	2007-09-21 15:38:38.000000000 +0900
@@ -60,6 +60,14 @@ static ssize_t kexec_crash_loaded_show(s
 	return sprintf(page, "%d\n", !!kexec_crash_image);
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
+
+static ssize_t vmcoreinfo_show(struct kset *kset, char *page)
+{
+	return sprintf(page, "%lx %zx\n",
+		       paddr_vmcoreinfo_note(), vmcoreinfo_max_size);
+}
+KERNEL_ATTR_RO(vmcoreinfo);
+
 #endif /* CONFIG_KEXEC */
 
 /*
@@ -95,6 +103,7 @@ static struct attribute * kernel_attrs[]
 #ifdef CONFIG_KEXEC
 	&kexec_loaded_attr.attr,
 	&kexec_crash_loaded_attr.attr,
+	&vmcoreinfo_attr.attr,
 #endif
 	NULL
 };
_
