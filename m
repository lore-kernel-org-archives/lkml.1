Return-Path: <linux-kernel-owner+w=401wt.eu-S1765470AbXHDScd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765470AbXHDScd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765005AbXHDScR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:32:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:44971 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765483AbXHDScJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=U7wSO1+attV4WLAB/HfHSnAc6TGLNTHYEwdgw8id/HMhOD9Engv39tQIyvTvgr85m12WXZRY1KHzOPkBZg1iNbjk08O9BbyltJMLow/d4z3XXpJhl+LKK+lqaIKDppmDzQbyOhFV42wsxVDj75nWT5sWeNGOl2XbTw47KecygEI=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND] Fix several memory leaks in cr_backlight_probe() - take2
User-Agent: KMail/1.9.7
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Alan Hourihane <alanh@tungstengraphics.com>,
       Thomas Hellstrom <thomas@tungstengraphics.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200707202311.l6KNBRDK021376@imap1.linux-foundation.org> <1185116146.6819.29.camel@localhost.localdomain>
In-Reply-To: <1185116146.6819.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 4 Aug 2007 20:30:13 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042030.13387.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of a patch I originally submitted on 23/7-2007 23:32. 
That patch was an updated version of one originally submitted on 21-Jul-2007 00:56.

The original patch made a brief appearance in -mm, but was dropped 
due to concerns raised by Richard Purdie that it didn't fix all issues.

Here are Richard's comments:
> The problems you've spotted are valid however the error paths are still
> broken both before and after this patch since there is no call to
> backlight_device_unregister() and/or lcd_device_unregister() in the
> probe function.
> 

The following patch fixes the same problems as the original and also 
tries to fix the stuff that Richard pointed out.
Hopefully this time it is perfect :-)


Here's the new version of the patch : 



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

This version of the patch also adds missing 
backlight_device_unregister() / lcd_device_unregister() / pci_dev_put() 
calls to error paths.
  Thanks to Richard Purdie <rpurdie@rpsys.net> for noticing.

Please consider merging.

Note: Due to lack of hardware the patch has only been compile tested.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/video/backlight/cr_bllcd.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index b7904da..92e201e 100644
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
@@ -193,27 +191,34 @@ static int cr_backlight_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	crp->cr_backlight_device = backlight_device_register("cr-backlight",
-							     &pdev->dev, NULL,
-							     &cr_backlight_ops);
-	if (IS_ERR(crp->cr_backlight_device)) {
+	bdp = backlight_device_register("cr-backlight",
+					&pdev->dev, NULL, &cr_backlight_ops);
+	if (IS_ERR(bdp)) {
 		pci_dev_put(lpc_dev);
-		return PTR_ERR(crp->cr_backlight_device);
+		return PTR_ERR(bdp);
 	}
 
-	crp->cr_lcd_device = lcd_device_register("cr-lcd",
-							&pdev->dev, NULL,
-							&cr_lcd_ops);
-
-	if (IS_ERR(crp->cr_lcd_device)) {
+	ldp = lcd_device_register("cr-lcd", &pdev->dev, NULL, &cr_lcd_ops);
+	if (IS_ERR(ldp)) {
+		backlight_device_unregister(bdp);
 		pci_dev_put(lpc_dev);
-		return PTR_ERR(crp->cr_backlight_device);
+		return PTR_ERR(bdp);
 	}
 
 	pci_read_config_dword(lpc_dev, CRVML_REG_GPIOBAR,
 			      &gpio_bar);
 	gpio_bar &= ~0x3F;
 
+	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
+	if (!crp) {
+		lcd_device_unregister(ldp);
+		backlight_device_unregister(bdp);
+		pci_dev_put(lpc_dev);
+		return -ENOMEM;
+	}
+
+	crp->cr_backlight_device = bdp;
+	crp->cr_lcd_device = ldp;
 	crp->cr_backlight_device->props.power = FB_BLANK_UNBLANK;
 	crp->cr_backlight_device->props.brightness = 0;
 	crp->cr_backlight_device->props.max_brightness = 0;


