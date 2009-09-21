Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZIUOqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZIUOqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZIUOqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:46:08 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:39627 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZIUOqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:46:06 -0400
Date: Mon, 21 Sep 2009 10:45:51 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090921144551.GA10825@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
References: <1253121768-20673-1-git-send-email-jack@suse.cz>
 <20090920023528.GA13114@localhost>
 <20090920174356.GA16919@duck.suse.cz>
 <20090921010859.GA6331@localhost>
 <20090921134511.GG1099@duck.suse.cz>
 <20090921141109.GA6479@localhost>
 <20090921141910.GE6259@think>
 <20090921143107.GA6567@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921143107.GA6567@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt013.oracle.com [141.146.116.22]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AB791A1.027E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:31:07PM +0800, Wu Fengguang wrote:
> On Mon, Sep 21, 2009 at 10:19:10PM +0800, Chris Mason wrote:
> > On Mon, Sep 21, 2009 at 10:11:09PM +0800, Wu Fengguang wrote:
> > > On Mon, Sep 21, 2009 at 09:45:11PM +0800, Jan Kara wrote:
> > > > On Mon 21-09-09 09:08:59, Wu Fengguang wrote:
> > > > > On Mon, Sep 21, 2009 at 01:43:56AM +0800, Jan Kara wrote:
> > > > > >   So when we see inode under writeback, we put it to b_more_io. So I think
> > > > > > my patch really fixes the issue when two threads are racing on writing the
> > > > > > same inode.
> > > > > 
> > > > > Ah OK. So it busy loops when there are more syncing threads than dirty
> > > > > files. For example, one bdi flush thread plus one process running
> > > > > balance_dirty_pages().
> > > >   Yes.
> > > > 
> > > > > > > The busy loop does exists, when bdi is congested.
> > > > > > > In this case, write_cache_pages() will refuse to write anything,
> > > > > > > we used to be calling congestion_wait() to take a breath, but now
> > > > > > > wb_writeback() purged that call and thus created a busy loop.
> > > > > >   I don't think congestion is an issue here. The device needen't be
> > > > > > congested for the busyloop to happen.
> > > > > 
> > > > > bdi congestion is a different case. When there are only one syncing
> > > > > thread, b_more_io inodes won't have I_SYNC, so your patch is a no-op.
> > > > > wb_writeback() or any of its sub-routines must wait/yield for a while
> > > > > to avoid busy looping on the congestion. Where is the wait with Jens'
> > > > > new code?
> > > >   I agree someone must wait when we bail out due to congestion. But we bail
> > > > out only when wbc->nonblocking is set.
> > > 
> > > Here is another problem. wbc->nonblocking used to be set for kupdate
> > > and background writebacks, but now it's gone. So they will be blocked
> > > in get_request_wait(). That's fine, no busy loops.
> > > 
> > > However this inverts the priority. pageout() still have nonblocking=1.
> > > So now vmscan can easily be live locked by heavy background writebacks.
> > 
> > The important part of the nonblocking check for pageout is really to
> > make sure that it doesn't get stuck locking a buffer that is actually
> > under IO, which happens in ext3/reiserfs data=ordered mode.
> 
> OK.
> 
> > Having pageout wait for a request is fine.  Its just as likely to wait
> > for a request when it does actually start the IO, regardless of the
> > congestion checks earlier in the call chain.
> 
> There are fundamental differences. The congestion wait is live lock for
> pageout, while wait_on_page_writeback() will finish in bounded time.
> 
> > I'd drop any congestion checks in the nooks and crannies of the
> > writeback paths.
> 
> Let's work on a better solution then?

Today, wbc->nonblocking and congestion are checked together:

1) in writeback_inodes_wb before we call writeback_single_inode
2) in write_cache_pages, before we call writepage
3) in write_cache_pages, after we call writepage

If we delete all 3, we get rid of the livelock but keep the check that
makes sure we don't wait on locked buffers that are under IO.

If we delete #1 and #2, we'll get rid of the livelock but pageout will
still stop trying to do IO on this backing dev once it finds some
congestion.

I think either way is fine ;)

-chris

