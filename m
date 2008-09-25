Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYIYO5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYIYO5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYIYO51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:57:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59861 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbYIYO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:57:26 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] Report the pagesize backing a VMA in /proc/pid/maps
Cc: kosaki.motohiro@jp.fujitsu.com, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <1222202736-13311-4-git-send-email-mel@csn.ul.ie>
References: <1222202736-13311-1-git-send-email-mel@csn.ul.ie> <1222202736-13311-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20080925235131.58B1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Sep 2008 23:57:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds a new field for hugepage-backed memory regions to show the
> pagesize in /proc/pid/maps.  While the information is available in smaps,
> maps is more human-readable and does not incur the cost of calculating Pss. An
> example of a /proc/self/maps output for an application using hugepages with
> this patch applied is;
> 
> 08048000-0804c000 r-xp 00000000 03:01 49135      /bin/cat
> 0804c000-0804d000 rw-p 00003000 03:01 49135      /bin/cat
> 08400000-08800000 rw-p 00000000 00:10 4055       /mnt/libhugetlbfs.tmp.QzPPTJ (deleted) (hpagesize=4096kB)
> b7daa000-b7dab000 rw-p b7daa000 00:00 0
> b7dab000-b7ed2000 r-xp 00000000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
> b7ed2000-b7ed7000 r--p 00127000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
> b7ed7000-b7ed9000 rw-p 0012c000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
> b7ed9000-b7edd000 rw-p b7ed9000 00:00 0
> b7ee1000-b7ee8000 r-xp 00000000 03:01 49262      /root/libhugetlbfs-git/obj32/libhugetlbfs.so
> b7ee8000-b7ee9000 rw-p 00006000 03:01 49262      /root/libhugetlbfs-git/obj32/libhugetlbfs.so
> b7ee9000-b7eed000 rw-p b7ee9000 00:00 0
> b7eed000-b7f02000 r-xp 00000000 03:01 119345     /lib/ld-2.3.6.so
> b7f02000-b7f04000 rw-p 00014000 03:01 119345     /lib/ld-2.3.6.so
> bf8ef000-bf903000 rwxp bffeb000 00:00 0          [stack]
> bf903000-bf904000 rw-p bffff000 00:00 0
> ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
> 
> To be predictable for parsers, the patch adds the notion of reporting on VMA
> attributes by appending one or more fields that look like "(attribute)". This
> already happens when a file is deleted and the user sees (deleted) after the
> filename. The expectation is that existing parsers will not break as those
> that read the filename should be reading forward after the inode number
> and stopping when it sees something that is not part of the filename.
> Parsers that assume everything after / is a filename will get confused by
> (hpagesize=XkB) but are already broken due to (deleted).
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

looks good to me.

However, this patch can't build on x86_64 mmotm 0923 because it conflict
against fix-vma-display-mismatch-between-proc-pid-mapssmaps.patch
(by Joe Korty <joe.korty@ccur.com>).

instead, I tested following rebased version and I confirmed it works well.



===============================================================
From: Mel Gorman <mel@csn.ul.ie>

This patch adds a new field for hugepage-backed memory regions to show the
pagesize in /proc/pid/maps.  While the information is available in smaps,
maps is more human-readable and does not incur the cost of calculating Pss. An
example of a /proc/self/maps output for an application using hugepages with
this patch applied is;

08048000-0804c000 r-xp 00000000 03:01 49135      /bin/cat
0804c000-0804d000 rw-p 00003000 03:01 49135      /bin/cat
08400000-08800000 rw-p 00000000 00:10 4055       /mnt/libhugetlbfs.tmp.QzPPTJ (deleted) (hpagesize=4096kB)
b7daa000-b7dab000 rw-p b7daa000 00:00 0
b7dab000-b7ed2000 r-xp 00000000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
b7ed2000-b7ed7000 r--p 00127000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
b7ed7000-b7ed9000 rw-p 0012c000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
b7ed9000-b7edd000 rw-p b7ed9000 00:00 0
b7ee1000-b7ee8000 r-xp 00000000 03:01 49262      /root/libhugetlbfs-git/obj32/libhugetlbfs.so
b7ee8000-b7ee9000 rw-p 00006000 03:01 49262      /root/libhugetlbfs-git/obj32/libhugetlbfs.so
b7ee9000-b7eed000 rw-p b7ee9000 00:00 0
b7eed000-b7f02000 r-xp 00000000 03:01 119345     /lib/ld-2.3.6.so
b7f02000-b7f04000 rw-p 00014000 03:01 119345     /lib/ld-2.3.6.so
bf8ef000-bf903000 rwxp bffeb000 00:00 0          [stack]
bf903000-bf904000 rw-p bffff000 00:00 0
ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]

To be predictable for parsers, the patch adds the notion of reporting on VMA
attributes by appending one or more fields that look like "(attribute)". This
already happens when a file is deleted and the user sees (deleted) after the
filename. The expectation is that existing parsers will not break as those
that read the filename should be reading forward after the inode number
and stopping when it sees something that is not part of the filename.
Parsers that assume everything after / is a filename will get confused by
(hpagesize=XkB) but are already broken due to (deleted).

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/task_mmu.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

Index: b/fs/proc/task_mmu.c
===================================================================
--- a/fs/proc/task_mmu.c	2008-09-25 21:51:39.000000000 +0900
+++ b/fs/proc/task_mmu.c	2008-09-25 22:30:48.000000000 +0900
@@ -198,7 +198,8 @@ static int do_maps_open(struct inode *in
 	return ret;
 }
 
-static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
+static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma,
+			 int showattributes)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
@@ -227,8 +228,8 @@ static void show_map_vma(struct seq_file
 	 * Print the dentry name for named mappings, and a
 	 * special [heap] marker for the heap:
 	 */
+	pad_len_spaces(m, len);
 	if (file) {
-		pad_len_spaces(m, len);
 		seq_path(m, &file->f_path, "\n");
 	} else {
 		const char *name = arch_vma_name(vma);
@@ -245,15 +246,22 @@ static void show_map_vma(struct seq_file
 				name = "[vdso]";
 			}
 		}
-		if (name) {
-			pad_len_spaces(m, len);
+		if (name)
 			seq_puts(m, name);
-		}
 	}
+
+	/*
+	 * Print additional attributes of the VMA of interest
+	 * - hugepage size if hugepage-backed
+	 */
+	if (showattributes && vma->vm_flags & VM_HUGETLB)
+		seq_printf(m, " (hpagesize=%lukB)",
+			vma_kernel_pagesize(vma) >> 10);
+
 	seq_putc(m, '\n');
 }
 
-static int show_map(struct seq_file *m, void *v)
+static int __show_map(struct seq_file *m, void *v, int showattributes)
 {
 	struct vm_area_struct *vma = v;
 	struct proc_maps_private *priv = m->private;
@@ -262,13 +270,18 @@ static int show_map(struct seq_file *m, 
 	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
 		return -EACCES;
 
-	show_map_vma(m, vma);
+	show_map_vma(m, vma, showattributes);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
 	return 0;
 }
 
+static int show_map(struct seq_file *m, void *v)
+{
+	return __show_map(m, v, 1);
+}
+
 static const struct seq_operations proc_pid_maps_op = {
 	.start	= m_start,
 	.next	= m_next,
@@ -391,7 +404,7 @@ static int show_smap(struct seq_file *m,
 	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
 		return -EACCES;
 
-	show_map_vma(m, vma);
+	show_map_vma(m, vma, 0);
 
 	seq_printf(m,
 		   "Size:           %8lu kB\n"


