Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbYBAJzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbYBAJzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYBAJxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:24 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:49563 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbYBAJxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:22 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/12] GBPAGES: Add an option to disable direct mapping gbpages and a global variable
Message-Id: <20080201095320.4BC5B1B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:20 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:47:02.0843 (UTC) FILETIME=[65B850B0:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/x86_64/boot-options.txt |    5 +++++
 arch/x86/mm/init_64.c                 |   16 ++++++++++++++++
 include/asm-x86/pgtable_64.h          |    7 +++++++
 3 files changed, 28 insertions(+)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -53,6 +53,22 @@ static unsigned long dma_reserve __initd
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
+enum gbopt direct_gbpages __meminitdata = GBP_DEFAULT;
+
+static int __init parse_direct_gbpages(char *arg)
+{
+	if (!strcmp(arg, "off")) {
+		direct_gbpages = GBP_OFF;
+		return 0;
+	}
+	if (!strcmp(arg, "on")) {
+		direct_gbpages = GBP_ON;
+		return 0;
+	}
+	return -1;
+}
+early_param("direct_gbpages", parse_direct_gbpages);
+
 /*
  * NOTE: pagetable_init alloc all the fixmap pagetables contiguous on the
  * physical space so we can cache the place of the first one and move
Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -239,6 +239,13 @@ static inline int pud_large(pud_t pte)
 
 #define update_mmu_cache(vma,address,pte) do { } while (0)
 
+enum gbopt {
+	GBP_OFF = -1,
+	GBP_DEFAULT,
+	GBP_ON
+};
+extern enum gbopt direct_gbpages;
+
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x3f)
 #define __swp_offset(x)			((x).val >> 8)
Index: linux/Documentation/x86_64/boot-options.txt
===================================================================
--- linux.orig/Documentation/x86_64/boot-options.txt
+++ linux/Documentation/x86_64/boot-options.txt
@@ -307,3 +307,8 @@ Debugging
 			stuck (default)
 
 Miscellaneous
+
+	direct_gbpages=off|on
+		off: Do not use GB pages for kernel direct mapping.
+		on: Use GB pages if hardware supports it, but some heuristic
+		would turn them off.
