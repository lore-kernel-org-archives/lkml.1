Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYACR25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYACR25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYACR1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:27:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:59048 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbYACR1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:27:04 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103626.635376000@suse.de>
In-Reply-To: <20080103626.635376000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [6/8] GBPAGES: Add an option to disable direct mapping gbpages and a global variable
Message-Id: <20080103172703.100C014DDD@wotan.suse.de>
Date: Thu,  3 Jan 2008 18:27:03 +0100 (CET)
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
@@ -57,6 +57,18 @@ static unsigned long dma_reserve __initd
 
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
@@ -408,6 +408,8 @@ static inline pte_t pte_modify(pte_t pte
 	__changed;							  \
 })
 
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
