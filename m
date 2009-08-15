Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZHOHP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZHOHP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 03:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZHOHP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 03:15:56 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:33109 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZHOHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 03:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=FFzMUXYiDedmaaFgeSKfivG237hFt3o+kWF+glik6DZkiL1GolHoee5QbvUTvDEUJE
         XYlHiNW7TNPWwBInpzw9F3gNChXTQ2IpFYiJugrBwDwIxsxxS4YhH1mCsd0qLziKryZx
         REfb6MYm5EhGRaPIU81s4ruuiMqg960L8dYmA=
Date: Sat, 15 Aug 2009 00:15:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Soeren Sonnenburg <bugreports@nn7.de>,
       =?iso-8859-1?Q?J=E9r=E9mie?= Huchet <jeremie@lamah.info>
Subject: Re: [PATCH] Samsung backlight driver
References: <20090814194815.GA31474@kroah.com> <20090814222533.26D94526EC9@mailhub.coreip.homeip.net> <20090814224835.GA31585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814224835.GA31585@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090815074645.A8582526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 03:48:35PM -0700, Greg KH wrote:
> Here's an updated version, with two more laptop models supported, and
> the comments from Dmitry added in.
> 

You are leaking pci device reference in error unwinding path....

Here you go, just fold it together with yours.

-- 
Dmitry

Fix PCI device reference leak in error handling path; move more code
into __init/__exit sections; simplify searching for video card and
use less globals.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/platform/x86/samsung-backlight.c |  100 +++++++++++-------------------
 1 files changed, 36 insertions(+), 64 deletions(-)


diff --git a/drivers/platform/x86/samsung-backlight.c b/drivers/platform/x86/samsung-backlight.c
index accc20e..8df5fc5 100644
--- a/drivers/platform/x86/samsung-backlight.c
+++ b/drivers/platform/x86/samsung-backlight.c
@@ -21,23 +21,24 @@
 #define MAX_BRIGHT	0xff
 #define OFFSET		0xf4
 
+static int offset = OFFSET;
+module_param(offset, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(offset, "The offset into the PCI device for the brightness control");
+
 static struct pci_dev *pci_device;
 static struct backlight_device *backlight_device;
-static int offset = OFFSET;
-static u8 current_brightness;
 
-static void read_brightness(void)
+static u8 read_brightness(void)
 {
-	if (!pci_device)
-		return;
-	pci_read_config_byte(pci_device, offset, &current_brightness);
+	u8 brightness;
+
+	pci_read_config_byte(pci_device, offset, &brightness);
+	return brightness;
 }
 
-static void set_brightness(void)
+static void set_brightness(u8 brightness)
 {
-	if (!pci_device)
-		return;
-	pci_write_config_byte(pci_device, offset, current_brightness);
+	pci_write_config_byte(pci_device, offset, brightness);
 }
 
 static int get_brightness(struct backlight_device *bd)
@@ -47,11 +48,7 @@ static int get_brightness(struct backlight_device *bd)
 
 static int update_status(struct backlight_device *bd)
 {
-	if (!pci_device)
-		return -ENODEV;
-
-	current_brightness = bd->props.brightness;
-	set_brightness();
+	set_brightness(bd->props.brightness);
 	return 0;
 }
 
@@ -60,51 +57,7 @@ static struct backlight_ops backlight_ops = {
 	.update_status	= update_status,
 };
 
-static int find_video_card(void)
-{
-	struct pci_dev *dev = NULL;
-
-	while ((dev = pci_get_device(0x8086, 0x27ae, dev)) != NULL) {
-		/*
-		 * Found one, so let's save it off and break
-		 * Note that the reference is still raised on
-		 * the PCI device here.
-		 */
-		pci_device = dev;
-		break;
-	}
-
-	if (!pci_device)
-		return -ENODEV;
-
-	/* create a backlight device to talk to this one */
-	backlight_device = backlight_device_register("samsung",
-						     &pci_device->dev,
-						     NULL, &backlight_ops);
-	if (IS_ERR(backlight_device))
-		return PTR_ERR(backlight_device);
-	read_brightness();
-	backlight_device->props.max_brightness = MAX_BRIGHT;
-	backlight_device->props.brightness = current_brightness;
-	backlight_device->props.power = FB_BLANK_UNBLANK;
-	backlight_update_status(backlight_device);
-	return 0;
-}
-
-static void remove_video_card(void)
-{
-	if (!pci_device)
-		return;
-
-	backlight_device_unregister(backlight_device);
-	backlight_device = NULL;
-
-	/* we are done with the PCI device, put it back */
-	pci_dev_put(pci_device);
-	pci_device = NULL;
-}
-
-static int dmi_check_cb(const struct dmi_system_id *id)
+static int __init dmi_check_cb(const struct dmi_system_id *id)
 {
 	printk(KERN_INFO KBUILD_MODNAME ": found laptop model '%s'\n",
 		id->ident);
@@ -147,12 +100,33 @@ static int __init samsung_init(void)
 	if (!dmi_check_system(samsung_dmi_table))
 		return -ENODEV;
 
-	return find_video_card();
+	pci_device = pci_get_device(0x8086, 0x27ae, NULL);
+	if (!pci_device)
+		return -ENODEV;
+
+	/* create a backlight device to talk to this one */
+	backlight_device = backlight_device_register("samsung",
+						     &pci_device->dev,
+						     NULL, &backlight_ops);
+	if (IS_ERR(backlight_device)) {
+		pci_dev_put(pci_device);
+		return PTR_ERR(backlight_device);
+	}
+
+	backlight_device->props.max_brightness = MAX_BRIGHT;
+	backlight_device->props.brightness = read_brightness();
+	backlight_device->props.power = FB_BLANK_UNBLANK;
+	backlight_update_status(backlight_device);
+
+	return 0;
 }
 
 static void __exit samsung_exit(void)
 {
-	remove_video_card();
+	backlight_device_unregister(backlight_device);
+
+	/* we are done with the PCI device, put it back */
+	pci_dev_put(pci_device);
 }
 
 module_init(samsung_init);
@@ -161,8 +135,6 @@ module_exit(samsung_exit);
 MODULE_AUTHOR("Greg Kroah-Hartman <gregkh@suse.de>");
 MODULE_DESCRIPTION("Samsung Backlight driver");
 MODULE_LICENSE("GPL");
-module_param(offset, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(offset, "The offset into the PCI device for the brightness control");
 MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnN130:*:rnN130:*");
 MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnNC10:*:rnNC10:*");
 MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnSQ45S70S:*:rnSQ45S70S:*");
