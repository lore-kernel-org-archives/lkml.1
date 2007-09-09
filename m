Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbXIIKwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbXIIKwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 06:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbXIIKwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 06:52:15 -0400
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:59050 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752536AbXIIKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 06:52:14 -0400
Date: Sun, 9 Sep 2007 12:54:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: [PATCH] Make platform_device.id an int
Message-ID: <20070909125416.47b2180d@hyperion.delvare>
In-Reply-To: <20070908133036.GA32145@suse.de>
References: <20070907153559.17faf9d1@hyperion.delvare>
	<20070908133036.GA32145@suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While platform_device.id is a u32, platform_device_add() handles "-1"
as a special id value. This has potential for confusion and bugs.
Making it an int instead should prevent problems from happening in
the future.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
I still believe that we can further clean up this area, but that will
do for now.

 drivers/base/platform.c         |    7 ++++---
 include/linux/platform_device.h |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc5.orig/drivers/base/platform.c	2007-07-09 14:49:46.000000000 +0200
+++ linux-2.6.23-rc5/drivers/base/platform.c	2007-09-09 12:15:24.000000000 +0200
@@ -166,7 +166,7 @@ static void platform_device_release(stru
  *	the device isn't being dynamically allocated as a legacy "probe the
  *	hardware" driver, infrastructure code should reverse this marking.
  */
-struct platform_device *platform_device_alloc(const char *name, unsigned int id)
+struct platform_device *platform_device_alloc(const char *name, int id)
 {
 	struct platform_object *pa;
 
@@ -256,7 +256,8 @@ int platform_device_add(struct platform_
 	pdev->dev.bus = &platform_bus_type;
 
 	if (pdev->id != -1)
-		snprintf(pdev->dev.bus_id, BUS_ID_SIZE, "%s.%u", pdev->name, pdev->id);
+		snprintf(pdev->dev.bus_id, BUS_ID_SIZE, "%s.%d", pdev->name,
+			 pdev->id);
 	else
 		strlcpy(pdev->dev.bus_id, pdev->name, BUS_ID_SIZE);
 
@@ -370,7 +371,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
  *	the Linux driver model.  In particular, when such drivers are built
  *	as modules, they can't be "hotplugged".
  */
-struct platform_device *platform_device_register_simple(char *name, unsigned int id,
+struct platform_device *platform_device_register_simple(char *name, int id,
 							struct resource *res, unsigned int num)
 {
 	struct platform_device *pdev;
--- linux-2.6.23-rc5.orig/include/linux/platform_device.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.23-rc5/include/linux/platform_device.h	2007-09-09 12:15:41.000000000 +0200
@@ -15,7 +15,7 @@
 
 struct platform_device {
 	const char	* name;
-	u32		id;
+	int		id;
 	struct device	dev;
 	u32		num_resources;
 	struct resource	* resource;
@@ -35,9 +35,10 @@ extern struct resource *platform_get_res
 extern int platform_get_irq_byname(struct platform_device *, char *);
 extern int platform_add_devices(struct platform_device **, int);
 
-extern struct platform_device *platform_device_register_simple(char *, unsigned int, struct resource *, unsigned int);
+extern struct platform_device *platform_device_register_simple(char *, int id,
+					struct resource *, unsigned int);
 
-extern struct platform_device *platform_device_alloc(const char *name, unsigned int id);
+extern struct platform_device *platform_device_alloc(const char *name, int id);
 extern int platform_device_add_resources(struct platform_device *pdev, struct resource *res, unsigned int num);
 extern int platform_device_add_data(struct platform_device *pdev, const void *data, size_t size);
 extern int platform_device_add(struct platform_device *pdev);


-- 
Jean Delvare
