Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZIIJ3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZIIJ3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZIIJ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:29:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:17487 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZIIJ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185627288"
Date: Wed, 9 Sep 2009 17:29:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090909092901.GA24185@localhost>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908162936.GA2975@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 12:29:36PM -0400, Chris Mason wrote:
> On Tue, Sep 08, 2009 at 06:06:23PM +0200, Peter Zijlstra wrote:
> > On Tue, 2009-09-08 at 13:37 +0300, Artem Bityutskiy wrote:
> > > Hi,
> > > 
> > > On 09/08/2009 12:23 PM, Jens Axboe wrote:
> > > > From: Theodore Ts'o<tytso@mit.edu>
> > > >
> > > > Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
> > > > concern of not holding I_SYNC for too long.  (At least, that was the
> > > > comment previously.)  This doesn't make sense now because the only
> > > > time we wait for I_SYNC is if we are calling sync or fsync, and in
> > > > that case we need to write out all of the data anyway.  Previously
> > > > there may have been other code paths that waited on I_SYNC, but not
> > > > any more.
> > > >
> > > > According to Christoph, the current writeback size is way too small,
> > > > and XFS had a hack that bumped out nr_to_write to four times the value
> > > > sent by the VM to be able to saturate medium-sized RAID arrays.  This
> > > > value was also problematic for ext4 as well, as it caused large files
> > > > to be come interleaved on disk by in 8 megabyte chunks (we bumped up
> > > > the nr_to_write by a factor of two).
> > > >
> > > > So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable,
> > > > max_writeback_mb, and set it to a default value of 128 megabytes.
> > > >
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=13930
> > > >
> > > > Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> > > > Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
> > > 
> > > Would be nice to update doc files like
> > > 
> > > Documentation/sysctl/vm.txt
> > > Documentation/filesystems/proc.txt
> > 
> > I'm still not convinced this knob is worth the patch and I'm inclined to
> > flat out NAK it..
> > 
> > The whole point of MAX_WRITEBACK_PAGES seems to occasionally check the
> > dirty stats again and not write out too much.
> 
> The problem is that 'too much' is a very abstract thing.  When a process
> is stuck in balance_dirty_pages, we want them to do the minimal amount
> of work (or waiting) required to get them safely back inside file_write().

It seems that balance_dirty_pages() is not coupled with MAX_WRITEBACK_PAGES. 
Instead it uses the much smaller (ratelimit_pages + ratelimit_pages / 2).

So I feel that we could just increase MAX_WRITEBACK_PAGES.  It won't
lead to bumpy throttled writes. It does affect fairness of background
writes, ie. small files will have to wait more time for large files.
But I'm fine with MAX_WRITEBACK_PAGES=64MB, which means for desktop
that a large file may only delay others for 1 second, which is small
enough comparing to the 30 second dirty expire time.

On the other hand, I find that the (ratelimit_pages + ratelimit_pages / 2)
used for balance_dirty_pages() may fall below the real number of
dirtied pages, which is not safe if some filesystem choose to dirty
2 * ratelimit_pages before calling balance_dirty_pages_ratelimited_nr().

So, how about this patch?

Thanks,
Fengguang
---

writeback: balance_dirty_pages() shall write more than dirtied pages

Some filesystem may choose to write much more than ratelimit_pages
before calling balance_dirty_pages_ratelimited_nr(). So it is safer to
determine number to write based on real number of dirtied pages.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-09-09 16:53:15.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-09 17:05:14.000000000 +0800
@@ -44,12 +44,12 @@ static long ratelimit_pages = 32;
 /*
  * When balance_dirty_pages decides that the caller needs to perform some
  * non-background writeback, this is how many pages it will attempt to write.
- * It should be somewhat larger than RATELIMIT_PAGES to ensure that reasonably
+ * It should be somewhat larger than dirtied pages to ensure that reasonably
  * large amounts of I/O are submitted.
  */
-static inline long sync_writeback_pages(void)
+static inline long sync_writeback_pages(unsigned long dirtied)
 {
-	return ratelimit_pages + ratelimit_pages / 2;
+	return dirtied + dirtied / 2;
 }
 
 /* The following parameters are exported via /proc/sys/vm */
@@ -481,7 +481,8 @@ get_dirty_limits(unsigned long *pbackgro
  * If we're over `background_thresh' then pdflush is woken to perform some
  * writeout.
  */
-static void balance_dirty_pages(struct address_space *mapping)
+static void balance_dirty_pages(struct address_space *mapping,
+				unsigned long write_chunk)
 {
 	long nr_reclaimable, bdi_nr_reclaimable;
 	long nr_writeback, bdi_nr_writeback;
@@ -489,7 +490,6 @@ static void balance_dirty_pages(struct a
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
-	unsigned long write_chunk = sync_writeback_pages();
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
@@ -634,9 +634,10 @@ void balance_dirty_pages_ratelimited_nr(
 	p =  &__get_cpu_var(ratelimits);
 	*p += nr_pages_dirtied;
 	if (unlikely(*p >= ratelimit)) {
+		ratelimit = sync_writeback_pages(*p);
 		*p = 0;
 		preempt_enable();
-		balance_dirty_pages(mapping);
+		balance_dirty_pages(mapping, ratelimit);
 		return;
 	}
 	preempt_enable();
