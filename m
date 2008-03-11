Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYCKDuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYCKDuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 23:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYCKDuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 23:50:44 -0400
Received: from phunq.net ([64.81.85.152]:37156 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754126AbYCKDun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 23:50:43 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 10 Mar 2008 19:50:40 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <20080310092213.7ba878b3@core>
In-Reply-To: <20080310092213.7ba878b3@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102050.40567.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Nice to see so many redhatters taking an avid interest in storage :-)

On Monday 10 March 2008 02:22, Alan Cox wrote:
> > So now you can ask some hard questions: what if the power goes out 
> > completely or the host crashes or something else goes wrong while 
> > critical data is still in the ramdisk?  Easy: use reliable components.  
> 
> Nice fiction - stuff crashes eventually - not that this isn't useful. For
> a long time simply loading a 2-3GB Ramdisk off hard disk has been a good
> way to build things like compile engines where loss of state is not bad.

Right, and now with ramback you will be able to preserve that state and
have the performance too.  It is a wonderful world.

> > If UPS power runs out while ramback still holds unflushed dirty data 
> > then things get ugly.  Hopefully a fsck -f will be able to pull 
> > something useful out of the mess.  (This is where you might want to be 
> > running Ext3.)  The name of the game is to install sufficient UPS power 
> > to get your dirty ramdisk data onto stable storage this time, every 
> > time.
> 
> Ext3 is only going to help you if the ramdisk writeback respects barriers
> and ordering rules ?

I was alluding to to e2fsck's amazing repair ability, not ext3's journal.

> >  * Previously saved data must be reloaded into the ramdisk on startup.
> 
> /bin/cp from initrd

But that does not satisfy the requirement you snipped:

 * Applications need to be able to read and write ramback data during
   initial loading.

> >  * Cannot transfer directly between ramdisk and backing store, so must 
> >    first transfer into memory then relaunch to destination.
> 
> Why not - providing you clear the dirty bit before the write and you
> check it again after ? And on the disk size as you are going to have to

More accurately: in general, cannot transfer directly.  The ramdisk may
be external and not present a memory interface.  Even an external
ramdisk with a memory interface (the Violin box has this) would require
extra programming to maintain cache consistency.  Then there is the
issue of ramdisks on the way that exceed the 40 bit physical addressing
of current generation processors.

Even for the simple case where the ramdisk is just part of the kernel
unified cache, I would rather not go delving into that code when these
transfers are on the slow path anyway.  Application IO does its normal
single copy_to/from_user thing.  If somebody wants to fiddle with vm,
the place to attack is right there.  The copy_to/from_user can be
eliminated (provided alignment requirements are met) using stupid page
table tricks.  In spite of Linus claiming there is no performance win 
to be had, I would like to see that put to the test.

> suck all the content back in presumably a log structure is not a big
> concern ?

Sorry, I failed to parse that.

> >  * Per chunk locking is not feasible for a terabyte scale ramdisk.
> 
> And we care  8) ?

"640K should be enough for anyone"

http://www.violin-memory.com/products/violin1010.html <- 504 GB ramdisk

> >   * Handle chunk size other than PAGE_SIZE.
> 
> If you are prepared to go bigger than the fs chunk size so lose the
> ordering guarantees your chunk size really ought to be *big* IMHO

The finer the granularity the faster the ramdisk syncs to backing
store.  The only attraction of coarse granularity I know of is
shrinking the bitmap, which is currently not so big that it presents
a problem.

Your comment re fs chunk size reveals that I have failed to
communicate the most basic principle of the ramback design: the
backing store is not expected to represent a consistent filesystem
state during normal operation.  Only the ramdisk needs to maintain a
consistent state, which I have taken care to ensure.  You just need
to believe in your battery, Linux and the hardware it runs on.  Which
of these do you mistrust?

Regards,

Daniel
