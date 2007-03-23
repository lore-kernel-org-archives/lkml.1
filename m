Return-Path: <linux-kernel-owner+w=401wt.eu-S2992594AbXCWWm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992594AbXCWWm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992599AbXCWWm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:42:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42592 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992594AbXCWWmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:42:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=a5iZaO3TD1uZJ8wSMdvKWATUPZHbGoUAHovTncB5d8oFMNKz1oCs8ZVrTebmkoe5Y
	TlmqEG/pEcA7QKFf4ZDrA==
Message-ID: <b040c32a0703231542r77030723o214255a5fa591dec@mail.gmail.com>
Date: Fri, 23 Mar 2007 15:42:13 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Adam Litke" <agl@us.ibm.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch 1/2] hugetlb: add resv argument to hugetlb_file_setup
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rename hugetlb_zero_setup() to hugetlb_file_setup() to better match
function name convention like shmem implementation.  Also add an
argument to the function to indicate whether file setup should reserve
hugetlb page upfront or not.

Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8c718a3..981886f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -734,7 +734,7 @@ static int can_do_hugetlb_shm(void)
 			can_do_mlock());
 }

-struct file *hugetlb_zero_setup(size_t size)
+struct file *hugetlb_file_setup(size_t size, int resv)
 {
 	int error = -ENOMEM;
 	struct file *file;
@@ -771,7 +771,7 @@ struct file *hugetlb_zero_setup(size_t s
 		goto out_file;

 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT))
+	if (resv && hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT))
 		goto out_inode;

 	d_instantiate(dentry, inode);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3f3e7a6..55cccd8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -163,7 +163,7 @@ static inline struct hugetlbfs_sb_info *

 extern const struct file_operations hugetlbfs_file_operations;
 extern struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_zero_setup(size_t);
+struct file *hugetlb_file_setup(size_t, int);
 int hugetlb_get_quota(struct address_space *mapping);
 void hugetlb_put_quota(struct address_space *mapping);

@@ -185,7 +185,7 @@ #else /* !CONFIG_HUGETLBFS */

 #define is_file_hugepages(file)		0
 #define set_file_hugepages(file)	BUG()
-#define hugetlb_zero_setup(size)	ERR_PTR(-ENOSYS)
+#define hugetlb_file_setup(size, resv)	ERR_PTR(-ENOSYS)

 #endif /* !CONFIG_HUGETLBFS */

diff --git a/ipc/shm.c b/ipc/shm.c
index 4fefbad..c64643f 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -366,7 +366,7 @@ static int newseg (struct ipc_namespace

 	if (shmflg & SHM_HUGETLB) {
 		/* hugetlb_zero_setup takes care of mlock user accounting */
-		file = hugetlb_zero_setup(size);
+		file = hugetlb_file_setup(size, 1);
 		shp->mlock_user = current->user;
 	} else {
 		int acctflag = VM_ACCOUNT;
