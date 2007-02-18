Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbXBRUaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbXBRUaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXBRUaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:30:16 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:4098 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752048AbXBRUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:30:15 -0500
Date: Sun, 18 Feb 2007 21:30:20 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH] platform: reorder platform_device_del
Message-Id: <20070218213020.5618eb98.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In platform_device_del(), we currently delete the device resources
first, then we delete the device itself. This causes a (minor) bug to
occur when one unregisters a platform device before unregistering its
platform driver, and the driver is requesting (in .probe()) and
releasing (in .remove()) a resource of the device. The device
resources are already gone by the time the driver gets the chance to
release the resources it had been requesting, causing an error like:
Trying to free nonexistent resource <0000000000000295-0000000000000296>

If the platform driver is unregistered first, the problem doesn't
occur, as the driver will have the opportunity to release the
resources it had requested before the device resources themselves are
released. It's a bit odd that unregistering the driver first or the
device first doesn't lead to the same result.

So I believe that we should delete the device first in
platform_device_del(). I've searched the git history and found that it
used to be the case before 2.6.8, but was changed here:

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=96ef7b3689936ee1e64b711511342026a8ce459c

> 2004/07/14 16:09:44-07:00 dtor_core
> [PATCH] Driver core: Fix OOPS in device_platform_unregister
> 
> Driver core: platform_device_unregister should release resources first
>              and only then call device_unregister, otherwise if there
>              are no more references to the device it will be freed and
>              the fucntion will try to access freed memory.

However we now have an explicit call to put_device() at the end of
platform_device_unregister() so I guess the original problem no longer
exists and it is safe to revert that change.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/base/platform.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.orig/drivers/base/platform.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/drivers/base/platform.c	2007-02-18 19:38:09.000000000 +0100
@@ -299,13 +299,13 @@ void platform_device_del(struct platform
 	int i;
 
 	if (pdev) {
+		device_del(&pdev->dev);
+
 		for (i = 0; i < pdev->num_resources; i++) {
 			struct resource *r = &pdev->resource[i];
 			if (r->flags & (IORESOURCE_MEM|IORESOURCE_IO))
 				release_resource(r);
 		}
-
-		device_del(&pdev->dev);
 	}
 }
 EXPORT_SYMBOL_GPL(platform_device_del);


-- 
Jean Delvare
