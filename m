Return-Path: <linux-kernel-owner+w=401wt.eu-S1423438AbXD3Ptj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423438AbXD3Ptj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423439AbXD3Ptj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:49:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:44969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423438AbXD3Pth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: bk@suse.de, akpm@linux-foundation.org, ak@suse.de, davej@codemonkey.org.uk,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/34] x86: Adds mtrr_save_fixed_ranges() for use in two later  patches.
Message-Id: <20070430154933.C6BA0151F8@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Bernhard Kaindl <bk@suse.de>

In this current implementation which is used in other patches,
mtrr_save_fixed_ranges() accepts a dummy void pointer because
in the current implementation of one of these patches, this
function may be called from smp_call_function_single() which
requires that this function takes a void pointer argument.

This function calls get_fixed_ranges(), passing mtrr_state.fixed_ranges
which is the element of the static struct which stores our current
backup of the fixed-range MTRR values which all CPUs shall be
using.

Because  mtrr_save_fixed_ranges calls get_fixed_ranges after
kernel initialisation time, __init needs to be removed from
the declaration of get_fixed_ranges().

If CONFIG_MTRR is not set, we define mtrr_save_fixed_ranges
as an empty statement because there is nothing to do.

AK: Moved prototypes for x86-64 around to fix warnings

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>

---
 arch/i386/kernel/cpu/mtrr/generic.c |    7 ++++++-
 include/asm-i386/mtrr.h             |    2 ++
 include/asm-x86_64/mtrr.h           |    2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux/arch/i386/kernel/cpu/mtrr/generic.c
@@ -37,7 +37,7 @@ get_mtrr_var_range(unsigned int index, s
 	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
 }
 
-static void __init
+static void
 get_fixed_ranges(mtrr_type * frs)
 {
 	unsigned int *p = (unsigned int *) frs;
@@ -51,6 +51,11 @@ get_fixed_ranges(mtrr_type * frs)
 		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
 }
 
+void mtrr_save_fixed_ranges(void *info)
+{
+	get_fixed_ranges(mtrr_state.fixed_ranges);
+}
+
 static void __init print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
Index: linux/include/asm-i386/mtrr.h
===================================================================
--- linux.orig/include/asm-i386/mtrr.h
+++ linux/include/asm-i386/mtrr.h
@@ -69,6 +69,7 @@ struct mtrr_gentry
 
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
+extern void mtrr_save_fixed_ranges(void *);
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
@@ -79,6 +80,7 @@ extern void mtrr_centaur_report_mcr(int 
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 #  else
+#define mtrr_save_fixed_ranges(arg) do {} while (0)
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
 {
Index: linux/include/asm-x86_64/mtrr.h
===================================================================
--- linux.orig/include/asm-x86_64/mtrr.h
+++ linux/include/asm-x86_64/mtrr.h
@@ -138,9 +138,11 @@ struct mtrr_gentry32
 #ifdef CONFIG_MTRR
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
+extern void mtrr_save_fixed_ranges(void *);
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
+#define mtrr_save_fixed_ranges(arg) do {} while (0)
 #endif
 
 #endif /* __KERNEL__ */
