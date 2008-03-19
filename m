Return-Path: <linux-kernel-owner+w=401wt.eu-S936088AbYCSWh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936088AbYCSWh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764320AbYCSVJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:09:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:65077 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936316AbYCSVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=KTdCqSxc116IKZKtnWPSB63Mc8UmsHjyDG16cjkT8i5lgl/olf5+iAk0vtE3S0vR+W5X47LFx+E8TrOYML5rFAznecSP3TIRjqqlVE3+2kP5uPThGQo63OBUCqw6eWnomONXsw3bb3+Q0U8Qg/QgAKBj/BF6KgpeuDhxSLPrdaw=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 10/12] x86_64: make reserve_bootmem_generic to use new reserve_bootmem
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2362
Date: Wed, 19 Mar 2008 14:04:48 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191404.48211.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: make reserve_bootmem_generic to use new reserve_bootmem

	[PATCH] mm: make reserve_bootmem can crossed the nodes

provides new resever_bootmem, let reserve_bootmem_generic use that.

acctualy reserve_bootme_generic is used to reserve initramdisk.
so we can make sure even bootloader or kexec load that cross the nodes, reserve_bootmem
still works.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -648,7 +648,7 @@ void free_initrd_mem(unsigned long start
 void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 {
 #ifdef CONFIG_NUMA
-	int nid = phys_to_nid(phys);
+	int nid, next_nid;
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
 
@@ -667,10 +667,14 @@ void __init reserve_bootmem_generic(unsi
 
 	/* Should check here against the e820 map to avoid double free */
 #ifdef CONFIG_NUMA
+	nid = phys_to_nid(phys);
+	next_nid = phys_to_nid(phys + len - 1);
+	if (nid == next_nid)
 	reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
-#else
-	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+	else
 #endif
+	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
 		set_dma_reserve(dma_reserve);
