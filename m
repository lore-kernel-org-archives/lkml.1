Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZDFJsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZDFJsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZDFJop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:42357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbZDFJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:39 -0400
Message-Id: <20090406094517.368446033@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:44:59 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/15] perf_counter: update mmap() counter read, take 2
Content-Disposition: inline; filename=perf_counter-mmap_counter_read.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the userspace read method.

Paul noted that:
 - userspace cannot observe ->lock & 1 on the same cpu.
 - we need a barrier() between reading ->lock and ->index
   to ensure we read them in that prticular order.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -170,22 +170,18 @@ struct perf_counter_mmap_page {
 	 *   u32 seq;
 	 *   s64 count;
 	 *
-	 * again:
-	 *   seq = pc->lock;
-	 *   if (unlikely(seq & 1)) {
-	 *     cpu_relax();
-	 *     goto again;
-	 *   }
+	 *   do {
+	 *     seq = pc->lock;
 	 *
-	 *   if (pc->index) {
-	 *     count = pmc_read(pc->index - 1);
-	 *     count += pc->offset;
-	 *   } else
-	 *     goto regular_read;
+	 *     barrier()
+	 *     if (pc->index) {
+	 *       count = pmc_read(pc->index - 1);
+	 *       count += pc->offset;
+	 *     } else
+	 *       goto regular_read;
 	 *
-	 *   barrier();
-	 *   if (pc->lock != seq)
-	 *     goto again;
+	 *     barrier();
+	 *   } while (pc->lock != seq);
 	 *
 	 * NOTE: for obvious reason this only works on self-monitoring
 	 *       processes.

-- 

