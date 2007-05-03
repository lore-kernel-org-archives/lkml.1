Return-Path: <linux-kernel-owner+w=401wt.eu-S1767321AbXECCOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767321AbXECCOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767320AbXECCOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:14:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:56292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767321AbXECCOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:14:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] platform: reorder platform_device_del
Date: Wed,  2 May 2007 19:11:30 -0700
Message-Id: <11781583003703-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11781582932668-git-send-email-gregkh@suse.de>
References: <20070503020924.GB21316@kroah.com>
 <11781582932668-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 30480f6..17b5ece 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
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
1.5.1.2

