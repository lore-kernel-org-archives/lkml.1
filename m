Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0BBNBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:01:01 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:40382 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab0BBNA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Qih+hRqJt9699xVqEuycV6tAm93guZs0qXJnQx7o8B/OAF1v8zhgIs8ncMiPB8PtOs
         wx9o+Z8JFi3bdhJVANSphPSNpXCAw9PgDuSjmjhixE8mRSbGVApGqyuYsWbiEmgE8aEc
         317+iRyr+YLCH+dKitdeVcht3x0sI+yRhw32E=
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: w@1wt.eu, Stefan Seyfried <seife@sphairon.com>
Subject: [PATCH 2.4] FAT: do not continue in fat_get_block if bmap fails
Date: Tue,  2 Feb 2010 14:00:35 +0100
Message-Id: <1265115635-22612-1-git-send-email-stefan.seyfried@googlemail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Seyfried <seife@sphairon.com>

There is no use in continuing the write operation after fat_bmap() fails.
(This successfully killed a VFAT FS for me).
The corresponding code in 2.6 does return here as well, AFAICT.

Signed-off-by: Stefan Seyfried <seife@sphairon.com>
---
 fs/fat/file.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index ade1a71..75efe74 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -72,8 +72,10 @@ int fat_get_block(struct inode *inode, long iblock, struct buffer_head *bh_resul
 	}
 	MSDOS_I(inode)->mmu_private += sb->s_blocksize;
 	phys = fat_bmap(inode, iblock);
-	if (!phys)
+	if (!phys) {
 		BUG();
+		return -EIO;
+	}
 	bh_result->b_dev = inode->i_dev;
 	bh_result->b_blocknr = phys;
 	bh_result->b_state |= (1UL << BH_Mapped);
-- 
1.6.4.2

