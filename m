Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZGJRCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZGJRCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZGJQ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:7787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbZGJQ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777345"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 10/10] x86, PAT: Sanity check remap_pfn_range for RAM region
Date: Fri, 10 Jul 2009 09:57:41 -0700
Message-Id: <c7fcdd4605702db149fb4a8aca0b5b1ef85cdf56.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <d21ca9019989911369192a5f6e3317ef55ac8fb8.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
 <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
 <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
 <5f0d51bf79a36ebb7c65ab0b80e5018438fe8a77.1247162373.git.venkatesh.pallipadi@intel.com>
 <3a66cb82f9810b9ecc942694b1bb23db7fff8ab2.1247162373.git.venkatesh.pallipadi@intel.com>
 <d165be9f92bc753ebe685b66b512a8fd36205d42.1247162373.git.venkatesh.pallipadi@intel.com>
 <9b94ff556a45738ea3bf5756662ed605c2a8f16f.1247162373.git.venkatesh.pallipadi@intel.com>
 <f1bc76700599173408bf67167efc49027d70d98b.1247162373.git.venkatesh.pallipadi@intel.com>
 <d21ca9019989911369192a5f6e3317ef55ac8fb8.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sanity check for remap_pfn_range of RAM regions using
lookup_memtype(). Previously, we did not have anyway to get the type of
RAM memory regions as they were tracked using a single bit in
page_struct (WB, nonWB). Now we can get the actual type from page struct
(WB, WC, UC_MINUS) and make sure the requester gets that type.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index b629f75..a6cace0 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -783,11 +783,29 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 
 	/*
-	 * reserve_pfn_range() doesn't support RAM pages. Maintain the current
-	 * behavior with RAM pages by returning success.
+	 * reserve_pfn_range() for RAM pages. We do not refcount to keep
+	 * track of number of mappings of RAM pages. We can assert that
+	 * the type requested matches the type of first page in the range.
 	 */
-	if (is_ram != 0)
+	if (is_ram) {
+		if (!pat_enabled)
+			return 0;
+
+		flags = lookup_memtype(paddr);
+		if (want_flags != flags) {
+			printk(KERN_WARNING
+			"%s:%d map pfn RAM range req %s for %Lx-%Lx, got %s\n",
+				current->comm, current->pid,
+				cattr_name(want_flags),
+				(unsigned long long)paddr,
+				(unsigned long long)(paddr + size),
+				cattr_name(flags));
+			*vma_prot = __pgprot((pgprot_val(*vma_prot) &
+					      (~_PAGE_CACHE_MASK)) |
+					     flags);
+		}
 		return 0;
+	}
 
 	ret = reserve_memtype(paddr, paddr + size, want_flags, &flags);
 	if (ret)
-- 
1.6.0.6

