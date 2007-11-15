Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXKOUp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXKOUp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbXKOUpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:45:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46440 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbXKOUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:45:18 -0500
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
	Bugs)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
In-Reply-To: <1195155601.22457.25.camel@lappy>
References: <20071113.043207.44732743.davem@davemloft.net>
	 <20071113110259.44c56d42.akpm@linux-foundation.org>
	 <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>
	 <20071113130411.26ccae12.akpm@linux-foundation.org>
	 <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
	 <20071115040708.GB15302@brong.net>
	 <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
	 <20071115052538.GA21522@brong.net>
	 <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
	 <20071115115049.GA8297@brong.net>
	 <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>
	 <1195155601.22457.25.camel@lappy>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 21:44:17 +0100
Message-Id: <1195159457.22457.35.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-15 at 20:40 +0100, Peter Zijlstra wrote:

> As for the highmem part, that was due to buffer cache, and unfortunately
> that is still true. Although maybe we can do something smart with the
> per-bdi stuff.

Something like this ought to do I guess. Although my
mapping_is_buffercache() is the ugliest thing. I'm sure that can be done
better.

Uncompiled, untested

Not-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/page-writeback.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -280,27 +280,28 @@ static unsigned long highmem_dirtyable_m
 #endif
 }
 
-static unsigned long determine_dirtyable_memory(void)
+static unsigned long determine_dirtyable_memory(int highmem)
 {
 	unsigned long x;
 
 	x = global_page_state(NR_FREE_PAGES)
 		+ global_page_state(NR_INACTIVE)
 		+ global_page_state(NR_ACTIVE);
-	x -= highmem_dirtyable_memory(x);
+	if (!highmem)
+		x -= highmem_dirtyable_memory(x);
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
 static void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
-		 struct backing_dev_info *bdi)
+		 struct backing_dev_info *bdi, int highmem)
 {
 	int background_ratio;		/* Percentages */
 	int dirty_ratio;
 	int unmapped_ratio;
 	long background;
 	long dirty;
-	unsigned long available_memory = determine_dirtyable_memory();
+	unsigned long available_memory = determine_dirtyable_memory(highmem);
 	struct task_struct *tsk;
 
 	unmapped_ratio = 100 - ((global_page_state(NR_FILE_MAPPED) +
@@ -346,6 +347,16 @@ get_dirty_limits(long *pbackground, long
 	}
 }
 
+static inline int mapping_is_buffercache(struct address_space *mapping)
+{
+	struct super_block *sb = mapping->host->i_sb;
+
+	if (sb && sb->s_bdev && sb->s_bdev->bd_inode->i_mapping != mapping)
+		return 0;
+
+	return 1;
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -364,6 +375,7 @@ static void balance_dirty_pages(struct a
 	unsigned long write_chunk = sync_writeback_pages();
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	int highmem = !mapping_is_buffercache(mapping);
 
 	for (;;) {
 		struct writeback_control wbc = {
@@ -375,7 +387,7 @@ static void balance_dirty_pages(struct a
 		};
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
-				&bdi_thresh, bdi);
+				&bdi_thresh, bdi, highmem);
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
@@ -394,7 +406,7 @@ static void balance_dirty_pages(struct a
 			writeback_inodes(&wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
-				       &bdi_thresh, bdi);
+				       &bdi_thresh, bdi, highmem);
 		}
 
 		/*
@@ -503,7 +515,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	long dirty_thresh;
 
         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL, 1);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
@@ -546,7 +558,7 @@ static void background_writeout(unsigned
 		long background_thresh;
 		long dirty_thresh;
 
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL, 1);
 		if (global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)



