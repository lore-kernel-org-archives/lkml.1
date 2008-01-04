Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbYADMYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYADMYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYADMYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:24:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYADMYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:24:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080104112642.GY27894@ZenIV.linux.org.uk>
References: <20080104112642.GY27894@ZenIV.linux.org.uk> <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI> <477CEE1C.7020005@gmail.com> <20080104104755.GX27894@ZenIV.linux.org.uk> <20080104111357.GA3429@darkstar.te-china.tietoenator.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Dave Young <hidave.darkstar@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 04 Jan 2008 12:24:01 +0000
Message-ID: <22924.1199449441@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> Not enough.  isofs_iget() still can return NULL; that needs to be converted to
> ERR_PTR().
> 
> BTW, ERR_CAST is there for purpose...

This patch should probably be added on top of that one.

David
---
IGET: Add another couple of fixes to ISOFS error handling

From: David Howells <dhowells@redhat.com>

Add some more fixes to ISOFS error handling on top of Al Viro's patch:

 (1) Use IS_ERR() rather than ERR_PTR() to test for errors.

 (2) Return the error from isofs_iget() in parse_rock_ridge_inode_internal().

 (3) In isofs_export_get_parent() return -ENOMEM if that was the error rather
     than -EACCES.  Should we return -EIO if that is the error rather than
     -EACCES?

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/isofs/export.c |    8 +++++---
 fs/isofs/namei.c  |    2 +-
 fs/isofs/rock.c   |    4 +++-
 3 files changed, 9 insertions(+), 5 deletions(-)


diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index 63a2113..bb21913 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -26,7 +26,7 @@ isofs_export_iget(struct super_block *sb,
 	if (block == 0)
 		return ERR_PTR(-ESTALE);
 	inode = isofs_iget(sb, block, offset);
-	if (ERR_PTR(inode))
+	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	if (generation && inode->i_generation != generation) {
 		iput(inode);
@@ -108,8 +108,10 @@ static struct dentry *isofs_export_get_parent(struct dentry *child)
 	parent_inode = isofs_iget(child_inode->i_sb,
 				  parent_block,
 				  parent_offset);
-	if (ERR_PTR(parent_inode)) {
-		rv = ERR_PTR(-EACCES);
+	if (IS_ERR(parent_inode)) {
+		rv = ERR_CAST(parent_inode);
+		if (rv != ERR_PTR(-ENOMEM))
+			rv = ERR_PTR(-EACCES);
 		goto out;
 	}
 
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index beee021..344b247 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -179,7 +179,7 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	inode = NULL;
 	if (found) {
 		inode = isofs_iget(dir->i_sb, block, offset);
-		if (ERR_PTR(inode)) {
+		if (IS_ERR(inode)) {
 			unlock_kernel();
 			return ERR_CAST(inode);
 		}
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index c62b650..6bd48f0 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -474,8 +474,10 @@ repeat:
 			    isofs_iget(inode->i_sb,
 				       ISOFS_I(inode)->i_first_extent,
 				       0);
-			if (ERR_PTR(reloc))
+			if (IS_ERR(reloc)) {
+				ret = PTR_ERR(reloc);
 				goto out;
+			}
 			inode->i_mode = reloc->i_mode;
 			inode->i_nlink = reloc->i_nlink;
 			inode->i_uid = reloc->i_uid;
