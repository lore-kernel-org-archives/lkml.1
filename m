Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbXHNIwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbXHNIwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXHNIwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:52:14 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53113 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752164AbXHNIwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:52:09 -0400
Message-ID: <387081524.09012@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 14 Aug 2007 16:52:04 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [RFC][PATCH] /proc/<pid>/pmaps - memory maps in granularity of
	pages
Message-ID: <20070814085204.GA10884@mail.ustc.edu.cn>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	David Rientjes <rientjes@google.com>,
	Matt Mackall <mpm@selenic.com>,
	John Berthels <jjberthels@gmail.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Matt Mackall brings us many memory-footprint-optimization
opportunities with his pagemap/kpagemap patches. However I wonder if
the binary interface can be improved.

This seq_file based implementation iterates in the unit of vmas.  So
super large vmas can be a problem. The next step is to to do address
based iteration. That should not be hard.

Andrew, please stop me early if it is at all a wrong interface :)

Thank you,
Fengguang
===

Show a process's memory maps page-by-page in /proc/<pid>/pmaps.
It helps to analyze application's memory footprint in a comprehensive way.

Pages share the same states are grouped into a page range.
For each page range, the following fields are exported:
	- first page index
	- number of pages in the range
	- well known page/pte flags
	- number of mmap users

Only page flags not expected to disappear in the near future are exported:

	Y:young R:referenced A:active U:uptodate P:ptedirty D:dirty W:writeback

Here is a sample output:

# cat /proc/$$/pmaps
08048000-080c9000 r-xp 08048000 00:00 0
32840   129     Y_A_P__ 1
080c9000-080f6000 rwxp 080c9000 00:00 0                                  [heap]
32969   45      Y_A_P__ 1
f7dba000-f7dc3000 r-xp 00000000 03:00 176633                             /lib/libnss_files-2.3.6.so
0       1       Y_AU___ 1
1       1       YR_U___ 1
5       1       YR_U___ 1
8       1       Y_AU___ 1
f7dc3000-f7dc5000 rwxp 00008000 03:00 176633                             /lib/libnss_files-2.3.6.so
8       2       Y_A_P__ 1
f7dc5000-f7dcd000 r-xp 00000000 03:00 176635                             /lib/libnss_nis-2.3.6.so
0       1       Y_AU___ 1
1       1       YR_U___ 1
4       1       YR_U___ 1
7       1       Y_AU___ 1
f7dcd000-f7dcf000 rwxp 00007000 03:00 176635                             /lib/libnss_nis-2.3.6.so
7       2       Y_A_P__ 1
f7dcf000-f7de1000 r-xp 00000000 03:00 176630                             /lib/libnsl-2.3.6.so
0       1       Y_AU___ 1
1       3       YR_U___ 1
16      1       YR_U___ 1
f7de1000-f7de3000 rwxp 00011000 03:00 176630                             /lib/libnsl-2.3.6.so
17      2       Y_A_P__ 1
[...]


Matt Mackall's pagemap/kpagemap and John Berthels's exmap can achieve the same goals,
and probably more. But this text based pmaps interface should be more easy to use.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: John Berthels <jjberthels@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/proc/base.c     |    5 +
 fs/proc/internal.h |    1 
 fs/proc/task_mmu.c |  170 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+)

--- linux-2.6.23-rc2.orig/fs/proc/task_mmu.c
+++ linux-2.6.23-rc2/fs/proc/task_mmu.c
@@ -258,6 +258,126 @@ static void smaps_pte_range(struct vm_ar
 	cond_resched();
 }
 
