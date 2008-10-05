Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYJEQZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYJEQZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbYJEQV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:21:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57959 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758757AbYJEQV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:21:26 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 57/76] Simplify devpts_get_tty()
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:21:26 +0100
Message-ID: <20081005162125.1997.12639.stgit@localhost.localdomain>
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

