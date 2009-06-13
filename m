Return-Path: <linux-kernel-owner+w=401wt.eu-S934651AbZFMBDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934651AbZFMBDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 21:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbZFMBCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 21:02:53 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48424 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934220AbZFMBCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 21:02:53 -0400
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 18:02:55 -0700
X-Google-Sender-Auth: d9f2213b97ebe775
Message-ID: <c8284b5b0906121802h3545fbfflf498fbba30fe42be@mail.gmail.com>
Subject: [PATCH 5/6] Unified AVR32/AT91 MCI Driver Support for a VCC Pin
From: Rob Emanuele <poorarm@shoreis.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the atmel-mci driver for a VCC pin in order to conserve
power if the MMC interface is powered down.

Please read the whole set, try it out, and comment.

Thank you,

Rob Emanuele

---
 drivers/mmc/host/atmel-mci.c |   33 ++++++++++++++++++++-------------
 include/linux/atmel-mci.h    |    2 ++
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 1c1a4b3..a639b93 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -214,6 +214,8 @@ struct atmel_mci_slot {

 	int			detect_pin;
 	int			wp_pin;
+	int			vcc_pin;
+	bool			vcc_pin_act_low;

 	struct timer_list	detect_timer;
 };
@@ -926,23 +928,19 @@ static void atmci_set_ios(struct mmc_host *mmc,
struct mmc_ios *ios)
 	}

 	switch (ios->power_mode) {
+	case MMC_POWER_OFF:
+		if (gpio_is_valid(slot->vcc_pin))
+			gpio_set_value(slot->vcc_pin, slot->vcc_pin_act_low);
+		break;
 	case MMC_POWER_UP:
+		if (gpio_is_valid(slot->vcc_pin))
+			gpio_set_value(slot->vcc_pin, !slot->vcc_pin_act_low);
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

@@ -1498,6 +1496,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	slot->host = host;
 	slot->detect_pin = slot_data->detect_pin;
 	slot->wp_pin = slot_data->wp_pin;
+	slot->vcc_pin = slot_data->vcc_pin;
+	slot->vcc_pin_act_low = slot_data->vcc_pin_act_low;
 	slot->sdc_reg = sdc_reg;

 	mmc->ops = &atmci_ops;
@@ -1534,6 +1534,13 @@ static int __init atmci_init_slot(struct atmel_mci *host,
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
index 2f1f957..3b4239a 100644
--- a/include/linux/atmel-mci.h
+++ b/include/linux/atmel-mci.h
@@ -24,6 +24,8 @@ struct mci_slot_pdata {
 	unsigned int		bus_width;
 	int			detect_pin;
 	int			wp_pin;
+	int			vcc_pin;
+	unsigned		vcc_pin_act_low:1;
 };

 /**
-- 
1.6.0.4
