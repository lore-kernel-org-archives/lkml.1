Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYFDChj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYFDChj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYFDCh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:37:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:49899 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYFDChX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xbCiVahHYbkMTh07Q+ulFBuCyWaeWuHKZGzkwSkVVGcu61zNYwIo+rS7xG3aloKGHHcsAOv3w52076Tm80N3Vm271cJ5zyioZ9dE1ueJ7UJ8/jWweYwpltDD4F5H50dvYxqsxQkymE08GVqY53CJwJq6GiZ3SDQuK9dQj8E3OMc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: numa32 make sure get kva space
Date: Tue, 3 Jun 2008 19:32:30 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com>
In-Reply-To: <200806031025.55026.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031932.31376.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when 1/3 user/kernel is used, and less memory is installed, or have big hole
below 4g, max_low_pfn is still using 3g-128m

try to go down from max_low_pfn until get it. otherwise will panic.

need to make 32bit code to use register_e820_active_regions...later

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index e119c53..e8d9a0a 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -306,6 +306,7 @@ unsigned long __init setup_memory(void)
 {
 	int nid;
 	unsigned long system_start_pfn, system_max_low_pfn;
+	long kva_target_pfn;
 
 	/*
 	 * When mapping a NUMA machine we allocate the node_mem_map arrays
@@ -322,11 +323,17 @@ unsigned long __init setup_memory(void)
 	system_start_pfn = min_low_pfn = PFN_UP(init_pg_tables_end);
 
 	system_max_low_pfn = max_low_pfn = find_max_low_pfn();
-	kva_start_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
-	kva_start_pfn = find_e820_area(kva_start_pfn<<PAGE_SHIFT,
-				max_low_pfn<<PAGE_SHIFT,
-				kva_pages<<PAGE_SHIFT,
-				PTRS_PER_PTE<<PAGE_SHIFT) >> PAGE_SHIFT;
+	kva_target_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
+	do {
+		kva_start_pfn = find_e820_area(kva_target_pfn<<PAGE_SHIFT,
+					max_low_pfn<<PAGE_SHIFT,
+					kva_pages<<PAGE_SHIFT,
+					PTRS_PER_PTE<<PAGE_SHIFT) >> PAGE_SHIFT;
+		kva_target_pfn -= PTRS_PER_PTE;
+	} while (kva_start_pfn == -1UL && kva_target_pfn > min_low_pfn);
+
+	if (kva_start_pfn == -1UL)
+		panic("Can not get kva space\n");
 
 	printk("kva_start_pfn ~ %ld find_max_low_pfn() ~ %ld\n",
 		kva_start_pfn, max_low_pfn);
