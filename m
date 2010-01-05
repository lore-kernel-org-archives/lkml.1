Return-Path: <linux-kernel-owner+w=401wt.eu-S932140Ab0AEUHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0AEUHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531Ab0AEUGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:06:31 -0500
Received: from kroah.org ([198.145.64.141]:50083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab0AEUG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:03 2010
Message-Id: <20100105200303.540167814@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>
Subject: [35/39] Add unlocked version of inode_add_bytes() function
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -401,9 +401,9 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, cha
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
@@ -411,6 +411,12 @@ void inode_add_bytes(struct inode *inode
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
 
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2296,6 +2296,7 @@ extern const struct inode_operations pag
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
 loff_t inode_get_bytes(struct inode *inode);


