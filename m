Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbZGPQIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbZGPQIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932455AbZGPQIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:08:39 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50042 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbZGPQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:08:38 -0400
Date: Thu, 16 Jul 2009 18:08:33 +0200
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 3/3] ds2760: implement set_charged() feature
Message-ID: <20090716160833.GR19257@buzzloop.caiaq.de>
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de> <1247759044-4747-2-git-send-email-daniel@caiaq.de> <1247759044-4747-3-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247759044-4747-3-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 05:44:04PM +0200, Daniel Mack wrote:
> The ds2760's internal current meter is not reliable enough as it has an
> inacurracy of around ~15%. Without any correction for that error, the
> current accumulator is couting up all the time, even though the battery
> is already fully charged and hence destroys the static information. The
> longer it is connected, the worse is the aberration.
> 
> Fortunately, this can be corrected by the DS2760_CURRENT_OFFSET_BIAS
> register. Using the external power_supply_set_battery_charged()
> function, this register is now gauging the measurement.
> 
> A delayed work is used to debounce flaky GPIO signals and to let the
> current value settle. Also see Maxim's application note AN4188.

One more small correction - we need to manually write back the BIAS
level to the di->raw buffer as ds2760_battery_read_status() won't do it
for us after the first time.

Daniel


commit ebb1173a2c6e1334b1afc7cd119b39eca2350351
Author: Daniel Mack <daniel@caiaq.de>
Date:   Thu Jul 16 17:28:56 2009 +0200

    ds2760: implement set_charged() feature
    
    The ds2760's internal current meter is not reliable enough as it has an
    inacurracy of around ~15%. Without any correction for that error, the
    current accumulator is couting up all the time, even though the battery
    is already fully charged and hence destroys the static information. The
    longer it is connected, the worse is the aberration.
    
    Fortunately, this can be corrected by the DS2760_CURRENT_OFFSET_BIAS
    register. Using the external power_supply_set_battery_charged()
    function, this register is now gauging the measurement.
    
    A delayed work is used to debounce flaky GPIO signals and to let the
    current value settle. Also see Maxim's application note AN4188.
    
    Signed-off-by: Daniel Mack <daniel@caiaq.de>
    Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
    Cc: Matt Reimer <mreimer@vpop.net>
    Cc: Anton Vorontsov <cbou@mail.ru>

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index f4a9258..9a95bc1 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -56,6 +56,7 @@ struct ds2760_device_info {
 	struct device *w1_dev;
 	struct workqueue_struct *monitor_wqueue;
 	struct delayed_work monitor_work;
+	struct delayed_work set_charged_work;
 };
 
 static unsigned int cache_time = 1000;
@@ -327,6 +328,52 @@ static void ds2760_battery_external_power_changed(struct power_supply *psy)
 	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, HZ/10);
 }
 
+
+static void ds2760_battery_set_charged_work(struct work_struct *work)
+{
+	char bias;
+	struct ds2760_device_info *di = container_of(work,
+		struct ds2760_device_info, set_charged_work.work);
+
+	dev_dbg(di->dev, "%s\n", __func__);
+
+	ds2760_battery_read_status(di);
+
+	/* When we get notified by external circuitry that the battery is
+	 * considered fully charged now, we know that there is no current
+	 * flow any more. However, the ds2760's internal current meter is
+	 * too inaccurate to rely on - spec say something ~15% failure.
+	 * Hence, we use the current offset bias register to compensate
+	 * that error.
+	 */
+
+	if (!power_supply_am_i_supplied(&di->bat))
+		return;
+
+	bias = di->current_raw +
+		(signed char) di->raw[DS2760_CURRENT_OFFSET_BIAS];
+
+	dev_dbg(di->dev, "%s: bias = %d\n", __func__, bias);
+
+	w1_ds2760_write(di->w1_dev, &bias, DS2760_CURRENT_OFFSET_BIAS, 1);
+	w1_ds2760_store_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK1);
+	w1_ds2760_recall_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK1);
+
+	/* Write to the di->raw[] buffer directly - the CURRENT_OFFSET_BIAS
+	 * value won't be read back by ds2760_battery_read_status() */
+	di->raw[DS2760_CURRENT_OFFSET_BIAS] = bias;
+}
+
+static void ds2760_battery_set_charged(struct power_supply *psy)
+{
+	struct ds2760_device_info *di = to_ds2760_device_info(psy);
+
+	/* postpone the actual work by 20 secs. This is for debouncing GPIO
+	 * signals and to let the current value settle. See AN4188. */
+	cancel_delayed_work(&di->set_charged_work);
+	queue_delayed_work(di->monitor_wqueue, &di->set_charged_work, HZ * 20);
+}
+
 static int ds2760_battery_get_property(struct power_supply *psy,
 				       enum power_supply_property psp,
 				       union power_supply_propval *val)
@@ -412,6 +459,7 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	di->bat.properties	= ds2760_battery_props;
 	di->bat.num_properties	= ARRAY_SIZE(ds2760_battery_props);
 	di->bat.get_property	= ds2760_battery_get_property;
+	di->bat.set_charged	= ds2760_battery_set_charged;
 	di->bat.external_power_changed =
 				  ds2760_battery_external_power_changed;
 
@@ -443,6 +491,7 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	}
 
 	INIT_DELAYED_WORK(&di->monitor_work, ds2760_battery_work);
+	INIT_DELAYED_WORK(&di->set_charged_work, ds2760_battery_set_charged_work);
 	di->monitor_wqueue = create_singlethread_workqueue(dev_name(&pdev->dev));
 	if (!di->monitor_wqueue) {
 		retval = -ESRCH;
@@ -467,6 +516,8 @@ static int ds2760_battery_remove(struct platform_device *pdev)
 
 	cancel_rearming_delayed_workqueue(di->monitor_wqueue,
 					  &di->monitor_work);
+	cancel_rearming_delayed_workqueue(di->monitor_wqueue,
+					  &di->set_charged_work);
 	destroy_workqueue(di->monitor_wqueue);
 	power_supply_unregister(&di->bat);
 
