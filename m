Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab0BXDOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:14:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:29683 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095Ab0BXDNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:13:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,529,1262592000"; 
   d="scan'208";a="495089973"
Message-Id: <20100224031054.307027163@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 11:10:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
CC: Nick Piggin <npiggin@suse.de>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/15] readahead: limit readahead size for small memory systems
References: <20100224031001.026464755@intel.com>
Content-Disposition: inline; filename=readahead-small-memory-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
readahead size proportional to available system memory, ie.
                512MB mem => 512KB readahead size
                128MB mem => 128KB readahead size
                 32MB mem =>  32KB readahead size (minimal)

Strictly speaking, only read-around size has to be limited.  However we
don't bother to seperate read-around size from read-ahead size for now.

CC: Matt Mackall <mpm@selenic.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- linux.orig/mm/readahead.c	2010-02-24 10:44:42.000000000 +0800
+++ linux/mm/readahead.c	2010-02-24 10:44:42.000000000 +0800
@@ -19,6 +19,10 @@
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
 
+#define MIN_READAHEAD_PAGES DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
+
+static int __initdata user_defined_readahead_size;
+
 static int __init config_readahead_size(char *str)
 {
 	unsigned long bytes;
@@ -36,11 +40,33 @@ static int __init config_readahead_size(
 			bytes = 128 << 20;
 	}
 
+	user_defined_readahead_size = 1;
 	default_backing_dev_info.ra_pages = bytes / PAGE_CACHE_SIZE;
 	return 0;
 }
 early_param("readahead", config_readahead_size);
 
+static int __init check_readahead_size(void)
+{
+	/*
+	 * Scale down default readahead size for small memory systems.
+	 * For example, a 64MB box will do 64KB read-ahead/read-around
+	 * instead of the default 512KB.
+	 *
+	 * Note that the default readahead size will also be scaled down
+	 * for small devices in add_disk().
+	 */
+	if (!user_defined_readahead_size) {
+		unsigned long max = roundup_pow_of_two(totalram_pages / 1024);
+		if (default_backing_dev_info.ra_pages > max)
+		    default_backing_dev_info.ra_pages = max;
+		if (default_backing_dev_info.ra_pages < MIN_READAHEAD_PAGES)
+		    default_backing_dev_info.ra_pages = MIN_READAHEAD_PAGES;
+	}
+	return 0;
+}
+fs_initcall(check_readahead_size);
+
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
  * memset *ra to zero.


