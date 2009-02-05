Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbZBEIZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbZBEIZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZBEIZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:25:01 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:52331 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbZBEIZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:25:00 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82346615"
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org
Cc: inux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/3] mtd/maps: blackfin async flash maps - fix bug: dont leak resources when initializing in case of errors
Date: Thu,  5 Feb 2009 16:26:49 +0800
Message-Id: <1233822411-10210-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233822411-10210-1-git-send-email-cooloney@kernel.org>
References: <1233822411-10210-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/maps/bfin-async-flash.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/bfin-async-flash.c b/drivers/mtd/maps/bfin-async-flash.c
index 6fec86a..576611f 100644
--- a/drivers/mtd/maps/bfin-async-flash.c
+++ b/drivers/mtd/maps/bfin-async-flash.c
@@ -152,14 +152,18 @@ static int __devinit bfin_flash_probe(struct platform_device *pdev)
 
 	if (gpio_request(state->enet_flash_pin, DRIVER_NAME)) {
 		pr_devinit(KERN_ERR DRIVER_NAME ": Failed to request gpio %d\n", state->enet_flash_pin);
+		kfree(state);
 		return -EBUSY;
 	}
 	gpio_direction_output(state->enet_flash_pin, 1);
 
 	pr_devinit(KERN_NOTICE DRIVER_NAME ": probing %d-bit flash bus\n", state->map.bankwidth * 8);
 	state->mtd = do_map_probe(memory->name, &state->map);
-	if (!state->mtd)
+	if (!state->mtd) {
+		gpio_free(state->enet_flash_pin);
+		kfree(state);
 		return -ENXIO;
+	}
 
 #ifdef CONFIG_MTD_PARTITIONS
 	ret = parse_mtd_partitions(state->mtd, part_probe_types, &pdata->parts, 0);
-- 
1.5.6.3
