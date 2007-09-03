Return-Path: <linux-kernel-owner+w=401wt.eu-S934315AbXICChy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbXICChy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbXICC0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:23 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57757 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbXICCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:25:56 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 19/32] Unionfs: partial_lookup update
Date: Sun,  2 Sep 2007 22:20:42 -0400
Message-Id: <11887860581524-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Handle new semantics of lookup_backend.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index e4e8470..d05daa5 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -425,20 +425,30 @@ out:
 	return ERR_PTR(err);
 }
 
-/* This is a utility function that fills in a unionfs dentry */
+/*
+ * This is a utility function that fills in a unionfs dentry.
+ *
+ * Returns: 0 (ok), or -ERRNO if an error occurred.
+ */
 int unionfs_partial_lookup(struct dentry *dentry)
 {
 	struct dentry *tmp;
 	struct nameidata nd = { .flags = 0 };
+	int err = -ENOSYS;
 
 	tmp = unionfs_lookup_backend(dentry, &nd, INTERPOSE_PARTIAL);
-	if (!tmp)
-		return 0;
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
+	if (!tmp) {
+		err = 0;
+		goto out;
+	}
+	if (IS_ERR(tmp)) {
+		err = PTR_ERR(tmp);
+		goto out;
+	}
 	/* need to change the interface */
 	BUG_ON(tmp != dentry);
-	return -ENOSYS;
+out:
+	return err;
 }
 
 /* The dentry cache is just so we have properly sized dentries. */
-- 
1.5.2.2.238.g7cbf2f2

