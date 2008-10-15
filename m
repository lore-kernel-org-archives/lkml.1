Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYJOOF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYJOOF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYJOOEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:50 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45089 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYJOOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:47 -0400
Subject: [PATCH 13/21] fat: Cleanup msdos_lookup()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:59 +0900
Message-ID: <5cfc12333e848f5f6e71322369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
	<649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
	<2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
	<db8ca48d3e848f5f6e71022369.ps@mail.parknet.co.jp>
	<6caa18733e848f5f6e71122369.ps@mail.parknet.co.jp>
	<c862f7d73e848f5f6e71222369.ps@mail.parknet.co.jp>
In-Reply-To: <c862f7d73e848f5f6e71222369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use same style with vfat_lookup().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/namei_msdos.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff -puN fs/fat/namei_msdos.c~msdos-lookup-cleanup fs/fat/namei_msdos.c
--- linux-2.6/fs/fat/namei_msdos.c~msdos-lookup-cleanup	2008-08-27 19:28:14.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/namei_msdos.c	2008-08-27 19:28:14.000000000 +0900
@@ -203,33 +203,37 @@ static struct dentry *msdos_lookup(struc
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
-	struct inode *inode = NULL;
-	int res;
-
-	dentry->d_op = &msdos_dentry_operations;
+	struct inode *inode;
+	int err;
 
 	lock_super(sb);
-	res = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
-	if (res == -ENOENT)
-		goto add;
-	if (res < 0)
-		goto out;
+
+	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
+	if (err) {
+		if (err == -ENOENT) {
+			inode = NULL;
+			goto out;
+		}
+		goto error;
+	}
+
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
-		res = PTR_ERR(inode);
-		goto out;
+		err = PTR_ERR(inode);
+		goto error;
 	}
-add:
-	res = 0;
+out:
+	unlock_super(sb);
+	dentry->d_op = &msdos_dentry_operations;
 	dentry = d_splice_alias(inode, dentry);
 	if (dentry)
 		dentry->d_op = &msdos_dentry_operations;
-out:
+	return dentry;
+
+error:
 	unlock_super(sb);
-	if (!res)
-		return dentry;
-	return ERR_PTR(res);
+	return ERR_PTR(err);
 }
 
 /***** Creates a directory entry (name is already formatted). */
_
