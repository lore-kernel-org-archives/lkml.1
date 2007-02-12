Return-Path: <linux-kernel-owner+w=401wt.eu-S933096AbXBLHi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096AbXBLHi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964779AbXBLHie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:34 -0500
Received: from ns.suse.de ([195.135.220.2]:38418 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933101AbXBLHiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:17 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [28/39] i386: fix size_or_mask and size_and_mask
Message-Id: <20070212073816.337A713D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
mtrr: fix size_or_mask and size_and_mask

This fixes two bugs in /proc/mtrr interface:
o If physical address size crosses the 44 bit boundary
  size_or_mask is evaluated wrong.
o size_and_mask limits width of physical base
  address for an MTRR to be less than 44 bits.

TBD: later patch had one more change, but I think that was bogus.
TBD: need to double check

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/mtrr/main.c |    6 +++---
 arch/i386/kernel/cpu/mtrr/mtrr.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux/arch/i386/kernel/cpu/mtrr/main.c
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
Index: linux/arch/i386/kernel/cpu/mtrr/mtrr.h
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/mtrr.h
+++ linux/arch/i386/kernel/cpu/mtrr/mtrr.h
@@ -84,7 +84,7 @@ void get_mtrr_state(void);
 
 extern void set_mtrr_ops(struct mtrr_ops * ops);
 
-extern u32 size_or_mask, size_and_mask;
+extern u64 size_or_mask, size_and_mask;
 extern struct mtrr_ops * mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
