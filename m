Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbZEAMwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbZEAMwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZEAMwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:52:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47587 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZEAMwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:52:06 -0400
Date: Fri, 1 May 2009 14:51:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] driver core: Silent meaningless error message
Message-ID: <20090501145151.5f97456e@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see the following error message in my kernel logs:

w83627ehf.2576: use which platform_data?

This is caused by platform_device_add_data() setting both
pdev->platform_data and pdev->dev.platform_data, and then
platform_device_add() complaining if both pointers are set.

As platform_device_add() is now making sure that both pointers are
set, there is no point in setting both in platform_device_add_data().

Additionally, we should only issue the error message when there is a
real problem, that is: both data pointers are set and differ. And, in
this case, we should fail right away, as something is seriously wrong.

Also free the memory through pa->pdev.platform_data rather than
pa->pdev.dev.platform_data. We will have to do that someday anyway, so
we might as well start now to make the intents clearer.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.30-rc4.orig/drivers/base/platform.c	2009-04-22 09:51:01.000000000 +0200
+++ linux-2.6.30-rc4/drivers/base/platform.c	2009-05-01 14:09:16.000000000 +0200
@@ -143,7 +143,7 @@ static void platform_device_release(stru
 	struct platform_object *pa = container_of(dev, struct platform_object,
 						  pdev.dev);
 
-	kfree(pa->pdev.dev.platform_data);
+	kfree(pa->pdev.platform_data);
 	kfree(pa->pdev.resource);
 	kfree(pa);
 }
@@ -216,7 +216,6 @@ int platform_device_add_data(struct plat
 	d = kmalloc(size, GFP_KERNEL);
 	if (d) {
 		memcpy(d, data, size);
-		pdev->dev.platform_data = d;
 		pdev->platform_data = d;
 	}
 	return d ? 0 : -ENOMEM;
@@ -253,9 +252,12 @@ int platform_device_add(struct platform_
 	* long time, so we allow the two cases coexist to make
 	* this kind of fix more easily*/
 	if (pdev->platform_data && pdev->dev.platform_data) {
-		printk(KERN_ERR
+		if (pdev->platform_data != pdev->dev.platform_data) {
+			printk(KERN_ERR
 			       "%s: use which platform_data?\n",
 			       dev_name(&pdev->dev));
+			return -EINVAL;
+		}
 	} else if (pdev->platform_data) {
 		pdev->dev.platform_data = pdev->platform_data;
 	} else if (pdev->dev.platform_data) {


-- 
Jean Delvare