+struct pmaps_private {
+	struct vm_area_struct *vma;
+	struct seq_file *m;
+	pte_t ptent;
+	struct page *page;
+	unsigned long offset;
+	unsigned long len;
+};
+
+static unsigned long page_mask;
+#define PG_YOUNG	PG_readahead	/* reuse any non-relevant flag */
+#define PG_DIRTY	PG_lru		/* ditto */
+#define NR_FAKED_FLAG	2
+#define PG_COUNT	(sizeof(page_flags)/sizeof(page_flags[0]))
+
+/*
+ * Page state names, prefixed by their abbreviations.
+ */
+struct pmaps_page_flag {
+	unsigned long	mask;
+	const char     *name;
+	bool		faked;
+};
+
+static struct pmaps_page_flag page_flags [] = {
+	{1 << PG_YOUNG,		"Y:young",	1},
+	{1 << PG_referenced,	"R:referenced",	0},
+	{1 << PG_active,	"A:active",	0},
+
+	{1 << PG_uptodate,	"U:uptodate",	0},
+	{1 << PG_DIRTY,		"P:ptedirty",	1},
+	{1 << PG_dirty,		"D:dirty",	0},
+	{1 << PG_writeback,	"W:writeback",	0},
+};
+
+static unsigned long pmaps_page_flags(pte_t ptent, struct page* page)
+{
+	unsigned long flags;
+
+	flags = page->flags & page_mask;
+
+	if (pte_young(ptent))
+		flags |= (1 << PG_YOUNG);
+
+	if (pte_dirty(ptent))
+		flags |= (1 << PG_DIRTY);
+
+	return flags;
+}
+
+static int pmaps_pages_similiar(pte_t ptent0, struct page* page0,
+				pte_t ptent,  struct page* page)
+{
+	if (!page0)
+		return 0;
+
+	if (page_mapcount(page0) != page_mapcount(page))
+		return 0;
+
+	if (pmaps_page_flags(ptent0, page0) != pmaps_page_flags(ptent, page))
+		return 0;
+
+	return 1;
+}
+
+static void pmaps_show_range(struct pmaps_private *pp)
+{
+	int i;
+	unsigned long flags;
+
+	if (!pp->page)
+		return;
+
+	seq_printf(pp->m, "%lu\t%lu\t", pp->offset, pp->len);
+
+	flags = pmaps_page_flags(pp->ptent, pp->page);
+	for (i = 0; i < PG_COUNT; i++)
+		seq_putc(pp->m, (flags & page_flags[i].mask) ?
+					 page_flags[i].name[0] : '_');
+
+	seq_printf(pp->m, "\t%d\n", page_mapcount(pp->page));
+}
+
+static void pmaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+			    unsigned long addr, unsigned long end,
+			    void *private)
+{
+	struct pmaps_private *pp = private;
+	pte_t *pte, ptent;
+	spinlock_t *ptl;
+	struct page *page;
+	pgoff_t offset;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		ptent = *pte;
+		if (!pte_present(ptent))
+			continue;
+
+		page = vm_normal_page(vma, addr, ptent);
+		if (!page)
+			continue;
+
+		offset = page_index(page);
+		if (offset == pp->offset + pp->len &&
+				pmaps_pages_similiar(pp->ptent, pp->page,
+						     ptent, page)) {
+			pp->len++;
+		} else {
+			pmaps_show_range(pp);
+			pp->page = page;
+			pp->ptent = ptent;
+			pp->offset = offset;
+			pp->len = 1;
+		}
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+}
+
 static void clear_refs_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 				 unsigned long addr, unsigned long end,
 				 void *private)
@@ -359,6 +479,26 @@ static int show_smap(struct seq_file *m,
 	return show_map_internal(m, v, &mss);
 }
 
+static int show_pmaps(struct seq_file *m, void *v)
+{
+	struct vm_area_struct *vma = v;
+	struct pmaps_private pp;
+
+	if (!vma->vm_mm || is_vm_hugetlb_page(vma))
+		return 0;
+
+	memset(&pp, 0, sizeof pp);
+	pp.m = m;
+	pp.vma = vma;
+
+	spin_lock(&vma->vm_mm->page_table_lock);
+	show_map_internal(m, v, NULL);
+	walk_page_range(vma, pmaps_pte_range, &pp);
+	pmaps_show_range(&pp);
+	spin_unlock(&vma->vm_mm->page_table_lock);
+	return 0;
+}
+
 void clear_refs_smap(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
@@ -482,6 +622,13 @@ static struct seq_operations proc_pid_sm
 	.show	= show_smap
 };
 
+static struct seq_operations proc_pid_pmaps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_pmaps
+};
+
 static int do_maps_open(struct inode *inode, struct file *file,
 			struct seq_operations *ops)
 {
@@ -558,3 +705,26 @@ const struct file_operations proc_smaps_
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
+
+static int pmaps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_pid_pmaps_op);
+}
+
+const struct file_operations proc_pmaps_operations = {
+	.open		= pmaps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
+static __init int task_mmu_init(void)
+{
+	int i;
+	for (page_mask = 0, i = 0; i < PG_COUNT; i++)
+		if (!page_flags[i].faked)
+			page_mask |= page_flags[i].mask;
+	return 0;
+}
+
+module_init(task_mmu_init);
--- linux-2.6.23-rc2.orig/fs/proc/base.c
+++ linux-2.6.23-rc2/fs/proc/base.c
@@ -45,6 +45,9 @@
  *
  *  Paul Mundt <paul.mundt@nokia.com>:
  *  Overall revision about smaps.
+ *
+ *  Fengguang Wu <wfg@mail.ustc.edu.cn>:
+ *  Initial version of pmaps.
  */
 
 #include <asm/uaccess.h>
@@ -2070,6 +2073,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
+	REG("pmaps",      S_IRUGO, pmaps),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
@@ -2356,6 +2360,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
+	REG("pmaps",     S_IRUGO, pmaps),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, attr_dir),
--- linux-2.6.23-rc2.orig/fs/proc/internal.h
+++ linux-2.6.23-rc2/fs/proc/internal.h
@@ -53,6 +53,7 @@ extern const struct file_operations proc
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
+extern const struct file_operations proc_pmaps_operations;
 
 
 void free_proc_entry(struct proc_dir_entry *de);

