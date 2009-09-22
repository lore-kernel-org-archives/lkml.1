Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZIVIFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZIVIFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZIVIFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:05:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:35618 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZIVIFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:05:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,430,1249282800"; 
   d="scan'208";a="190216859"
Date: Tue, 22 Sep 2009 16:05:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090922080505.GB9192@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com> <1253601612.8439.274.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253601612.8439.274.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 02:40:12PM +0800, Peter Zijlstra wrote:
> On Tue, 2009-09-22 at 13:49 +0800, Shaohua Li wrote:
> > Hi,
> > Commit d7831a0bdf06b9f722b947bb0c205ff7d77cebd8 causes disk io regression
> > in my test.
> > My system has 12 disks, each disk has two partitions. System runs fio sequence
> > write on all partitions, each partion has 8 jobs.
> > 2.6.31-rc1, fio gives 460m/s disk io
> > 2.6.31-rc2, fio gives about 400m/s disk io. Revert the patch, speed back to
> > 460m/s
> > 
> > Under latest git: fio gives 450m/s disk io; If reverting the patch, the speed
> > is 484m/s.
> > 
> > With the patch, fio reports less io merge and more interrupts. My naive
> > analysis is the patch makes balance_dirty_pages_ratelimited_nr() limits
> > write chunk to 8 pages and then soon go to sleep in balance_dirty_pages(),
> > because most time the bdi_nr_reclaimable < bdi_thresh, and so when write
> > the pages out, the chunk is 8 pages long instead of 4M long. Without the patch,
> > thread can write 8 pages and then move some pages to writeback, and then
> > continue doing write. The patch seems to break this.
> > 
> > Unfortunatelly I can't figure out a fix for this issue, hopefully you have more
> > ideas.
> 
> This whole writeback business is very fragile,

Agreed, sorry..

> the patch does indeed cure a few cases and compounds a few other
> cases, typical trade off.
> 
> People are looking at it.

Staring at the changelog, I don't think balance_dirty_pages() could
"overshoot its limits and move all the dirty pages to writeback".
Because it will break when enough pages are written:

                if (pages_written >= write_chunk)
                        break;          /* We've done our duty */

The observed "overshooting" may well be the background_writeout()
behavior, which will hit the dirty numbers all the way down to 0.


    mm: prevent balance_dirty_pages() from doing too much work

    balance_dirty_pages can overreact and move all of the dirty pages to
    writeback unnecessarily.

    balance_dirty_pages makes its decision to throttle based on the number of
    dirty plus writeback pages that are over the calculated limit,so it will
    continue to move pages even when there are plenty of pages in writeback
    and less than the threshold still dirty.

    This allows it to overshoot its limits and move all the dirty pages to
    writeback while waiting for the drives to catch up and empty the writeback
    list.


I'm not sure how this patch stopped the "overshooting" behavior.
Maybe it managed to not start the background pdflush, or the started
pdflush thread exited because it found writeback is in progress by
someone else?

-               if (bdi_nr_reclaimable) {
+               if (bdi_nr_reclaimable > bdi_thresh) {

Thanks,
Fengguang
