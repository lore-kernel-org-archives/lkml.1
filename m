Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYAELyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYAELyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 06:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYAELxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 06:53:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56034 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYAELxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 06:53:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] PM: Introduce destroy_suspended_device()
Date: Sat, 5 Jan 2008 12:55:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0801042202070.22169-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801042202070.22169-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801051255.51144.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of January 2008, Alan Stern wrote:
> On Fri, 4 Jan 2008, Rafael J. Wysocki wrote:
> 
> > I have rebased gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> > on top of the $subject series, the result is appended.  It has only been
> > compilation tested for now, but I'll be testing it for the next couple of days.
> > 
> > Please review.
> 
> I would prefer it if you could also merge in this patch at the same 
> time:
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2007-December/015921.html

Makes sense, I will.

> > +void device_resume(void)
> >  {
> > -	sysdev_resume();
> > -	dpm_power_up();
> > +	might_sleep();
> > +	dpm_resume();
> > +	unlock_all_devices();
> > +	unregister_dropped_devices();
> > +	up_write(&pm_sleep_rwsem);
> >  }
> 
> With the aforementioned patch merged in, this will generate a 
> warning for each dropped device.  The call to 
> unregister_dropped_devices() should come after the up_write().
> 
> You might also consider adding a call to unregister_dropped_devices()  
> in the error path of device_suspend() -- in theory even an aborted 
> suspend might cause a device to malfunction.

In fact it already works like this, since device_suspend() now calls the entire
device_resume() on error.

> Otherwise this looks okay.

However, I think we don't need to wait with unregistering suspended devices
until after the other ones are resumed.  We only need a special function for
unregistering suspended devices that will make the PM core release the device's
semaphore before unregistering it.

I have already sent a replacemet for
gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch that includes
some code from the $subject patch and implements the above idea:

http://lkml.org/lkml/2008/1/4/278

I'm going to merge it with your patch at:
https://lists.linux-foundation.org/pipermail/linux-pm/2007-December/015921.html
and with patches [2/4] and [4/4] from the $subject series.  I'll post the
result for a review later today.

Thanks,
Rafael
