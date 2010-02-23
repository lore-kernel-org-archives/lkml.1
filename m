Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0BWCyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:54:12 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:42028 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115Ab0BWCyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:54:11 -0500
Date: Tue, 23 Feb 2010 13:53:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: tytso@mit.edu, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100223025350.GC22370@discord.disaster>
References: <20100215141750.GC3434@quack.suse.cz> <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain> <20100216230017.GJ3153@quack.suse.cz> <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain> <20100217013336.GK3153@quack.suse.cz> <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain> <20100217043009.GZ5337@thunk.org> <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain> <20100222172938.GA2601@quack.suse.cz> <20100222210112.GE23832@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100222210112.GE23832@thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 04:01:12PM -0500, tytso@mit.edu wrote:
> On Mon, Feb 22, 2010 at 06:29:38PM +0100, Jan Kara wrote:
> > 
> > a) ext4_da_writepages returns after writing 32 MB even in WB_SYNC_ALL mode
> > (when 1024 is passed in nr_to_write). Writeback code kind of expects that
> > in WB_SYNC_ALL mode all dirty pages in the given range are written (the
> > same way as write_cache_pages does that).
> 
> Well, we return after writing 128MB because of the magic
> s_max_writeback_mb_bump.  The fact that nr_to_write limits the number
> of pages which are written is something which is intentional to the
> writeback code.  I've disagreed with it, but I don't think it would be
> legit to completely ignore nr_to_write in WB_SYNC_ALL mode --- is that
> what you are saying we should do?  (If it is indeed legit to ignore
> nr_to_write, I would have done it a long time ago; I introduced
> s_max_writeback_mb_bump instead as a workaround to what I consider to
> be a serious misfeature in the writeback code.)

Ignoring nr_to_write completely can lead to issues like we used to
have with XFS - it would write an entire extent (8GB) at a time and
starve all other writeback. Those starvation problems - which were
very obvious on NFS servers - went away when we trimmed back the
amount to write in a single pass to saner amounts...

> > b) because of delayed allocation, inode is redirtied during ->writepages
> > call and thus writeback_single_inode calls redirty_tail at it. Thus each
> > inode will be written at least twice (synchronously, which means a
> > transaction commit and a disk cache flush for each such write).
> 
> Hmm, does this happen with XFS, too?  If not, I wonder how they handle
> it?  And whether we need to push a solution into the generic layers.

Yes, it does - XFS dirties the inode during delayed allocation.  In
the worst case XFS writes back the inode twice, synchronously.
However, XFS inodes carry their own dirty state and so the second
flush is often a no-op because the inode is actually clean and not
pinned in the log any more. The inode is only dirty the second time
around if the file size was updated as a result of IO completion.

FWIW, we've only just changed the XFS code to issue transactions for
sync inode writes instead of writing the inode directly because of
changeѕ to the async inode writeback that avoid writing the inode
over and over again while it still has dirty data on it (coming in
2.6.34). These changes mean we need to issue a transaction to
capture any unlogged changes to the inode during sync writes, but we
still avoid the second transaction if the XFS inode is cleaned by
the first transaction.

As to a generic solution, why do you think I've been advocating
separate per-sb data sync and inode writeback methods that separate
data writeback from inode writeback for so long? ;)


> > d) ext4_writepage never succeeds to write a page with delayed-allocated
> > data. So pageout() function never succeeds in cleaning a page on ext4.
> > I think that when other problems in writeback code make writeout slow (like
> > in Jan Engelhardt's case), this can bite us and I assume this might be the
> > reason why Jan saw kswapd active doing some work during his problems.

[...]

> This is done to avoid a lock inversion, and so this is an
> ext4-specific thing (at least I don't think XFS's delayed allocation
> has this misfeature).

Not that I know of, but then again I don't know what inversion ext4
is trying to avoid. Can you describe the inversion, Ted?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
