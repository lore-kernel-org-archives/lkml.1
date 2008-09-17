Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYIQWf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYIQWf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYIQWfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:35:12 -0400
Received: from flusers.ccur.com ([12.192.68.2]:37204 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753761AbYIQWfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:35:10 -0400
Date: Wed, 17 Sep 2008 18:27:57 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix VMA display mismatch between /proc/pid/{maps,smaps}
Message-ID: <20080917222757.GA3713@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix vma display mismatch between /proc/pid/{maps,smaps}

The following commit

    From 4752c369789250eafcd7813e11c8fb689235b0d2
    From: Matt Mackall <mpm@selenic.com>
    Date: Mon, 4 Feb 2008 22:29:02 -0800
    Subject: [PATCH] maps4: simplify interdependence of maps and smaps

broke /proc/pid/smaps, causing it to display some vmas twice and other
vmas not at all.  For example:

    grep .- /proc/1/smaps >/tmp/smaps; diff /proc/1/maps /tmp/smaps

    1  25d24
    2  < 7fd7e23aa000-7fd7e23ac000 rw-p 7fd7e23aa000 00:00 0 
    3  28a28
    4  > ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0  [vsyscall]

The bug has something to do with setting m->version before all the
seq_printf's have been performed.  show_map was doing this correctly,
but show_smap was doing this in the middle of its seq_printf sequence.
This patch arranges things so that the setting of m->version in show_smap
is also done at the end of its seq_printf sequence.

Testing: in addition to the above grep test, for each process I summed
up the 'Rss' fields of /proc/pid/smaps and compared that to the 'VmRSS'
field of /proc/pid/status.  All matched except for Xorg (which has a
/dev/mem mapping which Rss accounts for but VmRSS does not).  This result
gives us some confidence that neither /proc/pid/maps nor /proc/pid/smaps
are any longer skipping or double-counting vmas.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc6-git4/fs/proc/task_mmu.c
===================================================================
--- 2.6.27-rc6-git4.orig/fs/proc/task_mmu.c	2008-09-17 17:53:02.000000000 -0400
+++ 2.6.27-rc6-git4/fs/proc/task_mmu.c	2008-09-17 18:15:40.000000000 -0400
@@ -198,11 +198,8 @@
 	return ret;
 }
 
-static int show_map(struct seq_file *m, void *v)
+static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 {
-	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
-	struct vm_area_struct *vma = v;
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
@@ -210,9 +207,6 @@
 	dev_t dev = 0;
 	int len;
 
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -257,9 +251,21 @@
 		}
 	}
 	seq_putc(m, '\n');
+}
+
+static int show_map(struct seq_file *m, void *v)
+{
+	struct vm_area_struct *vma = v;
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+
+	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
+	show_map_vma(m, vma);
 
 	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
+		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
 	return 0;
 }
 
@@ -367,9 +373,10 @@
 
 static int show_smap(struct seq_file *m, void *v)
 {
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
-	int ret;
 	struct mm_walk smaps_walk = {
 		.pmd_entry = smaps_pte_range,
 		.mm = vma->vm_mm,
@@ -381,9 +388,10 @@
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
 
-	ret = show_map(m, v);
-	if (ret)
-		return ret;
+	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
+	show_map_vma(m, vma);
 
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
@@ -405,7 +413,10 @@
 		   mss.referenced >> 10,
 		   mss.swap >> 10);
 
-	return ret;
+	if (m->count < m->size)  /* vma is copied successfully */
+		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
+
+	return 0;
 }
 
 static const struct seq_operations proc_pid_smaps_op = {

