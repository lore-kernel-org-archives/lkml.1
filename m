Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYFBHAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYFBHAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYFBHAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:00:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:12468 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYFBHAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oGV1LQlq952WaHLspFyvFT3BNcOznSEM8L1AS9Bx75Bt6qiSMLfFbHPCZBwDbW5DMPdNRFbxOjn7ZxeYX2sup1ixeJRkFMX00ijlSSv4MB6AHKSsYDwE/GVL4r75HnWglB6avPS8nVRhcc33fBrUJ+DIRKld42CDQnABOD7rgFU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: cleanup max_pfn_mapped usage - 64bit
Date: Sun, 1 Jun 2008 23:55:37 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805291625.56942.yhlu.kernel@gmail.com> <200806012106.31650.yhlu.kernel@gmail.com>
In-Reply-To: <200806012106.31650.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806012355.37334.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


64bit only after init_memory_mapping, we get valid max_pfn_mapped.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -55,16 +55,12 @@ unsigned long __init e820_end_of_ram(voi
 
 	last_pfn = find_max_pfn_with_active_regions();
 
-	if (last_pfn > max_pfn_mapped)
-		max_pfn_mapped = last_pfn;
-	if (max_pfn_mapped > MAXMEM>>PAGE_SHIFT)
-		max_pfn_mapped = MAXMEM>>PAGE_SHIFT;
+	if (last_pfn > MAXMEM>>PAGE_SHIFT)
+		last_pfn = MAXMEM>>PAGE_SHIFT;
 	if (last_pfn > end_user_pfn)
 		last_pfn = end_user_pfn;
-	if (last_pfn > max_pfn_mapped)
-		last_pfn = max_pfn_mapped;
 
-	printk(KERN_INFO "max_pfn_mapped = %lu\n", max_pfn_mapped);
+	printk(KERN_INFO "last_pfn = %lu\n", last_pfn);
 	return last_pfn;
 }
 
@@ -109,10 +105,6 @@ static int __init e820_find_active_regio
 	if (*ei_startpfn >= *ei_endpfn)
 		return 0;
 
-	/* Check if max_pfn_mapped should be updated */
-	if (ei->type != E820_RAM && *ei_endpfn > max_pfn_mapped)
-		max_pfn_mapped = *ei_endpfn;
-
 	/* Skip if map is outside the node */
 	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
 				    *ei_startpfn >= last_pfn)
@@ -229,7 +221,6 @@ static int __init parse_memmap_opt(char 
 		saved_max_pfn = e820_end_of_ram();
 		remove_all_active_ranges();
 #endif
-		max_pfn_mapped = 0;
 		e820.nr_map = 0;
 		userdef = 1;
 		return 0;
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -388,7 +388,7 @@ void __init setup_arch(char **cmdline_p)
 
 	check_efer();
 
-	max_pfn_mapped = init_memory_mapping(0, (max_pfn_mapped << PAGE_SHIFT));
+	max_pfn_mapped = init_memory_mapping(0, (end_pfn << PAGE_SHIFT));
 	if (efi_enabled)
 		efi_init();
 
