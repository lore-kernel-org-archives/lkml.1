Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbYLKTpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbYLKTpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYLKTTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:32 -0500
Received: from kroah.org ([198.145.64.141]:56786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757912AbYLKTTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:30 -0500
Date: Thu, 11 Dec 2008 11:16:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>
Subject: [patch 76/83] fix mapping_writably_mapped()
Message-ID: <20081211191639.GX5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-mapping_writably_mapped.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

commit b88ed20594db2c685555b68c52b693b75738b2f5 upstream.

Lee Schermerhorn noticed yesterday that I broke the mapping_writably_mapped
test in 2.6.7!  Bad bad bug, good good find.

The i_mmap_writable count must be incremented for VM_SHARED (just as
i_writecount is for VM_DENYWRITE, but while holding the i_mmap_lock)
when dup_mmap() copies the vma for fork: it has its own more optimal
version of __vma_link_file(), and I missed this out.  So the count
was later going down to 0 (dangerous) when one end unmapped, then
wrapping negative (inefficient) when the other end unmapped.

The only impact on x86 would have been that setting a mandatory lock on
a file which has at some time been opened O_RDWR and mapped MAP_SHARED
(but not necessarily PROT_WRITE) across a fork, might fail with -EAGAIN
when it should succeed, or succeed when it should fail.

But those architectures which rely on flush_dcache_page() to flush
userspace modifications back into the page before the kernel reads it,
may in some cases have skipped the flush after such a fork - though any
repetitive test will soon wrap the count negative, in which case it will
flush_dcache_page() unnecessarily.

Fix would be a two-liner, but mapping variable added, and comment moved.

Reported-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/fork.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -313,17 +313,20 @@ static int dup_mmap(struct mm_struct *mm
 		file = tmp->vm_file;
 		if (file) {
 			struct inode *inode = file->f_path.dentry->d_inode;
+			struct address_space *mapping = file->f_mapping;
+
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
-
-			/* insert tmp into the share list, just after mpnt */
-			spin_lock(&file->f_mapping->i_mmap_lock);
+			spin_lock(&mapping->i_mmap_lock);
+			if (tmp->vm_flags & VM_SHARED)
+				mapping->i_mmap_writable++;
 			tmp->vm_truncate_count = mpnt->vm_truncate_count;
-			flush_dcache_mmap_lock(file->f_mapping);
+			flush_dcache_mmap_lock(mapping);
+			/* insert tmp into the share list, just after mpnt */
 			vma_prio_tree_add(tmp, mpnt);
-			flush_dcache_mmap_unlock(file->f_mapping);
-			spin_unlock(&file->f_mapping->i_mmap_lock);
+			flush_dcache_mmap_unlock(mapping);
+			spin_unlock(&mapping->i_mmap_lock);
 		}
 
 		/*

