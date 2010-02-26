Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935449Ab0BZHiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:38:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:47188 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935431Ab0BZHiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:38:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,545,1262592000"; 
   d="scan'208";a="776120552"
Date: Fri, 26 Feb 2010 15:38:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 05/15] readahead: limit readahead size for small memory
	systems
Message-ID: <20100226073804.GA7868@localhost>
References: <20100224031001.026464755@intel.com> <20100224031054.307027163@intel.com> <4B869682.9010709@linux.vnet.ibm.com> <20100226022907.GA22226@localhost> <4B8776FC.30409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8776FC.30409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian,

On Fri, Feb 26, 2010 at 03:23:40PM +0800, Christian Ehrhardt wrote:
> Unfortunately without a chance to measure this atm, this patch now looks 
> really good to me.
> Thanks for adapting it to a read-ahead only per mem limit.
> Acked-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

Thank you. Effective measurement is hard because it really depends on
how the user want to stress use his small memory system ;) So I think
a simple to understand and yet reasonable limit scheme would be OK.

Thanks,
Fengguang
---
readahead: limit read-ahead size for small memory systems

When lifting the default readahead size from 128KB to 512KB,
make sure it won't add memory pressure to small memory systems.

For read-ahead, the memory pressure is mainly readahead buffers consumed
by too many concurrent streams. The context readahead can adapt
readahead size to thrashing threshold well.  So in principle we don't
need to adapt the default _max_ read-ahead size to memory pressure.

For read-around, the memory pressure is mainly read-around misses on
executables/libraries. Which could be reduced by scaling down
read-around size on fast "reclaim passes".

This patch presents a straightforward solution: to limit default
read-ahead size proportional to available system memory, ie.

                512MB mem => 512KB read-around size
                128MB mem => 128KB read-around size
                 32MB mem =>  32KB read-around size

This will allow power users to adjust read-ahead/read-around size at
once, while saving the low end from unnecessary memory pressure, under
the assumption that low end users have no need to request a large
read-around size.

CC: Matt Mackall <mpm@selenic.com>
Acked-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c   |    2 +-
 mm/readahead.c |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

--- linux.orig/mm/filemap.c	2010-02-26 10:04:28.000000000 +0800
+++ linux/mm/filemap.c	2010-02-26 10:08:33.000000000 +0800
@@ -1431,7 +1431,7 @@ static void do_sync_mmap_readahead(struc
 	/*
 	 * mmap read-around
 	 */
-	ra_pages = max_sane_readahead(ra->ra_pages);
+	ra_pages = min(ra->ra_pages, roundup_pow_of_two(totalram_pages / 1024));
 	if (ra_pages) {
 		ra->start = max_t(long, 0, offset - ra_pages/2);
 		ra->size = ra_pages;
