Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263Ab0AaVC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0AaVC4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640Ab0AaVCz
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:02:55 -0500
Received: from thunk.org ([69.25.196.29]:57657 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab0AaVCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:02:54 -0500
Date: Sun, 31 Jan 2010 16:02:07 -0500
From: tytso@mit.edu
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100131210207.GA27883@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@ftp.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>,
	Rik van Riel <riel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
References: <20100129204931.789743493@quilx.com>
 <20100129205004.405949705@quilx.com>
 <20100130192623.GE788@thunk.org>
 <20100131083409.GF29555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131083409.GF29555@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 09:34:09AM +0100, Andi Kleen wrote:
> 
> The standard case is the classic updatedb. Lots of dentries/inodes cached
> with no or little corresponding data cache.
> 
> > a huge number of pages that are actively getting used, the thrashing
> > that is going to result is going to enormous.
> 
> I think the consensus so far is to try to avoid any inodes/dentries
> which are dirty or used in any way.

OK, but in that case, the kick_inodes should check to see if the inode
is in use in any way (i.e., has dentries open that will tie it down,
is open, has pages that are dirty or are mapped into some page table)
before attempting to invalidating any of its pages.  The patch as
currently constituted doesn't do that.  It will attempt to drop all
pages owned by that inode before checking for any of these conditions.
If I wanted that, I'd just do "echo 3 > /proc/sys/vm/drop_caches".  

Worse yet, *after* it does this, it tries to write out the pages the
inode.  #1, this is pointless, since if the inode had any dirty pages,
they wouldn't have been invalidated, since it calls write_inode_now()
*after* calling invalidate_mapping_pages(), so the previously dirty
pages will still be mapped, and prevent the the inode from being
flushed.  #2, it interferes with delayed allocation and becomes
another writeback path, which means some dirty pages might get flushed
too early and it does this writeout without any of the congestion
handling code in the bdi writeback paths.

If the consensus is "avoid any inodes/dentries which are dirty or
used in any way", THIS PATCH DOESN'T DO THAT.

I'd go further, and say that it should avoid trying to flush any inode
if any of its sibling inodes on the slab cache are dirty or in use in
any way.  Otherwise, you end up dropping pages from the page cache and
still not be able to do any defragmentation.

> I personally would prefer it to be more aggressive for memory offlining
> though for RAS purposes though, but just handling the unused cases is a 
> good first step.

If you want something more aggressive, why not just "echo 3 >
/proc/sys/vm/drop_caches"?  We have that already.  If the answer is,
because it will trash the performance of the system, I'm concerned
this patch series will do this --- consistently.

If the concern is that the inode cache is filled with crap after an
updatedb run, then we should fix *that* problem; we need a way for
programs like updatedb to indicate that they are scanning lots of
inodes, and if the inode wasn't in cache before it was opened, it
should be placed on the short list to be dropped after it's closed.
Making that a new open(2) flag makes a lot of sense.  Let's solve the
real problem here, if that's the concern.

But most of the time, I *want* the page cache filled, since it means
less time wasted accessing spinning rust platters.  The last thing I
want is a some helpful defragmentation kernel thread constantly
wandering through inode caches, and randomly calling
"invalidate_mapping_pages" on inodes since it thinks this will help
defrag huge pages.  If I'm not running an Oracle database on my
laptop, but instead am concerned about battery lifetime, this is the
last thing I would want.

					- Ted
