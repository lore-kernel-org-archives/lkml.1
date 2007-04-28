Return-Path: <linux-kernel-owner+w=401wt.eu-S1161534AbXD1HZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161534AbXD1HZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161591AbXD1HZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:25:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:10031 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485AbXD1HZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=XoP3ZmYZybW6QnjQwCsHvGAXRnsKuw+vHD/fyYja04EisW8727my8OFf112jlydUsbII59pRl6K1cPSk/qDeLDFXtZP29DI4HsXYVKiVTaF15ULztrLFK1+cjpQ4IUdrX78oxYU48GN88sGJNXk1x6l06xlRsTHe3RNG19MJcdk=
Date: Sat, 28 Apr 2007 16:19:23 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: William Irwin <wli@holomorphy.com>
Subject: [PATCH] hugetlbfs: fix error path in module_init
Message-ID: <20070428071923.GB9545@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, William Irwin <wli@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

init_hugetlbfs_fs() needs to unregister hugetlbfs
when kern_mount() returns error.

Cc: William Irwin <wli@holomorphy.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/hugetlbfs/inode.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: 2.6-mm/fs/hugetlbfs/inode.c
===================================================================
--- 2.6-mm.orig/fs/hugetlbfs/inode.c
+++ 2.6-mm/fs/hugetlbfs/inode.c
@@ -804,20 +804,23 @@ static int __init init_hugetlbfs_fs(void
 
 	error = register_filesystem(&hugetlbfs_fs_type);
 	if (error)
-		goto out;
+		goto out_cache;
 
 	vfsmount = kern_mount(&hugetlbfs_fs_type);
 
-	if (!IS_ERR(vfsmount)) {
-		hugetlbfs_vfsmount = vfsmount;
-		return 0;
+	if (IS_ERR(vfsmount)) {
+		error = PTR_ERR(vfsmount);
+		goto out_fs;
 	}
+	hugetlbfs_vfsmount = vfsmount;
 
-	error = PTR_ERR(vfsmount);
+	return 0;
+
+out_fs:
+	unregister_filesystem(&hugetlbfs_fs_type);
+out_cache:
+	kmem_cache_destroy(hugetlbfs_inode_cachep);
 
- out:
-	if (error)
-		kmem_cache_destroy(hugetlbfs_inode_cachep);
 	return error;
 }
 
