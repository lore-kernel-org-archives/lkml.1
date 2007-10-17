Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbXJQEUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbXJQEUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 00:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbXJQEUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 00:20:10 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37355 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXJQEUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 00:20:09 -0400
Message-ID: <47158E10.5000408@suse.de>
Date: Wed, 17 Oct 2007 12:22:40 +0800
From: Coly Li <coyli@suse.de>
Reply-To: coyli@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
CC: Hugh Dickins <hugh@veritas.com>, "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] setup vma->vm_page_prot by vm_get_page_prot()
References: <20071015210753.a6fdbeb0.akpm@linux-foundation.org>	<4714E823.1030902@suse.de> <20071016094354.49242d54.akpm@linux-foundation.org>
In-Reply-To: <20071016094354.49242d54.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses vm_get_page_prot() to setup vma->vm_page_prot.
use-vm_read-write-exec-to-set-vm_page_prot.patch just only replaces "& 0x7" with "&
(VM_READ|VM_WRITE|VM_EXEC)". This is a non-unified method, because there is a vm_get_page_prot() in
mm/mmap.c and exported to kerenl.
Though inside vm_get_page_prot() the protection flags is AND with
(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED), it does not hurt correct code.

This patch can replace use-vm_read-write-exec-to-set-vm_page_prot.patch.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/ia64/mm/init.c |    2 +-
 fs/exec.c           |    2 +-
 mm/mmap.c           |   11 ++++-------
 mm/mprotect.c       |    6 ++----
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index c14abef..4065280 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -130,8 +130,8 @@ ia64_init_addr_space (void)
 		vma->vm_mm = current->mm;
 		vma->vm_start = current->thread.rbs_bot & PAGE_MASK;
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
-		vma->vm_page_prot = protection_map[VM_DATA_DEFAULT_FLAGS & 0x7];
 		vma->vm_flags = VM_DATA_DEFAULT_FLAGS|VM_GROWSUP|VM_ACCOUNT;
+		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 		down_write(&current->mm->mmap_sem);
 		if (insert_vm_struct(current->mm, vma)) {
 			up_write(&current->mm->mmap_sem);
diff --git a/fs/exec.c b/fs/exec.c
index 073b0b8..2794fee 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -260,7 +260,7 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 	vma->vm_start = vma->vm_end - PAGE_SIZE;

 	vma->vm_flags = VM_STACK_FLAGS;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 0x7];
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	err = insert_vm_struct(mm, vma);
 	if (err) {
 		up_write(&mm->mmap_sem);
diff --git a/mm/mmap.c b/mm/mmap.c
index 0d40e66..57f5628 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1049,8 +1049,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma)

 	/* The open routine did something to the protections already? */
 	if (pgprot_val(vma->vm_page_prot) !=
-	    pgprot_val(protection_map[vm_flags &
-		    (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]))
+	    pgprot_val(vm_get_page_prot(vm_flags)))
 		return 0;

 	/* Specialty mapping? */
@@ -1131,8 +1130,7 @@ munmap_back:
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 	vma->vm_flags = vm_flags;
-	vma->vm_page_prot = protection_map[vm_flags &
-				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	vma->vm_page_prot = vm_get_page_prot(vm_flags);
 	vma->vm_pgoff = pgoff;

 	if (file) {
@@ -2003,8 +2001,7 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	vma->vm_end = addr + len;
 	vma->vm_pgoff = pgoff;
 	vma->vm_flags = flags;
-	vma->vm_page_prot = protection_map[flags &
-				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 out:
 	mm->total_vm += len >> PAGE_SHIFT;
@@ -2210,7 +2207,7 @@ int install_special_mapping(struct mm_struct *mm,
 	vma->vm_end = addr + len;

 	vma->vm_flags = vm_flags | mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);

 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index e8346c3..d21c358 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -193,11 +193,9 @@ success:
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
-	vma->vm_page_prot = protection_map[newflags &
-		(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	vma->vm_page_prot = vm_get_page_prot(newflags);
 	if (vma_wants_writenotify(vma)) {
-		vma->vm_page_prot = protection_map[newflags &
-			(VM_READ|VM_WRITE|VM_EXEC)];
+		vma->vm_page_prot = vm_get_page_prot(newflags);
 		dirty_accountable = 1;
 	}




-- 
Coly Li
SuSE PRC Labs
