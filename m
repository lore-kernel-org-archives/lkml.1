Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbYA2FJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbYA2FJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbYA2FGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:39 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34415 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbYA2FGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:38 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/9] Add an option to disable direct mapping gbpages and a global variable
Message-Id: <20080129050635.B5A7C1B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:35 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:19.0377 (UTC) FILETIME=[D86A7A10:01C86233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/x86_64/boot-options.txt |    3 +++
 arch/x86/mm/init_64.c                 |   12 ++++++++++++
 include/asm-x86/pgtable_64.h          |    2 ++
 3 files changed, 17 insertions(+)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -53,6 +53,18 @@ static unsigned long dma_reserve __initd
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
+int direct_gbpages;
+
+static int __init parse_direct_gbpages(char *arg)
+{
+	if (!strcmp(arg, "off")) {
+		direct_gbpages = -1;
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
@@ -239,6 +239,8 @@ static inline int pud_large(pud_t pte)
 
 #define update_mmu_cache(vma,address,pte) do { } while (0)
 
+extern int direct_gbpages;
+
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x3f)
 #define __swp_offset(x)			((x).val >> 8)
Index: linux/Documentation/x86_64/boot-options.txt
===================================================================
--- linux.orig/Documentation/x86_64/boot-options.txt
+++ linux/Documentation/x86_64/boot-options.txt
@@ -307,3 +307,6 @@ Debugging
 			stuck (default)
 
 Miscellaneous
+
+	direct_gbpages=off
+		Do not use GB pages for kernel direct mapping.
