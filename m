Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbYBEKHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbYBEKHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYBEKHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:07:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652AbYBEKHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:07:42 -0500
Date: Tue, 5 Feb 2008 02:07:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: r31dmaeu@pc0312b.rz.unibw-muenchen.de
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       stable@kernel.org
Subject: Re: OOM-killer invoked but why ?
Message-Id: <20080205020737.cec97816.akpm@linux-foundation.org>
In-Reply-To: <47A1C4B1.8020607@pc0312a.rz.unibw-muenchen.de>
References: <47A1C4B1.8020607@pc0312a.rz.unibw-muenchen.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 13:53:05 +0100 Claude Frantz <r31dmaeu@pc0312b.rz.unibw-muenchen.de> wrote:

> Hello !
> 
> I'm faced to a problem where the OOM-killer is invoked but I cannot find
> the reason why. The machine is rather powerfull, the load is very moderate,
> the disk swap space is nearly unused. The only strange observation which
> appears to me is the slow but progressive decreasing of kbbuffers during
> many hours.
> 
> Can you help me to diagnose the problem and to find a good solution ?
> 
> ...
>
> Jan 28 03:50:49 toaster kernel: 177466 pages slab
> Jan 28 03:50:49 toaster kernel: 1915 pages pagetables
> Jan 28 03:50:49 toaster kernel: Out of memory: kill process 10859 (amavisd) score 36218 or a child
> Jan 28 03:50:49 toaster kernel: Killed process 19146 (amavisd)

slab.  Maybe you've been bitten by the quicklist leak.  If you're able to
patch your kernel then please try this fix:

commit 96990a4ae979df9e235d01097d6175759331e88c
Author: Christoph Lameter <clameter@sgi.com>
Date:   Mon Jan 14 00:55:14 2008 -0800

    quicklists: Only consider memory that can be used with GFP_KERNEL
    
    Quicklists calculates the size of the quicklists based on the number of
    free pages.  This must be the number of free pages that can be allocated
    with GFP_KERNEL.  node_page_state() includes the pages in ZONE_HIGHMEM and
    ZONE_MOVABLE which may lead the quicklists to become too large causing OOM.
    
    Signed-off-by: Christoph Lameter <clameter@sgi.com>
    Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/quicklist.c b/mm/quicklist.c
index ae8189c..3f703f7 100644
--- a/mm/quicklist.c
+++ b/mm/quicklist.c
@@ -26,9 +26,17 @@ DEFINE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];
 static unsigned long max_pages(unsigned long min_pages)
 {
 	unsigned long node_free_pages, max;
+	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
+
+	node_free_pages =
+#ifdef CONFIG_ZONE_DMA
+		zone_page_state(&zones[ZONE_DMA], NR_FREE_PAGES) +
+#endif
+#ifdef CONFIG_ZONE_DMA32
+		zone_page_state(&zones[ZONE_DMA32], NR_FREE_PAGES) +
+#endif
+		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
 
-	node_free_pages = node_page_state(numa_node_id(),
-			NR_FREE_PAGES);
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
 	return max(max, min_pages);
 }


I note that this didn't have the stable@kernel.org cc.  Christoph, did we
deliberately decide not to backport?

