Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbXI0PcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbXI0PcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXI0Pb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:31:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34393 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbXI0Pb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:31:58 -0400
Date: Thu, 27 Sep 2007 10:30:41 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
Message-ID: <20070927153041.GM11833@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070803114249.8b7de061.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803114249.8b7de061.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 11:42:49AM -0700, Andrew Morton wrote:
> ecryptfs_init() should be converted to the usual `goto out_foo' unwinding
> so we don't need N duplicated copies of the error recovery code.
> 
> 	if (foo())
> 		goto out;
> 	if (bar())
> 		goto out_foo;
> 	if (zot())
> 		goto out_bar;
> 	...
> out_bar:
> 	undo_bar();
> out_foo:
> 	undo_foo();
> out:
> 	return err;

The error paths and the module exit code need work. sysfs
unregistration is not the right place to tear down the crypto
subsystem, and the code to undo subsystem initializations on various
error paths is unnecessarily duplicated. This patch addresses those
issues.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 92b1e6c..f944d94 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -858,13 +858,6 @@ out:
 
 static void do_sysfs_unregistration(void)
 {
-	int rc;
-
-	rc = ecryptfs_destroy_crypto();
-	if (rc) {
-		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
-		       "rc = [%d]\n", rc);
-	}
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
 			  &sysfs_attr_version.attr);
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
@@ -895,43 +888,49 @@ static int __init ecryptfs_init(void)
 	rc = register_filesystem(&ecryptfs_fs_type);
 	if (rc) {
 		printk(KERN_ERR "Failed to register filesystem\n");
-		ecryptfs_free_kmem_caches();
-		goto out;
+		goto out_free_kmem_caches;
 	}
 	kobj_set_kset_s(&ecryptfs_subsys, fs_subsys);
 	rc = do_sysfs_registration();
 	if (rc) {
 		printk(KERN_ERR "sysfs registration failed\n");
-		unregister_filesystem(&ecryptfs_fs_type);
-		ecryptfs_free_kmem_caches();
-		goto out;
+		goto out_unregister_filesystem;
 	}
 	rc = ecryptfs_init_messaging(ecryptfs_transport);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Failure occured while attempting to "
 				"initialize the eCryptfs netlink socket\n");
-		do_sysfs_unregistration();
-		unregister_filesystem(&ecryptfs_fs_type);
-		ecryptfs_free_kmem_caches();
-		goto out;
+		goto out_do_sysfs_unregistration;
 	}
 	rc = ecryptfs_init_crypto();
 	if (rc) {
 		printk(KERN_ERR "Failure whilst attempting to init crypto; "
 		       "rc = [%d]\n", rc);
-		do_sysfs_unregistration();
-		unregister_filesystem(&ecryptfs_fs_type);
-		ecryptfs_free_kmem_caches();
-		goto out;
+		goto out_release_messaging;
 	}
+	goto out;
+out_release_messaging:
+	ecryptfs_release_messaging(ecryptfs_transport);
+out_do_sysfs_unregistration:
+	do_sysfs_unregistration();
+out_unregister_filesystem:
+	unregister_filesystem(&ecryptfs_fs_type);
+out_free_kmem_caches:
+	ecryptfs_free_kmem_caches();
 out:
 	return rc;
 }
 
 static void __exit ecryptfs_exit(void)
 {
-	do_sysfs_unregistration();
+	int rc;
+
+	rc = ecryptfs_destroy_crypto();
+	if (rc)
+		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
+		       "rc = [%d]\n", rc);
 	ecryptfs_release_messaging(ecryptfs_transport);
+	do_sysfs_unregistration();
 	unregister_filesystem(&ecryptfs_fs_type);
 	ecryptfs_free_kmem_caches();
 }

