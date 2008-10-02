Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYJBMFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYJBMFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 08:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYJBMFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 08:05:02 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52739 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753211AbYJBMFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 08:05:00 -0400
Date: Thu, 2 Oct 2008 08:04:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002120444.GA25164@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <20081002062736.GR19428@kernel.dk> <20081001235501.2b7f50fe.akpm@linux-foundation.org> <20081002074523.GW19428@kernel.dk> <20081002010315.1cda8147.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002010315.1cda8147.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 01:03:15AM -0700, Andrew Morton wrote:
> 
> An async atime update gets recorded into the current transaction. 
> kjournald is working on the committing transaction.  We try to keep
> those separated, to prevent user processes from getting blocked behind
> kjournald activity.
> 

This is true unless the journal gets too full, and we need to do a
checkpoint operation --- at which point, everything stops.  If this
was metadata-intensive a benchmark, and the journal wasn't large
enough, this could be the problem.  (And if you make the journal
bigger, then when you *do* finally get forced to do a checkpoint
operation, things get stalled for even longer.)

Arjan, is this *really* about atime updates?  I thought most poeple
these days run with noatime or relatime.  If people *really* want true
atime semantics, the best way to solve this problem would be to have
two dirty flags in the inode --- an "atime dirty" and a "dirty" flag.
The atime dirty bit would not actually cause the inode to get written
to disk, unless either (a) we are unmounting the filesystem, or (b) we
are trying to shrink the inode cache due to memory pressure.  If when
we write the inode out to disk, only the atime dirty bit is set, we
can also skip journalling the inode table block.  So if there are
people who really care about true atime semantics, without getting
killed by the I/O writes, there are some solutions we can pursue.

But if this is really about the "entangled fsync problem", where we
have a large number of processes writing a large amount of async data,
and then we have a single process writing a small amount of data and
then calling fsync(), then that's a different (and very long-standing)
problem in ext3/4.  Raising the I/O priority is probably the only
thing we can do in this circumstance.  We could try to do some kind of
complex priority inheritance scheme, but it would certainly be much
simpler to raise the I/O priority.  We could choose a level just below
realtime priority, but the reality is that if a real-time priority is
trying to write to the filesystem, and we are doing a checkpointing
opration, we're going to be blocking the real-time process anyway, and
it will be a priority inversion.  So perhaps the simplest and best
algorithm would be to use a priority level just below real-time when
doing a normal commit, but if we start to do a checkpoint, we go to
IOPRIO_CLASS_RT.

> But sometimes that doesn't work (including the place where I knowingly
> broke it).  If we can find and fix the offending piece of jbd logic (a
> big if) then all is peachy.

Do we have workloads that can easily demonstrate this problem?  If so,
we can add some tracing code which will allow us to see which theory
is correct, and what is actually happening.

						- Ted
