Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbXHULN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbXHULN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbXHULNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:13:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59672 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbXHULNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:13:17 -0400
Date: Tue, 21 Aug 2007 20:15:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "tony.luck@intel.com" <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: [PATCH][2.6.23-rc2-mm2] small fix for ia64 icache sync patch
Message-Id: <20070821201507.36641d76.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing 2 small issues pointed by Tony Luck.

* removing redundant BUG_ON in __ia64_sync_icache_dcache().
* check pte_present() first.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 arch/ia64/mm/init.c        |    2 --
 include/asm-ia64/pgtable.h |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6.23-rc2-mm2/include/asm-ia64/pgtable.h
===================================================================
--- linux-2.6.23-rc2-mm2.orig/include/asm-ia64/pgtable.h
+++ linux-2.6.23-rc2-mm2/include/asm-ia64/pgtable.h
@@ -327,8 +327,8 @@ ia64_phys_addr_valid (unsigned long addr
 extern void __ia64_sync_icache_dcache(pte_t pteval);
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {
-	if (pte_exec(pteval) &&    // flush only new executable page.
-	    pte_present(pteval) && // swap out ?
+	if (pte_present(pteval) &&// swap out ?
+	    pte_exec(pteval) &&    // flush only new executable page.
 	    pte_user(pteval) &&    // ignore kernel page
 	    (!pte_present(*ptep) ||// do_no_page or swap in, migration,
 		pte_pfn(*ptep) != pte_pfn(pteval))) // do_wp_page(), page copy
Index: linux-2.6.23-rc2-mm2/arch/ia64/mm/init.c
===================================================================
--- linux-2.6.23-rc2-mm2.orig/arch/ia64/mm/init.c
+++ linux-2.6.23-rc2-mm2/arch/ia64/mm/init.c
@@ -60,8 +60,6 @@ __ia64_sync_icache_dcache (pte_t pte)
 	struct page *page;
 	unsigned long order;
 
-	BUG_ON(!pte_exec(pte));
-
 	page = pte_page(pte);
 	addr = (unsigned long) page_address(page);
 

