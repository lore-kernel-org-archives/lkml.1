Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYJOOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYJOOLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbYJOOGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:06:18 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:32961 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbYJOOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:06:09 -0400
Subject: [PATCH 10/21] vfat: Fix vfat_find() error path in vfat_lookup()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:59 +0900
Message-ID: <db8ca48d3e848f5f6e71022369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
	<649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
	<2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
In-Reply-To: <2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current vfat_lookup() creates negetive dentry blindly if vfat_find()
returned a error. It's wrong. If the error isn't -ENOENT, just return
error.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/namei_vfat.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/fat/namei_vfat.c~vfat-lookup-fix-error fs/fat/namei_vfat.c
--- linux-2.6/fs/fat/namei_vfat.c~vfat-lookup-fix-error	2008-08-26 10:59:29.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/namei_vfat.c	2008-08-26 11:10:23.000000000 +0900
@@ -683,7 +683,7 @@ static struct dentry *vfat_lookup(struct
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
-	struct inode *inode = NULL;
+	struct inode *inode;
 	struct dentry *alias;
 	int err, table;
 
@@ -693,14 +693,18 @@ static struct dentry *vfat_lookup(struct
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err) {
-		table++;
+		if (err == -ENOENT) {
+			table++;
+			inode = NULL;
+			goto out;
+		}
 		goto error;
 	}
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
-		unlock_super(sb);
-		return ERR_CAST(inode);
+		err = PTR_ERR(inode);
+		goto error;
 	}
 	alias = d_find_alias(inode);
 	if (alias) {
@@ -713,7 +717,7 @@ static struct dentry *vfat_lookup(struct
 		}
 
 	}
-error:
+out:
 	unlock_super(sb);
 	dentry->d_op = &vfat_dentry_ops[table];
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
@@ -723,6 +727,10 @@ error:
 		dentry->d_time = dentry->d_parent->d_inode->i_version;
 	}
 	return dentry;
+
+error:
+	unlock_super(sb);
+	return ERR_PTR(err);
 }
 
 static int vfat_create(struct inode *dir, struct dentry *dentry, int mode,
_
