Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbZE0Dzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbZE0Dzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbZE0DzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:55:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:23193 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758952AbZE0DzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:55:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,256,1241420400"; 
   d="scan'208";a="147277843"
Date: Wed, 27 May 2009 11:55:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090527035505.GA16916@localhost>
References: <20090520025123.GB8186@localhost> <6.0.0.20.2.20090521145005.06f81fe0@172.19.0.2> <20090522010538.GB6010@localhost> <6.0.0.20.2.20090522102551.0705aea0@172.19.0.2> <20090522023323.GA10864@localhost> <20090526164252.0741b392.akpm@linux-foundation.org> <6.0.0.20.2.20090527092105.076be238@172.19.0.2> <20090527020909.GB17658@localhost> <6.0.0.20.2.20090527110937.0770c420@172.19.0.2> <20090526193601.b825af5f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526193601.b825af5f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:36:01AM +0800, Andrew Morton wrote:
> On Wed, 27 May 2009 11:21:53 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
> 
> > 
> > At 11:09 09/05/27, Wu Fengguang wrote:
> > >On Wed, May 27, 2009 at 08:25:04AM +0800, Hisashi Hifumi wrote:
> > >> 
> > >> At 08:42 09/05/27, Andrew Morton wrote:
> > >> >On Fri, 22 May 2009 10:33:23 +0800
> > >> >Wu Fengguang <fengguang.wu@intel.com> wrote:
> > >> >
> > >> >> > I tested above patch, and I got same performance number.
> > >> >> > I wonder why if (PageUptodate(page)) check is there...
> > >> >> 
> > >> >> Thanks!  This is an interesting micro timing behavior that
> > >> >> demands some research work.  The above check is to confirm if it's
> > >> >> the PageUptodate() case that makes the difference. So why that case
> > >> >> happens so frequently so as to impact the performance? Will it also
> > >> >> happen in NFS?
> > >> >> 
> > >> >> The problem is readahead IO pipeline is not running smoothly, which is
> > >> >> undesirable and not well understood for now.
> > >> >
> > >> >The patch causes a remarkably large performance increase.  A 9%
> > >> >reduction in time for a linear read? I'd be surprised if the workload
> > >> 
> > >> Hi Andrew.
> > >> Yes, I tested this with dd.
> > >> 
> > >> >even consumed 9% of a CPU, so where on earth has the kernel gone to?
> > >> >
> > >> >Have you been able to reproduce this in your testing?
> > >> 
> > >> Yes, this test on my environment is reproducible.
> > >
> > >Hisashi, does your environment have some special configurations?
> > 
> > Hi.
> > My testing environment is as follows:
> > Hardware: HP DL580 
> > CPU:Xeon 3.2GHz *4 HT enabled
> > Memory:8GB
> > Storage: Dothill SANNet2 FC (7Disks RAID-0 Array)
> > 
> > I did dd to this disk-array and got improved performance number.
> > 
> > I noticed that when a disk is just one HDD, performance improvement
> > is very small.
> > 
> 
> Ah.  So it's likely to be some strange interaction with the RAID setup.

The normal case is, if page N become uptodate at time T(N), then
T(N) <= T(N+1) holds. But for RAID, the data arrival time depends on
runtime status of individual disks, which breaks that formula. So
in do_generic_file_read(), just after submitting the async readahead IO
request, the current page may well be uptodate, so the page won't be locked,
and the block device won't be implicitly unplugged:

               if (PageReadahead(page))
                        page_cache_async_readahead()
                if (!PageUptodate(page))
                                goto page_not_up_to_date;
                //...
page_not_up_to_date:
                lock_page_killable(page);


Therefore explicit unplugging can help, so

        Acked-by: Wu Fengguang <fengguang.wu@intel.com> 

The only question is, shall we avoid the double unplug by doing this?

---
 mm/readahead.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- linux.orig/mm/readahead.c
+++ linux/mm/readahead.c
@@ -490,5 +490,15 @@ page_cache_async_readahead(struct addres
 
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
+
+	/*
+	 * Normally the current page is !uptodate and lock_page() will be
+	 * immediately called to implicitly unplug the device. However this
+	 * is not always true for RAID conifgurations, where data arrives
+	 * not strictly in their submission order. In this case we need to
+	 * explicitly kick off the IO.
+	 */
+	if (PageUptodate(page))
+		blk_run_backing_dev(mapping->backing_dev_info, NULL);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
