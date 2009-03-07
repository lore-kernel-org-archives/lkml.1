Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbZCGFex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbZCGFex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZCGFeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:34:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51926 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbZCGFeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:34:44 -0500
Message-ID: <49B2075B.4070509@cn.fujitsu.com>
Date: Sat, 07 Mar 2009 13:34:19 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [tip:x86/fixmap] x86: dont' define __this_fixmap_does_not_exist
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "1b42f51630c7eebce6fb780b480731eb81afd325" defined
__this_fixmap_does_not_exist().
This causes linker can't report error when __this_fixmap_does_not_exist() be
called with not-constant parameter.

Ingo defined __this_fixmap_does_not_exist() because he want to get virt
addresses of fix memory of nest level by non-constant index.
After defining __this_fixmap_does_not_exist(), he made the linker stopped
complaining "undefined symbol".

How to fix:
The fixmaps are fixed, so we can get the four slot virt addresses on link time
and store them to array slot_virt.
Then we can refer the slot_virt with non-constant index.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---
 arch/x86/mm/ioremap.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 433f7bd..d7e329d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -508,13 +508,17 @@ static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 	return &bm_pte[pte_index(addr)];
 }
 
+static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
 void __init early_ioremap_init(void)
 {
 	pmd_t *pmd;
+	int i;
 
 	if (early_ioremap_debug)
 		printk(KERN_INFO "early_ioremap_init()\n");
 
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		slot_virt[i] = fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	memset(bm_pte, 0, sizeof(bm_pte));
 	pmd_populate_kernel(&init_mm, pmd, bm_pte);
@@ -668,9 +672,9 @@ static void __init __iomem *__early_ioremap(unsigned long phys_addr, unsigned lo
 		--nrpages;
 	}
 	if (early_ioremap_debug)
-		printk(KERN_CONT "%08lx + %08lx\n", offset, fix_to_virt(idx0));
+		printk(KERN_CONT "%08lx + %08lx\n", offset, slot_virt[slot]);
 
-	prev_map[slot] = (void __iomem *)(offset + fix_to_virt(idx0));
+	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
 	return prev_map[slot];
 }
 
@@ -738,8 +742,3 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 	}
 	prev_map[slot] = NULL;
 }
-
-void __this_fixmap_does_not_exist(void)
-{
-	WARN_ON(1);
-}
-- 
1.5.3.4


