Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbYJEQ00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbYJEQ00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbYJEQVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:21:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57963 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756596AbYJEQVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:21:49 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 59/76] Simplify devpts_pty_kill
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:21:49 +0100
Message-ID: <20081005162139.1997.29585.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

When creating a new pty, save the pty's inode in the tty->driver_data.
Use this inode in pty_kill() to identify the devpts instance. Since
we now have the inode for the pty, we can skip get_node() lookup and
remove the unused get_node().

TODO:
	- check if the mutex_lock is needed in pty_kill().

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 fs/devpts/inode.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 50e885f..a70d5d0 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -170,14 +170,6 @@ static struct file_system_type devpts_fs_type = {
  * to the System V naming convention
  */
 
-static struct dentry *get_node(int num)
-{
-	char s[12];
-	struct dentry *root = devpts_root;
-	mutex_lock(&root->d_inode->i_mutex);
-	return lookup_one_len(s, root, sprintf(s, "%d", num));
-}
-
 int devpts_new_index(struct inode *ptmx_inode)
 {
 	int index;
@@ -235,6 +227,7 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	inode->i_private = tty;
+	tty->driver_data = inode;
 
 	sprintf(s, "%d", number);
 
@@ -262,18 +255,20 @@ struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number)
 
 void devpts_pty_kill(struct tty_struct *tty)
 {
-	int number = tty->index;
-	struct dentry *dentry = get_node(number);
+	struct inode *inode = tty->driver_data;
+	struct dentry *dentry;
 
-	if (!IS_ERR(dentry)) {
-		struct inode *inode = dentry->d_inode;
-		if (inode) {
-			inode->i_nlink--;
-			d_delete(dentry);
-			dput(dentry);
-		}
+	BUG_ON(inode->i_rdev == MKDEV(TTYAUX_MAJOR, PTMX_MINOR));
+
+	mutex_lock(&devpts_root->d_inode->i_mutex);
+
+	dentry = d_find_alias(inode);
+	if (dentry && !IS_ERR(dentry)) {
+		inode->i_nlink--;
+		d_delete(dentry);
 		dput(dentry);
 	}
+
 	mutex_unlock(&devpts_root->d_inode->i_mutex);
 }
 

