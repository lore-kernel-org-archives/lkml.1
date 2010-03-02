Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab0CBKEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 05:04:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52891 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab0CBKES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 05:04:18 -0500
Date: Tue, 2 Mar 2010 10:04:02 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
	due to "e084b - page-allocator: preserve PFN ordering when
	__GFP_COLD is set"
Message-ID: <20100302100402.GH3852@csn.ul.ie>
References: <20100212100519.GA29085@laptop> <4B796C6D.80800@linux.vnet.ibm.com> <20100216112517.GE1194@csn.ul.ie> <4B7ACC1E.9080205@linux.vnet.ibm.com> <4B7BBCFC.4090101@linux.vnet.ibm.com> <20100218114310.GC32626@csn.ul.ie> <4B7D664C.20507@linux.vnet.ibm.com> <4B7E73BF.5030901@linux.vnet.ibm.com> <20100219151934.GA1445@csn.ul.ie> <20100302065225.GC8653@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100302065225.GC8653@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 05:52:25PM +1100, Nick Piggin wrote:
> On Fri, Feb 19, 2010 at 03:19:34PM +0000, Mel Gorman wrote:
> > On Fri, Feb 19, 2010 at 12:19:27PM +0100, Christian Ehrhardt wrote:
> > > Eventually it might come down to a discussion of allocation priorities and
> > > we might even keep them as is and accept this issue - I still would prefer
> > > a good second chance implementation, other page cache allocation flags or
> > > something else that explicitly solves this issue.
> > >
> > 
> > In that line, the patch that replaced congestion_wait() with a waitqueue
> > makes some sense.
> > 
> > > Mel's patch that replaces congestion_wait with a wait for the zone watermarks
> > > becoming available again is definitely a step in the right direction and
> > > should go into upstream and the long term support branches.
> > 
> > I'll need to do a number of tests before I can move that upstream but I
> > don't think it's a merge candidate. Unfortunately, I'll be offline for a
> > week starting tomorrow so I won't be able to do the testing.
> > 
> > When I get back, I'll revisit those patches with the view to pushing
> > them upstream. I hate to treat symptoms here without knowing the
> > underlying problem but this has been spinning in circles for ages with
> > little forward progress :(
> 
> The zone pressure waitqueue patch makes sense.

I've just started the rebase and considering what sort of test is best
for it.

> We may even want to make
> it more strictly FIFO (eg. check upfront if there are waiters on the
> queue before allocating a page, and if yes then add ourself to the back
> of the waitqueue).

To be really strict about this, we'd have to check in the hot-path of the
per-cpu allocator which would be undesirable. We could check further in the
slow-path but I bet it'd be very rare that the logic would be triggered. For
a process to enter the FIFO due to waiters that were not yet woken up, the
system would have to be a) under heavy memory pressure b) reclaim taking such
a long time that check_zone_pressure() is not being called in time and c)
a process exiting or otherwise freeing memory such that the watermarks are
cleared without reclaim being involved.

This seems overkill but maybe you have a simplier case in mind?

> And also possibly even look at doing the wakeups in
> the page-freeing path. Although that might start adding too much
> overhead, so it's quite possible your sloppy-but-lighter timeout
> approach is preferable.
> 

That's how I felt about it. I was going to put another check_zone_pressure()
check after a pcp drain but thought it was too expensive.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
