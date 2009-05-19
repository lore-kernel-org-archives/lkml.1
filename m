Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZESR0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZESR0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZESR0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:26:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34619 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbZESR0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:26:02 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, hooanon05@yahoo.co.jp,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Eric Paris <eparis@redhat.com>, Hugh Dickins <hugh@veritas.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, linux-nfs@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 2/3] integrity: move ima_counts_get
Date: Tue, 19 May 2009 13:25:58 -0400
Message-Id: <4b26da825c7cff6c22e924012011bedb76f7079b.1242753148.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <8971a1efcc5153f1c9b167997e5ca0c3c40a69d5.1242753145.git.zohar@linux.vnet.ibm.com>
References: <8971a1efcc5153f1c9b167997e5ca0c3c40a69d5.1242753145.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <8971a1efcc5153f1c9b167997e5ca0c3c40a69d5.1242753145.git.zohar@linux.vnet.ibm.com>
References: <8971a1efcc5153f1c9b167997e5ca0c3c40a69d5.1242753145.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on discussion on lkml (Andrew Morton and Eric Paris),
move ima_counts_get down a layer into shmem/hugetlb__file_setup().
Resolves drm shmem_file_setup() usage case as well.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 153d968..ccc62de 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -30,6 +30,7 @@
 #include <linux/dnotify.h>
 #include <linux/statfs.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 
@@ -997,6 +998,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag)
 			&hugetlbfs_file_operations);
 	if (!file)
 		goto out_dentry; /* inode is already attached */
+	ima_counts_get(file);
 
 	return file;
 
diff --git a/ipc/shm.c b/ipc/shm.c
index 47b4642..5608183 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -384,7 +384,6 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto no_file;
-	ima_counts_get(file);
 
 	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
diff --git a/mm/shmem.c b/mm/shmem.c
index a817f75..0132fbd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2659,6 +2659,7 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 	if (error)
 		goto close_file;
 #endif
+	ima_counts_get(file);
 	return file;
 
 close_file:
@@ -2684,7 +2685,6 @@ int shmem_zero_setup(struct vm_area_struct *vma)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ima_counts_get(file);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vma->vm_file = file;
-- 
1.6.0.6

