Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbYKRHcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbYKRHcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYKRHbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:31:53 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:10620 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYKRHbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:31:51 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62689566"
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] mtd/maps: blackfin async flash maps - fix bug: dont leak resources when initializing in case of errors
Date: Tue, 18 Nov 2008 15:33:16 +0800
Message-Id: <1226993597-31998-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226993597-31998-1-git-send-email-cooloney@kernel.org>
References: <1226993597-31998-1-git-send-email-cooloney@kernel.org>
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
