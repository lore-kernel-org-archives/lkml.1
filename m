Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYLaELU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYLaELU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYLaELL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:11:11 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:45825 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbYLaELK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:11:10 -0500
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081231024609.GQ496@one.firstfloor.org>
References: <20081230231152.10427.50620.stgit@hermosa.site>
	 <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site>
	 <20081231024609.GQ496@one.firstfloor.org>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Tue, 30 Dec 2008 21:11:04 -0700
Message-Id: <1230696664.3470.105.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 03:46 +0100, Andi Kleen wrote:
> On Tue, Dec 30, 2008 at 06:56:29PM -0700, Peter W. Morreale wrote:
> > The rational is simply because one-size may not fit all.  Currently
> > there is minimalistic tuning wrt pdflush thread creation. 
> 
> Thanks. Please put this into the commit description for future
> reference. 
> 

Will do.

> Some comments below.
> 
> > Each pdflush thread arbitrarily decides to create another thread solely
> > on the basis of all currently existing threads being busy for >= one
> > second.  So this can result in NCPUS pdflush threads being created
> > 'concurrently' should all existing threads wind up in the idle check at
> > the same time (I have seen this).  Or it can result in a thread being
> 
> So perhaps a simple lock serializing creation of new pdflush threads
> would avoid the problem?

nod.  It's probably even simpler than that.  By merely updating
'last_empty_jifs" when we decide to create the next pdflush thread, we
could easily account for _most_ of the races without adding significant
overhead.  

I say most because the assumption would be that we will be successful in
creating the new thread.  Not that bad an assumption I think.  Besides,
the consequences of a miss are not harmful. 
 
> 
> > More to the point, on small systems with few file systems, what is the
> > point of having 8 (the current max) threads competing with each other on
> > a single disk?  Likewise, on a 64-way, or larger system with dozens of
> > filesystems/disks, why wouldn't I want more background flushing?
> 
> That makes some sense, but perhaps it would be better to base the default
> size on the number of underlying block devices then?
> 
> Ok one issue there is that there are lots of different types of 
> block devices, e.g. a big raid array may look like a single disk.
> Still I suspect defaults based on the block devices would do reasonably
> well.

Could be...  However bear in mind that we traverse *filesystems*, not
block devs with background_writeout() (the pdflush work function). 

But even if we did block devices, consider that we still don't know the
speed of those devices (consider SSD v. raid v. disk) and consequently,
we don't know how many threads to throw at the device before it becomes
congested and we're merely spinning our wheels.  I mean, an SSD at
500MB/s (or greater) certainly could handle more pages being thrown at
it than an IDE drive... 

And this ties back to MAX_WRITEBACK_PAGES (currently 1k) which is the
chunk that we write out in one pass.   In order to not "hold the inode
lock too long", this is the chunk we attempt to write out.  

What is the right magic number for the various types of block devs?  1k
for all?  for all time?  :-)

Anyway, back to the traversal of filesystems.  In writeback_inodes(), we
currently traverse the super block list in reverse.  I don't quite
understand why we do this, but <shrug>.  

What this does mean is that unfairly penalize certain file systems when
attempting to clean dirty pages.  If I have 5 filesystems, all getting
hit on, then the last one in will always be the 'cleanest'.   Not sure
that makes sense.  

I was thinking about a patch that would go both directions - forward and
reverse depending upon, say, a bit in jiffies...  Certainly not perfect,
but a bit more fair.  

Actually, it seems to me that we need to look at a radically different
approach.  What about making background writes a property of the super
block? (which implies the file system)  Has that been discussed before?


Best,
-PWM



> 
> > 
> > I actually think the question is: Why not allow the admin to control
> > this?  Since it seems like this is a matter of policy based on machine
> > configuration. 
> 
> The kernel should know the current machine config and most 
> admins don't really want to do very fine grained configuration;
> they expect the system to perform well out of the box. That is
> why it is adventageous to try to come up with good auto tuning.
> 
> > And btw Andi, I should have cc'ed you on this, I know from the flush
> > code that you were heavily involved.  I only cc'ed Peter Z. since his
> > name was in pdflush.c.  My apologies.  
> 
> No problem, but I think you're confusing me with someone else :). I don't
> remember ever hacking on this. Perhaps you thought of Andrew Morton
> who did pdflush originally.
> 
> -Andi
> 

