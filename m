Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZF3UIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZF3UIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZF3UIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:08:01 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:53924 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZF3UIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:08:00 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2009 16:08:00 EDT
X-Spam-Processed: digidescorp.com, Tue, 30 Jun 2009 15:02:51 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1432024fb5=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: steve@digidescorp.com
To: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Cc: "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] FAT: optimize FSINFO writeback
Date: Tue, 30 Jun 2009 15:02:10 -0500
Message-Id: <1246392130-4261-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only write the FSINFO block back to disk when its contents change.
This optimization can be important when the underlying physical media
can wear out, i.e. Flash.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/fs/fat/misc.c b/fs/fat/misc.c
--- a/fs/fat/misc.c	2009-06-29 11:12:40.000000000 -0500
+++ b/fs/fat/misc.c	2009-06-29 11:46:45.000000000 -0500
@@ -61,11 +61,25 @@ void fat_clusters_flush(struct super_blo
 		       le32_to_cpu(fsinfo->signature2),
 		       sbi->fsinfo_sector);
 	} else {
-		if (sbi->free_clusters != -1)
-			fsinfo->free_clusters = cpu_to_le32(sbi->free_clusters);
-		if (sbi->prev_free != -1)
-			fsinfo->next_cluster = cpu_to_le32(sbi->prev_free);
-		mark_buffer_dirty(bh);
+		char write_needed = 0;
+		__le32 le_value;
+
+		if (sbi->free_clusters != -1) {
+			le_value = cpu_to_le32(sbi->free_clusters);
+			if (fsinfo->free_clusters != le_value) {
+				fsinfo->free_clusters = le_value;
+				write_needed = 1;
+			}
+		}
+		if (sbi->prev_free != -1) {
+			le_value = cpu_to_le32(sbi->prev_free);
+			if (fsinfo->next_cluster != le_value) {
+				fsinfo->next_cluster = le_value;
+				write_needed = 1;
+			}
+		}
+		if (write_needed)
+			mark_buffer_dirty(bh);
 	}
 	brelse(bh);
 }

