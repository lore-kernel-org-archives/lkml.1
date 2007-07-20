Return-Path: <linux-kernel-owner+w=401wt.eu-S1765717AbXGTW5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765717AbXGTW5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbXGTW5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:57:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:45033 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXGTW47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=naBQl2pwIWZJTY9iKZZF+VN9apBgMpXlkOMkG18d9uTq0dXArKwSmQHs6t+wUIgwfzYJM2vuZkG03iZzp/5sica3evZQOv06Dd6JVBzKFS0Gwy6Mp9LAAABBNpu1Ofpvj8T/F2SszDTqzlQaw35qYQl/bGP6aV+CtrfT36qEz/8=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix several memory leaks in cr_backlight_probe()
Date: Sat, 21 Jul 2007 00:56:01 +0200
User-Agent: KMail/1.9.7
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>,
       Alan Hourihane <alanh@tungstengraphics.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210056.02139.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After fixing the too small memory allocation in cr_backlight_probe()
from drivers/video/backlight/cr_bllcd.c 
(commit e3bbb3f05339de438faf54124f25c92e6fe4ac2e) I noticed that the 
Coverity checker also thought there were a few memory leaks in there. 
I took a closer look and confirmed that there were indeed several 
leaks.

At the start of the function we allocate storage for a 
'struct cr_panel' and store the pointer in a variable named 'crp'. 

Then we call pci_get_device() and pci_read_config_byte() and if 
either of them fail we return without freeing the memory allocated 
for the 'struct cr_panel'. These two leaks are easy to fix since we 
don't even use 'crp' for anything up to this point, so I simply 
moved the allocation further down in the function so it only happens 
just before we actually need it.

A bit further down we call backlight_device_register() and store the 
result in 'crp->cr_backlight_device'. In case of error we return 
'crp->cr_backlight_device' from the function, thus leaking 'crp' 
itself. The same thing happens with the call to lcd_device_register().
To fix these two leaks I declare two new pointers to hold the return 
values, so that in case of error we can return the pointer (as before) 
but without leaking 'crp'.

Please consider merging.

Note: Due to lack of hardware the patch has only been compile tested.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/video/backlight/cr_bllcd.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index 1b3f658..d526907 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -171,13 +171,11 @@ static struct lcd_ops cr_lcd_ops = {
 
 static int cr_backlight_probe(struct platform_device *pdev)
 {
+	struct backlight_device *bdp;
+	struct lcd_device *ldp;
 	struct cr_panel *crp;
 	u8 dev_en;
 
-	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
-	if (crp == NULL)
-		return -ENOMEM;
-
 	lpc_dev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					CRVML_DEVICE_LPC, NULL);
 	if (!lpc_dev) {
@@ -193,27 +191,29 @@ static int cr_backlight_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	crp->cr_backlight_device = backlight_device_register("cr-backlight",
-							     &pdev->dev, NULL,
-							     &cr_backlight_ops);
-	if (IS_ERR(crp->cr_backlight_device)) {
+	bdp = backlight_device_register("cr-backlight",
+					&pdev->dev, NULL,
+					&cr_backlight_ops);
+	if (IS_ERR(bdp)) {
 		pci_dev_put(lpc_dev);
-		return PTR_ERR(crp->cr_backlight_device);
+		return PTR_ERR(bdp);
 	}
 
-	crp->cr_lcd_device = lcd_device_register("cr-lcd",
-							&pdev->dev,
-							&cr_lcd_ops);
-
-	if (IS_ERR(crp->cr_lcd_device)) {
+	ldp = lcd_device_register("cr-lcd", &pdev->dev, &cr_lcd_ops);
+	if (IS_ERR(ldp)) {
 		pci_dev_put(lpc_dev);
-		return PTR_ERR(crp->cr_backlight_device);
+		return PTR_ERR(bdp);
 	}
 
 	pci_read_config_dword(lpc_dev, CRVML_REG_GPIOBAR,
 			      &gpio_bar);
 	gpio_bar &= ~0x3F;
 
+	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
+	if (crp == NULL)
+		return -ENOMEM;
+	crp->cr_backlight_device = bdp;
+	crp->cr_lcd_device = ldp;
 	crp->cr_backlight_device->props.power = FB_BLANK_UNBLANK;
 	crp->cr_backlight_device->props.brightness = 0;
 	crp->cr_backlight_device->props.max_brightness = 0;


