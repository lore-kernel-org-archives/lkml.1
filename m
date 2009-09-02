Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbZIBECk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbZIBECk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 00:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbZIBECj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 00:02:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:38152 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZIBECi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 00:02:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183082194"
Message-Id: <20090902035814.717915674@intel.com>
References: <20090902034125.718886329@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Sep 2009 11:41:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Lameter <cl@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Chris Wright <chrisw@redhat.com>
CC: "Huang, Ying" <ying.huang@intel.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Josh Triplett <josh@joshtriplett.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
cc: linux-mm@kvack.org
Subject: [RFC][PATCH 3/4] pagemap: export KPF_HWPOISON
Content-Disposition: inline; filename=kpageflags-hwpoison.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag indicates a hardware detected memory corruption on the page.
Any future access of the page data may bring down the machine.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/pagemap.txt |    4 ++++
 fs/proc/page.c               |    5 +++++
 tools/vm/page-types.c        |    2 ++
 3 files changed, 11 insertions(+)

--- linux-mm.orig/fs/proc/page.c	2009-08-31 13:58:19.000000000 +0800
+++ linux-mm/fs/proc/page.c	2009-08-31 14:59:08.000000000 +0800
@@ -94,6 +94,7 @@ static const struct file_operations proc
 #define KPF_COMPOUND_TAIL	16
 #define KPF_HUGE		17
 #define KPF_UNEVICTABLE		18
+#define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
 
 #define KPF_KSM			21
@@ -180,6 +181,10 @@ static u64 get_uflags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
+#endif
+
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	u |= kpf_copy_bit(k, KPF_UNCACHED,	PG_uncached);
 #endif
--- linux-mm.orig/tools/vm/page-types.c	2009-08-31 13:58:19.000000000 +0800
+++ linux-mm/tools/vm/page-types.c	2009-08-31 14:59:08.000000000 +0800
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
--- linux-mm.orig/Documentation/vm/pagemap.txt	2009-08-31 13:58:19.000000000 +0800
+++ linux-mm/Documentation/vm/pagemap.txt	2009-08-31 14:59:08.000000000 +0800
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

