Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYCJPJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYCJPJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYCJPJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:09:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:54225 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYCJPJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ofWtj/vHo4RrybnbfTQd1pRC62OL/UYQHv6LujZ/jP/x/WCw0Bg0WRj8AhVqUujl8faf652FdqTqZg94AoQItJ4or57oPCNUDkHDVfADZ2PwnF2B9Jv+o5EZJgnkouuX71F2ledAqysienqQ8Aa3M2AanjYYO7UVrDF6EOjQS1s=
Date: Tue, 11 Mar 2008 00:01:50 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, William Irwin <wli@holomorphy.com>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/5] hugetlbfs: use call_once()
Message-ID: <20080310150148.GB6407@APFDCB5C>
References: <20080310145704.GA6396@APFDCB5C> <20080310150026.GA6407@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080310150026.GA6407@APFDCB5C>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defers mounting hugetlbfs till hugetlb_file_setup() is
called first time by using call_once().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: William Irwin <wli@holomorphy.com>
---
 fs/hugetlbfs/inode.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

Index: 2.6-rc/fs/hugetlbfs/inode.c
===================================================================
--- 2.6-rc.orig/fs/hugetlbfs/inode.c
+++ 2.6-rc/fs/hugetlbfs/inode.c
@@ -31,6 +31,7 @@
 #include <linux/dnotify.h>
 #include <linux/statfs.h>
 #include <linux/security.h>
+#include <linux/once.h>
 
 #include <asm/uaccess.h>
 
@@ -903,6 +904,13 @@ static struct file_system_type hugetlbfs
 
 static struct vfsmount *hugetlbfs_vfsmount;
 
+static int init_hugetlbfs_vfsmount(void)
+{
+	hugetlbfs_vfsmount = kern_mount(&hugetlbfs_fs_type);
+
+	return IS_ERR(hugetlbfs_vfsmount) ? PTR_ERR(hugetlbfs_vfsmount) : 0;
+}
+
 static int can_do_hugetlb_shm(void)
 {
 	return likely(capable(CAP_IPC_LOCK) ||
@@ -912,14 +920,16 @@ static int can_do_hugetlb_shm(void)
 
 struct file *hugetlb_file_setup(const char *name, size_t size)
 {
-	int error = -ENOMEM;
+	int error;
 	struct file *file;
 	struct inode *inode;
 	struct dentry *dentry, *root;
 	struct qstr quick_string;
+	static DEFINE_ONCE(once);
 
-	if (!hugetlbfs_vfsmount)
-		return ERR_PTR(-ENOENT);
+	error = call_once(&once, init_hugetlbfs_vfsmount);
+	if (error)
+		return ERR_PTR(error);
 
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
@@ -970,7 +980,6 @@ out_shm_unlock:
 static int __init init_hugetlbfs_fs(void)
 {
 	int error;
-	struct vfsmount *vfsmount;
 
 	error = bdi_init(&hugetlbfs_backing_dev_info);
 	if (error)
@@ -986,18 +995,9 @@ static int __init init_hugetlbfs_fs(void
 	if (error)
 		goto out;
 
-	vfsmount = kern_mount(&hugetlbfs_fs_type);
-
-	if (!IS_ERR(vfsmount)) {
-		hugetlbfs_vfsmount = vfsmount;
-		return 0;
-	}
-
-	error = PTR_ERR(vfsmount);
-
+	return 0;
  out:
-	if (error)
-		kmem_cache_destroy(hugetlbfs_inode_cachep);
+	kmem_cache_destroy(hugetlbfs_inode_cachep);
  out2:
 	bdi_destroy(&hugetlbfs_backing_dev_info);
 	return error;
