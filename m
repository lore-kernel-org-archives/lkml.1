Return-Path: <linux-kernel-owner+w=401wt.eu-S1764410AbZFQA4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764410AbZFQA4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762455AbZFQAzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:55:35 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:53876 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761217AbZFQAze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:55:34 -0400
From: Rob Emanuele <rob@emanuele.us>
To: nicolas.ferre@atmel.com
Cc: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, Rob Emanuele <rob@emanuele.us>
Subject: [PATCH 5/6] atmel-mci: Power control option for each MMC Slot
Date: Tue, 16 Jun 2009 17:54:38 -0700
Message-Id: <1245200079-6323-5-git-send-email-rob@emanuele.us>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1245200079-6323-1-git-send-email-rob@emanuele.us>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the atmel-mci driver for a VCC pin in order to conserve power by removing power from an MMC Slot.

Signed-off-by: Rob Emanuele <rob@emanuele.us>
---
 drivers/mmc/host/atmel-mci.c |   33 ++++++++++++++++++++-------------
 include/linux/atmel-mci.h    |    2 ++
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 601dae7..63cd5c7 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -214,6 +214,8 @@ struct atmel_mci_slot {
 	int			detect_pin;
 	int			wp_pin;
 	bool			detect_is_active_high;
+	int			vcc_pin;
+	bool			vcc_active_low;
 
 	struct timer_list	detect_timer;
 };
@@ -932,23 +934,19 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 
 	switch (ios->power_mode) {
+	case MMC_POWER_OFF:
+		if (gpio_is_valid(slot->vcc_pin))
+			gpio_set_value(slot->vcc_pin, slot->vcc_active_low);
+		break;
 	case MMC_POWER_UP:
+		if (gpio_is_valid(slot->vcc_pin))
+			gpio_set_value(slot->vcc_pin, !slot->vcc_active_low);
 		set_bit(ATMCI_CARD_NEED_INIT, &slot->flags);
 		break;
-	default:
-		/*
-		 * TODO: None of the currently available AVR32-based
-		 * boards allow MMC power to be turned off. Implement
-		 * power control when this can be tested properly.
-		 *
-		 * We also need to hook this into the clock management
-		 * somehow so that newly inserted cards aren't
-		 * subjected to a fast clock before we have a chance
-		 * to figure out what the maximum rate is. Currently,
-		 * there's no way to avoid this, and there never will
-		 * be for boards that don't support power control.
-		 */
+	case MMC_POWER_ON:
 		break;
+	default:
+		WARN_ON(1);
 	}
 }
 
@@ -1507,6 +1505,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	slot->detect_pin = slot_data->detect_pin;
 	slot->wp_pin = slot_data->wp_pin;
 	slot->detect_is_active_high = slot_data->detect_is_active_high;
+	slot->vcc_pin = slot_data->vcc_pin;
+	slot->vcc_active_low = slot_data->vcc_active_low;
 	slot->sdc_reg = sdc_reg;
 
 	mmc->ops = &atmci_ops;
@@ -1544,6 +1544,13 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 		}
 	}
 
+	if (gpio_is_valid(slot->vcc_pin)) {
+		if (gpio_request(slot->vcc_pin, "mmc_pow")) {
+			dev_dbg(&mmc->class_dev, "no power pin available\n");
+			slot->vcc_pin = -EBUSY;
+		}
+	}
+
 	host->slot[id] = slot;
 	mmc_add_host(mmc);
 
diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
index 57b1846..7c15a7c 100644
--- a/include/linux/atmel-mci.h
+++ b/include/linux/atmel-mci.h
@@ -26,6 +26,8 @@ struct mci_slot_pdata {
 	int			detect_pin;
 	int			wp_pin;
 	bool			detect_is_active_high;
+	int			vcc_pin;
+	unsigned		vcc_active_low:1;
 };
 
 /**
-- 
1.6.0.4

