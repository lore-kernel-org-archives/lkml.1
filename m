Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbXDNU5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbXDNU5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 16:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbXDNU5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 16:57:42 -0400
Received: from as4.cineca.com ([130.186.84.213]:52184 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbXDNU5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 16:57:41 -0400
Message-ID: <46214044.7050205@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: reiserfs-dev@namesys.com, LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [2.6.20.4] BUG: dentry xattrs still in use in shrink_dcache_for_umount()
 with reiserfs
References: <461F63BD.6000901@users.sourceforge.net>
In-Reply-To: <461F63BD.6000901@users.sourceforge.net>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Sat, 14 Apr 2007 22:57:30 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, this bug occurs also in 2.6.20.7 vanilla...

Honestly I don't know if I'm doing nasty things there, but I tested the
following patch and it seems to fix the problem (at least for my case).

It explicitly invalidates all the dentries in the reiserfs "private" dir
and releases all the valid xattrs references before calling
kill_block_super().

Signed-off-by: Andrea Righi <a.righi@cineca.it>

--- linux-2.6.20.7/include/linux/reiserfs_xattr.h.orig	2007-04-14 22:00:38.000000000 +0200
+++ linux-2.6.20.7/include/linux/reiserfs_xattr.h	2007-04-14 22:12:43.000000000 +0200
@@ -7,6 +7,9 @@
 /* Magic value in header */
 #define REISERFS_XATTR_MAGIC 0x52465841	/* "RFXA" */
 
+#define PRIVROOT_NAME ".reiserfs_priv"
+#define XAROOT_NAME   "xattrs"
+
 struct reiserfs_xattr_header {
 	__le32 h_magic;		/* magic number for identification */
 	__le32 h_hash;		/* hash of the value */
--- linux-2.6.20.7/fs/reiserfs/xattr.c.orig	2007-04-14 18:53:02.000000000 +0200
+++ linux-2.6.20.7/fs/reiserfs/xattr.c	2007-04-14 22:12:43.000000000 +0200
@@ -48,8 +48,6 @@
 
 #define FL_READONLY 128
 #define FL_DIR_SEM_HELD 256
-#define PRIVROOT_NAME ".reiserfs_priv"
-#define XAROOT_NAME   "xattrs"
 
 static struct reiserfs_xattr_handler *find_xattr_handler_prefix(const char
 								*prefix);
--- linux-2.6.20.7/fs/reiserfs/super.c.orig	2007-04-14 18:53:06.000000000 +0200
+++ linux-2.6.20.7/fs/reiserfs/super.c	2007-04-14 22:47:06.000000000 +0200
@@ -432,17 +432,30 @@ int remove_save_link(struct inode *inode
 
 static void reiserfs_kill_sb(struct super_block *s)
 {
+	struct dentry *priv;
+
 	if (REISERFS_SB(s)) {
-		if (REISERFS_SB(s)->xattr_root) {
-			d_invalidate(REISERFS_SB(s)->xattr_root);
-			dput(REISERFS_SB(s)->xattr_root);
-			REISERFS_SB(s)->xattr_root = NULL;
-		}
+		priv = REISERFS_SB(s)->priv_root;
+		if (priv) {
+			struct dentry *loop, *tmp;
 
-		if (REISERFS_SB(s)->priv_root) {
-			d_invalidate(REISERFS_SB(s)->priv_root);
-			dput(REISERFS_SB(s)->priv_root);
 			REISERFS_SB(s)->priv_root = NULL;
+#ifdef CONFIG_REISERFS_FS_XATTR
+			REISERFS_SB(s)->xattr_root = NULL;
+
+			list_for_each_entry_safe(loop, tmp,
+						 &priv->d_subdirs,
+						 d_u.d_child) {
+				d_invalidate(loop);
+				if (!strcmp(loop->d_name.name, XAROOT_NAME)) {
+					if (loop->d_inode) {
+						dput(loop);
+					}
+				}
+			}
+#endif
+			d_invalidate(priv);
+			dput(priv);
 		}
 	}
 
