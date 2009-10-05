Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZJES0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZJES0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZJES0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:26:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39433 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZJES0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:26:36 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@redhat.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] ima: ecryptfs fix imbalance message (updated)
Date: Mon,  5 Oct 2009 14:25:44 -0400
Message-Id: <1254767144-4756-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unencrypted files are being measured.  Update the counters to get
rid of the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)

Reported-by: Sachin Garg
Cc: stable@kernel.org
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/ecryptfs/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 101fe4c..c6ac85d 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -35,6 +35,7 @@
 #include <linux/key.h>
 #include <linux/parser.h>
 #include <linux/fs_stack.h>
+#include <linux/ima.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -118,6 +119,7 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 	const struct cred *cred = current_cred();
 	struct ecryptfs_inode_info *inode_info =
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
+	int opened_lower_file = 0;
 	int rc = 0;
 
 	mutex_lock(&inode_info->lower_file_mutex);
@@ -134,9 +136,12 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 			       "for lower_dentry [0x%p] and lower_mnt [0x%p]; "
 			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
 			inode_info->lower_file = NULL;
-		}
+		} else
+			opened_lower_file = 1;
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
+	if (opened_lower_file)
+		ima_counts_get(inode_info->lower_file);
 	return rc;
 }
 
-- 
1.6.0.6

