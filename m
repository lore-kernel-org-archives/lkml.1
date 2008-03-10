Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYCJPKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYCJPKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYCJPKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:10:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:57404 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYCJPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LEgwH/efAd7u6FhZ2xvKabhHz3bbxOdkIOP/HxDR2kZ0KEgq/wfe8mS9+45KDctYG3ktrDlQSCPpIZpx+ovgaeubayU3bMB0afWJOvgFirAmC0vUziVbOEBEErZs25RElARzmeJJUkQGQ62jYotfiO2LZ3VHsGSayW1iwfrR988=
Date: Tue, 11 Mar 2008 00:03:10 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/5] shmem: use call_once()
Message-ID: <20080310150308.GC6407@APFDCB5C>
References: <20080310145704.GA6396@APFDCB5C> <20080310150026.GA6407@APFDCB5C> <20080310150148.GB6407@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080310150148.GB6407@APFDCB5C>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defers mounting tmpfs till shmem_file_setup() is
called first time by using call_once().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/shmem.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

Index: 2.6-rc/mm/shmem.c
===================================================================
--- 2.6-rc.orig/mm/shmem.c
+++ 2.6-rc/mm/shmem.c
@@ -50,6 +50,7 @@
 #include <linux/migrate.h>
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
+#include <linux/once.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
@@ -2520,7 +2521,6 @@ static struct file_system_type tmpfs_fs_
 	.get_sb		= shmem_get_sb,
 	.kill_sb	= kill_litter_super,
 };
-static struct vfsmount *shm_mnt;
 
 static int __init init_tmpfs(void)
 {
@@ -2540,27 +2540,29 @@ static int __init init_tmpfs(void)
 		goto out2;
 	}
 
-	shm_mnt = vfs_kern_mount(&tmpfs_fs_type, MS_NOUSER,
-				tmpfs_fs_type.name, NULL);
-	if (IS_ERR(shm_mnt)) {
-		error = PTR_ERR(shm_mnt);
-		printk(KERN_ERR "Could not kern_mount tmpfs\n");
-		goto out1;
-	}
 	return 0;
-
-out1:
-	unregister_filesystem(&tmpfs_fs_type);
 out2:
 	destroy_inodecache();
 out3:
 	bdi_destroy(&shmem_backing_dev_info);
 out4:
-	shm_mnt = ERR_PTR(error);
 	return error;
 }
 module_init(init_tmpfs)
 
+static struct vfsmount *shm_mnt;
+
+static int init_shm_mnt(void)
+{
+	shm_mnt = vfs_kern_mount(&tmpfs_fs_type, MS_NOUSER,
+				tmpfs_fs_type.name, NULL);
+	if (IS_ERR(shm_mnt)) {
+		printk(KERN_ERR "Could not kern_mount tmpfs\n");
+		return PTR_ERR(shm_mnt);
+	}
+	return 0;
+}
+
 /*
  * shmem_file_setup - get an unlinked file living in tmpfs
  *
@@ -2575,9 +2577,11 @@ struct file *shmem_file_setup(char *name
 	struct inode *inode;
 	struct dentry *dentry, *root;
 	struct qstr this;
+	static DEFINE_ONCE(once);
 
-	if (IS_ERR(shm_mnt))
-		return (void *)shm_mnt;
+	error = call_once(&once, init_shm_mnt);
+	if (error)
+		return ERR_PTR(error);
 
 	if (size < 0 || size > SHMEM_MAX_BYTES)
 		return ERR_PTR(-EINVAL);
