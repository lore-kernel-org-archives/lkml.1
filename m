Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYJOOKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYJOOKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbYJOOGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:06:09 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:32957 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbYJOOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:06:08 -0400
Subject: [PATCH 08/21] fat: Fix fat_ent_update_ptr() for FAT12
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:58 +0900
Message-ID: <649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
In-Reply-To: <091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes the missing update for bhs/nr_bhs in case the caller
accessed from block boundary to first block of boundary.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fatent.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/fat/fatent.c~fat-fix-fat12-update_ptr fs/fat/fatent.c
--- linux-2.6/fs/fat/fatent.c~fat-fix-fat12-update_ptr	2008-10-11 23:46:04.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fatent.c	2008-10-11 23:46:04.000000000 +0900
@@ -317,10 +317,20 @@ static inline int fat_ent_update_ptr(str
 	/* Is this fatent's blocks including this entry? */
 	if (!fatent->nr_bhs || bhs[0]->b_blocknr != blocknr)
 		return 0;
-	/* Does this entry need the next block? */
-	if (sbi->fat_bits == 12 && (offset + 1) >= sb->s_blocksize) {
-		if (fatent->nr_bhs != 2 || bhs[1]->b_blocknr != (blocknr + 1))
-			return 0;
+	if (sbi->fat_bits == 12) {
+		if ((offset + 1) < sb->s_blocksize) {
+			/* This entry is on bhs[0]. */
+			if (fatent->nr_bhs == 2) {
+				brelse(bhs[1]);
+				fatent->nr_bhs = 1;
+			}
+		} else {
+			/* This entry needs the next block. */
+			if (fatent->nr_bhs != 2)
+				return 0;
+			if (bhs[1]->b_blocknr != (blocknr + 1))
+				return 0;
+		}
 	}
 	ops->ent_set_ptr(fatent, offset);
 	return 1;
_
