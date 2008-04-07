Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYDGIW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYDGIW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYDGIWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:22:47 -0400
Received: from lazybastard.de ([212.112.238.170]:49431 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYDGIWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:22:45 -0400
Date: Mon, 7 Apr 2008 10:22:36 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Nick Piggin <npiggin@suse.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [patch 0/15] LogFS take five
Message-ID: <20080407082235.GB22431@logfs.org>
References: <20080401181308.512473173@logfs.org> <20080404114600.GD29686@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080404114600.GD29686@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 April 2008 13:46:00 +0200, Jens Axboe wrote:
> On Tue, Apr 01 2008, joern@logfs.org wrote:
> > And it is currently reasonably simple to run into a deadlock when
> > using logfs on a block device.  The problem appears to be the block
> > layer allocating memory for its cache without GFP_NOFS, so that under
> > memory pressure logfs writes through block layer may recurse back to
> > logfs writes.
> 
> So you mean for writes through the page cache, you are seeing pages
> allocated with __GFP_FS set?

It sure looks like it.  On top, the patch at the bottom seems to solve
the deadlock.  I'm just not certain it is the right fix for the problem.

> > Not entirely sure who is to blame for this bug and how to
> > solve it.
> 
> A good starting point would be doing a stack trace dump in logfs if you
> see such back recursion into the fs. A quick guess would be a missing
> setting of mapping gfp mask?

Sorry, should have sent that right along.

 [<ffffffff802ca83f>] elv_insert+0x156/0x219
 [<ffffffff8037d96d>] __mutex_lock_slowpath+0x57/0x81
 [<ffffffff8037d804>] mutex_lock+0xd/0xf
 [<ffffffff802c07e7>] logfs_get_wblocks+0x33/0x54
 [<ffffffff802c025c>] logfs_write_buf+0x3d/0x322
 [<ffffffff802bbae0>] __logfs_writepage+0x24/0x67
 [<ffffffff802bbbfb>] logfs_writepage+0xd8/0xe3
 [<ffffffff8024ba78>] shrink_page_list+0x2ee/0x514
 [<ffffffff8024b466>] isolate_lru_pages+0x6c/0x1ff
 [<ffffffff8024c2a9>] shrink_zone+0x60b/0x85b
 [<ffffffff802cc0e5>] generic_make_request+0x329/0x364
 [<ffffffff80245ea1>] mempool_alloc_slab+0x11/0x13
 [<ffffffff802367b3>] up_read+0x9/0xb
 [<ffffffff8024c638>] shrink_slab+0x13f/0x151
 [<ffffffff8024cc1c>] try_to_free_pages+0x111/0x209
 [<ffffffff8024859a>] __alloc_pages+0x1b1/0x2f5
 [<ffffffff80243f6b>] read_cache_page_async+0x7e/0x15c
 [<ffffffff8027fba9>] blkdev_readpage+0x0/0x15
 [<ffffffff80245612>] read_cache_page+0xe/0x46
 [<ffffffff802c2842>] bdev_read+0x61/0xee
 [<ffffffff802bc741>] __logfs_gc_pass+0x219/0x7dc
 [<ffffffff802bcd1b>] logfs_gc_pass+0x17/0x19
 [<ffffffff802c0798>] logfs_flush_dirty+0x7d/0x99
 [<ffffffff802c0800>] logfs_get_wblocks+0x4c/0x54
 [<ffffffff802c025c>] logfs_write_buf+0x3d/0x322
 [<ffffffff802bbe1e>] logfs_commit_write+0x77/0x7d
 [<ffffffff80244ec2>] generic_file_buffered_write+0x49d/0x62c
 [<ffffffff802704da>] file_update_time+0x7f/0xad
 [<ffffffff802453a5>] __generic_file_aio_write_nolock+0x354/0x3be
 [<ffffffff80237077>] atomic_notifier_call_chain+0xf/0x11
 [<ffffffff80245abb>] filemap_fault+0x1b4/0x320
 [<ffffffff80245473>] generic_file_aio_write+0x64/0xc0
 [<ffffffff8025ebc8>] do_sync_write+0xe2/0x126
 [<ffffffff80224b4f>] release_console_sem+0x1a0/0x1a9
 [<ffffffff802344f4>] autoremove_wake_function+0x0/0x38
 [<ffffffff802ef6f3>] tty_write+0x1f2/0x20d
 [<ffffffff802f1914>] write_chan+0x0/0x334
 [<ffffffff8025f351>] vfs_write+0xae/0x137
 [<ffffffff8025f824>] sys_write+0x47/0x6f
 [<ffffffff802191c2>] ia32_sysret+0x0/0xa

Jörn

-- 
Joern's library part 10:
http://blogs.msdn.com/David_Gristwood/archive/2004/06/24/164849.aspx

Signed-off-by: Joern Engel <joern@logfs.org>

 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24logfs/fs/block_dev.c~blockdev_nofs	2008-04-07 10:19:08.627413077 +0200
+++ linux-2.6.24logfs/fs/block_dev.c	2008-04-07 10:20:56.927117162 +0200
@@ -586,7 +586,7 @@ struct block_device *bdget(dev_t dev)
 		inode->i_rdev = dev;
 		inode->i_bdev = bdev;
 		inode->i_data.a_ops = &def_blk_aops;
-		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
+		mapping_set_gfp_mask(&inode->i_data, GFP_USER & ~__GFP_FS);
 		inode->i_data.backing_dev_info = &default_backing_dev_info;
 		spin_lock(&bdev_lock);
 		list_add(&bdev->bd_list, &all_bdevs);
