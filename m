Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0BAKRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:17:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34309 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0BAKRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:17:03 -0500
Date: Mon, 1 Feb 2010 11:17:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100201101702.GH29555@one.firstfloor.org>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131210207.GA27883@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131210207.GA27883@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 04:02:07PM -0500, tytso@mit.edu wrote:
> OK, but in that case, the kick_inodes should check to see if the inode
> is in use in any way (i.e., has dentries open that will tie it down,
> is open, has pages that are dirty or are mapped into some page table)
> before attempting to invalidating any of its pages.  The patch as
> currently constituted doesn't do that.  It will attempt to drop all
> pages owned by that inode before checking for any of these conditions.
> If I wanted that, I'd just do "echo 3 > /proc/sys/vm/drop_caches".  

Yes the patch is more aggressive and probably needs to be fixed.

On the other hand I would like to keep the option to be more aggressive
for soft page offlining where it's useful and nobody cares about 
the cost.

> Worse yet, *after* it does this, it tries to write out the pages the
> inode.  #1, this is pointless, since if the inode had any dirty pages,
> they wouldn't have been invalidated, since it calls write_inode_now()

Yes .... fought with all that for hwpoison too.

> I'd go further, and say that it should avoid trying to flush any inode
> if any of its sibling inodes on the slab cache are dirty or in use in
> any way.  Otherwise, you end up dropping pages from the page cache and
> still not be able to do any defragmentation.

It depends -- for normal operation when running low on memory I agree
with you. 
But for hwpoison soft offline purposes it's better to be more aggressive
-- even if that is inefficient -- but number one priority is to still
be correct of course. 
> 
> If the concern is that the inode cache is filled with crap after an
> updatedb run, then we should fix *that* problem; we need a way for
> programs like updatedb to indicate that they are scanning lots of
> inodes, and if the inode wasn't in cache before it was opened, it
> this patch series will do this --- consistently.

This has been tried many times and nobody came up with a good approach
to detect it automatically that doesn't have bad regressions in corner 
cases.

Or the "let's add a updatedb" hint approach has the problem that
it won't cover a lot of other programs (as Linus always points out
these new interfaces rarely actually get used)

Also as Linus always points out -- thi

> But most of the time, I *want* the page cache filled, since it means
> less time wasted accessing spinning rust platters.  The last thing I
> want is a some helpful defragmentation kernel thread constantly
> wandering through inode caches, and randomly calling

The problem right now this patch series tries to access is that
when you run out of memory it tends to blow away your dcaches caches
because the dcache reclaim is just too stupid to actually free
memory without going through most of the LRU list.

So yes it's all about improving caching.  But yes also 
some details need to be improved

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
