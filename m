Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYDYWYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYDYWYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933077AbYDYWUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:40 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40614 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763387AbYDYWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:36 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 04/12] Unionfs: lock inode around calls to notify_change()
Date: Fri, 25 Apr 2008 18:19:00 -0400
Message-Id: <12091619502387-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |    2 ++
 fs/unionfs/inode.c  |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index f71bddf..6d1e461 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -135,6 +135,7 @@ static int copyup_permissions(struct super_block *sb,
 	newattrs.ia_valid = ATTR_CTIME | ATTR_ATIME | ATTR_MTIME |
 		ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_FORCE |
 		ATTR_GID | ATTR_UID;
+	mutex_lock(&new_lower_dentry->d_inode->i_mutex);
 	err = notify_change(new_lower_dentry, &newattrs);
 	if (err)
 		goto out;
@@ -152,6 +153,7 @@ static int copyup_permissions(struct super_block *sb,
 	}
 
 out:
+	mutex_unlock(&new_lower_dentry->d_inode->i_mutex);
 	return err;
 }
 
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 1446124..582d08b 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -1040,7 +1040,9 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	}
 
 	/* notify the (possibly copied-up) lower inode */
+	mutex_lock(&lower_dentry->d_inode->i_mutex);
 	err = notify_change(lower_dentry, ia);
+	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 	if (err)
 		goto out;
 
-- 
1.5.2.2

