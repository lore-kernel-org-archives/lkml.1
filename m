Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZIVJOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZIVJOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbZIVJOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:14:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:51665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbZIVJOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:14:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,431,1249282800"; 
   d="scan'208";a="190234501"
Date: Tue, 22 Sep 2009 17:14:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090922091413.GA24868@localhost>
References: <1253121768-20673-1-git-send-email-jack@suse.cz> <20090920023528.GA13114@localhost> <20090920174356.GA16919@duck.suse.cz> <20090921010859.GA6331@localhost> <20090921134511.GG1099@duck.suse.cz> <20090921141109.GA6479@localhost> <20090921141910.GE6259@think> <20090921143107.GA6567@localhost> <20090921144551.GA10825@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921144551.GA10825@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:45:51PM +0800, Chris Mason wrote:
> On Mon, Sep 21, 2009 at 10:31:07PM +0800, Wu Fengguang wrote:
> > On Mon, Sep 21, 2009 at 10:19:10PM +0800, Chris Mason wrote:
> > > On Mon, Sep 21, 2009 at 10:11:09PM +0800, Wu Fengguang wrote:
> > > > On Mon, Sep 21, 2009 at 09:45:11PM +0800, Jan Kara wrote:
> > > > > On Mon 21-09-09 09:08:59, Wu Fengguang wrote:
> > > > > > On Mon, Sep 21, 2009 at 01:43:56AM +0800, Jan Kara wrote:
> > > > > > >   So when we see inode under writeback, we put it to b_more_io. So I think
> > > > > > > my patch really fixes the issue when two threads are racing on writing the
> > > > > > > same inode.
> > > > > > 
> > > > > > Ah OK. So it busy loops when there are more syncing threads than dirty
> > > > > > files. For example, one bdi flush thread plus one process running
> > > > > > balance_dirty_pages().
> > > > >   Yes.
> > > > > 
> > > > > > > > The busy loop does exists, when bdi is congested.
> > > > > > > > In this case, write_cache_pages() will refuse to write anything,
> > > > > > > > we used to be calling congestion_wait() to take a breath, but now
> > > > > > > > wb_writeback() purged that call and thus created a busy loop.
> > > > > > >   I don't think congestion is an issue here. The device needen't be
> > > > > > > congested for the busyloop to happen.
> > > > > > 
> > > > > > bdi congestion is a different case. When there are only one syncing
> > > > > > thread, b_more_io inodes won't have I_SYNC, so your patch is a no-op.
> > > > > > wb_writeback() or any of its sub-routines must wait/yield for a while
> > > > > > to avoid busy looping on the congestion. Where is the wait with Jens'
> > > > > > new code?
> > > > >   I agree someone must wait when we bail out due to congestion. But we bail
> > > > > out only when wbc->nonblocking is set.
> > > > 
> > > > Here is another problem. wbc->nonblocking used to be set for kupdate
> > > > and background writebacks, but now it's gone. So they will be blocked
> > > > in get_request_wait(). That's fine, no busy loops.
> > > > 
> > > > However this inverts the priority. pageout() still have nonblocking=1.
> > > > So now vmscan can easily be live locked by heavy background writebacks.
> > > 
> > > The important part of the nonblocking check for pageout is really to
> > > make sure that it doesn't get stuck locking a buffer that is actually
> > > under IO, which happens in ext3/reiserfs data=ordered mode.
> > 
> > OK.
> > 
> > > Having pageout wait for a request is fine.  Its just as likely to wait
> > > for a request when it does actually start the IO, regardless of the
> > > congestion checks earlier in the call chain.
> > 
> > There are fundamental differences. The congestion wait is live lock for
> > pageout, while wait_on_page_writeback() will finish in bounded time.

Ah sorry for making silly mistakes! According Jan Kara, live lock is
not possible because pageout calls ->writepage() directly without
congestion wait.

> > > I'd drop any congestion checks in the nooks and crannies of the
> > > writeback paths.
> > 
> > Let's work on a better solution then?
> 
> Today, wbc->nonblocking and congestion are checked together:
> 
> 1) in writeback_inodes_wb before we call writeback_single_inode
> 2) in write_cache_pages, before we call writepage
> 3) in write_cache_pages, after we call writepage
> 
> If we delete all 3, we get rid of the livelock but keep the check that
> makes sure we don't wait on locked buffers that are under IO.
> 
> If we delete #1 and #2, we'll get rid of the livelock but pageout will
> still stop trying to do IO on this backing dev once it finds some
> congestion.
> 
> I think either way is fine ;)

To remove all these blocks? Looks like good cleanups because now no
one is passing nonblocking to these functions.

Thanks,
Fengguang

---
 fs/fs-writeback.c   |    9 +--------
 mm/page-writeback.c |   11 -----------
 2 files changed, 1 insertion(+), 19 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-22 16:29:58.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-22 17:09:25.000000000 +0800
@@ -566,14 +567,6 @@ rescan:
 			continue;
 		}
 
-		if (wbc->nonblocking && bdi_write_congested(wb->bdi)) {
-			wbc->encountered_congestion = 1;
-			if (!is_blkdev_sb)
-				break;		/* Skip a congested fs */
-			requeue_io(inode);
-			continue;		/* Skip a congested blockdev */
-		}
-
 		if (inode_dirtied_after(inode, wbc->older_than_this)) {
 			if (list_empty(&wb->b_more_io))
 				break;
--- linux.orig/mm/page-writeback.c	2009-09-22 17:09:28.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-22 17:09:47.000000000 +0800
@@ -827,11 +827,6 @@ int write_cache_pages(struct address_spa
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		writeback_index = mapping->writeback_index; /* prev offset */
@@ -950,12 +945,6 @@ continue_unlock:
 					break;
 				}
 			}
-
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-				break;
-			}
 		}
 		pagevec_release(&pvec);
 		cond_resched();
