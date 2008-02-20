Return-Path: <linux-kernel-owner+w=401wt.eu-S1764362AbYBTWn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764362AbYBTWn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYBTWnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:43:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60605 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbYBTWnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:43:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Wed, 20 Feb 2008 23:41:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802201721080.24031-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201721080.24031-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802202341.57748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Alan Stern wrote:
> On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:
> 
> > Well, below is an uncompiled and untested but illustrating the idea that
> > might allow people not to bother with device_pm_schedule_removal()
> > explicitly and can fix the issue at hand.
> > 
> > [There are some cases that need handling and are not covered here.]
> > 
> > Please have a look.
> > 
> > Thanks,
> > Rafael
> 
> > +static struct task_struct *suspending_task;
> > +static DEFINE_MUTEX(suspending_task_mtx);
> 
> I suspect you don't really need this mutex.
> 
> > +bool in_suspend_context(void)
> > +{
> > +	bool result;
> > +
> > +	mutex_lock(&suspending_task_mtx);
> > +	result = (suspending_task == current);
> > +	mutex_unlock(&suspending_task_mtx);
> > +	return result;
> > +}
> 
> If suspending_task == current then you are guaranteed to be serialized, 
> because everything a single task does is serial.

But in principle there could be a concurrent thread removind the device and
that should block on dev->sem held by us.

Right now that's not very likely to happen thanks to the freezer, but we're
doing all this stuff, because we want to get rid of the freezer eventually. :-)

> > @@ -1162,7 +1162,10 @@ void device_destroy(struct class *class,
> >  	dev = class_find_device(class, &devt, __match_devt);
> >  	if (dev) {
> >  		put_device(dev);
> > -		device_unregister(dev);
> > +		if (in_suspend_context())
> > +			device_pm_schedule_removal(dev);
> > +		else
> > +			device_unregister(dev);
> >  	}
> >  }
> 
> But what about device_del()?  Can a similar change be made there?

I believe so.

I'm working on a more complete patch right now.

Thanks,
Rafael
