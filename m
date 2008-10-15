Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYJOOMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYJOOMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbYJOOGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:06:22 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:32966 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbYJOOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:06:10 -0400
Subject: [PATCH 07/21] fat: improve fat_hash()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:58 +0900
Message-ID: <091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
In-Reply-To: <a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fat_hash() is using the algorithm known as bad. Instead of it, this
uses hash_32(). The following is the summary of test.

old hash:
	hash func (1000 times): 33489 cycles
	total inodes in hash table: 70926
	largest bucket contains: 696
	smallest bucket contains: 54

new hash:
	hash func (1000 times): 33129 cycles
	total inodes in hash table: 70926
	largest bucket contains: 315
	smallest bucket contains: 236

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fat.h   |    1 -
 fs/fat/inode.c |   18 +++++++-----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN fs/fat/fat.h~fat_improve-hash fs/fat/fat.h
--- linux-2.6/fs/fat/fat.h~fat_improve-hash	2008-08-25 03:33:31.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fat.h	2008-08-25 03:50:16.000000000 +0900
@@ -43,7 +43,6 @@ struct fat_mount_options {
 
 #define FAT_HASH_BITS	8
 #define FAT_HASH_SIZE	(1UL << FAT_HASH_BITS)
-#define FAT_HASH_MASK	(FAT_HASH_SIZE-1)
 
 /*
  * MS-DOS file system in-core superblock data
diff -puN fs/fat/inode.c~fat_improve-hash fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_improve-hash	2008-08-25 03:33:31.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-08-25 03:50:16.000000000 +0900
@@ -26,6 +26,7 @@
 #include <linux/uio.h>
 #include <linux/writeback.h>
 #include <linux/log2.h>
+#include <linux/hash.h>
 #include <asm/unaligned.h>
 #include "fat.h"
 
@@ -247,25 +248,21 @@ static void fat_hash_init(struct super_b
 		INIT_HLIST_HEAD(&sbi->inode_hashtable[i]);
 }
 
-static inline unsigned long fat_hash(struct super_block *sb, loff_t i_pos)
+static inline unsigned long fat_hash(loff_t i_pos)
 {
-	unsigned long tmp = (unsigned long)i_pos | (unsigned long) sb;
-	tmp = tmp + (tmp >> FAT_HASH_BITS) + (tmp >> FAT_HASH_BITS * 2);
-	return tmp & FAT_HASH_MASK;
+	return hash_32(i_pos, FAT_HASH_BITS);
 }
 
 void fat_attach(struct inode *inode, loff_t i_pos)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct hlist_head *head = sbi->inode_hashtable + fat_hash(i_pos);
 
 	spin_lock(&sbi->inode_hash_lock);
 	MSDOS_I(inode)->i_pos = i_pos;
-	hlist_add_head(&MSDOS_I(inode)->i_fat_hash,
-			sbi->inode_hashtable + fat_hash(sb, i_pos));
+	hlist_add_head(&MSDOS_I(inode)->i_fat_hash, head);
 	spin_unlock(&sbi->inode_hash_lock);
 }
-
 EXPORT_SYMBOL_GPL(fat_attach);
 
 void fat_detach(struct inode *inode)
@@ -276,13 +273,12 @@ void fat_detach(struct inode *inode)
 	hlist_del_init(&MSDOS_I(inode)->i_fat_hash);
 	spin_unlock(&sbi->inode_hash_lock);
 }
-
 EXPORT_SYMBOL_GPL(fat_detach);
 
 struct inode *fat_iget(struct super_block *sb, loff_t i_pos)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
-	struct hlist_head *head = sbi->inode_hashtable + fat_hash(sb, i_pos);
+	struct hlist_head *head = sbi->inode_hashtable + fat_hash(i_pos);
 	struct hlist_node *_p;
 	struct msdos_inode_info *i;
 	struct inode *inode = NULL;
_
