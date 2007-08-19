Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbXHSH5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbXHSH5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXHSH4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:56:31 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50467 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751079AbXHSHzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:55:52 -0400
Message-ID: <387510148.85183@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070819075547.785390741@mail.ustc.edu.cn>
References: <20070819075410.411207640@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 19 Aug 2007 15:54:14 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in granularity of pages
Content-Disposition: inline; filename=pmaps.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Show a process's page-by-page address space infomation in /proc/<pid>/pmaps.
It helps to analyze application memory footprints in a comprehensive way.

Pages share the same states are grouped into a page range.
For each page range, the following fields are exported:
	- [HEX NUM] first page index
	- [HEX NUM] number of pages in the range
	- [STRING]  well known page/pte flags
	- [DEC NUM] number of mmap users

Only page flags not expected to disappear in the near future are exported:

Y:pteyoung R:referenced A:active U:uptodate P:ptedirty D:dirty W:writeback

Here is a sample output:

wfg ~% cat /proc/$$/pmaps
00400000-00492000 r-xp 00000000 08:01 1727526                            /bin/zsh4
0       1       YRAU___ 7
2       16      YRAU___ 7
19      5       YRAU___ 7
20      18      YRAU___ 7
38      1       YRAU___ 6
39      9       YRAU___ 7
43      46      YRAU___ 7
00691000-00697000 rw-p 00091000 08:01 1727526                            /bin/zsh4
91      6       Y_A_P__ 1
00697000-00b6e000 rw-p 00697000 00:00 0                                  [heap]
698     1       Y_A_P__ 1
69c     1       Y_A_P__ 1
69e     2       Y_A_P__ 1
6a6     1       Y_A_P__ 1
6a8     2       Y_A_P__ 1
6ad     4bc     Y_A_P__ 1
b6a     2       Y_A_P__ 1
2b661b3ea000-2b661b407000 r-xp 00000000 08:01 1563879                    /lib/ld-2.6.so
0       1       YRAU___ 78
1       4       YRAU___ 56
5       2       YRAU___ 70
7       1       YRAU___ 65
8       1       YRAU___ 70
9       1       YRAU___ 96
a       1       YRAU___ 72
b       2       YRAU___ 70
d       2       YRAU___ 96
f       1       YRAU___ 70
10      1       YRAU___ 58
11      1       YRAU___ 52
12      1       YRAU___ 19
13      1       YRAU___ 96
14      1       YRAU___ 57
15      1       YRAU___ 96
16      1       YRAU___ 71
17      1       YRAU___ 96
18      1       YRAU___ 52
1a      1       YRAU___ 70
2b661b407000-2b661b40a000 rw-p 2b661b407000 00:00 0
2b661b407       3       Y_A_P__ 1
2b661b606000-2b661b608000 rw-p 0001c000 08:01 1563879                    /lib/ld-2.6.so
1c      2       Y_A_P__ 1
[...]

Matt Mackall's pagemap/kpagemap and John Berthels's exmap can achieve the same goals,
and probably more. But this text based pmaps interface should be more easy to use.

The concern of data set size is taken care of by working in a sparse way.

1) It will only generate output for resident pages, that normally is much
   smaller than the mapped size. For example, the VSZ:RSS ratio of ALL
   processes are 4516796KB:457048KB ~= 10:1.                                                   

2) The page range trick suppresses more output. For example, my
   running firefox has a (RSS_pages:page_ranges) of 16k:2k ~= 8:1.

It's interesting to see that the seq_file interface demands some
more programming efforts, and provides such flexibility as well.

In the worst case of each resident page makes a line in pmaps, a 4GB RSS can
produce up to 1M pmaps lines, or about 20MB data.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: John Berthels <jjberthels@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/proc/base.c     |    7 +
 fs/proc/internal.h |    1 
 fs/proc/task_mmu.c |  180 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+)

--- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
+++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
@@ -752,3 +752,183 @@ const struct file_operations proc_numa_m
 	.release	= seq_release_private,
 };
 #endif /* CONFIG_NUMA */
