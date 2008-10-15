Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYJOOGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYJOOGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYJOOEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:51 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45093 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYJOOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:47 -0400
Subject: [PATCH 20/21] fat: ->i_pos race fix
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:01 +0900
Message-ID: <ed5d0b893e848f5f6e92022369.ps@mail.parknet.co.jp>
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
	<5cfc12333e848f5f6e71322369.ps@mail.parknet.co.jp>
	<6b812e3e3e848f5f6e81422369.ps@mail.parknet.co.jp>
	<cd30496c3e848f5f6e81522369.ps@mail.parknet.co.jp>
	<056ecdb93e848f5f6e81622369.ps@mail.parknet.co.jp>
	<9562d38c3e848f5f6e81722369.ps@mail.parknet.co.jp>
	<e24598993e848f5f6e91822369.ps@mail.parknet.co.jp>
	<01d62c0f3e848f5f6e91922369.ps@mail.parknet.co.jp>
In-Reply-To: <01d62c0f3e848f5f6e91922369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i_pos is 64bits value, hence it's not atomic to update.

Important place is fat_write_inode() only, other places without lock
are just for printk().

This adds lock for "BITS_PER_LONG == 32" kernel.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fat_i_pos-race-fix fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_i_pos-race-fix	2008-09-29 19:04:03.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-09-29 19:04:03.000000000 +0900
@@ -542,6 +542,20 @@ static int fat_statfs(struct dentry *den
 	return 0;
 }
 
+static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+				    struct inode *inode)
+{
+	loff_t i_pos;
+#if BITS_PER_LONG == 32
+	spin_lock(&sbi->inode_hash_lock);
+#endif
+	i_pos = MSDOS_I(inode)->i_pos;
+#if BITS_PER_LONG == 32
+	spin_unlock(&sbi->inode_hash_lock);
+#endif
+	return i_pos;
+}
+
 static int fat_write_inode(struct inode *inode, int wait)
 {
 	struct super_block *sb = inode->i_sb;
@@ -551,9 +565,12 @@ static int fat_write_inode(struct inode 
 	loff_t i_pos;
 	int err;
 
+	if (inode->i_ino == MSDOS_ROOT_INO)
+		return 0;
+
 retry:
-	i_pos = MSDOS_I(inode)->i_pos;
-	if (inode->i_ino == MSDOS_ROOT_INO || !i_pos)
+	i_pos = fat_i_pos_read(sbi, inode);
+	if (!i_pos)
 		return 0;
 
 	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
_
