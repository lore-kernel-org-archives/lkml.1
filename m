Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYLaNOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYLaNOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYLaNOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:14:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48682 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYLaNOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:14:16 -0500
Date: Wed, 31 Dec 2008 14:27:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Peter W. Morreale" <pmorreale@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
Message-ID: <20081231132738.GS496@one.firstfloor.org>
References: <20081230231152.10427.50620.stgit@hermosa.site> <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site> <20081231024609.GQ496@one.firstfloor.org> <1230696664.3470.105.camel@hermosa.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230696664.3470.105.camel@hermosa.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I say most because the assumption would be that we will be successful in
> creating the new thread.  Not that bad an assumption I think.  Besides,

And that the memory read is not reordered (rmb()).

> the consequences of a miss are not harmful. 

Nod. Sounds reasonable.

>  
> > 
> > > More to the point, on small systems with few file systems, what is the
> > > point of having 8 (the current max) threads competing with each other on
> > > a single disk?  Likewise, on a 64-way, or larger system with dozens of
> > > filesystems/disks, why wouldn't I want more background flushing?
> > 
> > That makes some sense, but perhaps it would be better to base the default
> > size on the number of underlying block devices then?
> > 
> > Ok one issue there is that there are lots of different types of 
> > block devices, e.g. a big raid array may look like a single disk.
> > Still I suspect defaults based on the block devices would do reasonably
> > well.
> 
> Could be...  However bear in mind that we traverse *filesystems*, not
> block devs with background_writeout() (the pdflush work function). 

My thinking was that on traditional block devices you roughly
want only N, N small number, flushers per spingle because 
otherwise they will just seek too much.

Anyways iirc there's a way now to distingush SSDs from normal
block devices based on hints from the block layer, but that still 
doesn't handle the big RAID array case well.

> 
> But even if we did block devices, consider that we still don't know the
> speed of those devices (consider SSD v. raid v. disk) and consequently,
> we don't know how many threads to throw at the device before it becomes
> congested and we're merely spinning our wheels.  I mean, an SSD at
> 500MB/s (or greater) certainly could handle more pages being thrown at
> it than an IDE drive... 

I was thinking just of the initial default, but you're right
it really needs to tune the upper limit.

> 
> And this ties back to MAX_WRITEBACK_PAGES (currently 1k) which is the
> chunk that we write out in one pass.   In order to not "hold the inode
> lock too long", this is the chunk we attempt to write out.  
> 
> What is the right magic number for the various types of block devs?  1k
> for all?  for all time?  :-)

Ok it probably needs some kind of feedback mechanism.

Perhaps have keep an estimate of the average IO time for a single
flush and when it reaches some threshold start more threads? 
Or have feedback from the elevators how busy they are.

Of course it would still need a upper limit to prevent
a thread explosion in case IO suddenly becomes very slow
(e.g. in a error recovery case), but it could be much
higher than today.

> 
> Anyway, back to the traversal of filesystems.  In writeback_inodes(), we
> currently traverse the super block list in reverse.  I don't quite
> understand why we do this, but <shrug>.  
> 
> What this does mean is that unfairly penalize certain file systems when
> attempting to clean dirty pages.  If I have 5 filesystems, all getting
> hit on, then the last one in will always be the 'cleanest'.   Not sure
> that makes sense.  

Probably not.

> 
> I was thinking about a patch that would go both directions - forward and
> reverse depending upon, say, a bit in jiffies...  Certainly not perfect,
> but a bit more fair.  

Better a real RNG. But such probalistic schemes unfortunately tend to drive
benchmarkers crazy, that is why it is better to avoid them. 

I suppose you could just keep some state per fs to ensure fairness.

-Andi
