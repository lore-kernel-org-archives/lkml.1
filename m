Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXAVTpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXAVTpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbXAVTpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:45:14 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:43080 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbXAVTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:45:11 -0500
X-Greylist: delayed 4128 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jan 2007 14:45:11 EST
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 22 Jan 2007 19:36:07 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Richard Gooch" <rgooch@atnf.csiro.au>
cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [patch] mtrr: fix size_or_mask and size_and_mask
Message-ID: <20070122183607.GA13729@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jan 2007 18:36:14.0136 (UTC)
 FILETIME=[320EE380:01C73E54]
X-WSS-ID: 69ABDBAB2MC5778028-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mtrr: fix size_or_mask and size_and_mask

This fixes two bugs in /proc/mtrr interface:
o If physical address size crosses the 44 bit boundary
  size_or_mask is evaluated wrong.
o size_and_mask limits width of physical base
  address for an MTRR to be less than 44 bits.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/i386/kernel/cpu/mtrr/main.c |    6 +++---
 arch/i386/kernel/cpu/mtrr/mtrr.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 16bb7ea..0acfb6a 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -50,7 +50,7 @@ u32 num_var_ranges = 0;
 unsigned int *usage_table;
 static DEFINE_MUTEX(mtrr_mutex);
 
-u32 size_or_mask, size_and_mask;
+u64 size_or_mask, size_and_mask;
 
 static struct mtrr_ops * mtrr_ops[X86_VENDOR_NUM] = {};
 
@@ -662,8 +662,8 @@ void __init mtrr_bp_init(void)
 			     boot_cpu_data.x86_mask == 0x4))
 				phys_addr = 36;
 
-			size_or_mask = ~((1 << (phys_addr - PAGE_SHIFT)) - 1);
-			size_and_mask = ~size_or_mask & 0xfff00000;
+			size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
+			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
 		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
 			   boot_cpu_data.x86 == 6) {
 			/* VIA C* family have Intel style MTRRs, but
diff --git a/arch/i386/kernel/cpu/mtrr/mtrr.h b/arch/i386/kernel/cpu/mtrr/mtrr.h
index d61ea9d..289dfe6 100644
--- a/arch/i386/kernel/cpu/mtrr/mtrr.h
+++ b/arch/i386/kernel/cpu/mtrr/mtrr.h
@@ -84,7 +84,7 @@ void get_mtrr_state(void);
 
 extern void set_mtrr_ops(struct mtrr_ops * ops);
 
-extern u32 size_or_mask, size_and_mask;
+extern u64 size_or_mask, size_and_mask;
 extern struct mtrr_ops * mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
-- 
1.4.2.4




