Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZA0Nxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZA0Nxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZA0Nx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:53:28 -0500
Received: from mail.openmoko.org ([88.198.124.205]:46701 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbZA0Nx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:53:26 -0500
Subject: [PATCH 3/3] pcf50633_charger: Enable periodic charging restart
To: linux-kernel@vger.kernel.org
From: Balaji Rao <balajirrao@openmoko.org>
Cc: Anton Vorontsov <cbou@mail.ru>, Andy Green <andy@openmoko.com>
Date: Tue, 27 Jan 2009 19:23:12 +0530
Message-ID: <20090127135312.6875.94604.stgit@fedora.yogi>
In-Reply-To: <20090127135238.6875.26314.stgit@fedora.yogi>
References: <20090127135238.6875.26314.stgit@fedora.yogi>
User-Agent: StGit/0.14.3.328.gd3b3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The battery charger state machine switches into charging mode when
the battery voltage falls below 96% of a battery float voltage. But the
voltage drop in Li-ion batteries is marginal(1~2 %) till about 80% of its
capacity - which means, after a BATFULL, charging won't be restarted until 80%.

This work_struct function restarts charging at regular intervals to make sure
the battery doesn't discharge too much.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/pcf50633-charger.c  |   73 ++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/pcf50633/core.h |    2 +
 2 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index aceffdc..e8b278f 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -36,6 +36,8 @@ struct pcf50633_mbc {
 
 	struct power_supply usb;
 	struct power_supply adapter;
+
+	struct delayed_work charging_restart_work;
 };
 
 int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
@@ -43,6 +45,8 @@ int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 	struct pcf50633_mbc *mbc = platform_get_drvdata(pcf->mbc_pdev);
 	int ret = 0;
 	u8 bits;
+	int charging_start = 1;
+	u8 mbcs2, chgmod;
 
 	if (ma >= 1000)
 		bits = PCF50633_MBCC7_USB_1000mA;
@@ -50,8 +54,10 @@ int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 		bits = PCF50633_MBCC7_USB_500mA;
 	else if (ma >= 100)
 		bits = PCF50633_MBCC7_USB_100mA;
-	else
+	else {
 		bits = PCF50633_MBCC7_USB_SUSPEND;
+		charging_start = 0;
+	}
 
 	ret = pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_MBCC7,
 					PCF50633_MBCC7_USB_MASK, bits);
@@ -60,6 +66,22 @@ int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 	else
 		dev_info(pcf->dev, "usb curlim to %d mA\n", ma);
 
+	/* Manual charging start */
+	mbcs2 = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
+	chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
+
+	/* If chgmod == BATFULL, setting chgena has no effect.
+	 * We need to set resume instead.
+	 */
+	if (chgmod != PCF50633_MBCS2_MBC_BAT_FULL)
+		pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_MBCC1,
+				PCF50633_MBCC1_CHGENA, PCF50633_MBCC1_CHGENA);
+	else
+		pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_MBCC1,
+				PCF50633_MBCC1_RESUME, PCF50633_MBCC1_RESUME);
+
+	mbc->usb_active = charging_start;
+
 	power_supply_changed(&mbc->usb);
 
 	return ret;
@@ -145,10 +167,44 @@ static struct attribute_group mbc_attr_group = {
 	.attrs	= pcf50633_mbc_sysfs_entries,
 };
 
+/* MBC state machine switches into charging mode when the battery voltage
+ * falls below 96% of a battery float voltage. But the voltage drop in Li-ion
+ * batteries is marginal(1~2 %) till about 80% of its capacity - which means,
+ * after a BATFULL, charging won't be restarted until 80%.
+ *
+ * This work_struct function restarts charging at regular intervals to make
+ * sure we don't discharge too much
+ */
+
+static void pcf50633_mbc_charging_restart(struct work_struct *work)
+{
+	struct pcf50633_mbc *mbc;
+	u8 mbcs2, chgmod;
+
+	mbc = container_of(work, struct pcf50633_mbc,
+				charging_restart_work.work);
+
+	mbcs2 = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCS2);
+	chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
+
+	if (chgmod != PCF50633_MBCS2_MBC_BAT_FULL)
+		return;
+
+	/* Restart charging */
+	pcf50633_reg_set_bit_mask(mbc->pcf, PCF50633_REG_MBCC1,
+				PCF50633_MBCC1_RESUME, PCF50633_MBCC1_RESUME);
+	mbc->usb_active = 1;
+	power_supply_changed(&mbc->usb);
+
+	dev_info(mbc->pcf->dev, "Charging restarted\n");
+}
+
 static void
 pcf50633_mbc_irq_handler(int irq, void *data)
 {
 	struct pcf50633_mbc *mbc = data;
+	int chg_restart_interval =
+			mbc->pcf->pdata->charging_restart_interval;
 
 	/* USB */
 	if (irq == PCF50633_IRQ_USBINS) {
@@ -157,6 +213,7 @@ pcf50633_mbc_irq_handler(int irq, void *data)
 		mbc->usb_online = 0;
 		mbc->usb_active = 0;
 		pcf50633_mbc_usb_curlim_set(mbc->pcf, 0);
+		cancel_delayed_work_sync(&mbc->charging_restart_work);
 	}
 
 	/* Adapter */
@@ -171,7 +228,14 @@ pcf50633_mbc_irq_handler(int irq, void *data)
 	if (irq == PCF50633_IRQ_BATFULL) {
 		mbc->usb_active = 0;
 		mbc->adapter_active = 0;
-	}
+
+		if (chg_restart_interval > 0)
+			schedule_delayed_work(&mbc->charging_restart_work,
+							chg_restart_interval);
+	} else if (irq == PCF50633_IRQ_USBLIMON)
+		mbc->usb_active = 0;
+	else if (irq == PCF50633_IRQ_USBLIMOFF)
+		mbc->usb_active = 1;
 
 	power_supply_changed(&mbc->usb);
 	power_supply_changed(&mbc->adapter);
@@ -288,6 +352,9 @@ static int __devinit pcf50633_mbc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	INIT_DELAYED_WORK(&mbc->charging_restart_work,
+				pcf50633_mbc_charging_restart);
+
 	ret = sysfs_create_group(&pdev->dev.kobj, &mbc_attr_group);
 	if (ret)
 		dev_err(mbc->pcf->dev, "failed to create sysfs entries\n");
@@ -313,6 +380,8 @@ static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
 	power_supply_unregister(&mbc->usb);
 	power_supply_unregister(&mbc->adapter);
 
+	cancel_delayed_work_sync(&mbc->charging_restart_work);
+
 	kfree(mbc);
 
 	return 0;
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 4455b21..c8f51c3 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -29,6 +29,8 @@ struct pcf50633_platform_data {
 	char **batteries;
 	int num_batteries;
 
+	int charging_restart_interval;
+
 	/* Callbacks */
 	void (*probe_done)(struct pcf50633 *);
 	void (*mbc_event_callback)(struct pcf50633 *, int);

