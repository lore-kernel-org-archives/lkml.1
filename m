Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYFWKFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYFWKFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYFWKFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:05:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:16186 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYFWKFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WS3HFOU9XzLEWj3Yz6l57Nyh65by7wPsUkTzqz29SV6sGVaBTqrStPxKkQP22Hitjf
         uOaOZ1JhzT99+t2UIlbMI/JYYrkcAWFF0TwfXCdEvEHsPWZBcMhNidoDUkr3pYDUfC/G
         GF2iUv9g/tfvKoORFJzBQEnxP3EFMkf5KRYb8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: cleanup min_low_pfn
Date: Mon, 23 Jun 2008 03:06:14 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806220245.39289.yhlu.kernel@gmail.com> <200806220246.58958.yhlu.kernel@gmail.com>
In-Reply-To: <200806220246.58958.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230306.14276.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for 32bit
we already had early_res support, so don't need to track min_low_pfn.
keep it to 0 always.

also use init_bootmem_node instead of init_bootmem, so don't touch
min_low_pfn.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/init_32.c |   10 ++++------
 arch/x86/mm/init_64.c |    4 +++-
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -565,11 +565,7 @@ void __init find_low_pfn_range(void)
 {
 	/* it could update max_pfn */
 
-	/*
-	 * partially used pages are not usable - thus
-	 * we are rounding upwards:
-	 */
-	min_low_pfn = PFN_UP(init_pg_tables_end);
+	/* max_low_pfn is 0, we already have early_res support */
 
 	max_low_pfn = max_pfn;
 	if (max_low_pfn > MAXMEM_PFN) {
@@ -694,7 +690,9 @@ void __init setup_bootmem_allocator(void
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
 
-	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
+	/* don't touch min_low_pfn */
+	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
+					 min_low_pfn, max_low_pfn);
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -633,7 +633,9 @@ void __init initmem_init(unsigned long s
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
-	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
+	/* don't touch min_low_pfn */
+	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
+					 0, end_pfn);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
 	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
