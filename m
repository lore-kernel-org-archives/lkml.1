Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbZISE0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbZISE0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 00:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZISE0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 00:26:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:43049 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbZISE0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 00:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,413,1249282800"; 
   d="scan'208";a="189375114"
Date: Sat, 19 Sep 2009 12:26:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090919042607.GA19752@localhost>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com> <20090911134241.GB19707@mit.edu> <20090911141659.GA3508@infradead.org> <20090911142926.GI14984@kernel.dk> <20090911143929.GA25499@localhost> <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919040051.GA10245@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 12:00:51PM +0800, Wu Fengguang wrote:
> On Sat, Sep 19, 2009 at 11:58:35AM +0800, Wu Fengguang wrote:
> > On Sat, Sep 19, 2009 at 01:52:52AM +0800, Theodore Tso wrote:
> > > On Fri, Sep 11, 2009 at 10:39:29PM +0800, Wu Fengguang wrote:
> > > > 
> > > > That would be good. Sorry for the late work. I'll allocate some time
> > > > in mid next week to help review and benchmark recent writeback works,
> > > > and hope to get things done in this merge window.
> > > 
> > > Did you have some chance to get more work done on the your writeback
> > > patches?
> > 
> > Sorry for the delay, I'm now testing the patches with commands
> > 
> >  cp /dev/zero /mnt/test/zero0 &
> >  dd if=/dev/zero of=/mnt/test/zero1 &
> > 
> > and the attached debug patch.
> > 
> > One problem I found with ext3/4 is, redirty_tail() is called repeatedly
> > in the traces, which could slow down the inode writeback significantly.
> 
> FYI, it's this redirty_tail() called in writeback_single_inode():
> 
>                         /*
>                          * Someone redirtied the inode while were writing back
>                          * the pages.
>                          */
>                         redirty_tail(inode);

Hmm, this looks like an old fashioned problem get blew up by the
128MB MAX_WRITEBACK_PAGES.

The inode was redirtied by the busy cp/dd processes. Now it takes much
more time to sync 128MB, so that a heavy dirtier can easily redirty
the inode in that time window.

One single invocation of redirty_tail() could hold up the writeback of
current inode for up to 30 seconds.

Thanks,
Fengguang

