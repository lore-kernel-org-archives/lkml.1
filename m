Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbZBLDeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbZBLDeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbZBLDe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:34:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZBLDe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:34:27 -0500
Date: Thu, 12 Feb 2009 04:34:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Federico Cuello <fedux@lugmen.org.ar>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [Bug #12604] Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
Message-ID: <20090212033423.GC23790@wotan.suse.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.gUG.420jJB@chimera> <20090210162830.GD12146@placka.suse.cz> <20090212014718.GF30043@wotan.suse.de> <alpine.LFD.2.00.0902111757030.3189@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902111757030.3189@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 06:02:19PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 12 Feb 2009, Nick Piggin wrote:
> 
> > On Tue, Feb 10, 2009 at 05:28:30PM +0100, Jan Kara wrote:
> > > On Sun 08-02-09 20:21:42, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > > (either way).
> > >   Yes, I've verified with latest git and the regression is still there.
> > 
> > I'm working on this FWIW...
> 
> Shouldn't we just revert it? The code does look to be broken.
> 
> It also looks like the interaction with that ever-buggy "nr_to_write" 
> thing are totally wrong. I can see that whole
> 
> 	if (!cycled) {
> 		..
> 		index = 0;
> 		goto retry
> 	}
> 
> doing all the wrong things: if we ever hit the combination of 
> "!cycled + nr_to-write==0", we're always screwed. It simply _cannot_ do 
> the right thing.

Doh, I think you spotted the bug. I was going off on the wrong track.

 
> I dunno. That whole piece-of-sh*t function has been incredibly buggy this 
> release. The code is an unreadable mess, and I think that "cyclic" stuff 
> is part of the reason for it being messy and buggy. Please convince me 
> it's worth saving, or let me revert the whole stinking pile of crud?

Well... the cyclic stuff apparently gets used by some filesystems to do
data integrity stuff, so I think the problem addressed by my broken
commit maybe shouldn't be ignored.

Maybe you're being harsh on this function. It has been two thinko bugs
so far. Before this release cycle it seemed to have the record for the
most data integrity bugs in a single function...

How's this? Jan, can you test with the bdb workload please?

--

A bug was introduced into write_cache_pages cyclic writeout by commit
31a12666d8f0c22235297e1c1575f82061480029. The intention (and comments)
is that we should cycle back and look for more dirty pages at the
beginning of the file if there is no more work to be done.

But the !done condition was dropped from the test. This means that any
time the page writeout loop breaks (eg. due to nr_to_write == 0), we
will set index to 0, then goto again. This will set done_index to index,
then find done is set, so will proceed to the end of the function. When
updating mapping->writeback_index for cyclic writeout, we now use
done_index == 0, so we're always cycling back to 0.

This seemed to be causing random mmap writes (slapadd and iozone) to
start writing more pages from the LRU and writeout would slowdown.

With this patch, iozone random write performance is increased nearly
5x on my system (iozone -B -r 4k -s 64k -s 512m -s 1200m on ext2). 

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c	2009-02-12 13:30:42.000000000 +1100
+++ linux-2.6/mm/page-writeback.c	2009-02-12 14:16:28.000000000 +1100
@@ -1079,7 +1079,7 @@ continue_unlock:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!cycled) {
+	if (!cycled && !done) {
 		/*
 		 * range_cyclic:
 		 * We hit the last page and there is more work to be done: wrap
