Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbYBTFSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbYBTFSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYBTFR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:17:57 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34607 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYBTFR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:17:56 -0500
Subject: [PATCH] -mm: fix nommu path broken by procfs task exe symlink
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <chellwig@de.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Bryan Wu <Bryan.Wu@analog.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 19 Feb 2008 21:17:49 -0800
Message-Id: <1203484669.7408.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

nommu configurations will not compile because the "mm" variable does not
exist. Replace usage of the mm variable and the empty vma->vm_mm field
with correct mm pointers.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
---
Needs testing on a nommu system. I am working on getting an emulated nommu
environment built but it is not coming together quickly.

 mm/nommu.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6.24-mm1/mm/nommu.c
===================================================================
--- linux-2.6.24-mm1.orig/mm/nommu.c
+++ linux-2.6.24-mm1/mm/nommu.c
@@ -962,12 +962,14 @@ unsigned long do_mmap_pgoff(struct file 
 
 	INIT_LIST_HEAD(&vma->anon_vma_node);
 	atomic_set(&vma->vm_usage, 1);
 	if (file) {
 		get_file(file);
-		if (vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
+		if (vm_flags & VM_EXECUTABLE) {
+			added_exe_file_vma(current->mm);
+			vma->vm_mm = current->mm;
+		}
 	}
 	vma->vm_file	= file;
 	vma->vm_flags	= vm_flags;
 	vma->vm_start	= addr;
 	vma->vm_end	= addr + len;
@@ -1053,11 +1055,11 @@ unsigned long do_mmap_pgoff(struct file 
 EXPORT_SYMBOL(do_mmap_pgoff);
 
 /*
  * handle mapping disposal for uClinux
  */
-static void put_vma(struct vm_area_struct *vma)
+static void put_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	if (vma) {
 		down_write(&nommu_vma_sem);
 
 		if (atomic_dec_and_test(&vma->vm_usage)) {
@@ -1078,11 +1080,11 @@ static void put_vma(struct vm_area_struc
 			askedalloc -= sizeof(*vma);
 
 			if (vma->vm_file) {
 				fput(vma->vm_file);
 				if (vma->vm_flags & VM_EXECUTABLE)
-					removed_exe_file_vma(vma->vm_mm);
+					removed_exe_file_vma(mm);
 			}
 			kfree(vma);
 		}
 
 		up_write(&nommu_vma_sem);
@@ -1116,11 +1118,11 @@ int do_munmap(struct mm_struct *mm, unsi
 	return -EINVAL;
 
  found:
 	vml = *parent;
 
-	put_vma(vml->vma);
+	put_vma(mm, vml->vma);
 
 	*parent = vml->next;
 	realalloc -= kobjsize(vml);
 	askedalloc -= sizeof(*vml);
 	kfree(vml);
@@ -1161,11 +1163,11 @@ void exit_mmap(struct mm_struct * mm)
 
 		mm->total_vm = 0;
 
 		while ((tmp = mm->context.vmlist)) {
 			mm->context.vmlist = tmp->next;
-			put_vma(tmp->vma);
+			put_vma(mm, tmp->vma);
 
 			realalloc -= kobjsize(tmp);
 			askedalloc -= sizeof(*tmp);
 			kfree(tmp);
 		}


