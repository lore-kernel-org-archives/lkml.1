Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYCCW54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYCCW54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYCCW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:57:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47871 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYCCW5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:57:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Mon, 3 Mar 2008 23:56:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <Pine.LNX.4.44L0.0803031626180.8280-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803031626180.8280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803032356.35275.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of March 2008, Alan Stern wrote:
> On Mon, 3 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > > Of course, it won't be necessary if the ->suspend_begin() methods are called
> > > > in an initial forward pass through dpm_active.
> > > 
> > > Right.  That would be simpler.
> 
> Let's stick with that for now.
> 
> What about on the resume side?  Do you want to prevent child
> registrations until after end_sleep has run?  Or would you be okay with
> allowing the resume method to register new children?

I think ->resume() can register new children.  There's nothing wrong with
that from the core's standpoint.

> It should be safe to assume that drivers are smart enough to bring the device
> back to full power before looking for new children.

Well, it would be a bug not to do so.

> In fact, maybe we don't need an end_sleep method at all.  There isn't
> any synchronization issue to worry about -- drivers aren't going to
> register their new children in a suspended state!

Agreed.

> > > > That's correct.  Perhaps we should change device_add().
> > > 
> > > I had a change like that in my version of the patch.  It's excerpted 
> > > below.
> > 
> > Hm, I wonder why you didn't move dpm_sysfs_add() along with device_pm_add()?
> 
> Because I didn't think of it.  :-)
> 
> > Perhaps it's better to include dpm_sysfs_add() into device_pm_add(), since we
> > are going the make the return a result anyway?
> 
> Yes.

Okay, I'll prepare a patch for that, on top of the one introducing the
'sleeping' field into 'struct dev_pm_info' (posting in a while).
 
> > > > I thought ->suspend() would be mandatory, even if it's to be empty.
> > > 
> > > There's no need for that.  If it isn't implemented, treat it as though 
> > > it was successful.
> > 
> > Well, I'm not sure.  Right now we have a problem with distinguishing drivers
> > that don't implement ->suspend() purposefully from the ones that just don't
> > support suspend/hibernation ...
> > 
> > OTOH, since we are going to have a pointer to 'struct pm_ops', we can safely
> > assume that if it's not NULL, the driver writer knows what he's doing.
> 
> That's reasonable.  If a driver doesn't support PM then it won't have 
> a pm_ops pointer.

Exactly.

The question remains what we're going to do with the drivers without pm_ops
pointers in the long run (in the short run we will use the legacy callbacks in
that cases, if defined).

Thanks,
Rafael
