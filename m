Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZISPEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZISPEC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:04:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZISPEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:04:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:4895 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbZISPEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:04:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,416,1249282800"; 
   d="scan'208";a="189461553"
Date: Sat, 19 Sep 2009 23:03:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090919150351.GA19880@localhost>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com> <20090911134241.GB19707@mit.edu> <20090911141659.GA3508@infradead.org> <20090911142926.GI14984@kernel.dk> <20090911143929.GA25499@localhost> <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919042607.GA19752@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 12:26:07PM +0800, Wu Fengguang wrote:
> On Sat, Sep 19, 2009 at 12:00:51PM +0800, Wu Fengguang wrote:
> > On Sat, Sep 19, 2009 at 11:58:35AM +0800, Wu Fengguang wrote:
> > > On Sat, Sep 19, 2009 at 01:52:52AM +0800, Theodore Tso wrote:
> > > > On Fri, Sep 11, 2009 at 10:39:29PM +0800, Wu Fengguang wrote:
> > > > > 
> > > > > That would be good. Sorry for the late work. I'll allocate some time
> > > > > in mid next week to help review and benchmark recent writeback works,
> > > > > and hope to get things done in this merge window.
> > > > 
> > > > Did you have some chance to get more work done on the your writeback
> > > > patches?
> > > 
> > > Sorry for the delay, I'm now testing the patches with commands
> > > 
> > >  cp /dev/zero /mnt/test/zero0 &
> > >  dd if=/dev/zero of=/mnt/test/zero1 &
> > > 
> > > and the attached debug patch.
> > > 
> > > One problem I found with ext3/4 is, redirty_tail() is called repeatedly
> > > in the traces, which could slow down the inode writeback significantly.
> > 
> > FYI, it's this redirty_tail() called in writeback_single_inode():
> > 
> >                         /*
> >                          * Someone redirtied the inode while were writing back
> >                          * the pages.
> >                          */
> >                         redirty_tail(inode);
> 
> Hmm, this looks like an old fashioned problem get blew up by the
> 128MB MAX_WRITEBACK_PAGES.
> 
> The inode was redirtied by the busy cp/dd processes. Now it takes much
> more time to sync 128MB, so that a heavy dirtier can easily redirty
> the inode in that time window.
> 
> One single invocation of redirty_tail() could hold up the writeback of
> current inode for up to 30 seconds.

It seems that this patch helps. However I'm afraid it's too late to
risk merging such kind of patches now..

Thanks,
Fengguang
---

writeback: don't delay redirtied inode by a fast dirtier

The large 128MB MAX_WRITEBACK_PAGES greatly increases the chance
for an inode to be dirtied by a fast dirtier during the writeback.

We used to call redirty_tail() in this case, which could delay inode
writeback for up to 30s. This becomes unacceptable now even for simple
dd.

But still delay these cases:
- only inode metadata is dirtied (by the fs)
- the writeback_index wrapped around
  (to protect against fast dirtier that do repeated overwrites)

CC: Jan Kara <jack@suse.cz>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-19 18:09:50.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-19 19:00:18.000000000 +0800
@@ -466,6 +466,7 @@ writeback_single_inode(struct inode *ino
 	long last_file_written;
 	long nr_to_write;
 	unsigned dirty;
+	pgoff_t writeback_index;
 	int ret;
 
 	if (!atomic_read(&inode->i_count))
@@ -508,6 +509,7 @@ writeback_single_inode(struct inode *ino
 		last_file_written = wbc->last_file_written;
 	wbc->nr_to_write -= last_file_written;
 	nr_to_write = wbc->nr_to_write;
+	writeback_index = mapping->writeback_index;
 
 	ret = do_writepages(mapping, wbc);
 
@@ -534,10 +536,15 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
-		if (inode->i_state & I_DIRTY) {
+		if (inode->i_state & I_DIRTY_PAGES) {
 			/*
-			 * Someone redirtied the inode while were writing back
-			 * the pages.
+			 * More pages get dirtied by a fast dirtier.
+			 */
+			goto select_queue;
+		} else if (inode->i_state & I_DIRTY) {
+			/*
+			 * At least XFS will redirty the inode during the
+			 * writeback (delalloc) and on io completion (isize).
 			 */
 			redirty_tail(inode);
 		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -546,8 +553,10 @@ writeback_single_inode(struct inode *ino
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
+select_queue:
 			if (wbc->encountered_congestion ||
-			    wbc->nr_to_write <= 0) {
+			    wbc->nr_to_write <= 0 ||
+			    writeback_index < mapping->writeback_index) {
 				/*
 				 * if slice used up, queue for next round;
 				 * otherwise continue this inode after return
@@ -556,6 +565,7 @@ writeback_single_inode(struct inode *ino
 			} else {
 				/*
 				 * somehow blocked: retry later
+				 * also protect against busy rewrites.
 				 */
 				redirty_tail(inode);
 			}
