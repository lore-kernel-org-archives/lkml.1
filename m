Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbZCFLBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbZCFLBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZCFLBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:01:14 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:65284 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZCFLBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:01:14 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Sascha Hauer <s.hauer@pengutronix.de>, Eugene Konev <ejka@openwrt.org>,
       Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mtdpart: Make all partition parsers return allocated array
Date: Fri,  6 Mar 2009 20:01:08 +0900
Message-Id: <1236337268-4891-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently redboot and afx parser return allocated mtd_partition array
and cmdlinepart and ar7 return persistent array.

This patch make cmdlinepart and ar7 also return allocated array, so
that all users can free it regardless of parser type.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/mtd/ar7part.c     |    6 ++++--
 drivers/mtd/cmdlinepart.c |    6 +++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ar7part.c b/drivers/mtd/ar7part.c
index ecf170b..6697a1e 100644
--- a/drivers/mtd/ar7part.c
+++ b/drivers/mtd/ar7part.c
@@ -44,8 +44,6 @@ struct ar7_bin_rec {
 	unsigned int address;
 };
 
-static struct mtd_partition ar7_parts[AR7_PARTS];
-
 static int create_mtd_partitions(struct mtd_info *master,
 				 struct mtd_partition **pparts,
 				 unsigned long origin)
@@ -57,7 +55,11 @@ static int create_mtd_partitions(struct mtd_info *master,
 	unsigned int root_offset = ROOT_OFFSET;
 
 	int retries = 10;
+	struct mtd_partition *ar7_parts;
 
+	ar7_parts = kzalloc(sizeof(*ar7_parts) * AR7_PARTS, GFP_KERNEL);
+	if (!ar7_parts)
+		return -ENOMEM;
 	ar7_parts[0].name = "loader";
 	ar7_parts[0].offset = 0;
 	ar7_parts[0].size = master->erasesize;
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 50a3403..5011fa7 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -335,7 +335,11 @@ static int parse_cmdline_partitions(struct mtd_info *master,
 				}
 				offset += part->parts[i].size;
 			}
-			*pparts = part->parts;
+			*pparts = kmemdup(part->parts,
+					sizeof(*part->parts) * part->num_parts,
+					GFP_KERNEL);
+			if (!*pparts)
+				return -ENOMEM;
 			return part->num_parts;
 		}
 	}
-- 
1.5.6.3

