Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYJPR20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYJPR20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbYJPRO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:57 -0400
Received: from kroah.org ([198.145.64.141]:47021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756448AbYJPROz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Al Viro <viro@hera.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/46] sysfs: use ilookup5() instead of ilookup5_nowait()
Date: Thu, 16 Oct 2008 10:10:37 -0700
Message-Id: <1224177047-11859-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

As inode creation is protected by sysfs_mutex, ilookup5_nowait()
always either fails to find at all or finds one which is fully
initialized, so using ilookup5_nowait() or ilookup5() doesn't make any
difference.  Switch to ilookup5() as it's planned to be removed.  This
change also makes lookup return value handling a bit simpler.

This change was suggested by Al Viro.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@hera.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 53bc7fc..c183426 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -370,17 +370,17 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 	memset(acxt, 0, sizeof(*acxt));
 	acxt->parent_sd = parent_sd;
 
-	/* Lookup parent inode.  inode initialization and I_NEW
-	 * clearing are protected by sysfs_mutex.  By grabbing it and
-	 * looking up with _nowait variant, inode state can be
-	 * determined reliably.
+	/* Lookup parent inode.  inode initialization is protected by
+	 * sysfs_mutex, so inode existence can be determined by
+	 * looking up inode while holding sysfs_mutex.
 	 */
 	mutex_lock(&sysfs_mutex);
 
-	inode = ilookup5_nowait(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
-				parent_sd);
+	inode = ilookup5(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
+			 parent_sd);
+	if (inode) {
+		WARN_ON(inode->i_state & I_NEW);
 
-	if (inode && !(inode->i_state & I_NEW)) {
 		/* parent inode available */
 		acxt->parent_inode = inode;
 
@@ -393,8 +393,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 			mutex_lock(&inode->i_mutex);
 			mutex_lock(&sysfs_mutex);
 		}
-	} else
-		iput(inode);
+	}
 }
 
 /**
-- 
1.6.0.2

