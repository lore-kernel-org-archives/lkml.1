Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbYH3KU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbYH3KU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 06:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYH3KUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 06:20:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50595 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYH3KUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 06:20:16 -0400
Date: Sat, 30 Aug 2008 12:20:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Avoid double flush in do_tlb_flush_all()
Message-ID: <20080830102012.GA21145@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid double flush in do_tlb_flush_all()

leave_mm already flushes the TLBs, so don't need to flush directly before that
in do_flush_tlb_all(). Avoid the double flush.

Pointed out by Rainer Weikusat

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/tlb_32.c |    5 ++---
 arch/x86/kernel/tlb_64.c |    7 +++----
 2 files changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6.27-rc4-misc/arch/x86/kernel/tlb_32.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/arch/x86/kernel/tlb_32.c
+++ linux-2.6.27-rc4-misc/arch/x86/kernel/tlb_32.c
@@ -229,11 +229,10 @@ EXPORT_SYMBOL(flush_tlb_page);
 
 static void do_flush_tlb_all(void *info)
 {
-	unsigned long cpu = smp_processor_id();
-
-	__flush_tlb_all();
 	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_LAZY)
 		leave_mm(cpu);
+	else
+		__flush_tlb_all(smp_processor_id());
 }
 
 void flush_tlb_all(void)
Index: linux-2.6.27-rc4-misc/arch/x86/kernel/tlb_64.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/arch/x86/kernel/tlb_64.c
+++ linux-2.6.27-rc4-misc/arch/x86/kernel/tlb_64.c
@@ -266,11 +266,10 @@ void flush_tlb_page(struct vm_area_struc
 
 static void do_flush_tlb_all(void *info)
 {
-	unsigned long cpu = smp_processor_id();
-
-	__flush_tlb_all();
 	if (read_pda(mmu_state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
+		leave_mm(smp_processor_id());
+	else
+		__flush_tlb_all();
 }
 
 void flush_tlb_all(void)
