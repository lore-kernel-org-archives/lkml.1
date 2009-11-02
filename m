Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZKBQ2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZKBQ2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbZKBQ2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:28:54 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:42154 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755347AbZKBQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:28:53 -0500
Date: Mon, 2 Nov 2009 16:28:39 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, Antonio Ospite <ospite@studenti.unina.it>,
       openezx-devel@lists.openezx.org, Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Mike Rapoport <mike@compulab.co.il>, Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Using statically allocated memory for platform_data.
Message-ID: <20091102162839.GD20341@fluff.org.uk>
References: <20091102112316.16163f6a.ospite@studenti.unina.it>
 <20091102150011.GB20341@fluff.org.uk>
 <20091102150525.GB5785@n2100.arm.linux.org.uk>
 <20091102152500.GD23772@trinity.fluff.org>
 <20091102155231.GC20341@fluff.org.uk>
 <20091102155625.GC5785@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102155625.GC5785@n2100.arm.linux.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:56:25PM +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 02, 2009 at 03:52:31PM +0000, Ben Dooks wrote:
> > On Mon, Nov 02, 2009 at 03:25:00PM +0000, Ben Dooks wrote:
> > > On Mon, Nov 02, 2009 at 03:05:25PM +0000, Russell King - ARM Linux wrote:
> > > > On Mon, Nov 02, 2009 at 03:00:11PM +0000, Ben Dooks wrote:
> > > > > This looks like something is freeing stuff that it did not allocate in
> > > > > the first place, which is IMHO bad. The call platform_device_alloc()
> > > > > is setting platform_device_release() as the default release function
> > > > > but platform_device_release() releases more than platform_device_alloc()
> > > > > actually created.
> > > > > 
> > > > > My view is that platform_device_alloc()'s default release shouldn't
> > > > > be freeing the platform data, and that using platform_device_add_data()
> > > > > or platform_device_add_resources() should change either the behvaiour 
> > > > > of platform_device_release() or it should change the pointer to a new
> > > > > release function.
> > > > 
> > > > That doesn't work - how do those other functions (adding) know what data
> > > > has also been added by other functions?  That can't work reliably.
> > > 
> > > You could wrapper platform device, and each of the add functions could
> > > update it, but that would assume the platform device had been allocated
> > > with platform_device_alloc().
> > 
> > Having had a look, all the current users of platform_device_add_data()
> > are from a platform_alloc_device() created device. 
> > 
> > The number of calls to platform_device_add_resources() are many, but
> > the ones I checked are from platform_alloc_device().
> > 
> > However your point being that these add calls may not be used on a
> > device that has been created from platform_device_alloc() is one I
> > overlooked.
> 
> I did not say that.  I said your idea of replacing the release function
> on each _add() is impractical when you have multiple _add() functions.

Sorry, that was what I read into it.

As a note, this would be my proposed fix:

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ed156a1..302543e 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -141,16 +141,42 @@ void platform_device_put(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(platform_device_put);
 
+static inline platform_object *to_platform_object(struct device *dev)
+{
+	return container_of(dev, struct platform_object, pdev.dev);
+}
+
+static void platform_device_release_all(struct device *dev)
+{
+	struct platform_object *pa = to_platform_object(dev);
+
+	kfree(pa->pdev.dev.platform_data);
+	kfree(pa->pdev.resource);
+	kfree(pa);
+}
+
 static void platform_device_release(struct device *dev)
 {
-	struct platform_object *pa = container_of(dev, struct platform_object,
-						  pdev.dev);
+	kfree(to_platform_object(dev));
+}
+
+static void platform_device_release_pdata(struct device *dev)
+{
+	struct platform_object *pa = to_platform_object(dev);
 
 	kfree(pa->pdev.dev.platform_data);
+	kfree(pa);
+}
+
+static void platform_device_release_res(struct device *dev)
+{
+	struct platform_object *pa = to_platform_object(dev);
+
 	kfree(pa->pdev.resource);
 	kfree(pa);
 }
 
+
 /**
  * platform_device_alloc
  * @name: base name of the device we're adding
@@ -196,6 +222,11 @@ int platform_device_add_resources(struct platform_device *pdev,
 		memcpy(r, res, sizeof(struct resource) * num);
 		pdev->resource = r;
 		pdev->num_resources = num;
+
+		if (pdev->dev.release == platform_device_release)
+			pdev->dev.release = platform_device_release_res;
+		else if (pdev->dev.release ==  platform_device_release_pdata)
+			pdev->dev.release = platform_device_release_all;
 	}
 	return r ? 0 : -ENOMEM;
 }
@@ -218,6 +249,12 @@ int platform_device_add_data(struct platform_device *pdev, const void *data,
 
 	if (d) {
 		pdev->dev.platform_data = d;
+
+		if (pdev->dev.release == platform_device_release)
+			pdev->dev.release = platform_device_release_pdata;
+		else if (pdev->dev.release ==  platform_device_release_res)
+			pdev->dev.release = platform_device_release_all;
+
 		return 0;
 	}
 	return -ENOMEM;

 
> > Having a state machine that changed the release call from
> > platform_device_release() to say platform_device_release_resources()
> > or platform_device_release_all() and then platform_device_release_all()
> > may be another way to do it.
> 
> The reason we have platform_device_add_data() is that people think that
> the device data needs to persist for the lifetime of the device.  I
> personally disagree with that - once you unregister the device, it's
> guaranteed that device drivers will have been unregistered, so who's
> going to use the platform data?

That doesn't make any sense, in the current case of using the
platform_device_alloc() and those calls the data is only living
for the lifetime of the device, as the release call is tidying up
the result.

platform_device_add_data() is often being used to create platform data
from some stack based data or similar that isn't guarnateed to live
beyond the liftime of the call that is creating the platform_device
in the first place, let alone getting to the driver stage.

The default release function would be doing the right thing if the
data had been allocated on the fly by one of the subsequent calls
after platform_device_alloc(), but there is no guarantee that these
calls where used to create the data.

The problem comes when we already have the data copied somewhere, such
as from an init-time board that has already done the necessary copying
and this data is then being passed down to sub-drivers of an mfd
device, which use platform_device_alloc() to create a new device.

> So we could just fix it by killing off platform_device_add_data() and
> removing the kfree of the platform data, and ensuring that data marked
> with __initdata either loses that attributation or is kmalloc+copied.

There are a number of places where this data isn't __initdata, and
still needs to be copied, and then freed once the device has been
removed.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
