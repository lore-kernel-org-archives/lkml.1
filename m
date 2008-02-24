Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYBXTDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYBXTDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYBXTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:03:07 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2565 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753139AbYBXTDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:03:06 -0500
Date: Sun, 24 Feb 2008 14:03:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <20080224182120.GB3886@ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0802241358080.11145-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Pavel Machek wrote:

> Hi!
> 
> > Index: usb-2.6/drivers/base/power/main.c
> > ===================================================================
> > --- usb-2.6.orig/drivers/base/power/main.c
> > +++ usb-2.6/drivers/base/power/main.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/pm.h>
> >  #include <linux/resume-trace.h>
> >  #include <linux/rwsem.h>
> > +#include <linux/sched.h>
> >  
> >  #include "../base.h"
> >  #include "power.h"
> > @@ -59,6 +60,13 @@ static DECLARE_RWSEM(pm_sleep_rwsem);
> >  
> >  int (*platform_enable_wakeup)(struct device *dev, int is_on);
> >  
> > +static struct task_struct *suspending_task;
> 
> What locking protects this variable? What happens when suspending_task
> exits? (Hmm, that would probably be bug, anyway?)

It's protected by whatever existing locking scheme allows only one
task to start a system sleep at a time.  For example, the suspending 
task has to get a write lock on pm_sleep_rwsem.

Yes, if the suspending task exits before the system has woken up, 
you're in trouble regardless.

> Or are we running UP when this is accessed? This at least needs a big
> fat comment.
> 
> > +bool in_suspend_context(void)
> > +{
> > +	return (suspending_task == current);
> > +}

We aren't necessarily UP.  But since all that matters is whether or not 
suspend_task is equal to the current task, no extra locking is needed.  

I'll add a comment explaining all this.

Alan Stern

