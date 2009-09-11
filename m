Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZIKHI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZIKHI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZIKHI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:08:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:37138 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZIKHI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:08:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,369,1249282800"; 
   d="scan'208";a="186494404"
Date: Fri, 11 Sep 2009 15:08:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Enrik Berkhan <Enrik.Berkhan@ge.com>
Cc: Clemens Eisserer <linuxhippy@gmail.com>, linux-kernel@vger.kernel.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
Subject: [RFC] md: don't scale up readahead size if RAID chunk size >= 4MB
Message-ID: <20090911070847.GI6267@localhost>
References: <194f62550909050551n3ac70080u528ae8a9322d4a5a@mail.gmail.com> <194f62550909090405t531dac0die78761fd000802e5@mail.gmail.com> <4AA9170B.70306@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA9170B.70306@ge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 05:11:07PM +0200, Enrik Berkhan wrote:
> Clemens Eisserer wrote:
>> Does nobody have an idea what could be the cause of this OOM situation?
>
> I guess it's too large readahead. I had this situation recently, too,  
> with a raid0 of 8 disks (4MB chunks) that set the file readahead count  
> to 32MB or so (on a 60MB NOMMU system).

The default readahead size would be 2 * 8 * 4MB = 64MB for such an
software RAID. However max_sane_readahead() will limit runtime
readahead size to available_cache / 2, which is ~30MB for your system.

> When I tried to read a 100MB file via sendfile(), the kernel insisted on  
> doing the 32MB readahead ... (in __do_page_cache_readahead, like in your  
> trace).

You could configure readahead size with the blockdev command.

But I admit that the default 64MB ra size is insanely large.
I tended to change this long ago. Though I'm not sure if that
is exactly someone with big arrays wanted. Anyway here is the
patch. Maybe some storage gurus can drop us some hint of use
cases.

Thanks,
Fengguang
---
md: don't scale up readahead size for large RAID chunk size

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/md/raid0.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux.orig/drivers/md/raid0.c	2009-09-11 14:36:02.000000000 +0800
+++ linux/drivers/md/raid0.c	2009-09-11 14:51:13.000000000 +0800
@@ -341,12 +341,16 @@ static int raid0_run(mddev_t *mddev)
 	 * chunk size, then we will not drive that device as hard as it
 	 * wants.  We consider this a configuration error: a larger
 	 * chunksize should be used in that case.
+	 * Also don't touch readahead size if the chunk size is large enough
+	 * (4MB), so that individual devices can already receive good enough
+	 * IO sizes, and otherwise (2 * stripe) would grow too large.
 	 */
 	{
 		int stripe = mddev->raid_disks *
 			(mddev->chunk_sectors << 9) / PAGE_SIZE;
-		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
-			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
+		if (mddev->chunk_sectors < (4 * 1024 * 1024 / 512) &&
+			mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
+			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 	}
 
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
