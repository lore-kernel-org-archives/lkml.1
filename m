Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0BVVBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:01:25 -0500
Received: from thunk.org ([69.25.196.29]:45606 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab0BVVBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:01:23 -0500
Date: Mon, 22 Feb 2010 16:01:12 -0500
From: tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100222210112.GE23832@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
	stable@kernel.org, gregkh@suse.de
References: <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <20100215141750.GC3434@quack.suse.cz>
 <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain>
 <20100216230017.GJ3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
 <20100217013336.GK3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain>
 <20100217043009.GZ5337@thunk.org>
 <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain>
 <20100222172938.GA2601@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222172938.GA2601@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 06:29:38PM +0100, Jan Kara wrote:
> 
> a) ext4_da_writepages returns after writing 32 MB even in WB_SYNC_ALL mode
> (when 1024 is passed in nr_to_write). Writeback code kind of expects that
> in WB_SYNC_ALL mode all dirty pages in the given range are written (the
> same way as write_cache_pages does that).

Well, we return after writing 128MB because of the magic
s_max_writeback_mb_bump.  The fact that nr_to_write limits the number
of pages which are written is something which is intentional to the
writeback code.  I've disagreed with it, but I don't think it would be
legit to completely ignore nr_to_write in WB_SYNC_ALL mode --- is that
what you are saying we should do?  (If it is indeed legit to ignore
nr_to_write, I would have done it a long time ago; I introduced
s_max_writeback_mb_bump instead as a workaround to what I consider to
be a serious misfeature in the writeback code.)

> b) because of delayed allocation, inode is redirtied during ->writepages
> call and thus writeback_single_inode calls redirty_tail at it. Thus each
> inode will be written at least twice (synchronously, which means a
> transaction commit and a disk cache flush for each such write).

Hmm, does this happen with XFS, too?  If not, I wonder how they handle
it?  And whether we need to push a solution into the generic layers.

> d) ext4_writepage never succeeds to write a page with delayed-allocated
> data. So pageout() function never succeeds in cleaning a page on ext4.
> I think that when other problems in writeback code make writeout slow (like
> in Jan Engelhardt's case), this can bite us and I assume this might be the
> reason why Jan saw kswapd active doing some work during his problems.

Yeah, I've noticed this.  What it means is that if we have a massive
memory pressure in a particular zone, pages which are subject to
delayed allocation won't get written out by mm/vmscan.c.  Anonymous
pages will be written out to swap, and data pages which are re-written
via random access mmap() (and so we know where they will be written on
disk) will get written, and that's not a problem.  So with relatively
large zones, it happens, but most of the time I don't think it's a
major problem.

I am worried about this issue in certain configurations where pseudo
NUMA zones have been created and are artificially really tiny (128MB)
for container support, but that's not standard upstream thing.

This is done to avoid a lock inversion, and so this is an
ext4-specific thing (at least I don't think XFS's delayed allocation
has this misfeature).  It would be interesting if we have documented
evidence that this is easily triggered under normal situations.  If
so, we should look into figuring out how to fix this...

       	      	   		     	 - Ted
