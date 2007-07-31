Return-Path: <linux-kernel-owner+w=401wt.eu-S1761568AbXGaX0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568AbXGaX0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbXGaXZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:25:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46230 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754819AbXGaXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:25:13 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 5/7] Simple Performance Counters: __alloc_pages instrumentation
Date: Tue, 31 Jul 2007 16:25:10 -0700
Message-Id: <11859243121375-git-send-email-clameter@sgi.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: simple-perf-counters
References: simple-perf-counters
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instrument __alloc_pages with a performance counter.

Allows the investigation of various allocation scenarios on page allocator
performance.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/perf.h |    1 +
 kernel/perf.c        |    1 +
 mm/page_alloc.c      |    3 +++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf.h b/include/linux/perf.h
index 2958c81..795b7ec 100644
--- a/include/linux/perf.h
+++ b/include/linux/perf.h
@@ -15,6 +15,7 @@
 
 enum pc_item {
 	PC_UPDATE_PROCESS_TIMES,
+	PC_ALLOC_PAGES,
 	NR_PC_ITEMS
 };
 
diff --git a/kernel/perf.c b/kernel/perf.c
index 14cba9c..dd4e850 100644
--- a/kernel/perf.c
+++ b/kernel/perf.c
@@ -22,6 +22,7 @@ static int unsynced_get_cycles = 1;
 
 const char *var_id[NR_PC_ITEMS] = {
 	"update_process_times",
+	"__alloc_pages"
 };
 
 struct perf_counter {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3da85b8..69d34b7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -41,6 +41,7 @@
 #include <linux/pfn.h>
 #include <linux/backing-dev.h>
 #include <linux/fault-inject.h>
+#include <linux/perf.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1223,6 +1224,7 @@ struct page * fastcall
 __alloc_pages(gfp_t gfp_mask, unsigned int order,
 		struct zonelist *zonelist)
 {
+	INIT_PC(pc);
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct zone **z;
 	struct page *page;
@@ -1387,6 +1389,7 @@ nopage:
 		show_mem();
 	}
 got_pg:
+	pc_bytes(&pc, PAGE_SIZE << order, PC_ALLOC_PAGES);
 	return page;
 }
 
-- 
1.5.2.4

