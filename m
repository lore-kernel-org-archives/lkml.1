Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZBJLgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZBJLgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZBJLfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:35:51 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49395 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZBJLfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:35:50 -0500
Message-ID: <49916691.9080807@in.ibm.com>
Date: Tue, 10 Feb 2009 17:05:45 +0530
From: Chandru <chandru@in.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       benh@kernel.crashing.org, chandru@linux.vnet.ibm.com, paulus@samba.org,
       akpm@linux-foundation.org
Subject: Re: + powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
 added to -mm tree
References: <200812250806.mBP86LPQ018399@imap1.linux-foundation.org> <20090208204725.GA5514@cmpxchg.org>
In-Reply-To: <20090208204725.GA5514@cmpxchg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: powerpc: fix rounding error in teaching bootmem about LMB
>
> If the reserved LMB does not exactly span complete pages, treating
> (start + size) >> PAGE_SHIFT as the ending PFN is an off by one error.
>
> The subsequent check for whether the region needs to be trimmed to fit
> the underlying node can now fail if the range exceeds the node by 1 to
> PAGE_SIZE - 1 bytes.  The excessive range is then passed to bootmem
> which BUG()s out on it correctly.
>
> Fix up the rounding to include all pages the LMB spans, even partial
> ones.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

Hello Hannes,

Dave Hansen gave a fix for this problem which looks similar
to the changes that you have made here , but has an additional
one line change too. Here is the patch ( probably may not apply
cleanly to the latest kernel ) . I don' t know if Dave
submitted this patch to lkml for it's inclusion into the
latest tree. Thanks for looking into this issue. We may also have
to remove the 
powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
from the -mm tree.

Thanks,
Chandru

=================
Snippet from Dave's patch without change log

---

 linux-2.6.git-dave/arch/powerpc/mm/numa.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/mm/numa.c~reserve-over-fix arch/powerpc/mm/numa.c
--- linux-2.6.git/arch/powerpc/mm/numa.c~reserve-over-fix	2009-01-26 10:17:20.000000000 -0800
+++ linux-2.6.git-dave/arch/powerpc/mm/numa.c	2009-01-26 10:17:30.000000000 -0800
@@ -19,6 +19,7 @@
 #include <linux/notifier.h>
 #include <linux/lmb.h>
 #include <linux/of.h>
+#include <linux/pfn.h>
 #include <asm/sparsemem.h>
 #include <asm/prom.h>
 #include <asm/system.h>
@@ -882,7 +883,7 @@ static void mark_reserved_regions_for_ni
 		unsigned long physbase = lmb.reserved.region[i].base;
 		unsigned long size = lmb.reserved.region[i].size;
 		unsigned long start_pfn = physbase >> PAGE_SHIFT;
-		unsigned long end_pfn = ((physbase + size) >> PAGE_SHIFT);
+		unsigned long end_pfn = PFN_UP(physbase + size);
 		struct node_active_region node_ar;
 		unsigned long node_end_pfn = node->node_start_pfn +
 					     node->node_spanned_pages;
@@ -908,7 +909,7 @@ static void mark_reserved_regions_for_ni
 			 */
 			if (end_pfn > node_ar.end_pfn)
 				reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
-					- (start_pfn << PAGE_SHIFT);
+					- physbase;
 			/*
 			 * Only worry about *this* node, others may not
 			 * yet have valid NODE_DATA().
diff -puN arch/powerpc/kernel/prom_init.c~reserve-over-fix arch/powerpc/kernel/prom_init.c


