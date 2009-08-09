Return-Path: <linux-kernel-owner+w=401wt.eu-S1751646AbZHIC2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbZHIC2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 22:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZHIC2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 22:28:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47770 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750867AbZHIC2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 22:28:37 -0400
Date: Sat, 8 Aug 2009 22:28:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@GMAIL.COM>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH update x2] PM: Introduce core framework for run-time PM
 of I/O devices (rev. 13)
In-Reply-To: <200908082355.32749.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908082219380.27004-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009, Rafael J. Wysocki wrote:

> > The problem with this is that it calls pm_runtime_disable() at a time 
> > when the driver is still supposed to be in control of the device.  
> > Interfering with the driver's legitimate activity in this way is a bad 
> > thing to do.
> > 
> > The difficulty here is that our requirements are a little
> > contradictory.  We want to prevent all runtime PM callbacks while the
> > remove method is running, but we also want the remove method to be able
> > to carry out its own runtime PM activities.
> > 
> > So maybe what we really need is more like a barrier.  That is,
> > something that will do a "get", wait for outstanding callbacks to
> > finish, carry out a resume if one is pending, and cancel other pending
> > requests.  This could easily share code with pm_runtime_disable.  We 
> > should be able to use this for both probe and remove.
> 
> Isn't it what's done in rev. 14?
> 
> pm_runtime_disable(dev);
> pm_runtime_get_noresume(dev);
> pm_runtime_enable(dev);
> 
> is exactly a barrier like this.

It's not exactly the same because it disables runtime PM for a short 
time.  A barrier never disables runtime PM.

>  How exactly would you like to implement it
> instead?

As described above.  The barrier would be equivalent to
pm_runtime_get_noresume followed by pm_runtime_disable except that it
wouldn't actually disable anything.

> > Perhaps this means we don't want to disable runtime PM during system
> > sleep callbacks, but instead use the "barrier" scheme.
> 
> I'm not really sure about that.  I'd rather do what's right now in the patch
> (well, that's why it's in there) until drivers and bus types start using the
> runtime PM framework.  If it turns out to be problematic, we'll change it
> later.

All right.  Since it involves a race, the problem may not show up for a
while.

Alan Stern

