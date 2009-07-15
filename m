Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbZGOU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbZGOU5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbZGOU5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:57:22 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38595 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbZGOU5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:57:21 -0400
Date: Wed, 15 Jul 2009 22:57:16 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mreimer@vpop.net,
       linux-kernel@vger.kernel.org, szabolcs.gyurko@tlt.hu, cbou@mail.ru
Subject: Re: [PATCH 4/4] ds2760: handle full_active_uAh == 0 case correctly
Message-ID: <20090715205716.GT18340@buzzloop.caiaq.de>
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de> <1247674841-9909-2-git-send-email-daniel@caiaq.de> <1247674841-9909-3-git-send-email-daniel@caiaq.de> <1247674841-9909-4-git-send-email-daniel@caiaq.de> <147B4C9E-4AE2-4FAD-BC58-7D5D905A1B77@vpop.net> <20090715185159.GI9464@buzzloop.caiaq.de> <20090715120625.cb8937f3.akpm@linux-foundation.org> <20090715192833.GA8938@oksana.dev.rtsoft.ru> <20090715200246.GJ9464@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715200246.GJ9464@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 10:02:46PM +0200, Daniel Mack wrote:
> On Wed, Jul 15, 2009 at 11:28:33PM +0400, Anton Vorontsov wrote:
> > Yep. All patches look good, I'll apply them to battery-2.6.git.
> 
> Thanks. Please consider applying the one below as well if you're fine
> with it. We need that parameter for bootstrapping in the factory when
> devices are produced.

> When connecting a ds2760 to a partly loaded battery the first time,
> there must be a way to bootstrap the current_accum value. Without that,
> the current capactity value is bogus until the battery is fully charged
> for the first time.

Erm, sorry, here's another version that does the 0.25mAh -> Ah
calculation in ds2760_battery_set_current_accum().

Daniel

>From e89cd102afe30dcb26fa3c788b439aebc52a93c3 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Wed, 15 Jul 2009 21:57:29 +0200
Subject: [PATCH] ds2760: add current_accum module parameter

When connecting a ds2760 to a partly loaded battery the first time,
there must be a way to bootstrap the current_accum value. Without that,
the current capactity value is bogus until the battery is fully charged
for the first time.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/ds2760_battery.c |   41 ++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 2d0e5ed..f4a9258 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -70,6 +70,10 @@ static unsigned int rated_capacity;
 module_param(rated_capacity, uint, 0644);
 MODULE_PARM_DESC(rated_capacity, "rated battery capacity, 10*mAh or index");
 
+static unsigned int current_accum;
+module_param(current_accum, uint, 0644);
+MODULE_PARM_DESC(current_accum, "current accumulator value");
+
 /* Some batteries have their rated capacity stored a N * 10 mAh, while
  * others use an index into this table. */
 static int rated_capacities[] = {
@@ -215,6 +219,22 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 	return 0;
 }
 
+static void ds2760_battery_set_current_accum(struct ds2760_device_info *di,
+					     unsigned int acr_val)
+{
+	unsigned char acr[2];
+
+	/* acr is in units of 0.25 mAh */
+	acr_val *= 4L;
+	acr_val /= 1000;
+
+	acr[0] = acr_val >> 8;
+	acr[1] = acr_val & 0xff;
+
+	if (w1_ds2760_write(di->w1_dev, acr, DS2760_CURRENT_ACCUM_MSB, 2) < 2)
+		dev_warn(di->dev, "ACR write failed\n");
+}
+
 static void ds2760_battery_update_status(struct ds2760_device_info *di)
 {
 	int old_charge_status = di->charge_status;
@@ -246,21 +266,9 @@ static void ds2760_battery_update_status(struct ds2760_device_info *di)
 			if (di->full_counter < 2) {
 				di->charge_status = POWER_SUPPLY_STATUS_CHARGING;
 			} else {
-				unsigned char acr[2];
-				int acr_val;
-
-				/* acr is in units of 0.25 mAh */
-				acr_val = di->full_active_uAh * 4L / 1000;
-
-				acr[0] = acr_val >> 8;
-				acr[1] = acr_val & 0xff;
-
-				if (w1_ds2760_write(di->w1_dev, acr,
-				    DS2760_CURRENT_ACCUM_MSB, 2) < 2)
-					dev_warn(di->dev,
-						 "ACR reset failed\n");
-
 				di->charge_status = POWER_SUPPLY_STATUS_FULL;
+				ds2760_battery_set_current_accum(di,
+						di->full_active_uAh);
 			}
 		}
 	} else {
@@ -423,6 +431,11 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	if (rated_capacity)
 		ds2760_battery_write_rated_capacity(di, rated_capacity);
 
+	/* set current accumulator if given as parameter.
+	 * this should only be done for bootstrapping the value */
+	if (current_accum)
+		ds2760_battery_set_current_accum(di, current_accum);
+
 	retval = power_supply_register(&pdev->dev, &di->bat);
 	if (retval) {
 		dev_err(di->dev, "failed to register battery\n");
-- 
1.6.3.1

