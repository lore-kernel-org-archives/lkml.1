Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZKDV0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZKDV0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZKDV0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:26:11 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41415 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbZKDV0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:26:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LkfmN8xF+U1n5ed0Abn/qFi8zEZngpo8p6Bbf2bxGZGGSbe10Lpp6VS176LINwjh62
         XtgKMbAkLghAf3LLZP9PxVNDhakhQ+ORpoyiw8nAdBA9HjWnYKvbNUR60godwNChnSy9
         7dnQmypCGDkFJnJhKx0465YNuTPo94qqgGnyk=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 4/6] power: pcf50633: get rid of charging restart software auto-triggering
Date: Thu,  5 Nov 2009 00:24:57 +0300
Message-Id: <1257369899-325-4-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257369899-325-3-git-send-email-fercerpav@gmail.com>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
 <1257369899-325-3-git-send-email-fercerpav@gmail.com>
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
index 21b6e64..3383119 100644
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
@@ -236,44 +234,10 @@ static struct attribute_group mbc_attr_group = {
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
@@ -282,7 +246,6 @@ pcf50633_mbc_irq_handler(int irq, void *data)
 		mbc->usb_online = 0;
 		mbc->usb_active = 0;
 		pcf50633_mbc_usb_curlim_set(mbc->pcf, 0);
-		cancel_delayed_work_sync(&mbc->charging_restart_work);
 	}
 
 	/* Adapter */
@@ -297,10 +260,6 @@ pcf50633_mbc_irq_handler(int irq, void *data)
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
@@ -463,9 +422,6 @@ static int __devinit pcf50633_mbc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	INIT_DELAYED_WORK(&mbc->charging_restart_work,
-				pcf50633_mbc_charging_restart);
-
 	ret = sysfs_create_group(&pdev->dev.kobj, &mbc_attr_group);
 	if (ret)
 		dev_err(mbc->pcf->dev, "failed to create sysfs entries\n");
@@ -492,8 +448,6 @@ static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
 	power_supply_unregister(&mbc->adapter);
 	power_supply_unregister(&mbc->ac);
 
-	cancel_delayed_work_sync(&mbc->charging_restart_work);
-
 	kfree(mbc);
 
 	return 0;
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 09af8fd..46df7f0 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -29,8 +29,6 @@ struct pcf50633_platform_data {
 	char **batteries;
 	int num_batteries;
 
-	int charging_restart_interval;
-
 	/*
 	 * Should be set accordingly to the reference resistor used, see
 	 * I_{ch(ref)} charger reference current in the pcf50633 User
-- 
1.6.4.4

