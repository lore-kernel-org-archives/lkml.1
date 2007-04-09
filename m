Return-Path: <linux-kernel-owner+w=401wt.eu-S965997AbXDIVnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965997AbXDIVnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965982AbXDIVnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:43:25 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:32156 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965983AbXDIVaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:30:00 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Dirk Behme <dirk.behme@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 11/14] ARM: OMAP: H3 workqueue fixes
Date: Mon,  9 Apr 2007 17:28:36 -0400
Message-Id: <11761541721823-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176154169578-git-send-email-tony@atomide.com>
References: <1176154119123-git-send-email-tony@atomide.com> <11761541231278-git-send-email-tony@atomide.com> <11761541282179-git-send-email-tony@atomide.com> <1176154139299-git-send-email-tony@atomide.com> <117615414325-git-send-email-tony@atomide.com> <1176154146826-git-send-email-tony@atomide.com> <11761541501423-git-send-email-tony@atomide.com> <1176154157419-git-send-email-tony@atomide.com> <117615416178-git-send-email-tony@atomide.com> <11761541643961-git-send-email-tony@atomide.com> <1176154169578-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@gmail.com>

Signed-off-by: Dirk Behme <dirk.behme@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-h3.c   |   12 +++++++-----
 include/asm-arm/arch-omap/irda.h |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/board-h3.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-h3.c	2007-04-09 16:40:23.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-h3.c	2007-04-09 16:40:34.000000000 -0400
@@ -296,9 +296,11 @@ static int h3_select_irda(struct device 
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
@@ -323,9 +325,9 @@ static int h3_transceiver_mode(struct de
 {
 	struct omap_irda_config *irda_config = dev->platform_data;
 
+	irda_config->mode = mode;
 	cancel_delayed_work(&irda_config->gpio_expa);
-	PREPARE_WORK(&irda_config->gpio_expa, set_trans_mode, &mode);
-#error this is not permitted - mode is an argument variable
+	PREPARE_DELAYED_WORK(&irda_config->gpio_expa, set_trans_mode);
 	schedule_delayed_work(&irda_config->gpio_expa, 0);
 
 	return 0;
Index: linux-2.6/include/asm-arm/arch-omap/irda.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/irda.h	2007-04-09 16:38:12.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/irda.h	2007-04-09 16:40:34.000000000 -0400
@@ -31,6 +31,7 @@ struct omap_irda_config {
 	unsigned long src_start;
 	int tx_trigger;
 	int rx_trigger;
+	int mode;
 };
 
 #endif
