Return-Path: <linux-kernel-owner+w=401wt.eu-S1761092AbYCCWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092AbYCCWs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYCCWsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:48:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33963 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753150AbYCCWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:48:46 -0500
Date: Mon, 3 Mar 2008 17:48:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200803032147.10223.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803031626180.8280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Rafael J. Wysocki wrote:

> > > Of course, it won't be necessary if the ->suspend_begin() methods are called
> > > in an initial forward pass through dpm_active.
> > 
> > Right.  That would be simpler.

Let's stick with that for now.

What about on the resume side?  Do you want to prevent child
registrations until after end_sleep has run?  Or would you be okay with
allowing the resume method to register new children?  It should be safe
to assume that drivers are smart enough to bring the device back to
full power before looking for new children.

In fact, maybe we don't need an end_sleep method at all.  There isn't
any synchronization issue to worry about -- drivers aren't going to
register their new children in a suspended state!

> > > That's correct.  Perhaps we should change device_add().
> > 
> > I had a change like that in my version of the patch.  It's excerpted 
> > below.
> 
> Hm, I wonder why you didn't move dpm_sysfs_add() along with device_pm_add()?

Because I didn't think of it.  :-)

> Perhaps it's better to include dpm_sysfs_add() into device_pm_add(), since we
> are going the make the return a result anyway?

Yes.

> > > I thought ->suspend() would be mandatory, even if it's to be empty.
> > 
> > There's no need for that.  If it isn't implemented, treat it as though 
> > it was successful.
> 
> Well, I'm not sure.  Right now we have a problem with distinguishing drivers
> that don't implement ->suspend() purposefully from the ones that just don't
> support suspend/hibernation ...
> 
> OTOH, since we are going to have a pointer to 'struct pm_ops', we can safely
> assume that if it's not NULL, the driver writer knows what he's doing.

That's reasonable.  If a driver doesn't support PM then it won't have 
a pm_ops pointer.

> > > > Here's something else to think about.  We might want to allow some 
> > > > devices to be "power-irrelevant".  That is, the device exists in the 
> > > > kernel only as a representation of some software state, not as a 
> > > > physical device.  It doesn't consume power, it doesn't have any state 
> > > > to lose during a sleep, and its driver doesn't implement suspend or 
> > > > resume methods.  For these sorts of devices, we might allow 
> > > > device_add() to skip calling device_pm_add() altogether.  USB 
> > > > interfaces are a little like this, as are SCSI hosts and MMC hosts.
> > > 
> > > If such devices serve as logical parents of some "real" ones, we should
> > > at least mark them as "sleeping" during suspend to protect the dpm_active
> > > ordering.
> > 
> > They wouldn't have to be marked at all.  They would never get on any of 
> > the PM lists, because they would never be passed to device_pm_add().
> 
> But dev->parent will be not NULL for their children being on dpm_active ...
> 
> IMO it's simpler to just add those devices without any suspend callbacks
> defined to dpm_active and handle them normally than to introduce a special
> case.

Yeah, I'm just trying to think too far ahead.

Alan Stern

