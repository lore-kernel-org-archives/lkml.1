Return-Path: <linux-kernel-owner+w=401wt.eu-S934868AbXGZQit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868AbXGZQit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbXGZQfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:35:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934385AbXGZQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:35:00 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] cyclone.c: silly use of volatile, __iomem fixes
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com
Message-Id: <E1IE6Il-0005Kl-Mb@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:34:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


u32* volatile cyclone_timer means volatile auto pointer to u32,
which is clearly not what had been intended (we never even take
the address of that variable, let alone pass it to something that
could change it behind our back).  u32 volatile * is what the
authors apparently wanted to say, but in reality we don't need that
qualifier there at all - it's (properly) only passed to iomem helpers
which takes care of that stuff just fine.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/kernel/cyclone.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
index 2fd96d9..790ef0d 100644
--- a/arch/ia64/kernel/cyclone.c
+++ b/arch/ia64/kernel/cyclone.c
@@ -38,11 +38,11 @@ static struct clocksource clocksource_cyclone = {
 
 int __init init_cyclone_clock(void)
 {
-	u64* reg;
+	u64 __iomem *reg;
 	u64 base;	/* saved cyclone base address */
 	u64 offset;	/* offset from pageaddr to cyclone_timer register */
 	int i;
-	u32* volatile cyclone_timer;	/* Cyclone MPMC0 register */
+	u32 __iomem *cyclone_timer;	/* Cyclone MPMC0 register */
 
 	if (!use_cyclone)
 		return 0;
@@ -51,7 +51,7 @@ int __init init_cyclone_clock(void)
 
 	/* find base address */
 	offset = (CYCLONE_CBAR_ADDR);
-	reg = (u64*)ioremap_nocache(offset, sizeof(u64));
+	reg = ioremap_nocache(offset, sizeof(u64));
 	if(!reg){
 		printk(KERN_ERR "Summit chipset: Could not find valid CBAR"
 				" register.\n");
@@ -69,7 +69,7 @@ int __init init_cyclone_clock(void)
 
 	/* setup PMCC */
 	offset = (base + CYCLONE_PMCC_OFFSET);
-	reg = (u64*)ioremap_nocache(offset, sizeof(u64));
+	reg = ioremap_nocache(offset, sizeof(u64));
 	if(!reg){
 		printk(KERN_ERR "Summit chipset: Could not find valid PMCC"
 				" register.\n");
@@ -81,7 +81,7 @@ int __init init_cyclone_clock(void)
 
 	/* setup MPCS */
 	offset = (base + CYCLONE_MPCS_OFFSET);
-	reg = (u64*)ioremap_nocache(offset, sizeof(u64));
+	reg = ioremap_nocache(offset, sizeof(u64));
 	if(!reg){
 		printk(KERN_ERR "Summit chipset: Could not find valid MPCS"
 				" register.\n");
@@ -93,7 +93,7 @@ int __init init_cyclone_clock(void)
 
 	/* map in cyclone_timer */
 	offset = (base + CYCLONE_MPMC_OFFSET);
-	cyclone_timer = (u32*)ioremap_nocache(offset, sizeof(u32));
+	cyclone_timer = ioremap_nocache(offset, sizeof(u32));
 	if(!cyclone_timer){
 		printk(KERN_ERR "Summit chipset: Could not find valid MPMC"
 				" register.\n");
@@ -110,7 +110,7 @@ int __init init_cyclone_clock(void)
 			printk(KERN_ERR "Summit chipset: Counter not counting!"
 					" DISABLED\n");
 			iounmap(cyclone_timer);
-			cyclone_timer = 0;
+			cyclone_timer = NULL;
 			use_cyclone = 0;
 			return -ENODEV;
 		}
-- 
1.5.3.GIT


