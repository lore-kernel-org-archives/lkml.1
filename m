Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZHGMU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZHGMU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbZHGMUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:20:25 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:59132 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647AbZHGMUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:20:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH] mm: stop balance_dirty_pages doing too much work
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <1245839904.3210.85.camel@localhost.localdomain>
References: <1245839904.3210.85.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 14:20:01 +0200
Message-Id: <1249647601.32113.700.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 11:38 +0100, Richard Kennedy wrote:
>   
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ---
> balance_dirty_pages can overreact and move all of the dirty pages to
> writeback unnecessarily.
> 
> balance_dirty_pages makes its decision to throttle based on the number
> of dirty plus writeback pages that are over the calculated limit,so it
> will continue to move pages even when there are plenty of pages in
> writeback and less than the threshold still dirty.
> 
> This allows it to overshoot its limits and move all the dirty pages to
> writeback while waiting for the drives to catch up and empty the
> writeback list. 
> 
> A simple fio test easily demonstrates this problem.  
> 
> fio --name=f1 --directory=/disk1 --size=2G -rw=write
> 	--name=f2 --directory=/disk2 --size=1G --rw=write 		--startdelay=10
> 
> The attached graph before.png shows how all pages are moved to writeback
> as the second write starts and the throttling kicks in.
> 
> after.png is the same test with the patch applied, which clearly shows
> that it keeps dirty_background_ratio dirty pages in the buffer.
> The values and timings of the graphs are only approximate but are good
> enough to show the behaviour.  
> 
> This is the simplest fix I could find, but I'm not entirely sure that it
> alone will be enough for all cases. But it certainly is an improvement
> on my desktop machine writing to 2 disks.
> 
> Do we need something more for machines with large arrays where
> bdi_threshold * number_of_drives is greater than the dirty_ratio ?
> 

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 7b0dcea..7687879 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -541,8 +541,11 @@ static void balance_dirty_pages(struct address_space *mapping)
>  		 * filesystems (i.e. NFS) in which data may have been
>  		 * written to the server's write cache, but has not yet
>  		 * been flushed to permanent storage.
> +		 * Only move pages to writeback if this bdi is over its
> +		 * threshold otherwise wait until the disk writes catch
> +		 * up.
>  		 */
> -		if (bdi_nr_reclaimable) {
> +		if (bdi_nr_reclaimable > bdi_thresh) {
>  			writeback_inodes(&wbc);
>  			pages_written += write_chunk - wbc.nr_to_write;
>  			get_dirty_limits(&background_thresh, &dirty_thresh,

OK, so Chris ran into this bit yesterday, complaining that he'd only get
very few write requests and couldn't saturate his IO channel.

Now, since writing out everything once there's something to do sucks for
Richard, but only writing out stuff when we're over the limit sucks for
Chris (since we can only be over the limit a little), the best thing
would be to only write out when we're over the background limit. Since
that is the low watermark we use for throttling it makes sense that we
try to write out when above that.

However, since there's a lack of bdi_background_thresh, and I don't
think introducing one just for this is really justified. How about the
below?

Chris how did this work for you? Richard, does this make things suck for
you again?

---
 mm/page-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 81627eb..92f42d6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -545,7 +545,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 		 * threshold otherwise wait until the disk writes catch
 		 * up.
 		 */
-		if (bdi_nr_reclaimable > bdi_thresh) {
+		if (bdi_nr_reclaimable > bdi_thresh/2) {
 			writeback_inodes(&wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,


