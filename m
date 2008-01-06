Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYAFTzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYAFTzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 14:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYAFTy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 14:54:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33335 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYAFTyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 14:54:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Sun, 6 Jan 2008 20:57:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801061203510.7367-100000@netrider.rowland.org> <200801062005.12097.rjw@sisk.pl>
In-Reply-To: <200801062005.12097.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062057.01677.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of January 2008, Rafael J. Wysocki wrote:
> On Sunday, 6 of January 2008, Alan Stern wrote:
> > On Sun, 6 Jan 2008, Rafael J. Wysocki wrote:
> > 
> > > > If you can figure out a way to disable the warning in device_del() for 
> > > > just the one device being unregistered by 
> > > > device_pm_destroy_suspended(),
> > > 
> > > Something like this, perhaps:
> > > 
> > > @@ -905,6 +915,18 @@ void device_del(struct device * dev)
> > >  	struct device * parent = dev->parent;
> > >  	struct class_interface *class_intf;
> > >  
> > > +	if (down_trylock(&dev->sem)) {
> > > +		if (pm_sleep_lock()) {
> > > +			dev_warn(dev, "Illegal %s during suspend\n",
> > > +				__FUNCTION__);
> > > +			dump_stack();
> > > +		} else {
> > > +			pm_sleep_unlock();
> > > +		}
> > > +	} else {
> > > +		up(&dev->sem);
> > > +	}
> > > +
> > >  	if (parent)
> > >  		klist_del(&dev->knode_parent);
> > >  	if (MAJOR(dev->devt))
> > 
> > Bizarre, but it should work.
> 
> OK
> 
> Still, shouldn't we fail the removal of the device apart from giving the
> warning?

Actually, having thought about it a bit more, I don't see the point in
preventing the removal of the device from the list in device_pm_remove() if
we allow all of the operations in device_del() preceding it to be performed.

Shouldn't we just take pm_sleep_rwsem in device_del() upfront and block on that
if locked?

Rafael
