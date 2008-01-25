Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYAYFWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYAYFWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYAYFWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:22:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:3909 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYAYFWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:22:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="329720567"
Subject: [PATCH] x86: ioremap_nocache fix
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 13:22:41 +0800
Message-Id: <1201238561.15972.17.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 05:21:58.0592 (UTC) FILETIME=[3527F400:01C85F12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug of ioremap_nocache. ioremap_nocache() will call
__ioremap() with flags != 0 to do the real work, which will call
change_page_attr_addr() if phys_addr + size - 1 < (end_pfn_map << PAGE_SHIFT).
But some pages between 0 ~ end_pfn_map << PAGE_SHIFT are not mapped by 
identity map, this will make change_page_attr_addr failed.

This patch is based on latest x86 git and has been tested on x86_64 platform.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/ioremap_64.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/mm/ioremap_64.c
+++ b/arch/x86/mm/ioremap_64.c
@@ -41,8 +41,15 @@ ioremap_change_attr(unsigned long phys_a
 	if (phys_addr + size - 1 < (end_pfn_map << PAGE_SHIFT)) {
 		unsigned long npages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		unsigned long vaddr = (unsigned long) __va(phys_addr);
+		int level;
 
 		/*
+		 * If there is no identity map for this address,
+		 * change_page_attr_addr is unnecessary
+		 */
+		if (!lookup_address(vaddr, &level))
+			return err;
+		/*
  		 * Must use a address here and not struct page because the phys addr
 		 * can be a in hole between nodes and not have an memmap entry.
 		 */

