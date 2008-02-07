Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYBGHcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYBGHcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYBGHb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:31:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:59489 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYBGHb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:31:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=gJhji4Q/cR6N/TxXB7e/1hX8jiuI5aV7K+bCbSjysf3KyK/AGcku5gsBbST2y6IoFUNN9l7Zg7mHU7xFN6ivwRdifEDg9fG4+cEMRZkEApB+F2J2KFb3xLKEqWix9X6EMuUEIhOnFZGn0UPSb9pC9BoVJfk61Dd3Tsq7P0IXfkE=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: linux-kernel@vger.kernel.org
Subject: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb mtrrs - FIX
Date: Thu, 7 Feb 2008 12:57:51 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       jesse.barnes@intel.com, yhlu.kernel@gmail.com, ak@suse.de,
       balajirrao@gmail.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200802071257.51893.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following commit caused my X server to stop working.

commit 99fc8d424bc5d803fe92cad56c068fe64e73747a
Author: Jesse Barnes <jesse.barnes@intel.com>
Date:   Wed Jan 30 13:33:18 2008 +0100

    x86, 32-bit: trim memory not covered by wb mtrrs

This patch fixes the improper handling of addresses > 4G by mtrr_trim_uncached_memory.
This, now brings up X on my system.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 1e27b69..b0f1d48 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -659,7 +659,7 @@ static __init int amd_special_default_mtrr(void)
  */
 int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 {
-	unsigned long i, base, size, highest_addr = 0, def, dummy;
+	unsigned long i, base, size, highest_pfn = 0, def, dummy;
 	mtrr_type type;
 	u64 trim_start, trim_size;
 
@@ -682,30 +682,27 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 		mtrr_if->get(i, &base, &size, &type);
 		if (type != MTRR_TYPE_WRBACK)
 			continue;
-		base <<= PAGE_SHIFT;
-		size <<= PAGE_SHIFT;
-		if (highest_addr < base + size)
-			highest_addr = base + size;
+		if (highest_pfn < base + size)
+			highest_pfn = base + size;
 	}
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
-	if (!highest_addr) {
+	if (!highest_pfn) {
 		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
 		WARN_ON(1);
 		return 0;
 	}
 
-	if ((highest_addr >> PAGE_SHIFT) < end_pfn) {
+	if (highest_pfn < end_pfn) {
 		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
 			" all of memory, losing %LdMB of RAM.\n",
-			(((u64)end_pfn << PAGE_SHIFT) - highest_addr) >> 20);
+			((u64)(end_pfn - highest_pfn) << PAGE_SHIFT) >> 20);
 
 		WARN_ON(1);
 
 		printk(KERN_INFO "update e820 for mtrr\n");
-		trim_start = highest_addr;
-		trim_size = end_pfn;
-		trim_size <<= PAGE_SHIFT;
+		trim_start = highest_pfn << PAGE_SHIFT;
+		trim_size = end_pfn << PAGE_SHIFT;
 		trim_size -= trim_start;
 		add_memory_region(trim_start, trim_size, E820_RESERVED);
 		update_e820();
