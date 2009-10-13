Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbZJMWBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbZJMWBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934292AbZJMWBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:01:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:53627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761035AbZJMWBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hxfcSuyh4NppPt7wRJ7Xy7tjwyo2rC/qwWfRCjuM+7JHCFCRApzGdT5MPGKKYg/aRi
         JWTdSf0drZ8a27ZuigY1op8UKUH7YXelyFujbYvcmxQ+lt3pJX304daAQeoqL0dnnQVK
         sqvurptuq8MPK2z+vxHGJWRFln4utb4xmpI9o=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH] power: pcf50633: get rid of charging restart software auto-triggering
Date: Wed, 14 Oct 2009 01:59:06 +0400
Message-Id: <1255471148-29047-4-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471148-29047-3-git-send-email-fercerpav@gmail.com>
References: <1255471148-29047-1-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-3-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reaching Battery Full condition MBC state machine switches back
into charging mode when the battery voltage falls below 96% of a
battery float voltage. The voltage drop in Li-Ion batteries is
marginal (1-2%) till about 80% of its capacity - which means, after a
BATFULL, charging won't be restarted until 75-80%.

That is a desired behaviour recommended by battery manufacturers,
don't mess with it.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/power/pcf50633-charger.c  |   46 -------------------------------------
 include/linux/mfd/pcf50633/core.h |    2 -
 2 files changed, 0 insertions(+), 48 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 13f2839..644c7eb 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -37,8 +37,6 @@ struct pcf50633_mbc {
 	struct power_supply usb;
 	struct power_supply adapter;
 	struct power_supply ac;
-
-	struct delayed_work charging_restart_work;
 };
 
 int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
@@ -231,44 +229,10 @@ static struct attribute_group mbc_attr_group = {
 	.attrs	= pcf50633_mbc_sysfs_entries,
 };
 
-/* MBC state machine switches into charging mode when the battery voltage
- * falls below 96% of a battery float voltage. But the voltage drop in Li-ion
- * batteries is marginal(1~2 %) till about 80% of its capacity - which means,
- * after a BATFULL, charging won't be restarted until 80%.
- *
- * This work_struct function restarts charging at regular intervals to make
- * sure we don't discharge too much
- */
-
-static void pcf50633_mbc_charging_restart(struct work_struct *work)
-{
-	struct pcf50633_mbc *mbc;
-	u8 mbcs2, chgmod;
-
-	mbc = container_of(work, struct pcf50633_mbc,
-				charging_restart_work.work);
-
-	mbcs2 = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCS2);
-	chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
-
-	if (chgmod != PCF50633_MBCS2_MBC_BAT_FULL)
-		return;
-
-	/* Restart charging */
-	pcf50633_reg_set_bit_mask(mbc->pcf, PCF50633_REG_MBCC1,
-				PCF50633_MBCC1_RESUME, PCF50633_MBCC1_RESUME);
-	mbc->usb_active = 1;
-	power_supply_changed(&mbc->usb);
-
-	dev_info(mbc->pcf->dev, "Charging restarted\n");
-}
-
 static void
 pcf50633_mbc_irq_handler(int irq, void *data)
 {
 	struct pcf50633_mbc *mbc = data;
-	int chg_restart_interval =
-			mbc->pcf->pdata->charging_restart_interval;
 
 	/* USB */
 	if (irq == PCF50633_IRQ_USBINS) {
@@ -277,7 +241,6 @@ pcf50633_mbc_irq_handler(int irq, void *data)
 		mbc->usb_online = 0;
 		mbc->usb_active = 0;
 		pcf50633_mbc_usb_curlim_set(mbc->pcf, 0);
-		cancel_delayed_work_sync(&mbc->charging_restart_work);
 	}
 
 	/* Adapter */
@@ -292,10 +255,6 @@ pcf50633_mbc_irq_handler(int irq, void *data)
 	if (irq == PCF50633_IRQ_BATFULL) {
 		mbc->usb_active = 0;
 		mbc->adapter_active = 0;
-
-		if (chg_restart_interval > 0)
-			schedule_delayed_work(&mbc->charging_restart_work,
-							chg_restart_interval);
 	} else if (irq == PCF50633_IRQ_USBLIMON)
 		mbc->usb_active = 0;
 	else if (irq == PCF50633_IRQ_USBLIMOFF)
@@ -458,9 +417,6 @@ static int __devinit pcf50633_mbc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	INIT_DELAYED_WORK(&mbc->charging_restart_work,
-				pcf50633_mbc_charging_restart);
-
 	ret = sysfs_create_group(&pdev->dev.kobj, &mbc_attr_group);
 	if (ret)
 		dev_err(mbc->pcf->dev, "failed to create sysfs entries\n");
@@ -487,8 +443,6 @@ static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
 	power_supply_unregister(&mbc->adapter);
 	power_supply_unregister(&mbc->ac);
 
-	cancel_delayed_work_sync(&mbc->charging_restart_work);
-
 	kfree(mbc);
 
 	return 0;
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 222dd90..392eaa4 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -29,8 +29,6 @@ struct pcf50633_platform_data {
 	char **batteries;
 	int num_batteries;
 
-	int charging_restart_interval;
-
 	int chg_ref_current_ma;
 
 	/* Callbacks */
-- 
1.6.0.6

