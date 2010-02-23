Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab0BWFx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 00:53:56 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:33149 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979Ab0BWFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 00:53:54 -0500
Date: Tue, 23 Feb 2010 16:53:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: tytso@mit.edu, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100223055335.GE22370@discord.disaster>
References: <20100216230017.GJ3153@quack.suse.cz> <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain> <20100217013336.GK3153@quack.suse.cz> <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain> <20100217043009.GZ5337@thunk.org> <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain> <20100222172938.GA2601@quack.suse.cz> <20100222210112.GE23832@thunk.org> <20100223025350.GC22370@discord.disaster> <20100223032317.GG23832@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223032317.GG23832@thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 10:23:17PM -0500, tytso@mit.edu wrote:
> On Tue, Feb 23, 2010 at 01:53:50PM +1100, Dave Chinner wrote:
> > 
> > Ignoring nr_to_write completely can lead to issues like we used to
> > have with XFS - it would write an entire extent (8GB) at a time and
> > starve all other writeback. Those starvation problems - which were
> > very obvious on NFS servers - went away when we trimmed back the
> > amount to write in a single pass to saner amounts...
> 
> How do you determine what a "sane amount" is?  Is it something that is
> determined dynamically, or is it a hard-coded or manually tuned value?

"sane amount" was a hard coded mapping look-ahead value that limited
the size of the allocation that was done. It got set to 64 pages,
back in 2.6.16 (IIRC) so that we'd do at least a 256k allocation
on x86 or 1MB on ia64 (which had 16k page size at the time).
It was previously unbound, which is why XFS was mapping entire
extents...

Hence ->writepage() on XFS will write 64 pages at a time if there
are contiguous pages in the page cache, and then go back up to
write_cache_pages() for the loop to either terminate due to
nr_to_write <= 0 or call ->writepage on the next dirty page not
under writeback on the inode.

This behaviour pretty much defines the _minimum IO size_ we'd issue
if there are contiguous dirty pages in the page cache. It was (and
still is) primarily to work around the deficiencies of the random
single page writeback that the VM's memory reclaim algorithms are so
fond of (another of my pet peeves)....

> > As to a generic solution, why do you think I've been advocating
> > separate per-sb data sync and inode writeback methods that separate
> > data writeback from inode writeback for so long? ;)
> 
> Heh.
> 
> > > This is done to avoid a lock inversion, and so this is an
> > > ext4-specific thing (at least I don't think XFS's delayed allocation
> > > has this misfeature).
> > 
> > Not that I know of, but then again I don't know what inversion ext4
> > is trying to avoid. Can you describe the inversion, Ted?
> 
> The locking order is journal_start_handle (starting a micro
> transaction in jbd) -> lock_page.  A more detailed description of why
> this locking order is non-trivial for us to fix in ext4 can be found
> in the description of commit f0e6c985.

Nasty - you need to start a transaction before you lock pages for
writeback and allocation, but ->writepage hands you a locked page.
And you can't use an existing transaction handle open because you
can't guarantee that you have journal credits reserved for the
allocation?  IIUC, ext3/4 has this problem due to the ordered data
writeback constraints, right?

Regardless of the reason for the ext4 behaviour, you are right about
XFS - it doesn't have this particular problem with delalloc because
it does have any transaction/page lock ordering constraints in the
transaction subsystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
