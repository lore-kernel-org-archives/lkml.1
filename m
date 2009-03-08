Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZCHSNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZCHSNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZCHSNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:13:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:56479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbZCHSNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:13:11 -0400
Date: Sun, 8 Mar 2009 18:12:32 GMT
From: Wang Chen <wangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, wangchen@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, wangchen@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49B2075B.4070509@cn.fujitsu.com>
References: <49B2075B.4070509@cn.fujitsu.com>
Subject: [tip:x86/fixmap] x86: don't define __this_fixmap_does_not_exist()
Message-ID: <tip-8827247ffcc9e880cbe4705655065cf011265157@git.kernel.org>
Git-Commit-ID: 8827247ffcc9e880cbe4705655065cf011265157
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 18:12:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8827247ffcc9e880cbe4705655065cf011265157
Gitweb:     http://git.kernel.org/tip/8827247ffcc9e880cbe4705655065cf011265157
Author:     "Wang Chen" <wangchen@cn.fujitsu.com>
AuthorDate: Sat, 7 Mar 2009 13:34:19 +0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 17:07:47 +0100

x86: don't define __this_fixmap_does_not_exist()

Impact: improve out-of-range fixmap index debugging

Commit "1b42f51630c7eebce6fb780b480731eb81afd325"
defined the __this_fixmap_does_not_exist() function
with a WARN_ON(1) in it.

This causes the linker to not report an error when
__this_fixmap_does_not_exist() is called with a
non-constant parameter.

Ingo defined __this_fixmap_does_not_exist() because he
wanted to get virt addresses of fix memory of nest level
by non-constant index.

But we can fix this and still keep the link-time check:

We can get the four slot virt addresses on link time and
store them to array slot_virt[].

Then we can then refer the slot_virt with non-constant index,
in the ioremap-leak detection code.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
LKML-Reference: <49B2075B.4070509@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/ioremap.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 62773ab..96786ef 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -504,13 +504,19 @@ static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 	return &bm_pte[pte_index(addr)];
 }
 
+static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
+
 void __init early_ioremap_init(void)
 {
 	pmd_t *pmd;
+	int i;
 
 	if (early_ioremap_debug)
 		printk(KERN_INFO "early_ioremap_init()\n");
 
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		slot_virt[i] = fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
+
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	memset(bm_pte, 0, sizeof(bm_pte));
 	pmd_populate_kernel(&init_mm, pmd, bm_pte);
@@ -577,6 +583,7 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 
 static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
 static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
+
 static int __init check_early_ioremap_leak(void)
 {
 	int count = 0;
@@ -598,7 +605,8 @@ static int __init check_early_ioremap_leak(void)
 }
 late_initcall(check_early_ioremap_leak);
 
-static void __init __iomem *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
+static void __init __iomem *
+__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 {
 	unsigned long offset, last_addr;
 	unsigned int nrpages;
@@ -664,9 +672,9 @@ static void __init __iomem *__early_ioremap(unsigned long phys_addr, unsigned lo
 		--nrpages;
 	}
 	if (early_ioremap_debug)
-		printk(KERN_CONT "%08lx + %08lx\n", offset, fix_to_virt(idx0));
+		printk(KERN_CONT "%08lx + %08lx\n", offset, slot_virt[slot]);
 
-	prev_map[slot] = (void __iomem *)(offset + fix_to_virt(idx0));
+	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
 	return prev_map[slot];
 }
 
@@ -734,8 +742,3 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 	}
 	prev_map[slot] = NULL;
 }
-
-void __this_fixmap_does_not_exist(void)
-{
-	WARN_ON(1);
-}
