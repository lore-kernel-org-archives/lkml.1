Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYDYWXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYDYWXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933062AbYDYWUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:36 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40612 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbYDYWU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:26 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 12/12] Unionfs: lock parent dentry branch config in write
Date: Fri, 25 Apr 2008 18:19:08 -0400
Message-Id: <12091619542355-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that branch configuration is available to file_revalidate should a
copyup be required.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/file.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 09f594d..9b5fc58 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -55,7 +55,9 @@ static ssize_t unionfs_write(struct file *file, const char __user *buf,
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_PARENT);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
-	err = unionfs_file_revalidate(file, true);
+	if (dentry != dentry->d_parent)
+		unionfs_lock_dentry(dentry->d_parent, UNIONFS_DMUTEX_PARENT);
+	err = unionfs_file_revalidate_locked(file, true);
 	if (unlikely(err))
 		goto out;
 
@@ -72,6 +74,8 @@ static ssize_t unionfs_write(struct file *file, const char __user *buf,
 	}
 
 out:
+	if (dentry != dentry->d_parent)
+		unionfs_unlock_dentry(dentry->d_parent);
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
-- 
1.5.2.2

