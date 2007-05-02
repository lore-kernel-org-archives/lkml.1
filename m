Return-Path: <linux-kernel-owner+w=401wt.eu-S1767229AbXEBSzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767229AbXEBSzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767232AbXEBSzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:55:05 -0400
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:4373 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767229AbXEBSzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:55:03 -0400
Date: Wed, 2 May 2007 20:55:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] platform: reorder platform_device_del
Message-ID: <20070502205554.55a5956d@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I seem to remember that you had acked this patch, however it still
isn't in Linus' tree. Some of the hwmon patches I want to send to Linus
for 2.6.22 depend on it. Can you please push it now? Thanks.

* * * * *

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
 drivers/base/platform.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.21-pre.orig/drivers/base/platform.c	2007-02-20 11:05:25.000000000 +0100
+++ linux-2.6.21-pre/drivers/base/platform.c	2007-02-20 22:44:35.000000000 +0100
@@ -292,20 +292,22 @@ EXPORT_SYMBOL_GPL(platform_device_add);
  *	@pdev:	platform device we're removing
  *
  *	Note that this function will also release all memory- and port-based
- *	resources owned by the device (@dev->resource).
+ *	resources owned by the device (@dev->resource).  This function
+ *	must _only_ be externally called in error cases.  All other usage
+ *	is a bug.
  */
 void platform_device_del(struct platform_device *pdev)
 {
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
