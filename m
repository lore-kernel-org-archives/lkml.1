Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0CCMDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:03:20 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab0CCMDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:03:19 -0500
Date: Wed, 3 Mar 2010 13:03:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: John Hughes <john@Calva.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++
	on different filesystems seems to deadlock in sync
Message-ID: <20100303120317.GP5768@kernel.dk>
References: <bug-15426-10286@http.bugzilla.kernel.org/> <20100302161627.bf02d0a2.akpm@linux-foundation.org> <4B8E517E.3010702@Calva.COM> <20100303115015.GN5768@kernel.dk> <4B8E5805.30505@Calva.COM>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <4B8E5805.30505@Calva.COM>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 03 2010, John Hughes wrote:
> Jens Axboe wrote:
>> Is IO still going on, or does it appear to be stuck? From the traces
>> below, we have various procs caught in waiting for a request. So if
>> things are totally stuck, it could be some race in there.
>>   
> I see I/O happening on three or four of the disks.
>
> Just a thought.  What exactly is sync(2) supposed to do - block until  
> there are no more dirty pages, or block until all pages that were dirty  
> when the sync was done are clean?  In other words is the problem simply  
> that pages are being dirtied faster than the sync is writing them out?

Our sync is currently broken in that regard, since it'll wait for too
long. We have a debated patch going, I have included it below. Any
chance you could give it a whirl?

The semantics of sync are supposed to be 'wait for dirty IO generated
BEFORE this sync call'.

-- 
Jens Axboe


--WplhKdTI2c8ulnbP
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-fix-broken-sync-2.6.32.patch"

commit 057226ca7447880e4e766a82cf32197e492ba963
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Feb 12 10:14:34 2010 +0100

    writeback: Fix broken sync writeback
    
    There's currently a writeback bug in the 2.6.32 and 2.6.33-rc kernels
    that prevent proper writeback when sync(1) is being run. Instead of
    flushing everything older than the sync run, it will do chunks of normal
    MAX_WRITEBACK_PAGES writeback and restart over and over. This results in
    very suboptimal writeback for many files, see the initial report from
    Jan Engelhardt:
    
    http://lkml.org/lkml/2010/1/22/382
    
    This fixes it by using the passed in page writeback count, instead of
    doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
    (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
    finish properly even when new pages are being dirted.
    
    Thanks to Jan Kara <jack@suse.cz> for spotting this problem!
    
    Cc: stable@kernel.org
    Reported-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9d5360c..8a46c67 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -773,6 +773,8 @@ static long wb_writeback(struct bdi_writeback *wb,
 	}
 
 	for (;;) {
+		long to_write = 0;
+
 		/*
 		 * Stop writeback when nr_pages has been consumed
 		 */
@@ -786,13 +788,18 @@ static long wb_writeback(struct bdi_writeback *wb,
 		if (args->for_background && !over_bground_thresh())
 			break;
 
+		if (args->sync_mode == WB_SYNC_ALL)
+			to_write = args->nr_pages;
+		if (!to_write)
+			to_write = MAX_WRITEBACK_PAGES;
+
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.nr_to_write = to_write;
 		wbc.pages_skipped = 0;
 		writeback_inodes_wb(wb, &wbc);
-		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		args->nr_pages -= to_write - wbc.nr_to_write;
+		wrote += to_write - wbc.nr_to_write;
 
 		/*
 		 * If we consumed everything, see if we have more
@@ -807,7 +814,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		/*
 		 * Did we write something? Try for more
 		 */
-		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
+		if (wbc.nr_to_write < to_write)
 			continue;
 		/*
 		 * Nothing written. Wait for some inode to

--WplhKdTI2c8ulnbP--
