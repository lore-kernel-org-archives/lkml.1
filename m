Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYDUNTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYDUNTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbYDUNSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:18:44 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:35324 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274AbYDUNSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=TaDSVmz73HM68wUQdKkD61yl6lwE98AEsP/17R+OoOjRLoNzujyeCOSt+JxhFatMdW4qq5Wzu1DY+UFEAO5RDl19QM61bRhzFlOmhc063yYuWaoV/xI7a9WZni2n1mJ2z/PVh/Hu4E/9k3yeY/4PeI1RIyOQzV9tjz/2J5RekTo=
Message-Id: <7c6d0ee14cb7a4cfad4864dc196256da5749bc0c.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Wed, 2 Apr 2008 00:43:01 -0400
Subject: [PATCH 03/37] Input: ads7846 - simplify support of external vREF (and ads7843)
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: David Brownell <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the ads7846 driver to handle external vREF (required
on boards using ads7843 chips) without module parameters, and also
removes a needless variable with its associated bogus gcc warning.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/touchscreen/ads7846.c |   22 ++++++++++------------
 include/linux/spi/ads7846.h         |    3 ++-
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 57a1c28..a571aa9 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -87,6 +87,7 @@ struct ads7846 {
 #endif
 
 	u16			model;
+	u16			vref_mv;
 	u16			vref_delay_usecs;
 	u16			x_plate_ohms;
 	u16			pressure_max;
@@ -184,9 +185,6 @@ struct ads7846 {
  * The range is GND..vREF. The ads7843 and ads7835 must use external vREF;
  * ads7846 lets that pin be unconnected, to use internal vREF.
  */
-static unsigned vREF_mV;
-module_param(vREF_mV, uint, 0);
-MODULE_PARM_DESC(vREF_mV, "external vREF voltage, in milliVolts");
 
 struct ser_req {
 	u8			ref_on;
@@ -213,7 +211,6 @@ static int ads7846_read12_ser(struct device *dev, unsigned command)
 	struct ads7846		*ts = dev_get_drvdata(dev);
 	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
 	int			status;
-	int			uninitialized_var(sample);
 	int			use_internal;
 
 	if (!req)
@@ -270,13 +267,13 @@ static int ads7846_read12_ser(struct device *dev, unsigned command)
 
 	if (status == 0) {
 		/* on-wire is a must-ignore bit, a BE12 value, then padding */
-		sample = be16_to_cpu(req->sample);
-		sample = sample >> 3;
-		sample &= 0x0fff;
+		status = be16_to_cpu(req->sample);
+		status = status >> 3;
+		status &= 0x0fff;
 	}
 
 	kfree(req);
-	return status ? status : sample;
+	return status;
 }
 
 #if defined(CONFIG_HWMON) || defined(CONFIG_HWMON_MODULE)
@@ -317,7 +314,7 @@ static inline unsigned vaux_adjust(struct ads7846 *ts, ssize_t v)
 	unsigned retval = v;
 
 	/* external resistors may scale vAUX into 0..vREF */
-	retval *= vREF_mV;
+	retval *= ts->vref_mv;
 	retval = retval >> 12;
 	return retval;
 }
@@ -375,14 +372,14 @@ static int ads784x_hwmon_register(struct spi_device *spi, struct ads7846 *ts)
 	/* hwmon sensors need a reference voltage */
 	switch (ts->model) {
 	case 7846:
-		if (!vREF_mV) {
+		if (!ts->vref_mv) {
 			dev_dbg(&spi->dev, "assuming 2.5V internal vREF\n");
-			vREF_mV = 2500;
+			ts->vref_mv = 2500;
 		}
 		break;
 	case 7845:
 	case 7843:
-		if (!vREF_mV) {
+		if (!ts->vref_mv) {
 			dev_warn(&spi->dev,
 				"external vREF for ADS%d not specified\n",
 				ts->model);
@@ -875,6 +872,7 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 
 	ts->spi = spi;
 	ts->input = input_dev;
+	ts->vref_mv = pdata->vref_mv;
 
 	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ts->timer.function = ads7846_timer;
diff --git a/include/linux/spi/ads7846.h b/include/linux/spi/ads7846.h
index 334d314..daf7440 100644
--- a/include/linux/spi/ads7846.h
+++ b/include/linux/spi/ads7846.h
@@ -14,7 +14,8 @@ enum ads7846_filter {
 struct ads7846_platform_data {
 	u16	model;			/* 7843, 7845, 7846. */
 	u16	vref_delay_usecs;	/* 0 for external vref; etc */
-	int	keep_vref_on:1;		/* set to keep vref on for differential
+	u16	vref_mv;		/* external vref value, milliVolts */
+	bool	keep_vref_on;		/* set to keep vref on for differential
 					 * measurements as well */
 
 	/* Settling time of the analog signals; a function of Vcc and the
-- 
1.5.5.rc2.6.gf58d


