Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYCMBXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYCMBXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYCMBXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:23:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbYCMBXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:23:03 -0400
Date: Wed, 12 Mar 2008 18:22:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Message-Id: <20080312182240.db32c858.akpm@linux-foundation.org>
In-Reply-To: <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com>
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
	<86802c440803121621j3b9ec7e8nf7ae62b894eb85df@mail.gmail.com>
	<20080312163359.7fe0fd80.akpm@linux-foundation.org>
	<86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 18:11:41 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> >  <looks at it>
> >
> >  Sorry, but I find the changelog very hard to amke sense of.  I presently
> >  have:
> >
> >
> >   So call it when numa is enabled, we don't know which node have that
> >   range.  and make it more robust.
> >
> >   Try to trim it to get valid sidx, and eidx.
> >
> >  Could you please expand on this?
> 
> please check following...
> 

Heaps better, thanks ;)  Below is what I now have.

(cc's people)

Guys, could you please review this?  Maybe test it a bit?

Thanks.


From: "Yinghai Lu" <yhlu.kernel@gmail.com>

With numa enabled, some callers could have a range o fmemory on one node but
try to free that on other node.  This can cause some pages to be freed
wrongly.

For example: when we try to allocate 128g boot ram early for gart/swiotlb, and
free that range later so gart/swiotlb can get some range afterwards.

With this patch, we don't need to care which node holds the range, just loop
to call free_bootmem_node for all online nodes.

This patch make free_bootmem_core() more robust by trimming the sidx and eidx
according the ram range that the node has.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core
+++ a/mm/bootmem.c
@@ -125,6 +125,7 @@ static int __init reserve_bootmem_core(b
 	BUG_ON(!size);
 	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
 	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
+	BUG_ON(addr < bdata->node_boot_start);
 
 	sidx = PFN_DOWN(addr - bdata->node_boot_start);
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
@@ -156,21 +157,31 @@ static void __init free_bootmem_core(boo
 	unsigned long sidx, eidx;
 	unsigned long i;
 
+	BUG_ON(!size);
+
+	/* out range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
 	/*
 	 * round down end of usable mem, partially free pages are
 	 * considered reserved.
 	 */
-	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr + size) > bdata->node_low_pfn);
 
-	if (addr < bdata->last_success)
+	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
 		bdata->last_success = addr;
 
 	/*
-	 * Round up the beginning of the address.
+	 * Round up to index to the range.
 	 */
-	sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
+		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++) {
 		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
_

