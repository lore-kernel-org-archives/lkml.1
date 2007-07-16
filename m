Return-Path: <linux-kernel-owner+w=401wt.eu-S1764308AbXGPBLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764308AbXGPBLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 21:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759709AbXGPBKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 21:10:42 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:58487 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370AbXGPBKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 21:10:40 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fat: Fix the race of read/write the FAT12 entry
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 16 Jul 2007 09:40:05 +0900
Message-ID: <873azpqize.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


FAT12 entry is 12bits, so it needs 2 phase to update the value.  And
writer and reader access it without any lock, so reader can get the
half updated value.

This fixes the long standing race condition by adding a global
spinlock to only FAT12 for avoiding any impact against FAT16/32.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fatent.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/fat/fatent.c~fat_fat12-entry-race-fix fs/fat/fatent.c
--- linux-2.6/fs/fat/fatent.c~fat_fat12-entry-race-fix	2007-07-15 05:18:09.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fatent.c	2007-07-15 05:18:56.000000000 +0900
@@ -17,6 +17,8 @@ struct fatent_operations {
 	int (*ent_next)(struct fat_entry *);
 };
 
+static DEFINE_SPINLOCK(fat12_entry_lock);
+
 static void fat12_ent_blocknr(struct super_block *sb, int entry,
 			      int *offset, sector_t *blocknr)
 {
@@ -116,10 +118,13 @@ static int fat12_ent_get(struct fat_entr
 	u8 **ent12_p = fatent->u.ent12_p;
 	int next;
 
+	spin_lock(&fat12_entry_lock);
 	if (fatent->entry & 1)
 		next = (*ent12_p[0] >> 4) | (*ent12_p[1] << 4);
 	else
 		next = (*ent12_p[1] << 8) | *ent12_p[0];
+	spin_unlock(&fat12_entry_lock);
+
 	next &= 0x0fff;
 	if (next >= BAD_FAT12)
 		next = FAT_ENT_EOF;
@@ -151,6 +156,7 @@ static void fat12_ent_put(struct fat_ent
 	if (new == FAT_ENT_EOF)
 		new = EOF_FAT12;
 
+	spin_lock(&fat12_entry_lock);
 	if (fatent->entry & 1) {
 		*ent12_p[0] = (new << 4) | (*ent12_p[0] & 0x0f);
 		*ent12_p[1] = new >> 4;
@@ -158,6 +164,7 @@ static void fat12_ent_put(struct fat_ent
 		*ent12_p[0] = new & 0xff;
 		*ent12_p[1] = (*ent12_p[1] & 0xf0) | (new >> 8);
 	}
+	spin_unlock(&fat12_entry_lock);
 
 	mark_buffer_dirty(fatent->bhs[0]);
 	if (fatent->nr_bhs == 2)
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
