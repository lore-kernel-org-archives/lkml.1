Return-Path: <linux-kernel-owner+w=401wt.eu-S1751741AbXCDNii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbXCDNii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 08:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXCDNii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 08:38:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:49327 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbXCDNih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 08:38:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=LvufEtOhie9Sns8UuStWQQzNfYJLgk6XsTpOr6JeVfqBvTxSmOnFMDeAlw8GYUTLn/RdChSy+nd5kCQ/voHRz1r2wC1Ic1t7Yoht1N0wH6w+35jO1efweJLElAJVeYEr2/RG9tJRhYf50B/czm29SkybkCadF6iayBJpWEMOnwU=
Date: Sun, 4 Mar 2007 22:34:43 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark.fasheh@oracle.com>, Kurt Hackel <kurt.hackel@oracle.com>
Subject: [PATCH] ocfs2: fix module_init error handling
Message-ID: <20070304133443.GA8519@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>,
	Kurt Hackel <kurt.hackel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ocfs2: fix module_init error handling

Fix error handling in module_init and make module_init() return
correct error code.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
---
 fs/ocfs2/super.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

Index: 2.6-mm/fs/ocfs2/super.c
===================================================================
--- 2.6-mm.orig/fs/ocfs2/super.c
+++ 2.6-mm/fs/ocfs2/super.c
@@ -806,46 +806,58 @@ static int __init ocfs2_init(void)
 
 	ocfs2_print_version();
 
-	if (init_ocfs2_extent_maps())
-		return -ENOMEM;
+	status = init_ocfs2_extent_maps();
+	if (status)
+		goto err_extent_maps;
 
 	status = init_ocfs2_uptodate_cache();
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto err_uptodate_cache;
 	}
 
 	status = ocfs2_initialize_mem_caches();
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto err_mem_caches;
 	}
 
 	ocfs2_wq = create_singlethread_workqueue("ocfs2_wq");
 	if (!ocfs2_wq) {
 		status = -ENOMEM;
-		goto leave;
+		goto err_workqueue;
 	}
 
 	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
 	if (!ocfs2_debugfs_root) {
 		status = -EFAULT;
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
+		goto err_debugfs;
 	}
 
-leave:
-	if (status < 0) {
-		ocfs2_free_mem_caches();
-		exit_ocfs2_uptodate_cache();
-		exit_ocfs2_extent_maps();
-	}
+	status = register_filesystem(&ocfs2_fs_type);
+	if (status)
+		goto err_filesystem;
 
 	mlog_exit(status);
 
-	if (status >= 0) {
-		return register_filesystem(&ocfs2_fs_type);
-	} else
-		return -1;
+	return 0;
+
+err_filesystem:
+	debugfs_remove(ocfs2_debugfs_root);
+err_debugfs:
+	flush_workqueue(ocfs2_wq);
+	destroy_workqueue(ocfs2_wq);
+err_workqueue:
+	ocfs2_free_mem_caches();
+err_mem_caches:
+	exit_ocfs2_uptodate_cache();
+err_uptodate_cache:
+	exit_ocfs2_extent_maps();
+err_extent_maps:
+	mlog_exit(status);
+
+	return status;
 }
 
 static void __exit ocfs2_exit(void)
