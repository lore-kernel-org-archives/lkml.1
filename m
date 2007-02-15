Return-Path: <linux-kernel-owner+w=401wt.eu-S1161053AbXBOTkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161053AbXBOTkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161056AbXBOTkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:40:10 -0500
Received: from tim.rpsys.net ([194.106.48.114]:42035 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161053AbXBOTkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:40:08 -0500
Subject: Re: 2.6.20-mm1
From: Richard Purdie <rpurdie@rpsys.net>
To: Mattia Dongili <malattia@linux.it>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070215192920.GB2962@inferi.kami.home>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	 <20070215192920.GB2962@inferi.kami.home>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 19:39:49 +0000
Message-Id: <1171568390.5839.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 20:29 +0100, Mattia Dongili wrote:
> On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
> [...]
> > - The sony-laptop driver has been disabled due to disagreement between
> >   the git-acpi and git-backlight trees
> 
> Snigh... I though Richard had something to fix sony-laptop.
> 
> Am I wrong?

No, it just didn't make it into -mm. I've included what should be the
fix below.

Fix up the sony-laptop driver in git-acpi to work with the recent
changes in the git-backlight tree.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

---
 drivers/misc/sony-laptop.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux/drivers/misc/sony-laptop.c
===================================================================
--- linux.orig/drivers/misc/sony-laptop.c       2007-02-11 00:59:47.000000000 +0000
+++ linux/drivers/misc/sony-laptop.c    2007-02-11 01:02:51.000000000 +0000
@@ -341,7 +341,7 @@ static void sony_snc_pf_remove(void)
 static int sony_backlight_update_status(struct backlight_device *bd)
 {
        return acpi_callsetfunc(sony_acpi_handle, "SBRT",
-                               bd->props->brightness + 1, NULL);
+                               bd->props.brightness + 1, NULL);
 }
 
 static int sony_backlight_get_brightness(struct backlight_device *bd)
@@ -355,11 +355,9 @@ static int sony_backlight_get_brightness
 }
 
 static struct backlight_device *sony_backlight_device;
-static struct backlight_properties sony_backlight_properties = {
-       .owner = THIS_MODULE,
+static struct backlight_ops sony_backlight_ops = {
        .update_status = sony_backlight_update_status,
        .get_brightness = sony_backlight_get_brightness,
-       .max_brightness = SONY_MAX_BRIGHTNESS - 1,
 };
 
 /*
@@ -441,15 +439,17 @@ static int sony_acpi_add(struct acpi_dev
        if (ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle, "GBRT", &handle))) {
                sony_backlight_device = backlight_device_register("sony", NULL,
                                                                  NULL,
-                                                                 &sony_backlight_properties);
+                                                                 &sony_backlight_ops);
 
                if (IS_ERR(sony_backlight_device)) {
                        printk(LOG_PFX "unable to register backlight device\n");
                        sony_backlight_device = NULL;
-               } else
-                       sony_backlight_properties.brightness =
-                           sony_backlight_get_brightness
-                           (sony_backlight_device);
+               } else {
+                       sony_backlight_device->props.brightness =
+                           sony_backlight_get_brightness(sony_backlight_device);
+                       sony_backlight_device->props.max_brightness =
+                           SONY_MAX_BRIGHTNESS - 1;
+               }
        }
 
        if (sony_snc_pf_add())




