Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbYKNMX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbYKNMX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 07:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYKNMWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 07:22:53 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52815 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbYKNMWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 07:22:51 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: [PATCH v2] mtd/bfin-async-flash: use parse_mtd()
Date: Fri, 14 Nov 2008 07:22:49 -0500
Message-Id: <1226665369-20248-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1226665351-20226-1-git-send-email-vapier@gentoo.org>
References: <1226665351-20226-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call parse_mtd() to handle partition/device registration rather than doing
it all ourself.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2:
	- call unparse_mtd()

 drivers/mtd/maps/bfin-async-flash.c |   32 ++++----------------------------
 1 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/mtd/maps/bfin-async-flash.c b/drivers/mtd/maps/bfin-async-flash.c
index 6fec86a..e432f94 100644
--- a/drivers/mtd/maps/bfin-async-flash.c
+++ b/drivers/mtd/maps/bfin-async-flash.c
@@ -120,13 +120,8 @@ static void bfin_copy_to(struct map_info *map, unsigned long to, const void *fro
 	switch_back(state);
 }
 
-#ifdef CONFIG_MTD_PARTITIONS
-static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
-#endif
-
 static int __devinit bfin_flash_probe(struct platform_device *pdev)
 {
-	int ret;
 	struct physmap_flash_data *pdata = pdev->dev.platform_data;
 	struct resource *memory = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct resource *flash_ambctl = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -150,6 +145,8 @@ static int __devinit bfin_flash_probe(struct platform_device *pdev)
 	state->flash_ambctl0  = flash_ambctl->start;
 	state->flash_ambctl1  = flash_ambctl->end;
 
+	platform_set_drvdata(pdev, state);
+
 	if (gpio_request(state->enet_flash_pin, DRIVER_NAME)) {
 		pr_devinit(KERN_ERR DRIVER_NAME ": Failed to request gpio %d\n", state->enet_flash_pin);
 		return -EBUSY;
@@ -161,35 +158,14 @@ static int __devinit bfin_flash_probe(struct platform_device *pdev)
 	if (!state->mtd)
 		return -ENXIO;
 
-#ifdef CONFIG_MTD_PARTITIONS
-	ret = parse_mtd_partitions(state->mtd, part_probe_types, &pdata->parts, 0);
-	if (ret > 0) {
-		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using commandline partition definition\n");
-		add_mtd_partitions(state->mtd, pdata->parts, ret);
-
-	} else if (pdata->nr_parts) {
-		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using board partition definition\n");
-		add_mtd_partitions(state->mtd, pdata->parts, pdata->nr_parts);
-
-	} else
-#endif
-	{
-		pr_devinit(KERN_NOTICE DRIVER_NAME ": no partition info available, registering whole flash at once\n");
-		add_mtd_device(state->mtd);
-	}
-
-	platform_set_drvdata(pdev, state);
-
-	return 0;
+	return parse_mtd(state->mtd, NULL, pdata->parts, pdata->nr_parts, false);
 }
 
 static int __devexit bfin_flash_remove(struct platform_device *pdev)
 {
 	struct async_state *state = platform_get_drvdata(pdev);
 	gpio_free(state->enet_flash_pin);
-#ifdef CONFIG_MTD_PARTITIONS
-	del_mtd_partitions(state->mtd);
-#endif
+	unparse_mtd(state->mtd);
 	map_destroy(state->mtd);
 	kfree(state);
 	return 0;
-- 
1.6.0.3

