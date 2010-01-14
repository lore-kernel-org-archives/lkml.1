Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563Ab0ANIxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0ANIxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 03:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974Ab0ANIw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 03:52:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:52572 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab0ANIw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:52:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,274,1262592000"; 
   d="scan'208";a="531206906"
Date: Thu, 14 Jan 2010 16:52:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] pagemap: early return on unmapped areas
Message-ID: <20100114085230.GA12078@localhost>
References: <20100110020955.GB25323@basil.fritz.box> <20100113141648.42eff724.akpm@linux-foundation.org> <1263421562.29868.5000.camel@calx> <20100113143055.7bea30c5.akpm@linux-foundation.org> <1263423916.29868.5009.camel@calx> <20100113151502.fa425247.akpm@linux-foundation.org> <20100114055319.GA17671@localhost> <20100113221013.b1beecb4.akpm@linux-foundation.org> <20100114080600.GA4739@localhost> <20100114083048.GC12241@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114083048.GC12241@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 04:30:48PM +0800, Andi Kleen wrote:
> > ---
> > pagemap: early return on unmapped areas
> 
> Yes seems like a reasonable idea.

Thanks!

I just changed the ">" to ">=", because it happen to make a difference
for cp/cat, which does 4k sized read:

        4k read buffer = 4k/8 pages = 512 pages = NR_PMD_PAGES

So the change to ">=" makes cp exit immediately (4k buffer matches
exactly one PMD hole).

before
        dd if=/proc/$$/pagemap of=/dev/null bs=4k
        512+0 records in
        512+0 records out
        2097152 bytes (2.1 MB) copied, 0.0225796 s, 92.9 MB/s

after
        dd if=/proc/$$/pagemap of=/dev/null bs=4k
        0+0 records in
        0+0 records out
        0 bytes (0 B) copied, 2.8029e-05 s, 0.0 kB/s

page-types still works (only faster;) with this patch.

Thanks,
Fengguang
---
pagemap: early return on unmapped areas

This helps stop dumb cp/cat early instead of loop for days:

http://bugzilla.kernel.org/show_bug.cgi?id=15041

This also serves as an optimization to normal pagemap users (eg.
page-types).

CC: Andi Kleen <andi@firstfloor.org> 
CC: Matt Mackall <mpm@selenic.com>
CC: <stable@kernel.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-mm.orig/fs/proc/task_mmu.c	2010-01-14 13:38:44.000000000 +0800
+++ linux-mm/fs/proc/task_mmu.c	2010-01-14 16:38:49.000000000 +0800
@@ -586,6 +586,10 @@ static int pagemap_pte_hole(unsigned lon
 	struct pagemapread *pm = walk->private;
 	unsigned long addr;
 	int err = 0;
+
+	if ((end - start) / PAGE_SIZE >= pm->end - pm->out)
+		return PM_END_OF_BUFFER;
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		err = add_to_pagemap(addr, PM_NOT_PRESENT, pm);
 		if (err)
