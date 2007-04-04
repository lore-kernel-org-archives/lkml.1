Return-Path: <linux-kernel-owner+w=401wt.eu-S934072AbXDDSMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbXDDSMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934081AbXDDSMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:12:17 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38475 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934072AbXDDSLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:11:24 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 55/90] ARM: OMAP: H3 workqueue fixes
Date: Wed,  4 Apr 2007 14:05:34 -0400
Message-Id: <11757101164151-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101141643-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme_at_gmail.com>

Signed-off-by: Dirk Behme <dirk.behme_at_gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-h3.c   |   12 +++++++-----
 include/asm-arm/arch-omap/irda.h |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 1ce0ec3..4167f34 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -296,9 +296,11 @@ static int h3_select_irda(struct device *dev, int state)
 	return err;
 }
 
-static void set_trans_mode(void *data)
+static void set_trans_mode(struct work_struct *work)
 {
-	int *mode = data;
+	struct omap_irda_config *irda_config =
+		container_of(work, struct omap_irda_config, gpio_expa.work);
+	int mode = irda_config->mode;
 	unsigned char expa;
 	int err = 0;
 
@@ -308,7 +310,7 @@ static void set_trans_mode(void *data)
 
 	expa &= ~0x03;
 
-	if (*mode & IR_SIRMODE) {
+	if (mode & IR_SIRMODE) {
 		expa |= 0x01;
 	} else { /* MIR/FIR */
 		expa |= 0x03;
@@ -323,9 +325,9 @@ static int h3_transceiver_mode(struct device *dev, int mode)
 {
 	struct omap_irda_config *irda_config = dev->platform_data;
 
+	irda_config->mode = mode;
 	cancel_delayed_work(&irda_config->gpio_expa);
-	PREPARE_WORK(&irda_config->gpio_expa, set_trans_mode, &mode);
-#error this is not permitted - mode is an argument variable
+	PREPARE_DELAYED_WORK(&irda_config->gpio_expa, set_trans_mode);
 	schedule_delayed_work(&irda_config->gpio_expa, 0);
 
 	return 0;
diff --git a/include/asm-arm/arch-omap/irda.h b/include/asm-arm/arch-omap/irda.h
index 345a649..96bb12f 100644
--- a/include/asm-arm/arch-omap/irda.h
+++ b/include/asm-arm/arch-omap/irda.h
@@ -31,6 +31,7 @@ struct omap_irda_config {
 	unsigned long src_start;
 	int tx_trigger;
 	int rx_trigger;
+	int mode;
 };
 
 #endif
-- 
1.4.4.2

