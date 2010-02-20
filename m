Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0BTXa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 18:30:29 -0500
Received: from legolas.restena.lu ([158.64.1.34]:39047 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab0BTXa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 18:30:26 -0500
Date: Sun, 21 Feb 2010 00:28:31 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Len Brown <len.brown@intel.com>, Anisse Astier <anisse@astier.eu>,
       Thomas Renninger <trenn@suse.de>, Matt Chen <machen@novell.com>,
       Harald Welte <laforge@gnumonks.org>, Martin Lucina <mato@kotelna.sk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       pancho horrillo <pancho@pancho.name>,
       Mike Frysinger <vapier@gentoo.org>,
       Vivek Kutal <vivek.kutal@azingo.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: [PATCH 3/3] backlight: fix missing/incomplete registration failure
 handling
Message-ID: <20100221002831.689bace8@neptune.home>
In-Reply-To: <20100221001049.2f63f5d6@neptune.home>
References: <20100221001049.2f63f5d6@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check newly registered backlight_device for error and properly
return error to parent

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/platform/x86/classmate-laptop.c |    2 ++
 drivers/platform/x86/msi-wmi.c          |    4 +++-
 drivers/platform/x86/panasonic-laptop.c |    4 +++-
 drivers/usb/misc/appledisplay.c         |    1 +
 drivers/video/bf54x-lq043fb.c           |    8 ++++++++
 drivers/video/bfin-t350mcqb-fb.c        |    8 ++++++++
 6 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index bfae789..66f6aad 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -463,6 +463,8 @@ static int cmpc_bl_add(struct acpi_device *acpi)
 
 	bd = backlight_device_register("cmpc_bl", &acpi->dev,
 				       acpi->handle, &cmpc_bl_ops);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
 	bd->props.max_brightness = 7;
 	dev_set_drvdata(&acpi->dev, bd);
 	return 0;
diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index 5f7cff1..2ffbfcf 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -251,8 +251,10 @@ static int __init msi_wmi_init(void)
 	if (!acpi_video_backlight_support()) {
 		backlight = backlight_device_register(DRV_NAME,
 				NULL, NULL, &msi_backlight_ops);
-		if (IS_ERR(backlight))
+		if (IS_ERR(backlight)) {
+			err = PTR_ERR(backlight);
 			goto err_free_input;
+		}
 
 		backlight->props.max_brightness = ARRAY_SIZE(backlight_map) - 1;
 		err = bl_get(NULL);
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 9012d8d..9b17343 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -644,8 +644,10 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	/* initialize backlight */
 	pcc->backlight = backlight_device_register("panasonic", NULL, pcc,
 						   &pcc_backlight_ops);
-	if (IS_ERR(pcc->backlight))
+	if (IS_ERR(pcc->backlight)) {
+		result = PTR_ERR(pcc->backlight);
 		goto out_input;
+	}
 
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf)) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index ef79ca2..413f154 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -283,6 +283,7 @@ static int appledisplay_probe(struct usb_interface *iface,
 						&appledisplay_bl_data);
 	if (IS_ERR(pdata->bd)) {
 		dev_err(&iface->dev, "Backlight registration failed\n");
+		retval = PTR_ERR(pdata->bd);
 		goto error;
 	}
 
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index db4e6f7..a589216 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -678,6 +678,12 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 	bl_dev =
 	    backlight_device_register("bf54x-bl", NULL, NULL,
 				      &bfin_lq043fb_bl_ops);
+	if (IS_ERR(bl_dev)) {
+		printk(KERN_ERR DRIVER_NAME
+		       ": unable to register backlight.\n");
+		ret = -EINVAL;
+		goto out9;
+	}
 	bl_dev->props.max_brightness = 255;
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, &pdev->dev, NULL, &bfin_lcd_ops);
@@ -686,6 +692,8 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 
 	return 0;
 
+out9:
+	unregister_framebuffer(fbinfo);
 out8:
 	free_irq(info->irq, info);
 out7:
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index bc204c6..fe1492b 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -572,6 +572,12 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 	bl_dev =
 	    backlight_device_register("bf52x-bl", NULL, NULL,
 				      &bfin_lq043fb_bl_ops);
+	if (IS_ERR(bl_dev)) {
+		printk(KERN_ERR DRIVER_NAME
+		       ": unable to register backlight.\n");
+		ret = -EINVAL;
+		goto out9;
+	}
 	bl_dev->props.max_brightness = 255;
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
@@ -580,6 +586,8 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 
 	return 0;
 
+out9:
+	unregister_framebuffer(fbinfo);
 out8:
 	free_irq(info->irq, info);
 out7:
-- 
1.6.4.4

