Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbYDDASx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbYDDASx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbYDDASN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:18:13 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:37084
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755510AbYDDASL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:18:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 6] hotplug-memory: use common online_page
X-Mercurial-Node: a2a6c0b2e3fdc19d18b4f011fd81c9e7e55434bd
Message-Id: <a2a6c0b2e3fdc19d18b4.1207267544@localhost>
In-Reply-To: <patchbomb.1207267540@localhost>
Date: Thu, 03 Apr 2008 17:05:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from x86-32, all architectures use an identical online_page.
Define it weakly in mm/memory_hotplug.c so that architectures can
override it if necessary.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/ia64/mm/init.c   |    9 ---------
 arch/powerpc/mm/mem.c |    9 ---------
 arch/sh/mm/init.c     |    9 ---------
 arch/x86/mm/init_64.c |    9 ---------
 mm/memory_hotplug.c   |    9 +++++++++
 5 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -690,15 +690,6 @@
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
-
 int arch_add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat;
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -94,15 +94,6 @@
 EXPORT_SYMBOL(phys_mem_access_prot);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
 
 #ifdef CONFIG_NUMA
 int memory_add_physaddr_to_nid(u64 start)
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -307,15 +307,6 @@
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
-
 int arch_add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -624,15 +624,6 @@
 /*
  * Memory hotplug specific functions
  */
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * Memory is added always to NORMAL zone. This means you will never get
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -145,6 +145,15 @@
 
 	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
 					pgdat->node_start_pfn;
+}
+
+__weak void online_page(struct page *page)
+{
+	ClearPageReserved(page);
+	init_page_count(page);
+	__free_page(page);
+	totalram_pages++;
+	num_physpages++;
 }
 
 static void grow_zone_span(unsigned long start_pfn, unsigned long end_pfn)


