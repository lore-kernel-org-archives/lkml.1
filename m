Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZCaN7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZCaN7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZCaN7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:59:20 -0400
Received: from relay.atmel.no ([80.232.32.139]:62517 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZCaN7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:59:20 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jonas Larsson <jonas.larsson@martinsson.se>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel-mci: Add support for inverted detect pin
Date: Tue, 31 Mar 2009 15:59:05 +0200
Message-Id: <1238507945-5453-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Larsson <jonas.larsson@martinsson.se>

Same patch as before, modified to use bool. Also adds description of
the new field in struct atmel_mci that I missed in the first patch.

This patch adds Atmel MCI support for inverted detect pins.

Signed-off-by: Jonas Larsson <jonas.larsson@martinsson.se>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
Pierre, if it's fine with you, I'd like to apply this to the avr32 tree
since I have another patch which depends on this as well as another
change which hasn't gone upstream yet.

 drivers/mmc/host/atmel-mci.c |   12 +++++++++---
 include/linux/atmel-mci.h    |    2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e94e920..22273ba 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -177,6 +177,7 @@ struct atmel_mci {
  *	available.
  * @wp_pin: GPIO pin used for card write protect sending, or negative
  *	if not available.
+ * @detect_is_active_high: The state of the detect pin when it is active.
  * @detect_timer: Timer used for debouncing @detect_pin interrupts.
  */
 struct atmel_mci_slot {
@@ -196,6 +197,7 @@ struct atmel_mci_slot {
 
 	int			detect_pin;
 	int			wp_pin;
+	bool			detect_is_active_high;
 
 	struct timer_list	detect_timer;
 };
@@ -924,7 +926,8 @@ static int atmci_get_cd(struct mmc_host *mmc)
 	struct atmel_mci_slot	*slot = mmc_priv(mmc);
 
 	if (gpio_is_valid(slot->detect_pin)) {
-		present = !gpio_get_value(slot->detect_pin);
+		present = !(gpio_get_value(slot->detect_pin) ^
+			    slot->detect_is_active_high);
 		dev_dbg(&mmc->class_dev, "card is %spresent\n",
 				present ? "" : "not ");
 	}
@@ -1028,7 +1031,8 @@ static void atmci_detect_change(unsigned long data)
 		return;
 
 	enable_irq(gpio_to_irq(slot->detect_pin));
-	present = !gpio_get_value(slot->detect_pin);
+	present = !(gpio_get_value(slot->detect_pin) ^
+		    slot->detect_is_active_high);
 	present_old = test_bit(ATMCI_CARD_PRESENT, &slot->flags);
 
 	dev_vdbg(&slot->mmc->class_dev, "detect change: %d (was %d)\n",
@@ -1456,6 +1460,7 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	slot->host = host;
 	slot->detect_pin = slot_data->detect_pin;
 	slot->wp_pin = slot_data->wp_pin;
+	slot->detect_is_active_high = slot_data->detect_is_active_high;
 	slot->sdc_reg = sdc_reg;
 
 	mmc->ops = &atmci_ops;
@@ -1477,7 +1482,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 		if (gpio_request(slot->detect_pin, "mmc_detect")) {
 			dev_dbg(&mmc->class_dev, "no detect pin available\n");
 			slot->detect_pin = -EBUSY;
-		} else if (gpio_get_value(slot->detect_pin)) {
+		} else if (gpio_get_value(slot->detect_pin) ^
+				slot->detect_is_active_high) {
 			clear_bit(ATMCI_CARD_PRESENT, &slot->flags);
 		}
 	}
diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
index 2f1f957..57b1846 100644
--- a/include/linux/atmel-mci.h
+++ b/include/linux/atmel-mci.h
@@ -10,6 +10,7 @@
  * @bus_width: Number of data lines wired up the slot
  * @detect_pin: GPIO pin wired to the card detect switch
  * @wp_pin: GPIO pin wired to the write protect sensor
+ * @detect_is_active_high: The state of the detect pin when it is active
  *
  * If a given slot is not present on the board, @bus_width should be
  * set to 0. The other fields are ignored in this case.
@@ -24,6 +25,7 @@ struct mci_slot_pdata {
 	unsigned int		bus_width;
 	int			detect_pin;
 	int			wp_pin;
+	bool			detect_is_active_high;
 };
 
 /**
-- 
1.6.0.4

