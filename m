Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbZDCB1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbZDCB1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZDCB1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:27:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53512 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbZDCB1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:27:08 -0400
Date: Fri, 3 Apr 2009 10:25:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hugh@veritas.com, mikew@google.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, yinghan@google.com
Subject: [PATCH] proc pid maps dont show pgoff of pure anon vmas style fix
 (WasRe: [RFC][PATCH] don't show pgoff of vma if vma is pure ANON (was Re:
 mmotm 2009-01-12-16-53 uploaded)
Message-Id: <20090403102534.1d1e22de.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090402131816.54724d4e.akpm@linux-foundation.org>
References: <200901130053.n0D0rhev023334@imap1.linux-foundation.org>
	<20090113181317.48e910af.kamezawa.hiroyu@jp.fujitsu.com>
	<496CC9D8.6040909@google.com>
	<20090114162245.923c4caf.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0901141349410.5465@blonde.anvils>
	<20090115114312.e42a0dba.kamezawa.hiroyu@jp.fujitsu.com>
	<20090402131816.54724d4e.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote this on mmotm-Mar23 as 2.6.29-rc8-mm1. Is this ok ?
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix condig style of proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/task_mmu.c   |    5 +++--
 fs/proc/task_nommu.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

Index: mmotm-2.6.29-rc8-mm1/fs/proc/task_mmu.c
===================================================================
--- mmotm-2.6.29-rc8-mm1.orig/fs/proc/task_mmu.c
+++ mmotm-2.6.29-rc8-mm1/fs/proc/task_mmu.c
@@ -204,6 +204,7 @@ static void show_map_vma(struct seq_file
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
+	unsigned long long pgoff = 0;
 	dev_t dev = 0;
 	int len;
 
@@ -211,6 +212,7 @@ static void show_map_vma(struct seq_file
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
+		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
@@ -220,8 +222,7 @@ static void show_map_vma(struct seq_file
 			flags & VM_WRITE ? 'w' : '-',
 			flags & VM_EXEC ? 'x' : '-',
 			flags & VM_MAYSHARE ? 's' : 'p',
-			(!vma->vm_file) ? 0 :
-				((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
+			pgoff,
 			MAJOR(dev), MINOR(dev), ino, &len);
 
 	/*
Index: mmotm-2.6.29-rc8-mm1/fs/proc/task_nommu.c
===================================================================
--- mmotm-2.6.29-rc8-mm1.orig/fs/proc/task_nommu.c
+++ mmotm-2.6.29-rc8-mm1/fs/proc/task_nommu.c
@@ -125,6 +125,7 @@ static int nommu_vma_show(struct seq_fil
 	struct file *file;
 	dev_t dev = 0;
 	int flags, len;
+	unsigned long long pgoff = 0;
 
 	flags = vma->vm_flags;
 	file = vma->vm_file;
@@ -133,6 +134,7 @@ static int nommu_vma_show(struct seq_fil
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
+		pgoff = (loff_t)vma->pg_off << PAGE_SHIFT;
 	}
 
 	seq_printf(m,
@@ -143,8 +145,7 @@ static int nommu_vma_show(struct seq_fil
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   (!vma->vm_file) ? 0 :
-			(unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
+		   pgoff,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {

