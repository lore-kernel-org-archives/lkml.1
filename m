Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbZDNP4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbZDNP4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZDNPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46015 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbZDNPvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:52 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 13/14] [VOYAGER] x86/voyager: remove direct use of pg0 in favour of early_ioremap()
Date: Tue, 14 Apr 2009 10:51:39 -0500
Message-Id: <1239724300-16371-14-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-13-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-12-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-13-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was a hold over from the days when we didn't actually have an
early_ioremap() and we had to fiddle with the kernel page table
directly to read voyager cmos clickmap entries.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_basic.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_basic.c b/arch/x86/mach-voyager/voyager_basic.c
index 7c97c9a..5d37967 100644
--- a/arch/x86/mach-voyager/voyager_basic.c
+++ b/arch/x86/mach-voyager/voyager_basic.c
@@ -123,7 +123,6 @@ int __init voyager_memory_detect(int region, __u32 * start, __u32 * length)
 	__u8 cmos[4];
 	ClickMap_t *map;
 	unsigned long map_addr;
-	unsigned long old;
 
 	if (region >= CLICK_ENTRIES) {
 		printk("Voyager: Illegal ClickMap region %d\n", region);
@@ -135,13 +134,7 @@ int __init voyager_memory_detect(int region, __u32 * start, __u32 * length)
 		    voyager_extended_cmos_read(VOYAGER_MEMORY_CLICKMAP + i);
 
 	map_addr = *(unsigned long *)cmos;
-
-	/* steal page 0 for this */
-	old = pg0[0];
-	pg0[0] = ((map_addr & PAGE_MASK) | _PAGE_RW | _PAGE_PRESENT);
-	local_flush_tlb();
-	/* now clear everything out but page 0 */
-	map = (ClickMap_t *) (map_addr & (~PAGE_MASK));
+	map = (ClickMap_t *)early_ioremap(map_addr, sizeof(*map));
 
 	/* zero length is the end of the clickmap */
 	if (map->Entry[region].Length != 0) {
@@ -149,10 +142,8 @@ int __init voyager_memory_detect(int region, __u32 * start, __u32 * length)
 		*start = map->Entry[region].Address;
 		retval = 1;
 	}
+	early_iounmap(map, sizeof(*map));
 
-	/* replace the mapping */
-	pg0[0] = old;
-	local_flush_tlb();
 	return retval;
 }
 
-- 
1.6.2.1

