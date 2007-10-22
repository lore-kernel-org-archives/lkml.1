Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXJVSQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXJVSQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbXJVSNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:13:05 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46518 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbXJVSND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:13:03 -0400
Date: Mon, 22 Oct 2007 19:12:26 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Coly Li <coyli@suse.de>, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix mprotect vma_wants_writenotify prot
Message-ID: <Pine.LNX.4.64.0710221909420.18417@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix mprotect bug in recent commit 3ed75eb8f1cd89565966599c4f77d2edb086d5b0
(setup vma->vm_page_prot by vm_get_page_prot()): the vma_wants_writenotify
case was setting the same prot as when not.

Nothing wrong with the use of protection_map[] in mmap_region(),
but use vm_get_page_prot() there too in the same ~VM_SHARED way.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/mmap.c     |    3 +--
 mm/mprotect.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- 2.6.23-git17/mm/mmap.c	2007-10-22 17:07:00.000000000 +0100
+++ linux/mm/mmap.c	2007-10-22 18:25:25.000000000 +0100
@@ -1171,8 +1171,7 @@ munmap_back:
 	vm_flags = vma->vm_flags;
 
 	if (vma_wants_writenotify(vma))
-		vma->vm_page_prot =
-			protection_map[vm_flags & (VM_READ|VM_WRITE|VM_EXEC)];
+		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
 	if (!file || !vma_merge(mm, prev, addr, vma->vm_end,
 			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
--- 2.6.23-git17/mm/mprotect.c	2007-10-22 17:07:00.000000000 +0100
+++ linux/mm/mprotect.c	2007-10-22 18:25:25.000000000 +0100
@@ -194,7 +194,7 @@ success:
 	vma->vm_flags = newflags;
 	vma->vm_page_prot = vm_get_page_prot(newflags);
 	if (vma_wants_writenotify(vma)) {
-		vma->vm_page_prot = vm_get_page_prot(newflags);
+		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
 		dirty_accountable = 1;
 	}
 
