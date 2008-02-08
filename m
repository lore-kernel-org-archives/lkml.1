Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbYBHMWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbYBHMWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYBHMWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:22:46 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:25220 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbYBHMWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:22:46 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080208122.996401758@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] Use standard global TLB flushes in MTRR code v2
Date: Fri,  8 Feb 2008 13:22:44 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 12:16:23.0842 (UTC) FILETIME=[6BC88020:01C86A4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is more idiomatic and it does not really make sense for this 
code to implement a own TLB flushing variant.

The control registers will be read/written a few times more, but 
that should not really matter for this code.

v1->v2: Remove unused variable to fix warning

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux/arch/x86/kernel/cpu/mtrr/generic.c
@@ -324,7 +324,6 @@ static unsigned long set_mtrr_state(void
 }
 
 
-static unsigned long cr4 = 0;
 static DEFINE_SPINLOCK(set_atomicity_lock);
 
 /*
@@ -349,14 +348,8 @@ static void prepare_set(void) __acquires
 	write_cr0(cr0);
 	wbinvd();
 
-	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
-	if ( cpu_has_pge ) {
-		cr4 = read_cr4();
-		write_cr4(cr4 & ~X86_CR4_PGE);
-	}
-
-	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
-	__flush_tlb();
+	/* Flush all TLBs */
+	__flush_tlb_all();
 
 	/*  Save MTRR state */
 	rdmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
@@ -368,7 +361,7 @@ static void prepare_set(void) __acquires
 static void post_set(void) __releases(set_atomicity_lock)
 {
 	/*  Flush TLBs (no need to flush caches - they are disabled)  */
-	__flush_tlb();
+	__flush_tlb_all();
 
 	/* Intel (P6) standard MTRRs */
 	mtrr_wrmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
@@ -376,9 +369,9 @@ static void post_set(void) __releases(se
 	/*  Enable caches  */
 	write_cr0(read_cr0() & 0xbfffffff);
 
-	/*  Restore value of CR4  */
-	if ( cpu_has_pge )
-		write_cr4(cr4);
+	/* Flush TLBs again to handle prefetches etc. */
+	__flush_tlb_all();
+
 	spin_unlock(&set_atomicity_lock);
 }
 
