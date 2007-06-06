Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbXFFQnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbXFFQnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXFFQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:42:55 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:45391 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXFFQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:42:54 -0400
Message-ID: <4666E40A.2060708@fr.ibm.com>
Date: Wed, 06 Jun 2007 18:42:50 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a tentative fix for mm-merge-nopfn-into-fault.patch. 

./arch/powerpc/platforms/cell/spufs/file.c: In function 'spufs_mem_mmap_fault':
./arch/powerpc/platforms/cell/spufs/file.c:122: error: 'address' undeclared (first use in this function)
./arch/powerpc/platforms/cell/spufs/file.c:122: error: (Each undeclared identifier is reported only once
./arch/powerpc/platforms/cell/spufs/file.c:122: error: for each function it appears in.)
./arch/powerpc/platforms/cell/spufs/file.c:141: error: expected ';' before 'if'
./arch/powerpc/platforms/cell/spufs/file.c:122: warning: unused variable 'addr0'
 
I'm not sure how useful is the addr0 variable.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/powerpc/platforms/cell/spufs/file.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

Index: 2.6.22-rc4-mm1/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- 2.6.22-rc4-mm1.orig/arch/powerpc/platforms/cell/spufs/file.c
+++ 2.6.22-rc4-mm1/arch/powerpc/platforms/cell/spufs/file.c
@@ -53,19 +53,6 @@ spufs_mem_open(struct inode *inode, stru
 	return 0;
 }
 
-static int
-spufs_mem_release(struct inode *inode, struct file *file)
-{
-	struct spufs_inode_info *i = SPUFS_I(inode);
-	struct spu_context *ctx = i->i_ctx;
-
-	spin_lock(&ctx->mapping_lock);
-	if (!--i->i_openers)
-		ctx->local_store = NULL;
-	spin_unlock(&ctx->mapping_lock);
-	return 0;
-}
-
 static ssize_t
 __spufs_mem_read(struct spu_context *ctx, char __user *buffer,
 			size_t size, loff_t *pos)
@@ -119,13 +106,13 @@ static struct page *spufs_mem_mmap_fault
 					  struct fault_data *fdata)
 {
 	struct spu_context *ctx	= vma->vm_file->private_data;
-	unsigned long pfn, offset, addr0 = address;
+	unsigned long pfn, offset, addr0 = fdata->address;
 #ifdef CONFIG_SPU_FS_64K_LS
 	struct spu_state *csa = &ctx->csa;
 	int psize;
 
 	/* Check what page size we are using */
-	psize = get_slice_psize(vma->vm_mm, address);
+	psize = get_slice_psize(vma->vm_mm, fdata->address);
 
 	/* Some sanity checking */
 	BUG_ON(csa->use_big_pages != (psize == MMU_PAGE_64K));
@@ -133,18 +120,18 @@ static struct page *spufs_mem_mmap_fault
 	/* Wow, 64K, cool, we need to align the address though */
 	if (csa->use_big_pages) {
 		BUG_ON(vma->vm_start & 0xffff);
-		address &= ~0xfffful;
+		fdata->address &= ~0xfffful;
 	}
 #endif /* CONFIG_SPU_FS_64K_LS */
 
-	offset = fdata->pgoff << PAGE_SHIFT
+	offset = fdata->pgoff << PAGE_SHIFT;
 	if (offset >= LS_SIZE) {
 		fdata->type = VM_FAULT_SIGBUS;
 		return NULL;
 	}
 
 	pr_debug("spufs_mem_mmap_nopfn address=0x%lx -> 0x%lx, offset=0x%lx\n",
-		 addr0, address, offset);
+		 addr0, fdata->address, offset);
 
 	spu_acquire(ctx);
 
