Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYJXEqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYJXEqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYJXEjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:37 -0400
Received: from kroah.org ([198.145.64.141]:51949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751679AbYJXEjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:33 -0400
Date: Thu, 23 Oct 2008 21:35:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Matt Mackall <mpm@selenic.com>,
       Joe Korty <joe.korty@ccur.com>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 24/27] proc: fix vma display mismatch between
	/proc/pid/{maps,smaps}
Message-ID: <20081024043516.GY30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="proc-fix-vma-display-mismatch-between-proc-pid-maps-smaps.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Joe Korty <joe.korty@ccur.com>

[ backport of 7c88db0cb589df980acfb2f73c3595a0653004ec to 2.7.27.3 by Joe
Korty <joe.korty@ccur.com ]

proc: fix vma display mismatch between /proc/pid/{maps,smaps}

Commit 4752c369789250eafcd7813e11c8fb689235b0d2 aka
"maps4: simplify interdependence of maps and smaps" broke /proc/pid/smaps,
causing it to display some vmas twice and other vmas not at all.  For example:

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
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

---
 fs/proc/task_mmu.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -198,11 +198,8 @@ static int do_maps_open(struct inode *in
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
@@ -210,9 +207,6 @@ static int show_map(struct seq_file *m, 
 	dev_t dev = 0;
 	int len;
 
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -257,6 +251,18 @@ static int show_map(struct seq_file *m, 
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
 		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
@@ -367,23 +373,25 @@ static int smaps_pte_range(pmd_t *pmd, u
 
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
 		.private = &mss,
 	};
 
+	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
 
-	ret = show_map(m, v);
-	if (ret)
-		return ret;
+	show_map_vma(m, vma);
 
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
@@ -405,7 +413,9 @@ static int show_smap(struct seq_file *m,
 		   mss.referenced >> 10,
 		   mss.swap >> 10);
 
-	return ret;
+	if (m->count < m->size)  /* vma is copied successfully */
+		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
+	return 0;
 }
 
 static const struct seq_operations proc_pid_smaps_op = {

-- 
