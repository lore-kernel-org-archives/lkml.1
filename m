Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZERDtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZERDtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 23:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZERDtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 23:49:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:48000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbZERDtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 23:49:01 -0400
Date: Sun, 17 May 2009 20:48:10 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Message-ID: <20090518034809.GA26769@suse.de>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain> <ac3eb2510905161715m7d42879bqdc0d59c465521e99@mail.gmail.com> <1242522109.2635.6.camel@poy> <alpine.LFD.2.01.0905161908100.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.01.0905161908100.3301@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 07:13:59PM -0700, Linus Torvalds wrote:
> On Sun, 17 May 2009, Kay Sievers wrote:
> > 
> > This makes the oops in the driver-core, caused by the rtc driver
> > unregister, go away. The original issue is also fixed in the rtc driver
> > itself.
> 
> I don't think this is sufficient.
> 
> > --- a/drivers/base/driver.c
> > +++ b/drivers/base/driver.c
> > @@ -257,6 +257,8 @@ EXPORT_SYMBOL_GPL(driver_register);
> >   */
> >  void driver_unregister(struct device_driver *drv)
> >  {
> > +	if (!drv || !drv->p)
> > +		return;
> >  	driver_remove_groups(drv, drv->groups);
> >  	bus_remove_driver(drv);
> >  }
> 
> Ok, fine so far, but look at "driver_register()".
> 
> It will set drv->p, but then not unset it if it fails! (For a certain 
> class of failures)
> 
> So for a certain failure pattern, drv->p will point to some stale value. 
> Should we not clear drv->p in the "out_unregister" patch?
> 
> To confuse the thing more, there are actually "half-way failures" that 
> _succeed_ in driver registration, but then return an error code. See that 
> whole
> 
> 
> 	kobject_uevent(&priv->kobj, KOBJ_ADD);
> 	return error;
> 
> case in the "success" path driver_register(). We may return an error 
> despite the fact that we actually attached the driver to bus, but 
> "add_bind_files()" failed. A caller would be understandable very unhappy.
> 
> So I suspect we should do something like the appended (in addition to your 
> patch). Comments?

Yes, that's needed.  We also don't clean up properly when we do the same
thing for devices (error in the initialization of them).

So, here's a patch that combines everyone's intentions in this thread.
Any objections to it?

thanks,

greg k-h

------------------------
From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver Core: do not oops when driver_unregister() is called for unregistered drivers

We also fix a problem with cleaning up properly when initializing
drivers and devices, so checks like this will work successfully.

Portions of the patch by Linus and Greg and Ingo.

Reported-by: Ozan Çağlayan <ozan@pardus.org.tr>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index dc030f1..c659961 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -700,8 +700,10 @@ int bus_add_driver(struct device_driver *drv)
 	}
 
 	kobject_uevent(&priv->kobj, KOBJ_ADD);
-	return error;
+	return 0;
 out_unregister:
+	kfree(drv->p);
+	drv->p = NULL;
 	kobject_put(&priv->kobj);
 out_put_bus:
 	bus_put(bus);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4aa527b..1977d4b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -879,7 +879,7 @@ int device_add(struct device *dev)
 	}
 
 	if (!dev_name(dev))
-		goto done;
+		goto name_error;
 
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 
@@ -978,6 +978,9 @@ done:
 	cleanup_device_parent(dev);
 	if (parent)
 		put_device(parent);
+name_error:
+	kfree(dev->p);
+	dev->p = NULL;
 	goto done;
 }
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index c51f11b..8ae0f63 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -257,6 +257,10 @@ EXPORT_SYMBOL_GPL(driver_register);
  */
 void driver_unregister(struct device_driver *drv)
 {
+	if (!drv || !drv->p) {
+		WARN(1, "Unexpected driver unregister!\n");
+		return;
+	}
 	driver_remove_groups(drv, drv->groups);
 	bus_remove_driver(drv);
 }
