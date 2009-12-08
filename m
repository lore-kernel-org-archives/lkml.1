Return-Path: <linux-kernel-owner+w=401wt.eu-S966042AbZLHU3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966042AbZLHU3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966011AbZLHU3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:29:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965757AbZLHU3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:29:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 21:30:14 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912081508220.3046-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912081508220.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912082130.14634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Alan Stern wrote:
> On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> 
> > Suppose we use rwsem and during suspend each child uses a down_read() on a
> > parent and then the parent uses down_write() on itself.  What if, whatever the
> > reason, the parent is a bit early and does the down_write() before one of the
> > children has a chance to do the down_read()?  Aren't we toast?
> > 
> > Do we need any direct protection against that or does it just work itself out
> > in a way I just don't see right now?
> 
> That's not the way it should be done.  Linus had children taking their
> parents' locks during suspend, which is simple but leads to
> difficulties.
> 
> Instead, the PM core should do a down_write() on each device before
> starting the device's async suspend routine, and an up_write() when the
> routine finishes.  Parents should, at the start of their async routine,
> do down_read() on each of their children plus whatever other devices
> they need to wait for.  The core can do the waiting for children part 
> and the driver's suspend routine can handle any other waiting.
> 
> This is a little more awkward because it requires the parent to iterate 
> through its children.

I can live with that.

> But it does solve the off-tree dependency  problem for suspends.

That's a plus, but I still think we're trying to create a barrier-alike
mechanism using lock.

There's one more possibility to consider, though.  What if we use a completion
instead of the flag + wait queue?  It surely is a standard synchronization
mechanism and it seems it might work here.

Rafael
