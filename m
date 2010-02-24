Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0BXDOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:14:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:29684 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab0BXDNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:13:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,529,1262592000"; 
   d="scan'208";a="598621452"
Message-Id: <20100224031054.161214875@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 11:10:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Ankit Jain <radical@gmail.com>,
       Dave Chinner <david@fromorbit.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
cc: Matt Mackall <mpm@selenic.com>
CC: Nick Piggin <npiggin@suse.de>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/15] readahead: make default readahead size a kernel parameter
References: <20100224031001.026464755@intel.com>
Content-Disposition: inline; filename=readahead-kernel-parameter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikanth Karthikesan <knikanth@suse.de>

Add new kernel parameter "readahead", which allows user to override
the static VM_MAX_READAHEAD=512kb.

CC: Ankit Jain <radical@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 block/blk-core.c                    |    3 +--
 fs/fuse/inode.c                     |    2 +-
 mm/readahead.c                      |   22 ++++++++++++++++++++++
 4 files changed, 28 insertions(+), 3 deletions(-)

--- linux.orig/Documentation/kernel-parameters.txt	2010-02-24 10:44:26.000000000 +0800
+++ linux/Documentation/kernel-parameters.txt	2010-02-24 10:44:42.000000000 +0800
@@ -2200,6 +2200,10 @@ and is between 256 and 4096 characters. 
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
+	readahead=nn[KM]
+			Default max readahead size for block devices.
+			Range: 0; 4k - 128m
+
 	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
 			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
--- linux.orig/block/blk-core.c	2010-02-24 10:44:26.000000000 +0800
+++ linux/block/blk-core.c	2010-02-24 10:44:42.000000000 +0800
@@ -498,8 +498,7 @@ struct request_queue *blk_alloc_queue_no
 
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
-	q->backing_dev_info.ra_pages =
-			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	q->backing_dev_info.ra_pages = default_backing_dev_info.ra_pages;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
 	q->backing_dev_info.name = "block";
--- linux.orig/fs/fuse/inode.c	2010-02-24 10:44:26.000000000 +0800
+++ linux/fs/fuse/inode.c	2010-02-24 10:44:42.000000000 +0800
@@ -870,7 +870,7 @@ static int fuse_bdi_init(struct fuse_con
 	int err;
 
 	fc->bdi.name = "fuse";
-	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	fc->bdi.ra_pages = default_backing_dev_info.ra_pages;
 	fc->bdi.unplug_io_fn = default_unplug_io_fn;
 	/* fuse does it's own writeback accounting */
 	fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
--- linux.orig/mm/readahead.c	2010-02-24 10:44:40.000000000 +0800
+++ linux/mm/readahead.c	2010-02-24 10:44:42.000000000 +0800
@@ -19,6 +19,28 @@
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
 
+static int __init config_readahead_size(char *str)
+{
+	unsigned long bytes;
+
+	if (!str)
+		return -EINVAL;
+	bytes = memparse(str, &str);
+	if (*str != '\0')
+		return -EINVAL;
+
+	if (bytes) {
+		if (bytes < PAGE_CACHE_SIZE)	/* missed 'k'/'m' suffixes? */
+			return -EINVAL;
+		if (bytes > 128 << 20)		/* limit to 128MB */
+			bytes = 128 << 20;
+	}
+
+	default_backing_dev_info.ra_pages = bytes / PAGE_CACHE_SIZE;
+	return 0;
+}
+early_param("readahead", config_readahead_size);
+
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
  * memset *ra to zero.


