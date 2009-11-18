Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZKRKJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZKRKJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZKRKJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:09:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:17866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZKRKJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:09:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212858708"
Date: Wed, 18 Nov 2009 18:09:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] writeback: remove unused nonblocking and
	congestion checks (gfs2)
Message-ID: <20091118100941.GA18726@localhost>
References: <20091118082648.140755818@intel.com> <20091118082846.170413359@intel.com> <1258538386.2904.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1258538386.2904.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, Nov 18, 2009 at 05:59:46PM +0800, Steven Whitehouse wrote:
> Hi,
> 
> That looks ok to me, modulo the warnings below. The only "non-obvious"
> thing in this area which the GFS2 writepage[s] code relies upon is the
> assumption that if we have a ->writepages() then ->writepage() will
> never be called from a context which requires the fs to actually do a
> write (i.e. the fs can refuse this if required). That is also only the
> case for journaled data files - normal writes don't have that
> requirement.

Thank you for the tips. I don't think pageout() or migration
writeout() has that hard expectation for ->writepage() :)

>  CC [M]  fs/gfs2/aops.o
> fs/gfs2/aops.c: In function ‘gfs2_write_jdata_pagevec’:
> fs/gfs2/aops.c:272: warning: unused variable ‘bdi’
> fs/gfs2/aops.c: In function ‘gfs2_write_cache_jdata’:
> fs/gfs2/aops.c:336: warning: unused variable ‘bdi’

Ah sorry!

> Once the warnings are fixed:
> 
> Acked-by: Steven Whitehouse <swhiteho@redhat.com>
> 
> Do you want me to add this patch into my tree, or were you planning to
> submit via a different tree?

Thanks, can you pull the updated patch directly to your tree?

Thanks,
Fengguang
---
writeback: remove unused nonblocking and congestion checks (gfs2)

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/gfs2/aops.c |   12 ------------
 1 file changed, 12 deletions(-)

--- linux.orig/fs/gfs2/aops.c	2009-11-18 16:39:32.000000000 +0800
+++ linux/fs/gfs2/aops.c	2009-11-18 18:01:14.000000000 +0800
@@ -269,7 +269,6 @@ static int gfs2_write_jdata_pagevec(stru
 	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset = i_size & (PAGE_CACHE_SIZE-1);
 	unsigned nrblocks = nr_pages * (PAGE_CACHE_SIZE/inode->i_sb->s_blocksize);
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int i;
 	int ret;
 
@@ -313,11 +312,6 @@ static int gfs2_write_jdata_pagevec(stru
 
 		if (ret || (--(wbc->nr_to_write) <= 0))
 			ret = 1;
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
-			wbc->encountered_congestion = 1;
-			ret = 1;
-		}
-
 	}
 	gfs2_trans_end(sdp);
 	return ret;
@@ -338,7 +332,6 @@ static int gfs2_write_jdata_pagevec(stru
 static int gfs2_write_cache_jdata(struct address_space *mapping,
 				  struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
 	struct pagevec pvec;
@@ -348,11 +341,6 @@ static int gfs2_write_cache_jdata(struct
 	int scanned = 0;
 	int range_whole = 0;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
