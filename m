Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZCFBne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZCFBne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 20:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZCFBnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 20:43:25 -0500
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:5317 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751871AbZCFBnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 20:43:24 -0500
Date: Fri, 06 Mar 2009 10:43:18 +0900 (JST)
Message-Id: <20090306.104318.233533541.nemoto@toshiba-tops.co.jp>
To: dwmw2@infradead.org
Cc: akpm@linux-foundation.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, philipp.zabel@gmail.com,
       matthias@kaehlcke.net
Subject: [PATCH] mtd: physmap: Fix NULL pointer dereference in error path
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e480814f138cd5d78a8efe397756ba6b6518fdb6 ("[MTD] [MAPS]
physmap: fix wrong free and del_mtd_{partition,device}") introduces a
NULL pointer dereference in physmap_flash_remove when called from the
error path in physmap_flash_probe (if map_probe failed).

Call del_mtd_{partition,device} only if info->cmtd was not NULL.

Reported-by: pHilipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/mtd/maps/physmap.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 4b122e7..2297182 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -46,16 +46,19 @@ static int physmap_flash_remove(struct platform_device *dev)
 
 	physmap_data = dev->dev.platform_data;
 
+	if (info->cmtd) {
 #ifdef CONFIG_MTD_PARTITIONS
-	if (info->nr_parts) {
-		del_mtd_partitions(info->cmtd);
-		kfree(info->parts);
-	} else if (physmap_data->nr_parts)
-		del_mtd_partitions(info->cmtd);
-	else
-		del_mtd_device(info->cmtd);
+		if (info->nr_parts || physmap_data->nr_parts)
+			del_mtd_partitions(info->cmtd);
+		else
+			del_mtd_device(info->cmtd);
 #else
-	del_mtd_device(info->cmtd);
+		del_mtd_device(info->cmtd);
+#endif
+	}
+#ifdef CONFIG_MTD_PARTITIONS
+	if (info->nr_parts)
+		kfree(info->parts);
 #endif
 
 #ifdef CONFIG_MTD_CONCAT
-- 
1.5.6.5
