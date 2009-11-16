Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZKPDHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZKPDHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 22:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZKPDHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 22:07:42 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:55053 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZKPDHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 22:07:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tzFcoEq12u73T3AhH0pp9SUJDqq+nxOHqzm4eyr+kihqfaut1jf793pQ0HXyNhjH97
         mCAy0zAz4nK3lMBte6YfX8PAuQWIILtYV1Scggdm3VryCNMfM66j39n8mwq0hw8FJKcT
         cp/TbMaLYemLhlxCHgQ7w6RDEvJq2Y5R254CE=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH -mm] hpfs: Use bitmap_weight()
Date: Mon, 16 Nov 2009 12:06:59 +0900
Message-Id: <1258340819-28166-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap_weight instead of doing hweight32 for each 32bit in bitmap.

This patch applies on top of hpfs-use-hweight32.patch in -mm

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hpfs/super.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index cf6fe4a..cadc4ce 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -14,6 +14,7 @@
 #include <linux/magic.h>
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
+#include <linux/bitmap.h>
 
 /* Mark the filesystem dirty, so that chkdsk checks it when os/2 booted */
 
@@ -115,12 +116,13 @@ static void hpfs_put_super(struct super_block *s)
 unsigned hpfs_count_one_bitmap(struct super_block *s, secno secno)
 {
 	struct quad_buffer_head qbh;
-	unsigned *bits;
-	unsigned i, count;
-	if (!(bits = hpfs_map_4sectors(s, secno, &qbh, 4))) return 0;
-	count = 0;
-	for (i = 0; i < 2048 / sizeof(unsigned); i++)
-		count += hweight32(bits[i]);
+	unsigned long *bits;
+	unsigned count;
+
+	bits = hpfs_map_4sectors(s, secno, &qbh, 4);
+	if (!bits)
+		return 0;
+	count = bitmap_weight(bits, 2048 * BITS_PER_BYTE);
 	hpfs_brelse4(&qbh);
 	return count;
 }
-- 
1.6.5.1

