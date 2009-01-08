Return-Path: <linux-kernel-owner+w=401wt.eu-S1759764AbZAHMzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764AbZAHMzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZAHMzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:55:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbZAHMzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:55:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/10] NOMMU: Delete askedalloc and realalloc variables [ver
	#3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:54:02 +0000
Message-ID: <20090108125402.28454.97719.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the askedalloc and realalloc variables as nothing actually uses the
value calculated.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Mike Frysinger <vapier.adi@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---

 mm/nommu.c |   28 +---------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index 1c28ea3..23f355b 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -40,7 +40,6 @@ void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
-unsigned long askedalloc, realalloc;
 atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
@@ -1042,22 +1041,11 @@ unsigned long do_mmap_pgoff(struct file *file,
 	/* okay... we have a mapping; now we have to register it */
 	result = (void *) vma->vm_start;
 
-	if (vma->vm_flags & VM_MAPPED_COPY) {
-		realalloc += kobjsize(result);
-		askedalloc += len;
-	}
-
-	realalloc += kobjsize(vma);
-	askedalloc += sizeof(*vma);
-
 	current->mm->total_vm += len >> PAGE_SHIFT;
 
 	add_nommu_vma(vma);
 
  shared:
-	realalloc += kobjsize(vml);
-	askedalloc += sizeof(*vml);
-
 	add_vma_to_mm(current->mm, vml);
 
 	up_write(&nommu_vma_sem);
@@ -1124,14 +1112,8 @@ static void put_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 
 			/* IO memory and memory shared directly out of the pagecache from
 			 * ramfs/tmpfs mustn't be released here */
-			if (vma->vm_flags & VM_MAPPED_COPY) {
-				realalloc -= kobjsize((void *) vma->vm_start);
-				askedalloc -= vma->vm_end - vma->vm_start;
+			if (vma->vm_flags & VM_MAPPED_COPY)
 				kfree((void *) vma->vm_start);
-			}
-
-			realalloc -= kobjsize(vma);
-			askedalloc -= sizeof(*vma);
 
 			if (vma->vm_file) {
 				fput(vma->vm_file);
@@ -1177,8 +1159,6 @@ int do_munmap(struct mm_struct *mm, unsigned long addr, size_t len)
 	put_vma(mm, vml->vma);
 
 	*parent = vml->next;
-	realalloc -= kobjsize(vml);
-	askedalloc -= sizeof(*vml);
 	kfree(vml);
 
 	update_hiwater_vm(mm);
@@ -1220,9 +1200,6 @@ void exit_mmap(struct mm_struct * mm)
 		while ((tmp = mm->context.vmlist)) {
 			mm->context.vmlist = tmp->next;
 			put_vma(mm, tmp->vma);
-
-			realalloc -= kobjsize(tmp);
-			askedalloc -= sizeof(*tmp);
 			kfree(tmp);
 		}
 
@@ -1276,9 +1253,6 @@ unsigned long do_mremap(unsigned long addr,
 	/* all checks complete - do it */
 	vma->vm_end = vma->vm_start + new_len;
 
-	askedalloc -= old_len;
-	askedalloc += new_len;
-
 	return vma->vm_start;
 }
 EXPORT_SYMBOL(do_mremap);

