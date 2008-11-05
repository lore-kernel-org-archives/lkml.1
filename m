Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYKEOkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYKEOkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYKEOkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:40:12 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:50428 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYKEOkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:40:11 -0500
Date: Wed, 05 Nov 2008 23:40:18 +0900 (JST)
Message-Id: <20081105.234018.26100329.anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] physmap: Make map_info customizable
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a hook to physmap_flash_data for map_info initialization.
This makes platform code can customize map operations.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
Background: I wrote this patch to support RBTX4939 board, which
requires custom map->{read,write,copy_from} function.  I think
extending the physmap driver is better than adding a new map driver.

 drivers/mtd/maps/physmap.c  |    5 ++++-
 include/linux/mtd/physmap.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index dfbf3f2..7ca048d 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -128,7 +128,10 @@ static int physmap_flash_probe(struct platform_device *dev)
 			goto err_out;
 		}
 
-		simple_map_init(&info->map[i]);
+		if (physmap_data->map_init)
+			(*physmap_data->map_init)(&info->map[i]);
+		else
+			simple_map_init(&info->map[i]);
 
 		probe_type = rom_probe_types;
 		for (; info->mtd[i] == NULL && *probe_type != NULL; probe_type++)
diff --git a/include/linux/mtd/physmap.h b/include/linux/mtd/physmap.h
index c8e63a5..bf51a63 100644
--- a/include/linux/mtd/physmap.h
+++ b/include/linux/mtd/physmap.h
@@ -25,6 +25,7 @@ struct physmap_flash_data {
 	void			(*set_vpp)(struct map_info *, int);
 	unsigned int		nr_parts;
 	struct mtd_partition	*parts;
+	void			(*map_init)(struct map_info *map);
 };
 
 /*
-- 
1.5.6.3

