Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZA2UDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZA2UDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZA2UDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:03:32 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:10435 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZA2UDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:03:31 -0500
Subject: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
	file segments
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>
	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 29 Jan 2009 15:03:30 -0500
Message-Id: <1233259410.2315.75.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Against:  2.6.28.2

We see a:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff80336805>] __downgrade_write+0x43/0xb4
:
Call Trace:
 [<ffffffff80284dec>] mlock_vma_pages_range+0x53/0xc3
 [<ffffffff80287021>] mmap_region+0x389/0x471
 [<ffffffff802876b5>] do_mmap_pgoff+0x308/0x36d
 [<ffffffff802100a8>] sys_mmap+0x8b/0x110
 [<ffffffff8020bc8b>] system_call_fastpath+0x16/0x1b

when mmap_region() merges two segments of a file mmap()ed with
MAP_LOCKED [VM_LOCKED].  

This patch provides a simplistic fix, suitable, I hope, for -stable.

Pass the merged vma to mlock_vma_pages_range().

Tested with:  http://free.linux.hp.com/~lts/Tests/mmap_lock.c

I'll attempt a rework of mlock_vma_pages_range(), et al, to
eliminate the 'vma' arg for 29-rc?.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/mmap.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

Index: linux-2.6.28.2/mm/mmap.c
===================================================================
--- linux-2.6.28.2.orig/mm/mmap.c	2009-01-29 11:34:08.000000000 -0500
+++ linux-2.6.28.2/mm/mmap.c	2009-01-29 12:22:14.000000000 -0500
@@ -1094,7 +1094,7 @@ unsigned long mmap_region(struct file *f
 			  int accountable)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev;
+	struct vm_area_struct *vma, *prev, *merged = NULL;
 	int correct_wcount = 0;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
@@ -1207,14 +1207,19 @@ munmap_back:
 	if (vma_wants_writenotify(vma))
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
-	if (file && vma_merge(mm, prev, addr, vma->vm_end,
-			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
-		mpol_put(vma_policy(vma));
-		kmem_cache_free(vm_area_cachep, vma);
-		fput(file);
-		if (vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(mm);
-	} else {
+	if (file) {
+		merged = vma_merge(mm, prev, addr, vma->vm_end, vma->vm_flags,
+					NULL, file, pgoff, vma_policy(vma));
+		if (merged) {
+			mpol_put(vma_policy(vma));
+			kmem_cache_free(vm_area_cachep, vma);
+			fput(file);
+			if (vm_flags & VM_EXECUTABLE)
+				removed_exe_file_vma(mm);
+			vma = merged;	/* for mlock_vma_pages_range() */
+		}
+	}
+	if (!merged) {
 		vma_link(mm, vma, prev, rb_link, rb_parent);
 		file = vma->vm_file;
 	}


