Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbXHWKXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbXHWKXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXHWKXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:23:32 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59400 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbXHWKXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:23:31 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       Neil Horman <nhorman@redhat.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       Bernhard Walle <bwalle@suse.de>, Don Zickus <dzickus@redhat.com>,
       Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH 0/3] vmcoreinfo support for dump filtering
In-reply-to: <20070822154036.1bd2f360.akpm@linux-foundation.org>
Message-Id: <20070823192044oomichi@mail.jp.nec.com>
References: <20070822154036.1bd2f360.akpm@linux-foundation.org>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:5W0000
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Date: Thu, 23 Aug 2007 19:20:44 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Thank you for the comments, I updated the patch.

2007/08/22 15:40:36 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
>> This patch set frees the restriction that makedumpfile users should
>> install a vmlinux file (including the debugging information) into
>> each system.
>> 
>> makedumpfile command is the dump filtering feature for kdump.
>> It creates a small dumpfile by filtering unnecessary pages for the
>> analysis. To distinguish unnecessary pages, it needs a vmlinux file
>> including the debugging information. These days, the debugging package
>> becomes a huge file, and it is hard to install it into each system.
>> 
>> To solve the problem, kdump developers discussed it at lkml and kexec-ml.
>> As the result, we reached the conclusion that necessary information
>> for dump filtering (called "vmcoreinfo") should be embedded into the
>> first kernel file and it should be accessed through /proc/vmcore
>> during the second kernel.
>> (http://www.uwsg.iu.edu/hypermail/linux/kernel/0707.0/1806.html) 
>> 
>> Dan Aloni created the patch set for the above implementation.
>> (http://www.uwsg.iu.edu/hypermail/linux/kernel/0707.1/1053.html)
>> 
>> And I updated it for multi architectures and memory models.
>> (http://lists.infradead.org/pipermail/kexec/2007-August/000479.html)
>
>so...  will this permit us to generate kdump files whcih don't have any
>pagecache or anonymous memory in them?

Yes, makedumpfile can do it. Moreover it can generate kdump files which
don't have free pages or zero-filled pages too.


>> +void vmcoreinfo_append_str(const char *fmt, ...);
>
>This should have suitable __attribute__s so that the compiler can check its
>use.    See many examples in include/linux/kernel.h, around line 120.

OK. I added __attribute__ ((format (printf, 1, 2))) to the defination
for vmcoreinfo_append_str(), and I fixed the coding problems related
to this change.


>> +/* vmcoreinfo stuff */
>> +unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
>> +u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
>> +unsigned int vmcoreinfo_size = 0;
>
>Please always run scripts/checkpatch.pl against your diffs.

OK, I confirmed that the attached patch does not have any problems
by scripts/checkpatch.pl.


>> +unsigned int vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
>
>unsigned int = size_t?  Perhaps vmcoreinfo_max_size should have size_t
>type?

You are right. In the attached patch, both vmcoreinfo_max_size and
vmcoreinfo_size are defined as size_t.


>> +void crash_save_vmcoreinfo(void)
>> +{
>> +	u32 *buf;
>> +
>> +	if (!vmcoreinfo_size)
>> +		return;
>> +
>> +	vmcoreinfo_append_str("CRASHTIME=%d", xtime.tv_sec);
>
>open-coded access to xtime probably isn't appropriate here.  Consider using
>get_seconds().  That might be more accurate on tickless kernels, too.

OK, I fixed it as you said.


>> +static int __init crash_save_vmcoreinfo_init(void)
>> +{
>> +	vmcoreinfo_append_str("OSRELEASE=%s\n", UTS_RELEASE);
>> +	vmcoreinfo_append_str("PAGESIZE=%d\n", PAGE_SIZE);
>
>I expect the virtualisation guys would be bothered by an open-coded access
>to UTS_RELEASE.  I guess it doesn't matter much here, but perhaps it'd be
>setting a better example to use init_uts_ns.name.release?

OK, I fixed it as you said.


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
--- a/arch/i386/kernel/machine_kexec.c	2007-08-23 16:31:11.000000000 +0900
+++ b/arch/i386/kernel/machine_kexec.c	2007-08-23 16:32:01.000000000 +0900
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
+	SYMBOL(node_data);
+	LENGTH(node_data, MAX_NUMNODES);
+#endif
+#ifdef CONFIG_X86_PAE
+	CONFIG(X86_PAE);
+#endif
+}
+
diff -rpuN a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c	2007-08-23 16:31:14.000000000 +0900
+++ b/arch/ia64/kernel/machine_kexec.c	2007-08-23 16:32:01.000000000 +0900
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
+	SYMBOL(pgdat_list);
+	LENGTH(pgdat_list, MAX_NUMNODES);
+
+	SYMBOL(node_memblk);
+	LENGTH(node_memblk, NR_NODE_MEMBLKS);
+	SIZE(node_memblk_s);
+	OFFSET(node_memblk_s, start_paddr);
+	OFFSET(node_memblk_s, size);
+#endif
+#ifdef CONFIG_PGTABLE_3
+	CONFIG(PGTABLE_3);
+#elif  CONFIG_PGTABLE_4
+	CONFIG(PGTABLE_4);
+#endif
+}
+
+unsigned long paddr_vmcoreinfo_note(void)
+{
+	return ia64_tpa((unsigned long)(char *)&vmcoreinfo_note);
+}
+
diff -rpuN a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c	2007-08-23 16:31:14.000000000 +0900
+++ b/arch/ia64/mm/discontig.c	2007-08-23 16:32:01.000000000 +0900
@@ -47,7 +47,7 @@ struct early_node_data {
 static struct early_node_data mem_data[MAX_NUMNODES] __initdata;
 static nodemask_t memory_less_mask __initdata;
 
-static pg_data_t *pgdat_list[MAX_NUMNODES];
+pg_data_t *pgdat_list[MAX_NUMNODES];
 
 /*
  * To prevent cache aliasing effects, align per-node structures so that they
diff -rpuN a/arch/x86_64/kernel/machine_kexec.c b/arch/x86_64/kernel/machine_kexec.c
--- a/arch/x86_64/kernel/machine_kexec.c	2007-08-23 16:31:11.000000000 +0900
+++ b/arch/x86_64/kernel/machine_kexec.c	2007-08-23 16:32:01.000000000 +0900
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
+	SYMBOL(node_data);
+	LENGTH(node_data, MAX_NUMNODES);
+#endif
+}
+
diff -rpuN a/include/asm-ia64/numa.h b/include/asm-ia64/numa.h
--- a/include/asm-ia64/numa.h	2007-08-23 16:31:05.000000000 +0900
+++ b/include/asm-ia64/numa.h	2007-08-23 16:32:01.000000000 +0900
@@ -24,6 +24,7 @@
 
 extern u16 cpu_to_node_map[NR_CPUS] __cacheline_aligned;
 extern cpumask_t node_to_cpu_mask[MAX_NUMNODES] __cacheline_aligned;
+extern pg_data_t *pgdat_list[MAX_NUMNODES];
 
 /* Stuff below this line could be architecture independent */
 
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-08-23 16:31:05.000000000 +0900
+++ b/include/linux/kexec.h	2007-08-23 16:29:26.000000000 +0900
@@ -121,6 +121,25 @@ extern struct page *kimage_alloc_control
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
+void crash_save_vmcoreinfo(void);
+void arch_crash_save_vmcoreinfo(void);
+void vmcoreinfo_append_str(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+unsigned long paddr_vmcoreinfo_note(void);
+
+#define SYMBOL(name) \
+	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
+#define SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+			      (unsigned long)sizeof(struct name))
+#define OFFSET(name, field) \
+	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
+			      (unsigned long)&(((struct name *)0)->field))
+#define LENGTH(name, value) \
+	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
+#define CONFIG(name) \
+	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
+
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
 
@@ -148,11 +167,20 @@ extern struct kimage *kexec_crash_image;
 
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
--- a/kernel/kexec.c	2007-08-23 16:31:06.000000000 +0900
+++ b/kernel/kexec.c	2007-08-23 16:32:01.000000000 +0900
@@ -22,16 +22,26 @@
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
+size_t vmcoreinfo_size = 0;
+size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -1061,6 +1071,7 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 			crash_setup_regs(&fixed_regs, regs);
+			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
@@ -1135,3 +1146,102 @@ static int __init crash_notes_memory_ini
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
+	vmcoreinfo_append_str("OSRELEASE=%s\n", init_uts_ns.name.release);
+	vmcoreinfo_append_str("PAGESIZE=%ld\n", PAGE_SIZE);
+
+	SYMBOL(init_uts_ns);
+	SYMBOL(node_online_map);
+	SYMBOL(swapper_pg_dir);
+	SYMBOL(_stext);
+
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+	SYMBOL(mem_map);
+	SYMBOL(contig_page_data);
+#endif
+#ifdef CONFIG_SPARSEMEM
+	SYMBOL(mem_section);
+	LENGTH(mem_section, NR_SECTION_ROOTS);
+	SIZE(mem_section);
+	OFFSET(mem_section, section_mem_map);
+#endif
+	SIZE(page);
+	SIZE(pglist_data);
+	SIZE(zone);
+	SIZE(free_area);
+	SIZE(list_head);
+	OFFSET(page, flags);
+	OFFSET(page, _count);
+	OFFSET(page, mapping);
+	OFFSET(page, lru);
+	OFFSET(pglist_data, node_zones);
+	OFFSET(pglist_data, nr_zones);
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
+	OFFSET(pglist_data, node_mem_map);
+#endif
+	OFFSET(pglist_data, node_start_pfn);
+	OFFSET(pglist_data, node_spanned_pages);
+	OFFSET(pglist_data, node_id);
+	OFFSET(zone, free_area);
+	OFFSET(zone, vm_stat);
+	OFFSET(zone, spanned_pages);
+	OFFSET(free_area, free_list);
+	OFFSET(list_head, next);
+	OFFSET(list_head, prev);
+	LENGTH(zone.free_area, MAX_ORDER);
+
+	arch_crash_save_vmcoreinfo();
+
+	return 0;
+}
+
+module_init(crash_save_vmcoreinfo_init)
diff -rpuN a/kernel/ksysfs.c b/kernel/ksysfs.c
--- a/kernel/ksysfs.c	2007-08-23 16:31:06.000000000 +0900
+++ b/kernel/ksysfs.c	2007-08-23 16:32:01.000000000 +0900
@@ -60,6 +60,15 @@ static ssize_t kexec_crash_loaded_show(s
 	return sprintf(page, "%d\n", !!kexec_crash_image);
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
+
+static ssize_t vmcoreinfo_show(struct kset *kset, char *page)
+{
+	return sprintf(page, "%lx %x\n",
+		       paddr_vmcoreinfo_note(),
+		       (unsigned int)vmcoreinfo_max_size);
+}
+KERNEL_ATTR_RO(vmcoreinfo);
+
 #endif /* CONFIG_KEXEC */
 
 decl_subsys(kernel, NULL, NULL);
@@ -73,6 +82,7 @@ static struct attribute * kernel_attrs[]
 #ifdef CONFIG_KEXEC
 	&kexec_loaded_attr.attr,
 	&kexec_crash_loaded_attr.attr,
+	&vmcoreinfo_attr.attr,
 #endif
 	NULL
 };
_
