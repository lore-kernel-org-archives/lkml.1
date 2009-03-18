Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZCRMUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZCRMUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZCRMUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:20:05 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:4164 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751180AbZCRMUE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:20:04 -0400
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fKzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KGPBKS-03-9T2-01
Date: Wed, 18 Mar 2009 13:19:40 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dma-debug: add additional checks
Message-ID: <20090318121940.GT6159@amd.com>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com> <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu> <20090318112324.GB32233@elte.hu> <1237376327.5069.253.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1237376327.5069.253.camel@laptop>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Mar 2009 12:19:40.0661 (UTC) FILETIME=[CFFBB250:01C9A7C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 12:38:47PM +0100, Peter Zijlstra wrote:
> On Wed, 2009-03-18 at 12:23 +0100, Ingo Molnar wrote:
> > another -tip testbox started triggering:
> > 
> >   BUG: MAX_LOCKDEP_ENTRIES too low!
> > 
> > it triggers due to CONFIG_DMA_API_DEBUG=y. Config attached.
> 
> 
> I still have this laying about.. could be we're just at the limit due to
> lock bloat in the kernel, could be dma_api_debug is doing something
> all-together iffy

I had a look and the maximum locking depth in dma-debug code was two.
Attached patch reduces this to one.

>From d28fc4a308bf66ed98c68e1db18e4e1434206541 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 18 Mar 2009 13:15:20 +0100
Subject: [PATCH] dma-debug: serialize locking in unmap path

Impact: reduce maximum lockdepth to one

This patch reduces the maximum spin lock depth from two to one in the
dma-debug code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 9a350b4..3bd8d1d 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -542,7 +542,8 @@ static void check_unmap(struct dma_debug_entry *ref)
 			   "to free DMA memory it has not allocated "
 			   "[device address=0x%016llx] [size=%llu bytes]\n",
 			   ref->dev_addr, ref->size);
-		goto out;
+		put_hash_bucket(bucket, &flags);
+		return;
 	}
 
 	if (ref->size != entry->size) {
@@ -593,10 +594,8 @@ static void check_unmap(struct dma_debug_entry *ref)
 	}
 
 	hash_bucket_del(entry);
-	dma_entry_free(entry);
-
-out:
 	put_hash_bucket(bucket, &flags);
+	dma_entry_free(entry);
 }
 
 static void check_for_stack(struct device *dev, void *addr)
-- 
1.5.6.4


-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

