Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXBTVzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXBTVzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030471AbXBTVzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:55:24 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:1613 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030455AbXBTVzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:55:24 -0500
Date: Tue, 20 Feb 2007 22:55:06 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] platform: reorder platform_device_del
Message-Id: <20070220225506.ab3c66aa.khali@linux-fr.org>
In-Reply-To: <d120d5000702190640y58b0d75akb1579b7c611879eb@mail.gmail.com>
References: <20070218213020.5618eb98.khali@linux-fr.org>
	<200702190105.31051.dtor@insightbb.com>
	<20070219102335.8d56dddd.khali@linux-fr.org>
	<d120d5000702190640y58b0d75akb1579b7c611879eb@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, 19 Feb 2007 09:40:09 -0500, Dmitry Torokhov wrote:
> But the thing is that when you add resources to a platofrm device it
> is platform_device_add() that marks resources as busy and therefore it

No, devices declare the resources, but do not mark them as busy.
Otherwise any further attempt to request them would fail, which isn't
the case.

> is not driver's task to delete them. If you want driver to request
> resources you better pass them through a private data structure
> attached to a device.

The driver isn't deleting the resources, it is marking them as no longer
busy.

We can't seem to agree on this point. Can someone else who is familiar
with the new resource model please shed some light?

> The attached resources are normally used by arch setup codes that
> posess the knowledge about whether a device is present on a box and
> what IO port or memory region is used. The device is usualy there and
> its resources fixed and not available to anyone else even if there is
> no driver to actually control the device.

That we agree on.

> > >       However you are right that we should not free resources until
> > > device is marked for deletion and driver's ->remove() method completes
> > > but I would not rely on surrounding code for keeping an extra reference
> > > and would just take one explicitely in platform_device_del().
> >
> > You mean that you wouldn't trust the rest of the platform driver core,
> > which lives in the same source file, to do the right thing? That's
> > being too defensive IMHO, and I don't think we usually do that. Greg?
> >
> 
> platform_device_del() is public so all bets are off...

Good point, I had missed that fact. However, I've now checked all the
callers and found that they all call platform_device_put() right after
platform_device_del(), so we're safe. And they have to, otherwise their
code is broken. It's always in an error path, as this appears to the
only legitimate use for platform_device_del(). So I really don't see
the benefit of taking an additional reference in platform_device_del
"just in case". If it ever makes a difference, it means the caller code
is badly broken anyway, so why bother?

platform_device_put has the following comment: "This function must
_only_ be externally called in error cases.  All other usage is a bug."
As I understand it, we could/should add this to platform_device_del
too, to discourage the bogus use cases you fear could happen. Hence an
updated patch:

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
