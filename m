Return-Path: <linux-kernel-owner+w=401wt.eu-S933377AbYDYWVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbYDYWVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbYDYWUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:11 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40564 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763726AbYDYWUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:01 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 02/12] Unionfs: prevent races in unionfs_fault
Date: Fri, 25 Apr 2008 18:18:58 -0400
Message-Id: <12091619491117-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vm_ops->fault may be called in parallel.  Because we have to resort to
temporarily changing the vma->vm_file to point to the lower file, a
concurrent invocation of unionfs_fault could see a different value.  In this
workaround, we keep a different copy of the vma structure in our stack, so
we never expose a different value of the vma->vm_file called to us, even
temporarily.  A better fix (already tested) would be to change the calling
semantics of ->fault to take an explicit file pointer.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 07db5b0..febde7c 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -40,23 +40,28 @@ static int unionfs_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int err;
 	struct file *file, *lower_file;
 	struct vm_operations_struct *lower_vm_ops;
+	struct vm_area_struct lower_vma;
 
 	BUG_ON(!vma);
-	file = vma->vm_file;
+	memcpy(&lower_vma, vma, sizeof(struct vm_area_struct));
+	file = lower_vma.vm_file;
 	lower_vm_ops = UNIONFS_F(file)->lower_vm_ops;
 	BUG_ON(!lower_vm_ops);
 
 	lower_file = unionfs_lower_file(file);
 	BUG_ON(!lower_file);
 	/*
-	 * XXX: we set the vm_file to the lower_file, before calling the
-	 * lower ->fault op, then we restore the vm_file back to the upper
-	 * file.  Need to change the ->fault prototype to take an explicit
-	 * struct file, and fix all users accordingly.
+	 * XXX: vm_ops->fault may be called in parallel.  Because we have to
+	 * resort to temporarily changing the vma->vm_file to point to the
+	 * lower file, a concurrent invocation of unionfs_fault could see a
+	 * different value.  In this workaround, we keep a different copy of
+	 * the vma structure in our stack, so we never expose a different
+	 * value of the vma->vm_file called to us, even temporarily.  A
+	 * better fix would be to change the calling semantics of ->fault to
+	 * take an explicit file pointer.
 	 */
-	vma->vm_file = lower_file;
-	err = lower_vm_ops->fault(vma, vmf);
-	vma->vm_file = file;
+	lower_vma.vm_file = lower_file;
+	err = lower_vm_ops->fault(&lower_vma, vmf);
 	return err;
 }
 
-- 
1.5.2.2

