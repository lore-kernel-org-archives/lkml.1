Return-Path: <linux-kernel-owner+w=401wt.eu-S934633AbYCFUlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633AbYCFUlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbYCFUlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:41:31 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:11471 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700AbYCFUla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:41:30 -0500
Date: Thu, 6 Mar 2008 21:41:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix memory hotplug and bouncing in block layer
Message-ID: <20080306204124.GA17154@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 06 Mar 2008 20:34:54.0270 (UTC) FILETIME=[88F0DDE0:01C87FC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory hotplug and bouncing in block layer

Only noticed this while hacking something else, no test case.

blk_max_low_pfn is initialized once at bootup by the block layer
from max_low_pfn. But max_low_pfn is not necessarily constant
over the runtime of the system when you consider memory hotplug.
What could happen if that someone adds memory later the block
layer wouldn't get updated and then start bouncing memory unnecessarily.

Also on 64bit blk_max_low_pfn actually isn't needed because
it just disables bouncing essentially and there is no highmem.
And nobody can pass pfns > max_low_pfn to the block layer, 
because those wouldn't have a struct page and I suspect
block layer wouldn't be very happy without that.

So set BLK_BOUNCE_HIGH to infinity (-1ULL) on 64bit. That
avoids the problem of having to update it on memory hotadd.

On 32bit I kept the same behaviour because at least on i386
memory hotadd only adds HIGHMEM, never lowmem.

BLK_BOUNCE_ANY is always set to infinity on both 32 and 64bit.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/blkdev.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -532,8 +532,13 @@ extern unsigned long blk_max_low_pfn, bl
  * BLK_BOUNCE_ANY	: don't bounce anything
  * BLK_BOUNCE_ISA	: bounce pages above ISA DMA boundary
  */
+
+#if BITS_PER_LONG == 32
 #define BLK_BOUNCE_HIGH		((u64)blk_max_low_pfn << PAGE_SHIFT)
-#define BLK_BOUNCE_ANY		((u64)blk_max_pfn << PAGE_SHIFT)
+#else
+#define BLK_BOUNCE_HIGH		-1ULL
+#endif
+#define BLK_BOUNCE_ANY		(-1ULL)
 #define BLK_BOUNCE_ISA		(ISA_DMA_THRESHOLD)
 
 /*
