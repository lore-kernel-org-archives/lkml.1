Return-Path: <linux-kernel-owner+w=401wt.eu-S935683AbZLGXuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935683AbZLGXuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935337AbZLGXue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:50:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935309AbZLGXud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:50:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Tue, 8 Dec 2009 00:51:12 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912071610520.15701-100000@iolanthe.rowland.org> <200912072302.57318.rjw@sisk.pl> <alpine.LFD.2.00.0912071407070.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912071407070.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912080051.13061.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Linus Torvalds wrote:
> 
> On Mon, 7 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > BTW, I still don't quite understand why not to put the parent's down_write
> > operation into the core.  It's not going to hurt for the "synchronous" devices
> > and the "asynchronous" ones will need to do it anyway.
> 
> That's what I started out doing (see the first pseudo-code with the two 
> phases). But it _does_ actually hurt.

Hmm.  If no one calls down_read() on the "synchronous" devices, their
down_write()s will be nops.  In turn, if somebody does call down_read(), it
means they really need to wait for someone.  They presumably don't need
to wait for each other, but we don't really know that (otherwise they would
have been "asynchronous").

> Because it will hurt exactly for the "multiple hubs" case: if you have two 
> USB hubs in parallel (and the case that Alan pointed out about a USB host 
> bridge is the exact same deal), then you want to be able to suspend and 
> resume those two independent hubs in parallel too.
> 
> But if you do the "down_write()" synchronously in the core, that means 
> that you are also stopping the whole "traverse the tree" thing - so now 
> you aren't handling the hubs in parallel even if you are handling all the 
> devices _behind_ them asynchronously.
> 
> This "serialize while traversing the tree" was what I was initially trying 
> to avoid with the two-phase approach, but that I realized (after writing 
> the resume path) that I could avoid much better by just moving the parents 
> down_write into the asynchronous path.

But the asynchronous path has to be started somewhere.  Basically, there are
three possible places: the core itself, the bus type's suspend routine called
by the core (same goes for resume of course), and the device driver's suspend
routine called by the bus type.

Now, I don't really see how we can put the the parent's down_write() in a
child's suspend routine, for multiple reasons (one of them being that there can
be multiple asynchronous children the parent needs to wait for), so it looks like
it needs to be above the driver's suspend.

However, the parent can be on a different bus type than the children, so it
looks like we can only start the asynchronous path at the core level.

> > Also it looks like that's something to do unconditionally for all nodes
> > having children, because the parent need not know if the children do async
> > operations.
> 
> True, and that was (again) the first iteration. But see above: in order to 
> allow way more concurrency, you don't want to introduce the false 
> dependency between the write-lock and the traversal of the tree (or, as 
> Alan points out - just a list - but that doesn't really change anything) 
> that is introduced by taking the lock synchronously.
> 
> So by moving the write-lock to the asynchronous work that also shuts down 
> the parent, you avoid that whole unnecessary serialization. But that means 
> that you can't do the lock in generic code.
>
> Unless you want to do _all_ of the async logic in generic code and 
> re-introduce the "dev->async_suspend" flag.

Quite frankly, I would like to.

> I would be ok with that now that the infrastructure seems so simple.

Well, perhaps I should dig out my original async suspend/resume patches
that didn't contain all of the non-essential stuff and post them here for
discussion, after all ...

Rafael
