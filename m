Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbXFKSqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbXFKSqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXFKSqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:46:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbXFKSqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:46:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH -mm 1/7] PM: Remove pm_parent from struct dev_pm_info
Date: Mon, 11 Jun 2007 20:52:32 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <Pine.LNX.4.44L0.0706111147160.2611-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706111147160.2611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706112052.32872.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 June 2007 17:59, Alan Stern wrote:
> On Mon, 11 Jun 2007, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The pm_parent member of struct dev_pm_info (defined in include/linux/pm.h) is
> > only used to check if the device's parent is in the right state while the
> > device is being suspended or resumed.  However, this can be done just as well
> > with the help of the parent pointer in struct device, so pm_parent can be
> > removed along with some code that handles it.
> 
> > @@ -61,21 +40,26 @@ int device_pm_add(struct device * dev)
> >  		 kobject_name(&dev->kobj));
> >  	mutex_lock(&dpm_list_mtx);
> >  	list_add_tail(&dev->power.entry, &dpm_active);
> > -	device_pm_set_parent(dev, dev->parent);
> > -	if ((error = dpm_sysfs_add(dev)))
> > +	/*
> > +	 * The device's parent must not be released until the device itself is
> > +	 * removed from the dpm_active list.
> > +	 */
> > +	get_device(dev->parent);
> > +	error = dpm_sysfs_add(dev);
> > +	if (error)
> >  		list_del(&dev->power.entry);
> >  	mutex_unlock(&dpm_list_mtx);
> >  	return error;
> >  }
> 
> The error pathway here does an unbalanced get_device on dev->parent.
> 
> Anyway, I don't think you need to do this get_device at all (or the
> coresponding put in device_pm_remove).  As long as a device is
> registered it retains a reference to its parent, and unregistration
> always calls device_pm_remove.

Yes, I've just come to the same conclusion.  I'll remove the
get_device(dev->parent) and the correspondint put_device(dev->parent)
from device_pm_remove().

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
