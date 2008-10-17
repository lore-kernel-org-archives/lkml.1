Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYJQMhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYJQMhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYJQMhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:37:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:30437 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbYJQMhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mK4CeDhx4ckyRAMfadkdGOwOfF8EiTH/c8hQikmPZTWmsZ9nmWEhy8TrJptG02HthD
         FT+aXlQc4msMpdJ1cE+a0BSTU7J0fRLzna2OWnjlr+E5Zy4ubjNCETWlo8rx9dlWRAZs
         GKzL+yyFazz70z48EAfVOLngrJuOvsZWTO10c=
Date: Fri, 17 Oct 2008 16:40:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/31] proc: switch /proc/meminfo to seq_file
Message-ID: <20081017124035.GD22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 98d49f1a800ef6599eeeaaf49ff5827798055080 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Wed, 15 Oct 2008 23:50:22 +0400
Subject: [PATCH 03/31] proc: switch /proc/meminfo to seq_file

and move it to fs/proc/meminfo.c while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/x86/mm/pageattr.c    |   11 ++--
 fs/proc/Makefile          |    1 +
 fs/proc/meminfo.c         |  147 +++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/proc_misc.c       |  116 -----------------------------------
 include/asm-x86/pgtable.h |    3 +-
 include/linux/hugetlb.h   |    6 +-
 mm/hugetlb.c              |    5 +-
 7 files changed, 162 insertions(+), 127 deletions(-)
 create mode 100644 fs/proc/meminfo.c

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a9ec89c..f782a27 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -65,23 +65,22 @@ static void split_page_count(int level)
 	direct_pages_count[level - 1] += PTRS_PER_PTE;
 }
 
