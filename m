Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbYHKTza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbYHKTza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYHKTzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:55:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:3777 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYHKTzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=rkOCo1fi8TtAtjYKuELDMpLNX21iowgipDb818Bdi5V/BG8lZDjBDNuujK2Y+/TxdR
         77pmdZGTTZe3BD5nCxXQtuGlvQ3S8r5B9AbbSdEywrmtTwidZa4n6GbH+b8+0S5Cx/M1
         C9LJN8vPBJOTckK9JGU2KoC1za0e8RZZmsWrM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: don't call e820_regiter_active_regions if out of range on node
Date: Mon, 11 Aug 2008 12:54:23 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111254.23693.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so don't get warning on 32bit system with 64g more

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/srat_32.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_32.c
+++ linux-2.6/arch/x86/mm/srat_32.c
@@ -178,7 +178,7 @@ void acpi_numa_arch_fixup(void)
  * start of the node, and that the current "end" address is after
  * the previous one.
  */
-static __init void node_read_chunk(int nid, struct node_memory_chunk_s *memory_chunk)
+static __init int node_read_chunk(int nid, struct node_memory_chunk_s *memory_chunk)
 {
 	/*
 	 * Only add present memory as told by the e820.
@@ -189,10 +189,10 @@ static __init void node_read_chunk(int n
 	if (memory_chunk->start_pfn >= max_pfn) {
 		printk(KERN_INFO "Ignoring SRAT pfns: %08lx - %08lx\n",
 			memory_chunk->start_pfn, memory_chunk->end_pfn);
-		return;
+		return -1;
 	}
 	if (memory_chunk->nid != nid)
-		return;
+		return -1;
 
 	if (!node_has_online_mem(nid))
 		node_start_pfn[nid] = memory_chunk->start_pfn;
@@ -202,6 +202,8 @@ static __init void node_read_chunk(int n
 
 	if (node_end_pfn[nid] < memory_chunk->end_pfn)
 		node_end_pfn[nid] = memory_chunk->end_pfn;
+
+	return 0;
 }
 
 int __init get_memcfg_from_srat(void)
@@ -259,7 +261,9 @@ int __init get_memcfg_from_srat(void)
 		printk(KERN_DEBUG
 			"chunk %d nid %d start_pfn %08lx end_pfn %08lx\n",
 		       j, chunk->nid, chunk->start_pfn, chunk->end_pfn);
-		node_read_chunk(chunk->nid, chunk);
+		if (node_read_chunk(chunk->nid, chunk))
+			continue;
+
 		e820_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
