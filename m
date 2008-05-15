Return-Path: <linux-kernel-owner+w=401wt.eu-S1763907AbYEOR5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763907AbYEOR5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763229AbYEOR4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:56:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbYEOR4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:56:03 -0400
Message-Id: <20080515175431.237110763@redhat.com>
References: <20080515175357.636334082@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 13:54:02 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: [patch 5/5] spufs use the new vm_ops->access
Content-Disposition: inline; filename=05-spufs-use-vm_ops-access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spufs: use new vm_ops->access to allow local state access from gdb

This uses the new vm_ops->access to allow gdb to access the SPU
local store. We currently prevent access to problem state registers,
this can be done later if really needed but it's safer not to.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Rik van Riel <riel@redhat.com>
---

Index: ptrace-2.6.26-rc2-mm1/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/arch/powerpc/platforms/cell/spufs/file.c	2008-05-15 13:35:39.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/arch/powerpc/platforms/cell/spufs/file.c	2008-05-15 13:42:26.000000000 -0400
@@ -287,9 +287,32 @@ spufs_mem_mmap_fault(struct vm_area_stru
 	return VM_FAULT_NOPAGE;
 }
 
+static int spufs_mem_mmep_access(struct vm_area_struct *vma,
+				unsigned long address,
+				void *buf, int len, int write)
+{
+	struct spu_context *ctx = vma->vm_file->private_data;
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
 	.fault = spufs_mem_mmap_fault,
+	.access = spufs_mem_mmep_access,
 };
 
 static int spufs_mem_mmap(struct file *file, struct vm_area_struct *vma)

-- 
All Rights Reversed

