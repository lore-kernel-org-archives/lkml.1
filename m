Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab0BVRb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:31:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0BVRbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:31:55 -0500
Date: Mon, 22 Feb 2010 18:29:38 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100222172938.GA2601@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <20100215141750.GC3434@quack.suse.cz>
 <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain>
 <20100216230017.GJ3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
 <20100217013336.GK3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain>
 <20100217043009.GZ5337@thunk.org>
 <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-02-10 21:16:46, Linus Torvalds wrote:
> On Tue, 16 Feb 2010, tytso@mit.edu wrote:
> >
> > We've had this logic for a long time, and given the increase in disk
> > density, and spindle speeds, the 4MB limit, which might have made
> > sense 10 years ago, probably doesn't make sense now.
> 
> I still don't think that 4MB is enough on its own to suck quite that 
> much. Even a fast device should be perfectly happy with 4MB IOs, or it 
> must be sucking really badly. 
> 
> In order to see the kinds of problems that got quoted in the original 
> thread, there must be something else going on too, methinks (disk light 
> was "blinking").
  <snip>
> Are we perhaps ending up in a situation where we essentially wait 
> synchronously on just the inode itself being written out? That would 
> explain the "40kB/s" kind of behavior.
> 
> If we were actually doing real 4MB chunks, that would _not_ explain 40kB/s 
> throughput.
  Yes, it is actually 400kB/s but still you're right that that seems too
low if the only problem were seeks. I was looking at the code and it's even
bigger mess than what I thought :(.

a) ext4_da_writepages returns after writing 32 MB even in WB_SYNC_ALL mode
(when 1024 is passed in nr_to_write). Writeback code kind of expects that
in WB_SYNC_ALL mode all dirty pages in the given range are written (the
same way as write_cache_pages does that).

b) because of delayed allocation, inode is redirtied during ->writepages
call and thus writeback_single_inode calls redirty_tail at it. Thus each
inode will be written at least twice (synchronously, which means a
transaction commit and a disk cache flush for each such write).

c) the livelock avoidace in writeback_inodes_wb does not work because the
function exists as soon as nr_to_write (set to 1024) gets to 0 and thus
the 'start' timestamp gets always renewed.

d) ext4_writepage never succeeds to write a page with delayed-allocated
data. So pageout() function never succeeds in cleaning a page on ext4.
I think that when other problems in writeback code make writeout slow (like
in Jan Engelhardt's case), this can bite us and I assume this might be the
reason why Jan saw kswapd active doing some work during his problems.

> But if we do a 4MB chunk (for the one file that had real dirty data in 
> it), and then do a few hundred trivial "write out the inode data 
> _synchronously_" (due to access time changes etc) in between until we hit 
> the file that has real dirty data again - now _that_ would explain 40kB/s 
> throughput. It's not just seeking around - it's not even trying to push 
> multiple IO's to get any elevator going or anything like that.
> 
> And then the patch that started this discussion makes sense: it improves 
> performance because in between those synchronous inode updates it now 
> writes big chunks. But again, it's mostly hiding us just doing insane 
> things.
  I'm not quite sure whether some of the above problems is really causing the
sync writeback to be so slow. At least problems a) and c) would be
worked-around by the patch setting nr_to_write to LONG_MAX for sync
writeback and the effect of b) would be mitigated to just two synchronous
inode writes instead of (dirty_pages + 8191) / 8192 + 1 sync writes.
  For c) I think the original patch is actually the right solution but I
agree that it just hides the other problems...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
