Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbXHQF2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbXHQF2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 01:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbXHQF2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 01:28:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:19273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbXHQF2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 01:28:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,273,1183359600"; 
   d="scan'208";a="280187389"
Subject: [BUGFIX] x86_64: NX bit handling in change_page_attr
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Aug 2007 13:28:38 +0800
Message-Id: <1187328518.28497.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 17 Aug 2007 05:28:07.0341 (UTC) FILETIME=[6470D5D0:01C7E08F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug of change_page_attr/change_page_attr_addr on
Intel x86_64 CPU. After changing page attribute to be executable with
these functions, the page remains un-executable on Intel x86_64
CPU. Because on Intel x86_64 CPU, only if the "NX" bits of all four
level page tables are cleared, the corresponding page is executable
(refer to section 4.13.2 of Intel 64 and IA-32 Architectures Software
Developer's Manual). So, the bug is fixed through clearing the "NX"
bit of PMD when splitting the huge PMD.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

Index: linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c
===================================================================
--- linux-2.6.23-rc2-mm2.orig/arch/x86_64/mm/pageattr.c	2007-08-17 12:50:25.000000000 +0800
+++ linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c	2007-08-17 12:50:48.000000000 +0800
@@ -147,6 +147,7 @@
 			split = split_large_page(address, prot, ref_prot2);
 			if (!split)
 				return -ENOMEM;
+			pgprot_val(ref_prot2) &= ~_PAGE_NX;
 			set_pte(kpte, mk_pte(split, ref_prot2));
 			kpte_page = split;
 		}
