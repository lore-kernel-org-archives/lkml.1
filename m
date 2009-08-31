Return-Path: <linux-kernel-owner+w=401wt.eu-S1751046AbZHaHOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbZHaHOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZHaHOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:14:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:41424 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZHaHOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:14:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182254776"
Date: Mon, 31 Aug 2009 15:14:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] pagemap: export KPF_HWPOISON
Message-ID: <20090831071425.GA26634@localhost>
References: <20090808173900.GA21009@feather> <20090812065107.GA16363@localhost> <20090831135720.5E53.A69D9226@jp.fujitsu.com> <20090831065659.GA18039@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831065659.GA18039@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
 
