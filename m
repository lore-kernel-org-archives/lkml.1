Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736Ab0AEAj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0AEAj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516Ab0AEAgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:36:06 -0500
Received: from kroah.org ([198.145.64.141]:42429 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab0AEAgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Monakhov <dmonakhov@openvz.org>,
       Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 80/97] Add unlocked version of inode_add_bytes() function
Date: Mon,  4 Jan 2010 16:33:33 -0800
Message-Id: <1262651630-7354-80-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit b462707e7ccad058ae151e5c5b06eb5cadcb737f upstream.

Quota code requires unlocked version of this function. Off course
we can just copy-paste the code, but copy-pasting is always an evil.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/stat.c          |   10 ++++++++--
 include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 075694e..c4ecd52 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -401,9 +401,9 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 */
 
-void inode_add_bytes(struct inode *inode, loff_t bytes)
+/* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
+void __inode_add_bytes(struct inode *inode, loff_t bytes)
 {
-	spin_lock(&inode->i_lock);
 	inode->i_blocks += bytes >> 9;
 	bytes &= 511;
 	inode->i_bytes += bytes;
@@ -411,6 +411,12 @@ void inode_add_bytes(struct inode *inode, loff_t bytes)
 		inode->i_blocks++;
 		inode->i_bytes -= 512;
 	}
+}
+
+void inode_add_bytes(struct inode *inode, loff_t bytes)
+{
+	spin_lock(&inode->i_lock);
+	__inode_add_bytes(inode, bytes);
 	spin_unlock(&inode->i_lock);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..98ea200 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2314,6 +2314,7 @@ extern const struct inode_operations page_symlink_inode_operations;
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
 loff_t inode_get_bytes(struct inode *inode);
-- 
1.6.6

