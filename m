Return-Path: <linux-kernel-owner+w=401wt.eu-S1764844AbYJMJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764844AbYJMJ6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760953AbYJMJnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:43:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51007 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759507AbYJMJnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:43:11 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 63/80] Simplify devpts_get_tty()
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:43:08 +0100
Message-ID: <20081013094304.21645.90958.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

As pointed out by H. Peter Anvin, since the inode for the pty is known,
we don't need to look it up.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 fs/devpts/inode.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)


diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 638db9b..b292ed7 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -27,6 +27,7 @@
 #define DEVPTS_SUPER_MAGIC 0x1cd1
 
 #define DEVPTS_DEFAULT_MODE 0600
+#define PTMX_MINOR	2
 
 extern int pty_limit;			/* Config limit on Unix98 ptys */
 static DEFINE_IDA(allocated_ptys);
@@ -247,19 +248,11 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 
 struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number)
 {
-	struct dentry *dentry = get_node(number);
-	struct tty_struct *tty;
-
-	tty = NULL;
-	if (!IS_ERR(dentry)) {
-		if (dentry->d_inode)
-			tty = dentry->d_inode->i_private;
-		dput(dentry);
-	}
-
-	mutex_unlock(&devpts_root->d_inode->i_mutex);
+	BUG_ON(pts_inode->i_rdev == MKDEV(TTYAUX_MAJOR, PTMX_MINOR));
 
-	return tty;
+	if (pts_inode->i_sb->s_magic == DEVPTS_SUPER_MAGIC)
+		return (struct tty_struct *)pts_inode->i_private;
+	return NULL;
 }
 
 void devpts_pty_kill(struct tty_struct *tty)

