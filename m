Return-Path: <linux-kernel-owner+w=401wt.eu-S933723AbYDVX6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbYDVX6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYDVX6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:58:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45477 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbYDVX6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:58:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: device_pm_add (was: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff)
Date: Wed, 23 Apr 2008 00:48:23 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, herbert@gondor.apana.org.au,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804222234.19936.rjw@sisk.pl> <alpine.LFD.1.10.0804221350110.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804221350110.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804230048.24893.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 of April 2008, Linus Torvalds wrote:
> 
> On Tue, 22 Apr 2008, Rafael J. Wysocki wrote:
> > 
> > There is a bug in device_add() that IMO can be fixed this way:
> 
> Ok, looks fine. Greg?
> 
> > Index: linux-2.6/drivers/base/core.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/core.c
> > +++ linux-2.6/drivers/base/core.c
> > @@ -820,11 +820,11 @@ int device_add(struct device *dev)
> >  	error = bus_add_device(dev);
> >  	if (error)
> >  		goto BusError;
> > +	bus_attach_device(dev);
> >  	error = device_pm_add(dev);
> >  	if (error)
> >  		goto PMError;
> >  	kobject_uevent(&dev->kobj, KOBJ_ADD);
> > -	bus_attach_device(dev);
> >  	if (parent)
> >  		klist_add_tail(&dev->knode_parent, &parent->klist_children);
> >  
> > The problem is that bus_remove_device() assumes bus_attach_device() to have
> > run, AFAICS.
> 
> As to the other issue:
> 
> > > So I would suggest reverting that commit, or at least just making it a 
> > > warning (while still registering the device).
> > 
> > Are drivers supposed to register children of suspended devices?  That doesn't
> > make much sense IMO ...
> 
> Well, that's why I think the warning itself makes sense - and then we can 
> decide whether it makes sense for that particular case or not. Clearly it 
> happens (since it triggered), now we need to figure out _why_ it happened. 

Well, this particular case looks like a race to me, but I'm waiting for the
whole dmesg from Zdenek to verify that.

> But I don't think debugging messages should change behaviour.

Okay, below is a more complete patch that changes device_pm_add() so that
it doesn't refuse to add children of suspended devices.  Note, however, that
even if such a registration succeeds, it will probably lead to some future
problems.

Thanks,
Rafael

---
Do not refuse to actually register children of suspended devices,
but still warn about attempts to do that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -62,7 +62,7 @@ static bool all_sleeping;
  */
 int device_pm_add(struct device *dev)
 {
-	int error = 0;
+	int error;
 
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
@@ -70,18 +70,15 @@ int device_pm_add(struct device *dev)
 	mutex_lock(&dpm_list_mtx);
 	if ((dev->parent && dev->parent->power.sleeping) || all_sleeping) {
 		if (dev->parent->power.sleeping)
-			dev_warn(dev,
-				"parent %s is sleeping, will not add\n",
+			dev_warn(dev, "parent %s is sleeping\n",
 				dev->parent->bus_id);
 		else
-			dev_warn(dev, "devices are sleeping, will not add\n");
+			dev_warn(dev, "all devices are sleeping\n");
 		WARN_ON(true);
-		error = -EBUSY;
-	} else {
-		error = dpm_sysfs_add(dev);
-		if (!error)
-			list_add_tail(&dev->power.entry, &dpm_active);
 	}
+	error = dpm_sysfs_add(dev);
+	if (!error)
+		list_add_tail(&dev->power.entry, &dpm_active);
 	mutex_unlock(&dpm_list_mtx);
 	return error;
 }

