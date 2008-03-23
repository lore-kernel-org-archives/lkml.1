Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYCWHOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYCWHOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 03:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYCWHOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 03:14:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:1584 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYCWHOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 03:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=uPZeMTv146sDyCWsVIymlEPXo4WVpjAjKltR0TLG8coSnptM0RaMf9uvPS1vueyc9MewVabYnMxWZitcAi8CEYjRap2ysT/lhHUh54hYktln9Hb7k+vWPQUCuh0F3oyUC3ndaKfJZc+LBfIcalUdH8Kgf61NYDDYKTQqyAdgreg=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] x86_32: fix trim mtrr not to setup_memory two times
Date: Sun, 23 Mar 2008 00:16:49 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803230016.50063.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we could call find_max_pfn() directly instead of setup_memory() to get
max_pfn needed for mtrr trimming.

otherwise setup_mempry is called two times... that is duplicated...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -448,8 +448,6 @@ static unsigned long __init setup_memory
 	 */
 	min_low_pfn = PFN_UP(init_pg_tables_end);
 
-	find_max_pfn();
-
 	max_low_pfn = find_max_low_pfn();
 
 #ifdef CONFIG_HIGHMEM
@@ -811,12 +809,13 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
-	max_low_pfn = setup_memory();
-
 	/* update e820 for memory not covered by WB MTRRs */
+	find_max_pfn();
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(max_pfn))
-		max_low_pfn = setup_memory();
+		find_max_pfn();
+
+	max_low_pfn = setup_memory();
 
 #ifdef CONFIG_VMI
 	/*
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -324,7 +324,6 @@ unsigned long __init setup_memory(void)
 	 * this space and use it to adjust the boundary between ZONE_NORMAL
 	 * and ZONE_HIGHMEM.
 	 */
-	find_max_pfn();
 	get_memcfg_numa();
 
 	kva_pages = calculate_numa_remap_pages();
