Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYEWNqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYEWNqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYEWNoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:22 -0400
Received: from gw.goop.org ([64.81.55.164]:53234 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbYEWNoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:19 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 12] xen: efficiently support a holey p2m table
X-Mercurial-Node: 87258f679408de6918842b767490dfb300ed5552
Message-Id: <87258f679408de691884.1211550070@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:10 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using sparsemem and memory hotplug, the kernel's pseudo-physical
address space can be discontigious.  Previously this was dealt with by
having the upper parts of the radix tree stubbed off.  Unfortunately,
this is incompatible with save/restore, which requires a complete p2m
table.

The solution is to have a special distinguished all-invalid p2m leaf
page, which we can point all the hole areas at.  This allows the tools
to see a complete p2m table, but it only costs a page for all memory
holes.

It also simplifies the code since it removes a few special cases.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -57,8 +57,17 @@
 #include "mmu.h"
 
 #define P2M_ENTRIES_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long))
+#define TOP_ENTRIES		(MAX_DOMAIN_PAGES / P2M_ENTRIES_PER_PAGE)
 
-static unsigned long *p2m_top[MAX_DOMAIN_PAGES / P2M_ENTRIES_PER_PAGE];
+/* Placeholder for holes in the address space */
+static unsigned long p2m_missing[P2M_ENTRIES_PER_PAGE]
+	__attribute__((section(".data.page_aligned"))) =
+		{ [ 0 ... P2M_ENTRIES_PER_PAGE-1 ] = ~0UL };
+
+ /* Array of pointers to pages containing p2m entries */
+static unsigned long *p2m_top[TOP_ENTRIES]
+	__attribute__((section(".data.page_aligned"))) =
+		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
@@ -92,9 +101,6 @@
 		return INVALID_P2M_ENTRY;
 
 	topidx = p2m_top_index(pfn);
-	if (p2m_top[topidx] == NULL)
-		return INVALID_P2M_ENTRY;
-
 	idx = p2m_index(pfn);
 	return p2m_top[topidx][idx];
 }
@@ -110,7 +116,7 @@
 	for(i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
 		p[i] = INVALID_P2M_ENTRY;
 
-	if (cmpxchg(pp, NULL, p) != NULL)
+	if (cmpxchg(pp, p2m_missing, p) != p2m_missing)
 		free_page((unsigned long)p);
 }
 
@@ -129,7 +135,7 @@
 	}
 
 	topidx = p2m_top_index(pfn);
-	if (p2m_top[topidx] == NULL) {
+	if (p2m_top[topidx] == p2m_missing) {
 		/* no need to allocate a page to store an invalid entry */
 		if (mfn == INVALID_P2M_ENTRY)
 			return;


