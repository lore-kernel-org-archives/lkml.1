Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZIJHgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZIJHgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZIJHgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:36:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:56717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZIJHgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:36:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="186054420"
Date: Thu, 10 Sep 2009 15:35:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/7] writeback: use 64MB MAX_WRITEBACK_PAGES
Message-ID: <20090910073553.GA21899@localhost>
References: <20090909145141.293229693@intel.com> <20090909150600.874037375@intel.com> <20090909232938.GD24951@mit.edu> <1252558398.7205.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252558398.7205.0.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 12:53:18PM +0800, Peter Zijlstra wrote:
> On Wed, 2009-09-09 at 19:29 -0400, Theodore Tso wrote:
> > On Wed, Sep 09, 2009 at 10:51:46PM +0800, Wu Fengguang wrote:
> > > + * The maximum number of pages to writeout in a single periodic/background
> > > + * writeback operation. 64MB means I_SYNC may be hold for up to 1 second.
> > > + * This is not a big problem since we normally do kind of trylock on I_SYNC
> > > + * for non-data-integrity writes.  Userspace tasks doing throttled writeback
> > > + * do not use this value.
> > 
> > What's your justification for using 64MB?  Where are you getting 1
> > second from?  On a fast RAID array 64MB can be written in much less
> > than 1 second.
> 
> Worse, on my 5mb/s usb stick writing out 64m will take forever.

        cp bigfile1 bigfile2 /mnt/usb/
        sync

In that case the user would notice that kernel keeps writing to one
file for up to 13 seconds before switching to another file.

A simple fix would look like this. It stops io continuation on one
file after 1 second. It will work because when io is congested, it
relies on the io continuation logic (based on last_file*) to retry
the same file until MAX_WRITEBACK_PAGES is reached. The queue-able
requests between congested <=> uncongested states are not very large.
For slow devices, the queue-able pages between empty <=> congested
states are also not very large. For example, my USB stick has
nr_requests=128 and max_sectors_kb=120. It would take less than 12MB
to congest this queue.

With this patch and my usb stick, the kernel may first sync 12MB for
bigfile1 (which takes 1-3 seconds), then sync bigfile2 for 1 second,
and then bigfile1 for 1 second, and so on.

It seems that we could now safely bump MAX_WRITEBACK_PAGES to even
larger values beyond 128MB :)

Thanks,
Fengguang
---

--- linux.orig/fs/fs-writeback.c	2009-09-10 15:02:48.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-10 15:07:23.000000000 +0800
@@ -277,7 +277,8 @@ static void requeue_io(struct inode *ino
  */
 static void requeue_partial_io(struct writeback_control *wbc, struct inode *inode)
 {
-	if (wbc->last_file_written == 0 ||
+	if (time_before(wbc->last_file_time + HZ, jiffies) ||
+	    wbc->last_file_written == 0 ||
 	    wbc->last_file_written >= MAX_WRITEBACK_PAGES)
 		return requeue_io(inode);
 
@@ -428,6 +429,7 @@ writeback_single_inode(struct inode *ino
 
 	if (wbc->last_file != inode->i_ino) {
 		wbc->last_file = inode->i_ino;
+		wbc->last_file_time = jiffies;
 		wbc->last_file_written = nr_to_write - wbc->nr_to_write;
 	} else
 		wbc->last_file_written += nr_to_write - wbc->nr_to_write;
--- linux.orig/include/linux/writeback.h	2009-09-10 15:07:28.000000000 +0800
+++ linux/include/linux/writeback.h	2009-09-10 15:08:46.000000000 +0800
@@ -46,6 +46,7 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	unsigned long last_file;	/* Inode number of last written file */
+	unsigned long last_file_time;	/* First sync time for last file */
 	long last_file_written;		/* Total pages written for last file */
 	long pages_skipped;		/* Pages which were not written */
 
