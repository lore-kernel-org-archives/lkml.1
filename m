Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0BHUNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:13:07 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:36919 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0BHUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:12:59 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 01/41] CAPI: Fix leaks in capifs_new_ncci
Date: Mon,  8 Feb 2010 21:12:05 +0100
Message-Id: <81d94ed7f89889cd0df8f426c50a1caee93fc938.1265659933.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX18nOKW56Roniu+iE/gALldC2VCLiQ/zdoF88/z1
	zJA0iN3qIrVy6Cs1hr4q0vUez+MiwcnLyjjOtsA/5fqVsRb0Ix
	YI7zAPk2M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When something went wrong during capifs_new_ncci, the looked up dentry
was not properly released. Neither was the allocated inode. Refactor the
function to avoid leaks.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capifs.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index 9f8f67b..dc68fcb 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -152,22 +152,33 @@ static struct dentry *get_node(int num)
 void capifs_new_ncci(unsigned int number, dev_t device)
 {
 	struct dentry *dentry;
-	struct inode *inode = new_inode(capifs_mnt->mnt_sb);
-	if (!inode)
-		return;
-	inode->i_ino = number+2;
+	struct inode *inode;
 
 	dentry = get_node(number);
+	if (IS_ERR(dentry))
+		goto unlock_out;
+
+	if (dentry->d_inode) {
+		dput(dentry);
+		goto unlock_out;
+	}
+
+	inode = new_inode(capifs_mnt->mnt_sb);
+	if (!inode) {
+		dput(dentry);
+		goto unlock_out;
+	}
 
 	/* config contents is protected by root's i_mutex */
 	inode->i_uid = config.setuid ? config.uid : current_fsuid();
 	inode->i_gid = config.setgid ? config.gid : current_fsgid();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	inode->i_ino = number + 2;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
-	//inode->i_op = &capifs_file_inode_operations;
 
-	if (!IS_ERR(dentry) && !dentry->d_inode)
-		d_instantiate(dentry, inode);
+	d_instantiate(dentry, inode);
+
+unlock_out:
 	mutex_unlock(&capifs_root->d_inode->i_mutex);
 }
 
-- 
1.6.0.2

