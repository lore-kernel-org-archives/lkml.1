Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYJEQ0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYJEQ0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbYJEQVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:21:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57961 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758772AbYJEQVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:21:34 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 58/76] Simplify devpts_pty_new()
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:21:34 +0100
Message-ID: <20081005162132.1997.31705.stgit@localhost.localdomain>
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

devpts_pty_new() is called when setting up a new pty and would not
will not have an existing dentry or inode for the pty. So don't bother
looking for an existing dentry - just create a new one.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 fs/devpts/inode.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index b292ed7..50e885f 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -220,6 +220,7 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 	dev_t device = MKDEV(driver->major, driver->minor_start+number);
 	struct dentry *dentry;
 	struct inode *inode = new_inode(devpts_mnt->mnt_sb);
+	char s[12];
 
 	/* We're supposed to be given the slave end of a pty */
 	BUG_ON(driver->type != TTY_DRIVER_TYPE_PTY);
@@ -235,9 +236,13 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	inode->i_private = tty;
 
-	dentry = get_node(number);
-	if (!IS_ERR(dentry) && !dentry->d_inode) {
-		d_instantiate(dentry, inode);
+	sprintf(s, "%d", number);
+
+	mutex_lock(&devpts_root->d_inode->i_mutex);
+
+	dentry = d_alloc_name(devpts_root, s);
+	if (!IS_ERR(dentry)) {
+		d_add(dentry, inode);
 		fsnotify_create(devpts_root->d_inode, dentry);
 	}
 

