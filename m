Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYJNGZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYJNGZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYJNGZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:25:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:60477 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYJNGZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=fvGD/xJlk3rOXtGCf3ffGtEBMGqBjivstwWNUr9a+6sY5fU94ZJTEk9LT3IZwtCiTS
         a5h2DXlJHkUjCgmuxCPg/OWKgJh/2gyXok/dnXpd4USrx+snKKBxmxWOK9op7GaG+mKw
         L8Te9csxMbHJr/YNnTs2re8lOFQKT+4ZrNkuw=
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86: 64 bit print out absent pages num too
Date: Mon, 13 Oct 2008 23:24:43 -0700
Message-Id: <1223965483-8202-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so users are not confused with memhole causing big total ram

we don't need to worry about 32 bit, because memhole is always
above max_low_pfn.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -878,6 +878,7 @@ static struct kcore_list kcore_mem, kcor
 void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
+	unsigned long absent_pages;
 
 	start_periodic_check_for_corruption();
 
@@ -893,8 +894,9 @@ void __init mem_init(void)
 #else
 	totalram_pages = free_all_bootmem();
 #endif
-	reservedpages = max_pfn - totalram_pages -
-					absent_pages_in_range(0, max_pfn);
+
+	absent_pages = absent_pages_in_range(0, max_pfn);
+	reservedpages = max_pfn - totalram_pages - absent_pages;
 	after_bootmem = 1;
 
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
@@ -911,10 +913,11 @@ void __init mem_init(void)
 				 VSYSCALL_END - VSYSCALL_START);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
-				"%ldk reserved, %ldk data, %ldk init)\n",
+			 "%ldk absent, %ldk reserved, %ldk data, %ldk init)\n",
 		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
 		max_pfn << (PAGE_SHIFT-10),
 		codesize >> 10,
+		absent_pages << (PAGE_SHIFT-10),
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
 		initsize >> 10);
