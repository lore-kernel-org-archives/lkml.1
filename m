Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYBXPeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYBXPeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYBXPdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:33:51 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2168 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757182AbYBXPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:33:37 -0500
Date: Sun, 24 Feb 2008 10:33:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pierre Ossman <drzeus-mmc@drzeus.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is
 inserted]
In-Reply-To: <200802241500.41969.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802240941440.29504-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:

> > In fact this turns out to be exactly the problem with the MMC
> > subsystem.  It uses a dedicated workqueue (kmmcd) to handle state
> > changes, and mmc_suspend_host() does a flush_workqueue().  If the
> > workqueue contains an entry to register or unregister a device, this is
> > guaranteed to deadlock -- and that's exactly what happens when Zdenek 
> > inserts or removes a card during the disk-drive spindown time of a 
> > system sleep.
> > 
> > It looks like the best solution is for mmc_suspend_host() not to flush
> > the workqueue; instead the workqueue should prevent itself from
> > running during a suspend.  Right now the easiest way to accomplish this
> > is for the workqueue routines (mmc_detect() and siblings) to acquire
> > the mmc_host's device semaphore.  If in the future the MMC subsystem
> > adds dynamic PM support then a more complicated arrangement will be 
> > needed.
> > 
> > So the patch below, in combination with the previous patch, might just 
> > fix the whole problem.
> 
> The patch looks sane and I think you're right.

Well, the patch itself isn't really adequate; it was just a first pass 
intended to illustrate the nature of the problem.

The problems in the MMC subsystem go deeper.

The first is the way it uses flush_workqueue().  This is almost always 
a bad function to call, because it introduces unnecessary dependencies.  
cancel_delayed_work_sync() is much better.

But even changing that won't solve the second issue, which is a genuine
bug.  There is a race between detect events and suspend events.  The
mmc_suspend_host() routine starts out by flushing the kmmcd workqueue
before calling the host's suspend routine.  So what happens if another
detect event occurs in between?

This whole area of synchronization between card insertion, card
removal, suspend, and resume needs to be thought out better.  
Especially keeping in mind that device registration or unregistration
during a system sleep is likely to block until the sleep is over.

Lastly, there are some other questions about confusing aspects of the
subsystem.  What's the story with __mmc_claim_host()?  Is it really
nothing more than an abortable mutex_lock()?  Why does it ever need to
be aborted?  Why is its second argument an atomic_t instead of a normal
int?

Why are mmc_detect() and related routines described in comments as
"Card detection callback from host"?  They don't handle card
_detection_ -- they handle card _removal_.

What's the purpose of the card-counting loop in 
host/omap.c:mmc_omap_switch_handler()?  It looks like dead code.

Alan Stern

