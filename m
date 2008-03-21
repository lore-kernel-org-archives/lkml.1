Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYCUBVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYCUBVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 21:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYCUBVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 21:21:35 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4688 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752475AbYCUBVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 21:21:34 -0400
Date: Thu, 20 Mar 2008 21:21:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 2)
In-Reply-To: <200803210101.04706.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803202104090.11234-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Rafael J. Wysocki wrote:

> Hi,
> 
> Below is an updated version of the $subject patch.  It has only been
> compilation tested, but I'd like to get as much feedback as reasonably possible
> at this stage to avoid redesigning things later in the process.
> 
> The most important changes from the previous one are the following:
> * Callbacks to be executed with interrupts disabled are now separated from
>   the "regular" ones.  There still are six of them, but IMHO this is what may
>   be necessary in the most general case (eg. a driver may have to carry out
>   some operations with interrupts disabled, which are different for SUSPEND,
>   FREEZE and HIBERNATE; the complementary "resume" callbacks are needed for
>   error recovery, for example)
> * It occured to me that the ->freeze() and ->quiesce() callbacks were
>   essentially the same, so I removed the latter
> * The ->recover() callback was also dropped, as ->thaw() may well be used instead
>   just fine (it seems)
> * ->prepare() and ->complete() are now called in separate loops which causes
>   some funny complications with error recovery.  Namely, we must remember which
>   devices have already been ->prepare()d, so that we call ->complete() for them
>   in the error path.  Moreover, there may be some ->prepare()d and some
>   ->suspend()ed devices at the same time, so if there's an error we should
>   ->resume() the ->suspend()ed ones and ->complete() everything etc.
>   This may be handled in many different ways, but I decided to introduce a new
>   list on which the ->complete()d devices are stored.  Accordingly, the
>   registration of new children of a device is blocked between ->prepare() and
>   ->complete() (it was only blocked between ->prepare() and ->resume() in the
>   previous version).
> 
> Please have a look.

I don't have time to go through this in detail now, but a few things 
stand out.

One trivial problem is that your dpm_prepare and dpm_complete routines 
go through the list in the wrong order.

More importantly, the situation with prepare and complete is getting
rather complicated.  Now that you're adding dev->power.state, why not
go all the way?  Get rid of all the different lists, keeping just
dpm_active and possibly dpm_destroy.  Instead of moving devices between
different lists, just store in dev->power.state an identification for
which list the device is supposed to be on or is supposed to be moving
to.  (Or else have a bunch of bitfields indicating which methods have
been called.)  This has the advantage that the entries will never get
out of order, even if devices are registered at the wrong time.

There's some question about when we want the PM core to start
preventing new children from being registered.  Should this start right
after prepare() returns, or should it start right before suspend() is
called?  The first alternative sounds better to me.  Not only does it
agree with the purpose of the prepare method, it also makes race
situations easier to handle.

Since dpm_prepare is supposed to go through the list in the forward
direction, logically the "root" of the device tree should be the first
thing "prepared".  This means you should not allow parentless devices
to be registered any time after dpm_prepare has started.  Is that 
liable to cause problems?

There may be similar problems with complete().  A number of drivers
check during their resume method for the presence of new children
plugged in while the system was asleep.  All these drivers would have
to be converted over to the new scheme if they weren't permitted to
register the new children before complete() was called.  Of course,
this is easily fixed by permitting new children starting from when
resume() is called rather than when complete() is called.

Alan Stern

