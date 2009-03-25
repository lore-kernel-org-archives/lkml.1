Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZCYVvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZCYVvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZCYVvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:51:10 -0400
Received: from THUNK.ORG ([69.25.196.29]:38893 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZCYVvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:51:08 -0400
Date: Wed, 25 Mar 2009 17:50:16 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325215016.GP32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325194851.GA1617@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 03:48:51PM -0400, Christoph Hellwig wrote:
> On Wed, Mar 25, 2009 at 02:58:24PM -0400, Theodore Tso wrote:
> > omits the fsync().  So with ext4 we has workarounds that start pushing
> > out the data blocks in the for replace-via-rename and
> > replace-via-truncate cases, while XFS will do an implied fsync for
> > replace-via-truncate only, and btrfs will do an implied fsync for
> > replace-via-rename only.
> 
> The XFS one and the ext4 one that I saw only start an _asynchronous_
> writeout.  Which is not an implied fsync but snake oil to make the
> most common complaints go away without providing hard guarantees.

It actually does the right thing for ext4, because once we allocate
the blocks, the default data=ordered mode means that we flush the
datablocks before we execute the commit.  Hence, in the case of
open/write/close/rename, the rename will trigger an async writeout,
but before the commit block is actually written, we'll have flushed
out the data blocks.

I was under the impression that XFS was doing a synchronous fsync
before allowing the close() return, but all it is triggering an async
writeout, then yes, your concern is correct.  The bigger problem from
my perspective is that XFS is only doing this for the truncate case,
and (from what I've been told) not for the rename case.  The truncate
is fundamentally racy and application writers that don't do this
definitely don't deserve our solicitude, IMHO.  But people who do
open/write/close/rename, and omit the fsync before the rename, are at
least somewhat more deserving for some kind of workaround than the
idiots that do open/truncate/write/close.

> IFF we want to go down this route we should better provide strong
> guranteed semantics and document the propery.  And of course implement
> it consistently on all native filesystems.

That's something we should talk about at LSF.  I'm not all that eager
(or happy) about doing this, but I think that, given that the
application writers massively outnumber us, we are going to be bullied
into it.

> Note that the rename for atomic commits trick originated in mail severs
> which always did the proper fsync.  When the word spread into the
> desktop world it looks like this wisdom got lost.

Yep, agreed.

To be fair, though, one problem which Matthew Garrett has pointed out
is that if lots of applications issue fsync(), it will have the
tendency to wake up the hard drive a lot, and do a real number on
power utilization.  I believe the right solution for this is an
extension to laptop mode which synchronizes the filesystem at a clean
point, and then which suppresses fsync()'s until the hard drive wakes
up, at which point it should flush all dirty data to the drive, and
then freezes writes to the disk again.  Presumably that should be OK,
because who are using laptop mode are inherently trading off a certain
amount of safety for power savings; but then other people who want to
run a mysql server on a laptop get cranky, and then if we start
implementing ways that applications can exempt themselves from the
fsync() suppression, the complexity level starts rising.

This is a pretty complicated problem....  if people want to mount the
filesystem with the sync mount option, sure, but when people want
safety, speed, efficiency, power savings, *and* they want to use
crappy proprietary device drivers that crash if you look at them
funny, *and* be solicitous to application writers that rewrite
hundreds of files on desktop startup (even though it's not clear *why*
it is useful for KDE or GNOME to rewrite hundreds of files when the
user logs in and initializes the desktop), something has got to give.

There's nothing to trade off, other than the sanity of the file system
maintainers.  (But that's OK, Linus has called us crazy already.  :-/)

	      	   	      	    	       - Ted
