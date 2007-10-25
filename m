Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbXJYQ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbXJYQ6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbXJYQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:57:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955AbXJYQ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:57:35 -0400
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: David Miller <davem@davemloft.net>, jens.axboe@oracle.com, rjw@sisk.pl,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       htejun@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071024235231.GA6160@kroah.com>
References: <20071016204238.GA1093@kroah.com>
	 <20071016205053.GI9942@kernel.dk> <20071016213730.GB21815@kroah.com>
	 <20071016.153248.95506316.davem@davemloft.net>
	 <20071016232350.GB24827@kroah.com> <1192616214.4300.16.camel@lov.site>
	 <20071024234348.GA4909@kroah.com>  <20071024235231.GA6160@kroah.com>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 18:58:23 +0200
Message-Id: <1193331503.2782.3.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18Mz7H9DKNRNJarRLYrYqbSZ35ubHamjYxZS/X
 v2a+fJkiFxOu/i/e8H2dKgTx1W0T20l6FxDRtwvmpIhixCVREr
 XmvN04SPcAjJB9qElFTEKijtK7AcN9a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 16:52 -0700, Greg KH wrote: 
> On Wed, Oct 24, 2007 at 04:43:48PM -0700, Greg KH wrote:
> > On Wed, Oct 17, 2007 at 12:16:54PM +0200, Kay Sievers wrote:
> > > On Tue, 2007-10-16 at 16:23 -0700, Greg KH wrote:
> > > > On Tue, Oct 16, 2007 at 03:32:48PM -0700, David Miller wrote:
> > > > > From: Greg KH <greg@kroah.com>
> > > > > Date: Tue, 16 Oct 2007 14:37:30 -0700
> > > > > 
> > > > > > Kay, are we doing something wrong in userspace when renaming wireless
> > > > > > devices such that we can overlap names?
> > > 
> > > Not udev, but SUSE 10.2's network renaming. It uses udev and calls
> > > ifrename in the same code path. 10.3 uses the unified version from the
> > > udev tree.
> > > 
> > > > > It does it for all network devices, I see this ugly message on every
> > > > > single system I have from Fedora foo to RHEL foo to ubuntu foo to
> > > > > debian foo.
> > > > >
> > > > > udev simply applies the MAC address to device name rules blindly, it
> > > > > doesn't check if the device already has the desired name already
> > > 
> > > There is a check for the same name in udev for long.
> > > 
> > > > Ugh :(
> > > > 
> > > > > It's been like this forever, and since userland has been doing it for
> > > > > so long, you can't warn on this there is too much established
> > > > > practice.  Expecting people to install "fixed" udev is not an
> > > > > acceptable answer, the warning is a regression and therefore you'll
> > > > > have to remove the kernel warning for this case and live with this
> > > > > issue essentially forever.
> > > 
> > > We should probably just add the check to kobject_rename() and print a
> > > simple warning and then do nothing. Or just do the check in the network
> > > ioctl, if we really don't want to see this.
> > 
> > I agree that perhaps kobject_rename() should check for this.  Let me go
> > see if I can get that to work...
> 
> Can someone try this patch, and see what happens when they try to rename
> an object to something that is already existing?

That may still fail if a netif creation, and a rename compete about the
same name, right?

The driver core name of the netdev is part of the netdev, so the net
core might need to rename the driver core part while holding its usual
lock, just like it does when it changes the net internal name?

The netdev rename should also fail, if the core rename fails, right?

Thanks,
Kay

diff --git a/net/core/dev.c b/net/core/dev.c
index 8726589..ed3db06 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -899,9 +899,12 @@ int dev_change_name(struct net_device *dev, char *newname)
 		strlcpy(dev->name, newname, IFNAMSIZ);
 
 rollback:
-	device_rename(&dev->dev, dev->name);
-
 	write_lock_bh(&dev_base_lock);
+	err = device_rename(&dev->dev, dev->name);
+	if (err) {
+		write_unlock_bh(&dev_base_lock);
+		return err;
+	}
 	hlist_del(&dev->name_hlist);
 	hlist_add_head(&dev->name_hlist, dev_name_hash(net, dev->name));
 	write_unlock_bh(&dev_base_lock);



