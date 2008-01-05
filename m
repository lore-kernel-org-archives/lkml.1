Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbYAEUTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbYAEUTF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbYAEUSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:18:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57597 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbYAEUSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:18:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Sat, 5 Jan 2008 21:19:47 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801051455320.26040-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801051455320.26040-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801052119.48542.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of January 2008, Alan Stern wrote:
> On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:
> 
> > Greg, Andrew,
> > 
> > The appended patch is a replacement for
> > gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch that deadlocked
> > suspend and hibernation on some systems.
> > 
> > Please consider for applying.
> 
> This warning message:
> 
> > @@ -905,6 +915,13 @@ void device_del(struct device * dev)
> >  	struct device * parent = dev->parent;
> >  	struct class_interface *class_intf;
> >  
> > +	if (pm_sleep_lock()) {
> > +		dev_warn(dev, "Illegal %s during suspend\n", __FUNCTION__);
> > +		dump_stack();
> > +	} else {
> 
> will unavoidably be triggered by this code:

Ah, my fault, sorry.

> > +void device_pm_destroy_suspended(struct device *dev)
> > +{
> > +	pr_debug("PM: Removing suspended device %s:%s\n",
> > +		 dev->bus ? dev->bus->name : "No Bus",
> > +		 kobject_name(&dev->kobj));
> > +	mutex_lock(&dpm_list_mtx);
> > +	list_del_init(&dev->power.entry);
> > +	mutex_unlock(&dpm_list_mtx);
> > +	up(&dev->sem);
> > +	device_unregister(dev);
> > +}
> 
> since the call to device_del() will occur while the pm_sleep_rwsem is
> still locked for writing.  That's why I suggested not unregistering
> these devices until after everything else has been resumed and the
> rwsem has been dropped.

Hmm, well.  I'll go back to the previous version, then.  Sorry for the mess.

> Another thing to watch out for: Just in case somebody ends up calling
> destroy_suspended_device(dev) from within dev's own resume method, you 
> should interchange the resume_device() and the list_move_tail() 
> calls in dpm_resume().

However, if we unregister them all at once after releasing pm_sleep_rwsem,
that shouldn't be necessary, right?

Rafael
