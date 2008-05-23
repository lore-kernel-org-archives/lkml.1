Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYEWNo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYEWNo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYEWNoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:20 -0400
Received: from gw.goop.org ([64.81.55.164]:53231 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbYEWNoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:17 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 12] xen: add configurable max domain size
X-Mercurial-Node: 7ba28dacb6419ebd6cbe4e894dca2ff1ce1b0a2e
Message-Id: <7ba28dacb6419ebd6cbe.1211550069@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:09 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a config option to set the max size of a Xen domain.  This is used
to scale the size of the physical-to-machine array; it ends up using
around 1 page/GByte, so there's no reason to be very restrictive.

For a 32-bit guest, the default value of 8GB is probably sufficient;
there's not much point in giving a 32-bit machine much more memory
than that.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig       |   10 ++++++++++
 arch/x86/xen/mmu.c         |   25 ++++++++++++-------------
 arch/x86/xen/setup.c       |    3 +++
 include/asm-x86/xen/page.h |    5 +++++
 4 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -11,3 +11,13 @@
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
 	  Xen hypervisor.
+
+config XEN_MAX_DOMAIN_MEMORY
+       int "Maximum allowed size of a domain in gigabytes"
+       default 8
+       depends on XEN
+       help
+         The pseudo-physical to machine address array is sized
+         according to the maximum possible memory size of a Xen
+         domain.  This array uses 1 page per gigabyte, so there's no
+         need to be too stingy here.
\ No newline at end of file
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -56,19 +56,13 @@
 #include "multicalls.h"
 #include "mmu.h"
 
-/*
- * This should probably be a config option.  On 32-bit, it costs 1
- * page/gig of memory; on 64-bit its 2 pages/gig.  If we want it to be
- * completely unbounded we can add another level to the p2m structure.
- */
-#define MAX_GUEST_PAGES		(16ull * 1024*1024*1024 / PAGE_SIZE)
 #define P2M_ENTRIES_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long))
 
-static unsigned long *p2m_top[MAX_GUEST_PAGES / P2M_ENTRIES_PER_PAGE];
+static unsigned long *p2m_top[MAX_DOMAIN_PAGES / P2M_ENTRIES_PER_PAGE];
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
-	BUG_ON(pfn >= MAX_GUEST_PAGES);
+	BUG_ON(pfn >= MAX_DOMAIN_PAGES);
 	return pfn / P2M_ENTRIES_PER_PAGE;
 }
 
@@ -81,12 +75,9 @@
 {
 	unsigned pfn;
 	unsigned long *mfn_list = (unsigned long *)xen_start_info->mfn_list;
+	unsigned long max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
 
-	BUG_ON(xen_start_info->nr_pages >= MAX_GUEST_PAGES);
-
-	for(pfn = 0;
-	    pfn < xen_start_info->nr_pages;
-	    pfn += P2M_ENTRIES_PER_PAGE) {
+	for(pfn = 0; pfn < max_pfn; pfn += P2M_ENTRIES_PER_PAGE) {
 		unsigned topidx = p2m_top_index(pfn);
 
 		p2m_top[topidx] = &mfn_list[pfn];
@@ -96,6 +87,9 @@
 unsigned long get_phys_to_machine(unsigned long pfn)
 {
 	unsigned topidx, idx;
+
+	if (unlikely(pfn >= MAX_DOMAIN_PAGES))
+		return INVALID_P2M_ENTRY;
 
 	topidx = p2m_top_index(pfn);
 	if (p2m_top[topidx] == NULL)
@@ -126,6 +120,11 @@
 
 	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
 		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return;
+	}
+
+	if (unlikely(pfn >= MAX_DOMAIN_PAGES)) {
+		BUG_ON(mfn != INVALID_P2M_ENTRY);
 		return;
 	}
 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -16,6 +16,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
+#include <xen/page.h>
 #include <xen/interface/callback.h>
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
@@ -35,6 +36,8 @@
 char * __init xen_memory_setup(void)
 {
 	unsigned long max_pfn = xen_start_info->nr_pages;
+
+	max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
 
 	e820.nr_map = 0;
 	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -25,6 +25,11 @@
 #define INVALID_P2M_ENTRY	(~0UL)
 #define FOREIGN_FRAME_BIT	(1UL<<31)
 #define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
+
+/* Maximum amount of memory we can handle in a domain in pages */
+#define MAX_DOMAIN_PAGES						\
+    ((unsigned long)((u64)CONFIG_XEN_MAX_DOMAIN_MEMORY * 1024 * 1024 * 1024 / PAGE_SIZE))
+
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern void set_phys_to_machine(unsigned long pfn, unsigned long mfn);


