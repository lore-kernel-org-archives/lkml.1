Return-Path: <linux-kernel-owner+w=401wt.eu-S1761058AbZEHLNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058AbZEHLNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbZEHLMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:12:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:58922 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbZEHLMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,316,1239001200"; 
   d="scan'208";a="140664191"
Message-Id: <20090508111032.121067794@intel.com>
References: <20090508105320.316173813@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:53:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: <linux-mm@kvack.org>
Subject: [PATCH 8/8] pagemap: export PG_hwpoison
Content-Disposition: inline; filename=kpageflags-hwpoison.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag indicates a hardware detected memory corruption on the page.
Any future access of the page data may bring down the machine.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |    2 ++
 Documentation/vm/pagemap.txt  |    4 ++++
 fs/proc/page.c                |    5 +++++
 3 files changed, 11 insertions(+)

--- linux.orig/fs/proc/page.c
+++ linux/fs/proc/page.c
@@ -92,6 +92,7 @@ static const struct file_operations proc
 #define KPF_COMPOUND_TAIL	16
 #define KPF_HUGE		17
 #define KPF_UNEVICTABLE		18
+#define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
 
 /* kernel hacking assistances
@@ -171,6 +172,10 @@ static u64 get_uflags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_SWAPCACHE,	PG_swapcache);
 	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
+#endif
+
 #ifdef CONFIG_UNEVICTABLE_LRU
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
--- linux.orig/Documentation/vm/page-types.c
+++ linux/Documentation/vm/page-types.c
@@ -47,6 +47,7 @@
 #define KPF_COMPOUND_TAIL	16
 #define KPF_HUGE		17
 #define KPF_UNEVICTABLE		18
+#define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
 
 /* [32-] kernel hacking assistances */
@@ -94,6 +95,7 @@ static char *page_flag_names[] = {
 	[KPF_COMPOUND_TAIL]	= "T:compound_tail",
 	[KPF_HUGE]		= "G:huge",
 	[KPF_UNEVICTABLE]	= "u:unevictable",
+	[KPF_HWPOISON]		= "X:hwpoison",
 	[KPF_NOPAGE]		= "n:nopage",
 
 	[KPF_RESERVED]		= "r:reserved",
--- linux.orig/Documentation/vm/pagemap.txt
+++ linux/Documentation/vm/pagemap.txt
@@ -57,6 +57,7 @@ There are three components to pagemap:
     16. COMPOUND_TAIL
     16. HUGE
     18. UNEVICTABLE
+    19. HWPOISON
     20. NOPAGE
 
 Short descriptions to the page flags:
@@ -86,6 +87,9 @@ Short descriptions to the page flags:
 17. HUGE
     this is an integral part of a HugeTLB page
 
+19. HWPOISON
+    hardware detected memory corruption on this page: don't touch the data!
+
 20. NOPAGE
     no page frame exists at the requested address
 

-- 

