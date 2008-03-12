Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbYCLCyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbYCLCyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYCLCxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:53:33 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:25921 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYCLCxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:53:32 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080312353.598285931@firstfloor.org>
In-Reply-To: <20080312353.598285931@firstfloor.org>
To: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [4/7] Don't use large pages to map the first 2/4MB of memory
Message-Id: <20080312025330.AC1961B41D1@basil.firstfloor.org>
Date: Wed, 12 Mar 2008 03:53:30 +0100 (CET)
X-OriginalArrivalTime: 12 Mar 2008 02:46:58.0582 (UTC) FILETIME=[57554B60:01C883EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Intel recommends to not use large pages for the first 1MB 
of the physical memory because there are fixed size MTRRs there
which cause splitups in the TLBs.

On AMD doing so is also a good idea.

The implementation is a little different between 32bit and 64bit.
On 32bit I just taught the initial page table set up about this
because it was very simple to do. This also has the advantage
that the risk of a prefetch ever seeing the page even
if it only exists for a short time is minimized.

On 64bit that is not quite possible, so use set_memory_4k() a little
later (in check_bugs) instead.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/bugs_64.c |   12 ++++++++++++
 arch/x86/mm/init_32.c     |    6 +++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/bugs_64.c
===================================================================
--- linux.orig/arch/x86/kernel/bugs_64.c
+++ linux/arch/x86/kernel/bugs_64.c
@@ -9,6 +9,7 @@
 #include <asm/bugs.h>
 #include <asm/processor.h>
 #include <asm/mtrr.h>
+#include <asm/cacheflush.h>
 
 void __init check_bugs(void)
 {
@@ -18,4 +19,15 @@ void __init check_bugs(void)
 	print_cpu_info(&boot_cpu_data);
 #endif
 	alternative_instructions();
+
+	/*
+	 * Make sure the first 2MB area is not mapped by huge pages
+	 * There are typically fixed size MTRRs in there and overlapping
+	 * MTRRs into large pages causes slow downs.
+	 *
+	 * Right now we don't do that with gbpages because there seems
+	 * very little benefit for that case.
+	 */
+	if (!direct_gbpages)
+		set_memory_4k((unsigned long)__va(0), 1);
 }
Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -181,8 +181,13 @@ static void __init kernel_physical_mappi
 			/*
 			 * Map with big pages if possible, otherwise
 			 * create normal page tables:
+			 *
+			 * Don't use a large page for the first 2/4MB of memory
+			 * because there are often fixed size MTRRs in there
+			 * and overlapping MTRRs into large pages can cause
+			 * slowdowns.
 			 */
-			if (cpu_has_pse) {
+			if (cpu_has_pse && !(pgd_idx == 0 && pmd_idx == 0)) {
 				unsigned int addr2;
 				pgprot_t prot = PAGE_KERNEL_LARGE;
 