> > Ideal is to call requeue_[partial_]io() instead of redirty_tail().
> > 
> > [  131.963885] fs/fs-writeback.c +809 wb_writeback(): comm=flush-8:0 pid=2816 n=0
> > [  131.966171] global dirty=4105 writeback=18793 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
> > [  132.780826] fs/fs-writeback.c +809 wb_writeback(): comm=flush-0:15 pid=1150 n=0
> > [  132.783097] global dirty=4105 writeback=16623 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
> > [  134.307094] redirty_tail() +542: inode=12
> > [  134.815776] redirty_tail() +542: inode=13
> > [  134.817709] fs/fs-writeback.c +809 wb_writeback(): comm=flush-8:0 pid=2816 n=11493
> > [  134.821242] global dirty=4192 writeback=16203 nfs=0 flags=__ towrite=21275 skipped=0 file=13 written=4430
> > [  135.599954] redirty_tail() +542: inode=12
> > [  136.372523] redirty_tail() +542: inode=13
> > [  136.386748] fs/fs-writeback.c +809 wb_writeback(): comm=flush-8:0 pid=2816 n=11570
> > [  136.432168] global dirty=4308 writeback=15752 nfs=0 flags=__ towrite=21198 skipped=0 file=13 written=4650
> > [  137.789115] fs/fs-writeback.c +809 wb_writeback(): comm=flush-0:15 pid=1150 n=0
> > [  138.587178] global dirty=9551 writeback=10755 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
> > [  138.962743] redirty_tail() +542: inode=12
> > [  139.395024] redirty_tail() +542: inode=13
> > [  139.403194] fs/fs-writeback.c +809 wb_writeback(): comm=flush-8:0 pid=2816 n=11893
> > [  139.413026] global dirty=4101 writeback=16630 nfs=0 flags=__ towrite=20875 skipped=0 file=0 written=2
> > [  139.426074] fs/fs-writeback.c +809 wb_writeback(): comm=flush-8:0 pid=2816 n=0
> > [  139.435190] global dirty=4101 writeback=16378 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
> > [  140.266713] redirty_tail() +542: inode=12
> > [  140.449304] redirty_tail() +542: inode=13
> > [  140.496241] fs/fs-writeback.c +809 wb_writeback(): comm=flush-8:0 pid=2816 n=11678
> > [  140.508339] global dirty=4203 writeback=19220 nfs=0 flags=__ towrite=21090 skipped=0 file=13 written=4254
> > [  141.649192] redirty_tail() +542: inode=12
> > [  141.971276] redirty_tail() +542: inode=13
> > [  141.988572] fs/fs-writeback.c +809 wb_writeback(): comm=flush-8:0 pid=2816 n=11304
> > [  142.000107] global dirty=4112 writeback=18362 nfs=0 flags=__ towrite=21464 skipped=0 file=13 written=4541
> > 
> > btrfs pattern is almost the same, but with an extra (metadata) inode 1.
> > 
> > [  464.443873] fs/fs-writeback.c +809 wb_writeback(): comm=flush-btrfs-1 pid=2865 n=0
> > [  464.450458] global dirty=163 writeback=4375 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
> > [  464.655999] fs/fs-writeback.c +809 wb_writeback(): comm=flush-8:0 pid=2816 n=0
> > [  464.664478] global dirty=3873 writeback=1175 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
> > [  465.291059] redirty_tail() +542: inode=257
> > [  465.331584] redirty_tail() +542: inode=258
> > [  465.346433] redirty_tail() +560: inode=1
> > [  465.352016] fs/fs-writeback.c +809 wb_writeback(): comm=flush-btrfs-1 pid=2865 n=14480
> > [  465.355797] global dirty=337 writeback=3980 nfs=0 flags=__ towrite=18288 skipped=0 file=1 written=0
> > [  466.226489] redirty_tail() +542: inode=257
> > [  466.280894] redirty_tail() +542: inode=258
> > [  466.282270] redirty_tail() +560: inode=1
> > [  466.288079] fs/fs-writeback.c +809 wb_writeback(): comm=flush-btrfs-1 pid=2865 n=14300
> > [  466.291738] global dirty=666 writeback=3807 nfs=0 flags=__ towrite=18468 skipped=0 file=1 written=0
> > [  467.101730] redirty_tail() +542: inode=257
> > [  467.134303] redirty_tail() +542: inode=258
> > [  467.135675] redirty_tail() +560: inode=1
> > [  467.144120] fs/fs-writeback.c +809 wb_writeback(): comm=flush-btrfs-1 pid=2865 n=14032
> > [  467.147302] global dirty=331 writeback=3665 nfs=0 flags=__ towrite=18736 skipped=0 file=1 written=0
> > [  467.964652] redirty_tail() +542: inode=257
> > [  468.002423] redirty_tail() +542: inode=258
> > [  468.003795] redirty_tail() +560: inode=1
> > 
> > I'm looking into it.
> > 
> > Thanks,
> > Fengguang
> 
> >  fs/fs-writeback.c   |   30 +++++++++++++++++++++++++++++-
> >  mm/page-writeback.c |    1 +
> >  2 files changed, 30 insertions(+), 1 deletion(-)
> > 
> > --- linux.orig/mm/page-writeback.c	2009-09-19 10:51:09.000000000 +0800
> > +++ linux/mm/page-writeback.c	2009-09-19 10:51:47.000000000 +0800
> > @@ -536,6 +536,7 @@ static void balance_dirty_pages(struct a
> >  			pages_written += write_chunk - wbc.nr_to_write;
> >  			get_dirty_limits(&background_thresh, &dirty_thresh,
> >  				       &bdi_thresh, bdi);
> > +			writeback_debug_report(pages_written, &wbc);
> >  		}
> >  
> >  		/*
> > --- linux.orig/fs/fs-writeback.c	2009-09-19 10:51:46.000000000 +0800
> > +++ linux/fs/fs-writeback.c	2009-09-19 10:51:47.000000000 +0800
> > @@ -68,6 +68,33 @@ enum {
> >  #define WS_USED (1 << WS_USED_B)
> >  #define WS_ONSTACK (1 << WS_ONSTACK_B)
> >  
> > +void print_writeback_control(struct writeback_control *wbc)
> > +{
> > +	printk(KERN_DEBUG
> > +			"global dirty=%lu writeback=%lu nfs=%lu "
> > +			"flags=%c%c towrite=%ld skipped=%ld "
> > +			"file=%lu written=%lu\n",
> > +			global_page_state(NR_FILE_DIRTY),
> > +			global_page_state(NR_WRITEBACK),
> > +			global_page_state(NR_UNSTABLE_NFS),
> > +			wbc->encountered_congestion ? 'C':'_',
> > +			wbc->more_io ? 'M':'_',
> > +			wbc->nr_to_write,
> > +			wbc->pages_skipped,
> > +			wbc->last_file,
> > +			wbc->last_file_written);
> > +}
> > +
> > +void __writeback_debug_report(long n, struct writeback_control *wbc,
> > +		const char *file, int line, const char *func)
> > +{
> > +	printk(KERN_DEBUG "%s +%d %s(): comm=%s pid=%d n=%ld\n",
> > +			file, line, func,
> > +			current->comm, current->pid,
> > +			n);
> > +	print_writeback_control(wbc);
> > +}
> > +
> >  static inline bool bdi_work_on_stack(struct bdi_work *work)
> >  {
> >  	return test_bit(WS_ONSTACK_B, &work->state);
> > @@ -302,7 +329,7 @@ static void requeue_io(struct inode *ino
> >   */
> >  static void requeue_partial_io(struct writeback_control *wbc, struct inode *inode)
> >  {
> > -	if (time_before(wbc->last_file_time + HZ, jiffies) ||
> > +	if (time_before(wbc->last_file_time + 1000 * HZ, jiffies) ||
> >  	    wbc->last_file_written == 0 ||
> >  	    wbc->last_file_written >= MAX_WRITEBACK_PAGES) {
> >  		requeue_io(inode);
> > @@ -749,6 +776,7 @@ static long wb_writeback(struct bdi_writ
> >  		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> >  		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> >  
> > +		writeback_debug_report(wrote, &wbc);
> >  		/*
> >  		 * If we ran out of stuff to write, bail unless more_io got set
> >  		 */
> 
> > Subject: track redirty_tail() calls
> > 
> > It helps a lot to know how redirty_tail() are called.
> > 
> > Cc: Ken Chen <kenchen@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> > ---
> >  fs/fs-writeback.c |   36 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 33 insertions(+), 3 deletions(-)
> > 
> > --- linux.orig/fs/fs-writeback.c	2009-09-19 10:51:47.000000000 +0800
> > +++ linux/fs/fs-writeback.c	2009-09-19 10:52:03.000000000 +0800
> > @@ -290,6 +290,21 @@ void bdi_start_writeback(struct backing_
> >  	bdi_alloc_queue_work(bdi, &args);
> >  }
> >  
> > +#define redirty_tail(inode)						\
> > +	do {								\
> > +		__redirty_tail(inode, __LINE__);			\
> > +	} while (0)
> > +
> > +#define requeue_io(inode)						\
> > +	do {								\
> > +		__requeue_io(inode, __LINE__);				\
> > +	} while (0)
> > +
> > +#define requeue_partial_io(wbc, inode)					\
> > +	do {								\
> > +		__requeue_partial_io(wbc, inode, __LINE__);		\
> > +	} while (0)
> > +
> >  /*
> >   * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
> >   * furthest end of its superblock's dirty-inode list.
> > @@ -299,7 +314,7 @@ void bdi_start_writeback(struct backing_
> >   * the case then the inode must have been redirtied while it was being written
> >   * out and we don't reset its dirtied_when.
> >   */
> > -static void redirty_tail(struct inode *inode)
> > +static void __redirty_tail(struct inode *inode, int line)
> >  {
> >  	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
> >  
> > @@ -311,23 +326,33 @@ static void redirty_tail(struct inode *i
> >  			inode->dirtied_when = jiffies;
> >  	}
> >  	list_move(&inode->i_list, &wb->b_dirty);
> > +
> > +	if (sysctl_dirty_debug) {
> > +		printk(KERN_DEBUG "redirty_tail() +%d: inode=%lu\n",
> > +				line, inode->i_ino);
> > +	}
> >  }
> >  
> >  /*
> >   * requeue inode for re-scanning after bdi->b_io list is exhausted.
> >   */
> > -static void requeue_io(struct inode *inode)
> > +static void __requeue_io(struct inode *inode, int line)
> >  {
> >  	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
> >  
> >  	list_move(&inode->i_list, &wb->b_more_io);
> > +
> > +	if (sysctl_dirty_debug) {
> > +		printk(KERN_DEBUG "requeue_io() +%d: inode=%lu\n",
> > +				line, inode->i_ino);
> > +	}
> >  }
> >  
> >  /*
> >   * continue io on this inode on next writeback if
> >   * it has not accumulated large enough writeback io chunk
> >   */
> > -static void requeue_partial_io(struct writeback_control *wbc, struct inode *inode)
> > +static void __requeue_partial_io(struct writeback_control *wbc, struct inode *inode, int line)
> >  {
> >  	if (time_before(wbc->last_file_time + 1000 * HZ, jiffies) ||
> >  	    wbc->last_file_written == 0 ||
> > @@ -337,6 +362,11 @@ static void requeue_partial_io(struct wr
> >  	}
> >  
> >  	list_move_tail(&inode->i_list, &inode_to_bdi(inode)->wb.b_io);
> > +
> > +	if (sysctl_dirty_debug) {
> > +		printk(KERN_DEBUG "requeue_partial_io() +%d: inode=%lu\n",
> > +				line, inode->i_ino);
> > +	}
> >  }
> >  
> >  static void inode_sync_complete(struct inode *inode)
> 