+
+struct pmaps_private {
+	struct proc_maps_private pmp;
+	struct vm_area_struct *vma;
+	struct seq_file *m;
+	/* page range attrs */
+	unsigned long offset;
+	unsigned long len;
+	unsigned long flags;
+	int mapcount;
+};
+
+#define PMAPS_BUF_SIZE   (64<<10)  /* 64K */
+#define PMAPS_BATCH_SIZE (16<<20)  /* 16M */
+
+#define PG_YOUNG	PG_readahead	/* reuse any non-relevant flag */
+#define PG_DIRTY	PG_lru		/* ditto */
+
+static unsigned long page_mask;
+
+static struct {
+	unsigned long	mask;
+	const char     *name;
+	bool		faked;
+} page_flags [] = {
+	{1 << PG_YOUNG,		"Y:pteyoung",	1},
+	{1 << PG_referenced,	"R:referenced",	0},
+	{1 << PG_active,	"A:active",	0},
+
+	{1 << PG_uptodate,	"U:uptodate",	0},
+	{1 << PG_DIRTY,		"P:ptedirty",	1},
+	{1 << PG_dirty,		"D:dirty",	0},
+	{1 << PG_writeback,	"W:writeback",	0},
+};
+
+static unsigned long pte_page_flags(pte_t ptent, struct page* page)
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
+static int pmaps_show_range(struct pmaps_private *pp)
+{
+	int i;
+
+	if (!pp->len)
+		return 0;
+
+	seq_printf(pp->m, "%lx\t%lx\t", pp->offset, pp->len);
+
+	for (i = 0; i < ARRAY_SIZE(page_flags); i++)
+		seq_putc(pp->m, (pp->flags & page_flags[i].mask) ?
+					     page_flags[i].name[0] : '_');
+
+	return seq_printf(pp->m, "\t%d\n", pp->mapcount);
+}
+
+int pmaps_add_page(struct pmaps_private *pp, unsigned long offset,
+				unsigned long flags, int mapcount)
+{
+	int ret = 0;
+
+	if (offset == pp->offset + pp->len &&
+			flags == pp->flags &&
+			mapcount == pp->mapcount) {
+		pp->len++;
+	} else {
+		ret = pmaps_show_range(pp);
+		pp->offset = offset;
+		pp->len = 1;
+		pp->flags = flags;
+		pp->mapcount = mapcount;
+	}
+
+	return ret;
+}
+
+static int pmaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			    void *private)
+{
+	struct pmaps_private *pp = private;
+	struct vm_area_struct *vma = pp->vma;
+	pte_t *pte, *apte, ptent;
+	spinlock_t *ptl;
+	struct page *page;
+	unsigned long offset;
+	unsigned long flags;
+	int mapcount;
+	int ret = 0;
+
+	apte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
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
+		mapcount = page_mapcount(page);
+		flags = pte_page_flags(ptent, page);
+
+		if (pmaps_add_page(pp, offset, flags, mapcount))
+			break;
+	}
+	pte_unmap_unlock(apte, ptl);
+	cond_resched();
+	return ret;
+}
+
+static struct mm_walk pmaps_walk = { .pmd_entry = pmaps_pte_range };
+static int show_pmaps(struct seq_file *m, void *v)
+{
+	struct vm_area_struct *vma = v;
+	struct pmaps_private *pp = m->private;
+	unsigned long addr = pp->pmp.addr;
+	unsigned long end;
+	int ret;
+
+	if (addr == vma->vm_start) {
+		ret = show_map(m, vma);
+		if (ret)
+			return ret;
+	}
+
+	end = vma->vm_end;
+	if (end - addr > PMAPS_BATCH_SIZE)
+	    end = addr + PMAPS_BATCH_SIZE;
+
+	pp->m = m;
+	pp->vma = vma;
+	pp->len = 0;
+	walk_page_range(vma->vm_mm, addr, end, &pmaps_walk, pp);
+	pmaps_show_range(pp);
+
+	return 0;
+}
+
+static struct seq_operations proc_pid_pmaps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_pmaps
+};
+
+static int pmaps_open(struct inode *inode, struct file *file)
+{
+	return generic_maps_open(inode, file, &proc_pid_pmaps_op,
+				PMAPS_BATCH_SIZE, PMAPS_BUF_SIZE,
+				sizeof(struct pmaps_private));
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
+	for (page_mask = 0, i = 0; i < ARRAY_SIZE(page_flags); i++)
+		if (!page_flags[i].faked)
+			page_mask |= page_flags[i].mask;
+	return 0;
+}
+
+pure_initcall(task_mmu_init);
--- linux-2.6.23-rc2-mm2.orig/fs/proc/base.c
+++ linux-2.6.23-rc2-mm2/fs/proc/base.c
@@ -45,6 +45,11 @@
  *
  *  Paul Mundt <paul.mundt@nokia.com>:
  *  Overall revision about smaps.
+ *
+ *  ChangeLog:
+ *  15-Aug-2007
+ *  Fengguang Wu <wfg@mail.ustc.edu.cn>:
+ *  Page granularity mapping info in pmaps.
  */
 
 #include <asm/uaccess.h>
@@ -2044,6 +2049,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
+	REG("pmaps",      S_IRUSR, pmaps),
 	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #endif
@@ -2336,6 +2342,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
+	REG("pmaps",     S_IRUSR, pmaps),
 	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #endif
--- linux-2.6.23-rc2-mm2.orig/fs/proc/internal.h
+++ linux-2.6.23-rc2-mm2/fs/proc/internal.h
@@ -50,6 +50,7 @@ extern loff_t mem_lseek(struct file * fi
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
+extern const struct file_operations proc_pmaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
 

-- 
