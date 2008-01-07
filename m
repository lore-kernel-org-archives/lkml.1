Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYAGTaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYAGTaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYAGTaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:30:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57986 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752372AbYAGT37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:29:59 -0500
Date: Mon, 7 Jan 2008 14:29:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801071901.24926.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801071412530.6739-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Rafael J. Wysocki wrote:

> On Monday, 7 of January 2008, Alan Stern wrote:
> > On Mon, 7 Jan 2008, Rafael J. Wysocki wrote:
> > 
> > > Please see the patch at: http://lkml.org/lkml/2008/1/6/298 .  It represents my
> > > current idea about how to do that.
> > 
> > It has some problems.
> > 
> > First, note that the list manipulations in dpm_suspend(), 
> > device_power_down(), and so on aren't protected by dpm_list_mtx.  So 
> > your patch could corrupt the list pointers.
> 
> Yes, they need the locking.  I have overlooked that, mostly because the locking
> was removed by gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> too (because you assumed there woundn't be any need to remove a device during
> a suspend, right?).

Right.

> > Are you assuming that no other threads can be running at this time?
> 
> No, I'm not.
> 
> > Note also that device_pm_destroy_suspended() does up(&dev->sem), but it 
> > doesn't know whether or not dev->sem was locked to begin with.
> 
> Do you mean it might have been released already by another thread
> calling device_pm_destroy_suspended() on the same device?

I was thinking that it might be called before lock_all_devices().

However let's ignore that possibility and simplify the discussion by 
assuming that destroy_suspended_device() is never called except by a 
suspend or resume method for that device or one of its ancestors.  
(This still leaves the possibility that it might get called by mistake 
during a runtime suspend or resume...)

> > Do you want to rule out the possibility of a driver's suspend or remove 
> > methods calling destroy_suspended_device() on its own device?  With 
> > your synchronous approach, this would mean that the suspend/resume 
> > method would indirectly end up calling the remove method.  This is 
> > dangerous at best; with USB it would be a lockdep violation.  With an 
> > asynchronous approach, on the other hand, this wouldn't be a problem.
> 
> Well, the asynchronous apprach has the problem that the device may end up
> on a wrong list when removed by one of the .suspend() callbacks (and I don't
> see how to avoid that without extra complexity).  Perhaps that's something we
> can live with, though.

The same problem affects the synchronous approach.  We can fix it by
having dpm_suspend() do the list_move() before calling
suspend_device().  Then if the suspend fails move the device back.

> One more question: is there any particular reason not to call
> device_pm_remove() at the beginning of device_del()?

I think it's done this way to avoid having a window where the device 
isn't on a PM list and is still owned by the bus and the driver.  But 
if a suspend occurs during that window, it shouldn't matter that the 
device will be left unsuspended.  After all, the same thing would have 
happened if the suspend occurred after bus_remove_device().

So no, there shouldn't be a problem with moving the call.

Alan Stern

