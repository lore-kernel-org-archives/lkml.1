Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab0BPXAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:00:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933312Ab0BPXAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:00:11 -0500
Date: Wed, 17 Feb 2010 00:00:18 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100216230017.GJ3153@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <20100215141750.GC3434@quack.suse.cz>
 <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-02-10 16:05:43, Linus Torvalds wrote:
> 
> 
> On Mon, 15 Feb 2010, Jan Kara wrote:
> > 
> > Personally, I don't see why VM shouldn't generate IO from a single inode
> > larger than a few MB for data integrity syncs. There are two reasons I know
> > about for MAX_WRITEBACK_PAGES:
> 
> Two issues:
>  - it shouldn't matter for performance (if you have a broken disk that 
>    wants multi-megabyte writes to get good performance, you need to fix 
>    the driver, not the VM)
  The IO size actually does matter for performance because if you switch
after 4 MB (current value of MAX_WRITEBACK_PAGES) to writing another inode,
that means a seek to a distant place and that has significant impact (seek
time are in a 10-20 ms range for a common drives so with 50 MB/s throughput
this is like 13-25% of the IO time...). A similar reason why it matters is
if the filesystem does delayed allocation - then allocation is performed
from writeback code and if it happens in 4 MB chunks, chances for
fragmentation are higher. Actually XFS, btrfs, and ext4 *workaround* the
fact that VM sends only 4 MB chunks and write more regardless of
nr_to_write set - I agree this really sucks but that's the way it is.

>  - I generally think that _latency_ is much more important than 
>    throughput, and huge writes are simply bad for latency.
  I agree that latency matters but is VM the right place to decide where to
break writes into smaller chunks for latency reasons? It knows neither
about the placement of the file nor about possible concurrent requests for
that device. So I personally believe that IO scheduler should be the layer
that should care about scheduling IO so that we have decent latecies. As
splitting bios is probably not an option, we might want to have an
artificial upper limit on bio size for latency reasons but it's still it's
way below VM...

> But the real complaint I had about your patch was that it made no sense. 
>
> Your statement that it speeds up sync is indicative of some _other_ 
> independent problem (perhaps starting from the beginning of the file each 
> time? Who knows?) and the patch _clearly_doesn't actually address the 
> underlying problem, it just changes the logic in a way that makes no 
> obvious sense to anybody, without actually explaining why it would matter.
> 
> So if you can explain _why_ that patch makes such a big difference for 
> you, and actually write that up, I wouldn't mind it. But right now it was 
> sent as a voodoo patch with no sensible explanation for why it would 
> really make any difference, since the outer loop should already do what 
> the patch does.
  OK, fair enough :). The patch is actually Jens' but looking at the code
again the nr_to_write trimming should rather happen inside of
writeback_inodes_wb, not outside of it. That would make the logic clearer
and magically also fix the problem because write_cache_pages() ignores
nr_to_write in WB_SYNC_ALL mode. But I guess it's better to not depend
on this and explicitely handle that in writeback_inodes_wb...
So I'll post a new patch with a better changelog shortly.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
