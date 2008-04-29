Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbYD2Pf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbYD2Pf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYD2Pfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:35:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbYD2Pfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:35:46 -0400
Date: Tue, 29 Apr 2008 11:35:04 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       ajackson@redhat.com, airlied@redhat.com, akpm@linux-foundation.org
Subject: [PATCH 3/3] spufs use the new vm_ops->access
Message-ID: <20080429113504.0b916341@cuia.boston.redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spufs: use new vm_ops->access to allow local state access from gdb

This uses the new vm_ops->access to allow gdb to access the SPU
local store. We currently prevent access to problem state registers,
this can be done later if really needed but it's safer not to.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-work.orig/arch/powerpc/platforms/cell/spufs/file.c	2008-04-29 13:20:47.000000000 +1000
+++ linux-work/arch/powerpc/platforms/cell/spufs/file.c	2008-04-29 15:15:14.000000000 +1000
@@ -285,9 +285,32 @@ static unsigned long spufs_mem_mmap_nopf
 	return NOPFN_REFAULT;
 }
 
+static int spufs_mem_mmep_access(struct vm_area_struct *vma,
+				 unsigned long address,
+				 void *buf, int len, int write)
+{
+	struct spu_context *ctx	= vma->vm_file->private_data;
+	unsigned long offset = address - vma->vm_start;
+	char *local_store;
+
+	if (write && !(vma->vm_flags & VM_WRITE))
+		return -EACCES;
+	if (spu_acquire(ctx))
+		return -EINTR;
+	if ((offset + len) > vma->vm_end)
+		len = vma->vm_end - offset;
+	local_store = ctx->ops->get_ls(ctx);
+	if (write)
+		memcpy_toio(local_store + offset, buf, len);
+	else
+		memcpy_fromio(buf, local_store + offset, len);
+	spu_release(ctx);
+	return len;
+}
 
 static struct vm_operations_struct spufs_mem_mmap_vmops = {
 	.nopfn = spufs_mem_mmap_nopfn,
+	.access = spufs_mem_mmep_access,
 };
 
 static int spufs_mem_mmap(struct file *file, struct vm_area_struct *vma)
@@ -403,6 +426,13 @@ refault:
 	return NOPFN_REFAULT;
 }
 
+static int spufs_no_access(struct vm_area_struct *vma,
+			   unsigned long addr,
+			   void *buf, int len, int write)
+{
+	return -EINVAL;
+}
+
 #if SPUFS_MMAP_4K
 static unsigned long spufs_cntl_mmap_nopfn(struct vm_area_struct *vma,
 					   unsigned long address)
@@ -412,6 +442,7 @@ static unsigned long spufs_cntl_mmap_nop
 
 static struct vm_operations_struct spufs_cntl_mmap_vmops = {
 	.nopfn = spufs_cntl_mmap_nopfn,
+	.access = spufs_no_access,
 };
 
 /*
@@ -1113,6 +1144,7 @@ static unsigned long spufs_signal1_mmap_
 
 static struct vm_operations_struct spufs_signal1_mmap_vmops = {
 	.nopfn = spufs_signal1_mmap_nopfn,
+	.access = spufs_no_access,
 };
 
 static int spufs_signal1_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1250,6 +1282,7 @@ static unsigned long spufs_signal2_mmap_
 
 static struct vm_operations_struct spufs_signal2_mmap_vmops = {
 	.nopfn = spufs_signal2_mmap_nopfn,
+	.access = spufs_no_access,
 };
 
 static int spufs_signal2_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1369,6 +1402,7 @@ static unsigned long spufs_mss_mmap_nopf
 
 static struct vm_operations_struct spufs_mss_mmap_vmops = {
 	.nopfn = spufs_mss_mmap_nopfn,
+	.access = spufs_no_access,
 };
 
 /*
@@ -1431,6 +1465,7 @@ static unsigned long spufs_psmap_mmap_no
 
 static struct vm_operations_struct spufs_psmap_mmap_vmops = {
 	.nopfn = spufs_psmap_mmap_nopfn,
+	.access = spufs_no_access,
 };
 
 /*
@@ -1491,6 +1526,7 @@ static unsigned long spufs_mfc_mmap_nopf
 
 static struct vm_operations_struct spufs_mfc_mmap_vmops = {
 	.nopfn = spufs_mfc_mmap_nopfn,
+	.access = spufs_no_access,
 };
 
 /*



-- 
All Rights Reversed
