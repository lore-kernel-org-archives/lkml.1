Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbYBBAcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbYBBAcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763522AbYBBAZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:25:23 -0500
Received: from mx1.suse.de ([195.135.220.2]:54727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763120AbYBBAZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:25:21 -0500
Date: Fri, 1 Feb 2008 16:21:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com, clameter@sgi.com
Subject: [patch 22/27] quicklist: Set tlb->need_flush if pages are
	remaining in quicklist 0
Message-ID: <20080202002103.GW8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="quicklist-set-tlb-need_flush-if-pages-are-remaining-in-quicklist-0.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Christoph Lameter <clameter@sgi.com>

patch 421d99193537a6522aac2148286f08792167d5fd in mainline.

This ensures that the quicklists are drained. Otherwise draining may only
occur when the processor reaches an idle state.

Fixes fatal leakage of pgd_t's on 2.6.22 and later.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reported-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 include/asm-generic/tlb.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -14,6 +14,7 @@
 #define _ASM_GENERIC__TLB_H
 
 #include <linux/swap.h>
+#include <linux/quicklist.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
@@ -85,6 +86,9 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
+#ifdef CONFIG_QUICKLIST
+	tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
+#endif
 	tlb_flush_mmu(tlb, start, end);
 
 	/* keep the page table cache within bounds */

-- 