-int arch_report_meminfo(char *page)
+void arch_report_meminfo(struct seq_file *m)
 {
-	int n = sprintf(page, "DirectMap4k:  %8lu kB\n",
+	seq_printf(m, "DirectMap4k:  %8lu kB\n",
 			direct_pages_count[PG_LEVEL_4K] << 2);
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-	n += sprintf(page + n, "DirectMap2M:  %8lu kB\n",
+	seq_printf(m, "DirectMap2M:  %8lu kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 11);
 #else
-	n += sprintf(page + n, "DirectMap4M:  %8lu kB\n",
+	seq_printf(m, "DirectMap4M:  %8lu kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 12);
 #endif
 #ifdef CONFIG_X86_64
 	if (direct_gbpages)
-		n += sprintf(page + n, "DirectMap1G:  %8lu kB\n",
+		seq_printf(m, "DirectMap1G:  %8lu kB\n",
 			direct_pages_count[PG_LEVEL_1G] << 20);
 #endif
-	return n;
 }
 #else
 static inline void split_page_count(int level) { }
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 27efa14..70607a0 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -10,6 +10,7 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o proc_misc.o
 proc-y	+= loadavg.o
+proc-y	+= meminfo.o
 proc-y	+= uptime.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
new file mode 100644
index 0000000..5036786
--- /dev/null
+++ b/fs/proc/meminfo.c
@@ -0,0 +1,147 @@
+#include <linux/fs.h>
+#include <linux/hugetlb.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/mmzone.h>
+#include <linux/proc_fs.h>
+#include <linux/quicklist.h>
+#include <linux/seq_file.h>
+#include <linux/swap.h>
+#include <linux/vmstat.h>
+#include <asm/atomic.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include "internal.h"
+
+void __attribute__((weak)) arch_report_meminfo(struct seq_file *m)
+{
+}
+
+static int meminfo_proc_show(struct seq_file *m, void *v)
+{
+	struct sysinfo i;
+	unsigned long committed;
+	unsigned long allowed;
+	struct vmalloc_info vmi;
+	long cached;
+
+/*
+ * display in kilobytes.
+ */
+#define K(x) ((x) << (PAGE_SHIFT - 10))
+	si_meminfo(&i);
+	si_swapinfo(&i);
+	committed = atomic_long_read(&vm_committed_space);
+	allowed = ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+
+	cached = global_page_state(NR_FILE_PAGES) -
+			total_swapcache_pages - i.bufferram;
+	if (cached < 0)
+		cached = 0;
+
+	get_vmalloc_info(&vmi);
+
+	/*
+	 * Tagged format, for easy grepping and expansion.
+	 */
+	seq_printf(m,
+		"MemTotal:     %8lu kB\n"
+		"MemFree:      %8lu kB\n"
+		"Buffers:      %8lu kB\n"
+		"Cached:       %8lu kB\n"
+		"SwapCached:   %8lu kB\n"
+		"Active:       %8lu kB\n"
+		"Inactive:     %8lu kB\n"
+#ifdef CONFIG_HIGHMEM
+		"HighTotal:    %8lu kB\n"
+		"HighFree:     %8lu kB\n"
+		"LowTotal:     %8lu kB\n"
+		"LowFree:      %8lu kB\n"
+#endif
+		"SwapTotal:    %8lu kB\n"
+		"SwapFree:     %8lu kB\n"
+		"Dirty:        %8lu kB\n"
+		"Writeback:    %8lu kB\n"
+		"AnonPages:    %8lu kB\n"
+		"Mapped:       %8lu kB\n"
+		"Slab:         %8lu kB\n"
+		"SReclaimable: %8lu kB\n"
+		"SUnreclaim:   %8lu kB\n"
+		"PageTables:   %8lu kB\n"
+#ifdef CONFIG_QUICKLIST
+		"Quicklists:   %8lu kB\n"
+#endif
+		"NFS_Unstable: %8lu kB\n"
+		"Bounce:       %8lu kB\n"
+		"WritebackTmp: %8lu kB\n"
+		"CommitLimit:  %8lu kB\n"
+		"Committed_AS: %8lu kB\n"
+		"VmallocTotal: %8lu kB\n"
+		"VmallocUsed:  %8lu kB\n"
+		"VmallocChunk: %8lu kB\n",
+		K(i.totalram),
+		K(i.freeram),
+		K(i.bufferram),
+		K(cached),
+		K(total_swapcache_pages),
+		K(global_page_state(NR_ACTIVE)),
+		K(global_page_state(NR_INACTIVE)),
+#ifdef CONFIG_HIGHMEM
+		K(i.totalhigh),
+		K(i.freehigh),
+		K(i.totalram-i.totalhigh),
+		K(i.freeram-i.freehigh),
+#endif
+		K(i.totalswap),
+		K(i.freeswap),
+		K(global_page_state(NR_FILE_DIRTY)),
+		K(global_page_state(NR_WRITEBACK)),
+		K(global_page_state(NR_ANON_PAGES)),
+		K(global_page_state(NR_FILE_MAPPED)),
+		K(global_page_state(NR_SLAB_RECLAIMABLE) +
+				global_page_state(NR_SLAB_UNRECLAIMABLE)),
+		K(global_page_state(NR_SLAB_RECLAIMABLE)),
+		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
+		K(global_page_state(NR_PAGETABLE)),
+#ifdef CONFIG_QUICKLIST
+		K(quicklist_total_size()),
+#endif
+		K(global_page_state(NR_UNSTABLE_NFS)),
+		K(global_page_state(NR_BOUNCE)),
+		K(global_page_state(NR_WRITEBACK_TEMP)),
+		K(allowed),
+		K(committed),
+		(unsigned long)VMALLOC_TOTAL >> 10,
+		vmi.used >> 10,
+		vmi.largest_chunk >> 10
+		);
+
+	hugetlb_report_meminfo(m);
+
+	arch_report_meminfo(m);
+
+	return 0;
+#undef K
+}
+
+static int meminfo_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, meminfo_proc_show, NULL);
+}
+
+static const struct file_operations meminfo_proc_fops = {
+	.open		= meminfo_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_meminfo_init(void)
+{
+	proc_create("meminfo", 0, NULL, &meminfo_proc_fops);
+	return 0;
+}
+module_init(proc_meminfo_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 6c520f4..573dc9e 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -77,121 +77,6 @@ static int proc_calc_metrics(char *page, char **start, off_t off,
 	return len;
 }
 
-int __attribute__((weak)) arch_report_meminfo(char *page)
-{
-	return 0;
-}
-
-static int meminfo_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	struct sysinfo i;
-	int len;
-	unsigned long committed;
-	unsigned long allowed;
-	struct vmalloc_info vmi;
-	long cached;
-
-/*
- * display in kilobytes.
- */
-#define K(x) ((x) << (PAGE_SHIFT - 10))
-	si_meminfo(&i);
-	si_swapinfo(&i);
-	committed = atomic_long_read(&vm_committed_space);
-	allowed = ((totalram_pages - hugetlb_total_pages())
-		* sysctl_overcommit_ratio / 100) + total_swap_pages;
-
-	cached = global_page_state(NR_FILE_PAGES) -
-			total_swapcache_pages - i.bufferram;
-	if (cached < 0)
-		cached = 0;
-
-	get_vmalloc_info(&vmi);
-
-	/*
-	 * Tagged format, for easy grepping and expansion.
-	 */
-	len = sprintf(page,
-		"MemTotal:     %8lu kB\n"
-		"MemFree:      %8lu kB\n"
-		"Buffers:      %8lu kB\n"
-		"Cached:       %8lu kB\n"
-		"SwapCached:   %8lu kB\n"
-		"Active:       %8lu kB\n"
-		"Inactive:     %8lu kB\n"
-#ifdef CONFIG_HIGHMEM
-		"HighTotal:    %8lu kB\n"
-		"HighFree:     %8lu kB\n"
-		"LowTotal:     %8lu kB\n"
-		"LowFree:      %8lu kB\n"
-#endif
-		"SwapTotal:    %8lu kB\n"
-		"SwapFree:     %8lu kB\n"
-		"Dirty:        %8lu kB\n"
-		"Writeback:    %8lu kB\n"
-		"AnonPages:    %8lu kB\n"
-		"Mapped:       %8lu kB\n"
-		"Slab:         %8lu kB\n"
-		"SReclaimable: %8lu kB\n"
-		"SUnreclaim:   %8lu kB\n"
-		"PageTables:   %8lu kB\n"
-#ifdef CONFIG_QUICKLIST
-		"Quicklists:   %8lu kB\n"
-#endif
-		"NFS_Unstable: %8lu kB\n"
-		"Bounce:       %8lu kB\n"
-		"WritebackTmp: %8lu kB\n"
-		"CommitLimit:  %8lu kB\n"
-		"Committed_AS: %8lu kB\n"
-		"VmallocTotal: %8lu kB\n"
-		"VmallocUsed:  %8lu kB\n"
-		"VmallocChunk: %8lu kB\n",
-		K(i.totalram),
-		K(i.freeram),
-		K(i.bufferram),
-		K(cached),
-		K(total_swapcache_pages),
-		K(global_page_state(NR_ACTIVE)),
-		K(global_page_state(NR_INACTIVE)),
-#ifdef CONFIG_HIGHMEM
-		K(i.totalhigh),
-		K(i.freehigh),
-		K(i.totalram-i.totalhigh),
-		K(i.freeram-i.freehigh),
-#endif
-		K(i.totalswap),
-		K(i.freeswap),
-		K(global_page_state(NR_FILE_DIRTY)),
-		K(global_page_state(NR_WRITEBACK)),
-		K(global_page_state(NR_ANON_PAGES)),
-		K(global_page_state(NR_FILE_MAPPED)),
-		K(global_page_state(NR_SLAB_RECLAIMABLE) +
-				global_page_state(NR_SLAB_UNRECLAIMABLE)),
-		K(global_page_state(NR_SLAB_RECLAIMABLE)),
-		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
-		K(global_page_state(NR_PAGETABLE)),
-#ifdef CONFIG_QUICKLIST
-		K(quicklist_total_size()),
-#endif
-		K(global_page_state(NR_UNSTABLE_NFS)),
-		K(global_page_state(NR_BOUNCE)),
-		K(global_page_state(NR_WRITEBACK_TEMP)),
-		K(allowed),
-		K(committed),
-		(unsigned long)VMALLOC_TOTAL >> 10,
-		vmi.used >> 10,
-		vmi.largest_chunk >> 10
-		);
-
-		len += hugetlb_report_meminfo(page + len);
-
-	len += arch_report_meminfo(page + len);
-
-	return proc_calc_metrics(page, start, off, count, eof, len);
-#undef K
-}
-
 static int fragmentation_open(struct inode *inode, struct file *file)
 {
 	(void)inode;
@@ -797,7 +682,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-		{"meminfo",	meminfo_read_proc},
 		{"version",	version_read_proc},
 #ifdef CONFIG_PROC_HARDWARE
 		{"hardware",	hardware_read_proc},
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 88a53b1..a3dda6d 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -348,7 +348,8 @@ static inline void native_pagetable_setup_start(pgd_t *base) {}
 static inline void native_pagetable_setup_done(pgd_t *base) {}
 #endif
 
-extern int arch_report_meminfo(char *page);
+struct seq_file;
+extern void arch_report_meminfo(struct seq_file *m);
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 32e0ef0..e1c8afc 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -27,7 +27,7 @@ void unmap_hugepage_range(struct vm_area_struct *,
 void __unmap_hugepage_range(struct vm_area_struct *,
 			unsigned long, unsigned long, struct page *);
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
-int hugetlb_report_meminfo(char *);
+void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(int, char *);
 unsigned long hugetlb_total_pages(void);
 int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -79,7 +79,9 @@ static inline unsigned long hugetlb_total_pages(void)
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
 #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
 #define unmap_hugepage_range(vma, start, end, page)	BUG()
-#define hugetlb_report_meminfo(buf)		0
+static inline void hugetlb_report_meminfo(struct seq_file *m)
+{
+}
 #define hugetlb_report_node_meminfo(n, buf)	0
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
 #define follow_huge_pud(mm, addr, pud, write)	NULL
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3863386..85ade11 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/sysctl.h>
 #include <linux/highmem.h>
 #include <linux/mmu_notifier.h>
@@ -1455,10 +1456,10 @@ int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 
 #endif /* CONFIG_SYSCTL */
 
-int hugetlb_report_meminfo(char *buf)
+void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h = &default_hstate;
-	return sprintf(buf,
+	seq_printf(m,
 			"HugePages_Total: %5lu\n"
 			"HugePages_Free:  %5lu\n"
 			"HugePages_Rsvd:  %5lu\n"
-- 
1.5.6.5

