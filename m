Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbYE2T7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbYE2T7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYE2T7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:59:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:64865 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbYE2T7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pMgo9PsFLyt35BWQQYLRBscTr3U0/RN7zpLLrMjcloaM29pnavqm2TG0F8n5rHpeCbPLQ87KGk992jZtOyCHC/M7q/NmT/g2wuuGGX3WbXtlxSlmbzdA52zEMc4Ek1OM1Uy0FFAEtQ043Che4mgDAsGY0m0/znhMDeZ8h9EtxA4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: extend e820 early_res support 32bit -fix #4
Date: Thu, 29 May 2008 12:57:22 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com>
In-Reply-To: <200805251000.10205.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291257.22456.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


reserve_early pgdata for 32bit numa

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -159,8 +159,13 @@ static void __init allocate_pgdat(int ni
 	if (nid && node_has_online_mem(nid) && node_remap_start_vaddr[nid])
 		NODE_DATA(nid) = (pg_data_t *)node_remap_start_vaddr[nid];
 	else {
-		NODE_DATA(nid) = (pg_data_t *)(pfn_to_kaddr(min_low_pfn));
-		min_low_pfn += PFN_UP(sizeof(pg_data_t));
+		unsigned long pgdat_phys;
+		pgdat_phys = find_e820_area(min_low_pfn<<PAGE_SHIFT,
+				 max_low_pfn<<PAGE_SHIFT, sizeof(pg_data_t),
+				 PAGE_SIZE);
+		NODE_DATA(nid) = (pg_data_t *)(pfn_to_kaddr(pgdat_phys>>PAGE_SHIFT));
+		reserve_early(pgdat_phys, pgdat_phys + sizeof(pg_data_t),
+			      "NODE_DATA");
 	}
 }
 
