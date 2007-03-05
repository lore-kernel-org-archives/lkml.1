Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXCEVCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXCEVCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXCEU6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:42 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46868 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200AbXCEU6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:11 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 03/11] uml - hostfs: make hostfs= option work as a jail, as intended.
Date: Mon, 05 Mar 2007 21:49:01 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204901.9072.51033.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L4bZJ008334

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

When a given host directory is specified to be mounted both in hostfs=path1 and
with mount option -o path2, we should give access to path1/path2, but this does
not happen. Fix that in the simpler way.

Also, root_ino can be the empty string, since we use %s/%s as format.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 fs/hostfs/hostfs_kern.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 6f10e43..9baf697 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -47,7 +47,7 @@ struct dentry_operations hostfs_dentry_ops = {
 };
 
 /* Changed in hostfs_args before the kernel starts running */
-static char *root_ino = "/";
+static char *root_ino = "";
 static int append = 0;
 
 #define HOSTFS_SUPER_MAGIC 0x00c0ffee
@@ -947,15 +947,17 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	sb->s_magic = HOSTFS_SUPER_MAGIC;
 	sb->s_op = &hostfs_sbops;
 
-	if((data == NULL) || (*data == '\0'))
-		data = root_ino;
+	/* NULL is printed as <NULL> by sprintf: avoid that. */
+	if (data == NULL)
+		data = "";
 
 	err = -ENOMEM;
-	name = kmalloc(strlen(data) + 1, GFP_KERNEL);
+	name = kmalloc(strlen(root_ino) + 1
+			+ strlen(data) + 1, GFP_KERNEL);
 	if(name == NULL)
 		goto out;
 
-	strcpy(name, data);
+	sprintf(name, "%s/%s", root_ino, data);
 
 	root_inode = iget(sb, 0);
 	if(root_inode == NULL)


