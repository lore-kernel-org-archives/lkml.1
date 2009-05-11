Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZEKTzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZEKTzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZEKTyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:54:53 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:46600 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZEKTyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=dWw78GwLHCvZ2BSKaZi0Gniqk6voTK6fHCEXy156BO+jFgDkY9WGow/Ncw822GfOXN
         7VIPaqNItI/Crp6L38glxSMlsR5ObhRK9P8HMdNPppAL3vVyIK2QmB8hLe+6pyiZWZFt
         bFb+aybhjr1SLzBosgQ9unDbVgQE9soydaveQ=
Message-ID: <4A08828B.7090106@gmail.com>
Date: Mon, 11 May 2009 21:54:51 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linuxppc-dev@ozlabs.org, alsa-devel@alsa-project.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] aoa: remove driver_data direct access of struct device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid direct access to the driver_data pointer in struct device, the
functions dev_get_drvdata() and dev_set_drvdata() should be used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/sound/aoa/fabrics/layout.c b/sound/aoa/fabrics/layout.c
index fbf5c93..586965f 100644
--- a/sound/aoa/fabrics/layout.c
+++ b/sound/aoa/fabrics/layout.c
@@ -1037,7 +1037,7 @@ static int aoa_fabric_layout_probe(struct soundbus_dev *sdev)
 	}
 	ldev->selfptr_headphone.ptr = ldev;
 	ldev->selfptr_lineout.ptr = ldev;
-	sdev->ofdev.dev.driver_data = ldev;
+	dev_set_drvdata(&sdev->ofdev.dev, ldev);
 	list_add(&ldev->list, &layouts_list);
 	layouts_list_items++;
 
@@ -1081,7 +1081,7 @@ static int aoa_fabric_layout_probe(struct soundbus_dev *sdev)
 
 static int aoa_fabric_layout_remove(struct soundbus_dev *sdev)
 {
-	struct layout_dev *ldev = sdev->ofdev.dev.driver_data;
+	struct layout_dev *ldev = dev_get_drvdata(&sdev->ofdev.dev);
 	int i;
 
 	for (i=0; i<MAX_CODECS_PER_BUS; i++) {
@@ -1114,7 +1114,7 @@ static int aoa_fabric_layout_remove(struct soundbus_dev *sdev)
 #ifdef CONFIG_PM
 static int aoa_fabric_layout_suspend(struct soundbus_dev *sdev, pm_message_t state)
 {
-	struct layout_dev *ldev = sdev->ofdev.dev.driver_data;
+	struct layout_dev *ldev = dev_get_drvdata(&sdev->ofdev.dev);
 
 	if (ldev->gpio.methods && ldev->gpio.methods->all_amps_off)
 		ldev->gpio.methods->all_amps_off(&ldev->gpio);
@@ -1124,7 +1124,7 @@ static int aoa_fabric_layout_suspend(struct soundbus_dev *sdev, pm_message_t sta
 
 static int aoa_fabric_layout_resume(struct soundbus_dev *sdev)
 {
-	struct layout_dev *ldev = sdev->ofdev.dev.driver_data;
+	struct layout_dev *ldev = dev_get_drvdata(&sdev->ofdev.dev);
 
 	if (ldev->gpio.methods && ldev->gpio.methods->all_amps_off)
 		ldev->gpio.methods->all_amps_restore(&ldev->gpio);
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 418c84c..4e3b819 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -358,14 +358,14 @@ static int i2sbus_probe(struct macio_dev* dev, const struct of_device_id *match)
 		return -ENODEV;
 	}
 
-	dev->ofdev.dev.driver_data = control;
+	dev_set_drvdata(&dev->ofdev.dev, control);
 
 	return 0;
 }
 
 static int i2sbus_remove(struct macio_dev* dev)
 {
-	struct i2sbus_control *control = dev->ofdev.dev.driver_data;
+	struct i2sbus_control *control = dev_get_drvdata(&dev->ofdev.dev);
 	struct i2sbus_dev *i2sdev, *tmp;
 
 	list_for_each_entry_safe(i2sdev, tmp, &control->list, item)
@@ -377,7 +377,7 @@ static int i2sbus_remove(struct macio_dev* dev)
 #ifdef CONFIG_PM
 static int i2sbus_suspend(struct macio_dev* dev, pm_message_t state)
 {
-	struct i2sbus_control *control = dev->ofdev.dev.driver_data;
+	struct i2sbus_control *control = dev_get_drvdata(&dev->ofdev.dev);
 	struct codec_info_item *cii;
 	struct i2sbus_dev* i2sdev;
 	int err, ret = 0;
@@ -407,7 +407,7 @@ static int i2sbus_suspend(struct macio_dev* dev, pm_message_t state)
 
 static int i2sbus_resume(struct macio_dev* dev)
 {
-	struct i2sbus_control *control = dev->ofdev.dev.driver_data;
+	struct i2sbus_control *control = dev_get_drvdata(&dev->ofdev.dev);
 	struct codec_info_item *cii;
 	struct i2sbus_dev* i2sdev;
 	int err, ret = 0;
