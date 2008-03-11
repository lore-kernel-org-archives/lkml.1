Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYCKISu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYCKISu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYCKISf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:18:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYCKISd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:18:33 -0400
Date: Tue, 11 Mar 2008 09:18:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: fix alloc_bootmem_core to use fast searching for
	all nodes
Message-ID: <20080311081815.GB24240@elte.hu>
References: <86802c440803102323k62b6f908l72b3680f25f27650@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803102323k62b6f908l72b3680f25f27650@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> [PATCH] mm: fix alloc_bootmem_core to use fast searching for all nodes

a nice improvement as well. Find below the text-inlined patch for -mm 
inclusion.

	Ingo

-------------------->
Subject: mm: fix alloc_bootmem_core to use fast searching for all nodes
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Date: Mon, 10 Mar 2008 23:23:42 -0700

make the nodes other than node 0 could use bdata->last_success for fast
search too.

we need to use __alloc_bootmem_core for vmemmap allocation for other
nodes when numa and sparsemem/vmemmap are enabled.

also make fail_block path increase i with incr only needed after ALIGN
to avoid extra increase when size is larger than align.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/bootmem.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-x86.q/mm/bootmem.c
===================================================================
--- linux-x86.q.orig/mm/bootmem.c
+++ linux-x86.q/mm/bootmem.c
@@ -227,28 +227,32 @@ __alloc_bootmem_core(struct bootmem_data
 	 * We try to allocate bootmem pages above 'goal'
 	 * first, then we try to allocate lower pages.
 	 */
-	if (goal && goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
-		preferred = goal - bdata->node_boot_start;
+	preferred = 0;
+	if (goal && PFN_DOWN(goal) < end_pfn) {
+		if (goal > bdata->node_boot_start)
+			preferred = goal - bdata->node_boot_start;
 
 		if (bdata->last_success >= preferred)
 			if (!limit || (limit && limit > bdata->last_success))
 				preferred = bdata->last_success;
-	} else
-		preferred = 0;
+	}
 
 	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
 	incr = align >> PAGE_SHIFT ? : 1;
 
 restart_scan:
-	for (i = preferred; i < eidx; i += incr) {
+	for (i = preferred; i < eidx;) {
 		unsigned long j;
+
 		i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
 		i = ALIGN(i, incr);
 		if (i >= eidx)
 			break;
-		if (test_bit(i, bdata->node_bootmem_map))
+		if (test_bit(i, bdata->node_bootmem_map)) {
+			i += incr;
 			continue;
+		}
 		for (j = i + 1; j < i + areasize; ++j) {
 			if (j >= eidx)
 				goto fail_block;
@@ -259,6 +263,8 @@ restart_scan:
 		goto found;
 	fail_block:
 		i = ALIGN(j, incr);
+		if (i == j)
+			i += incr;
 	}
 
 	if (preferred > offset) {

