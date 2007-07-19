Return-Path: <linux-kernel-owner+w=401wt.eu-S939340AbXGSPdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939340AbXGSPdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939327AbXGSPcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:32:36 -0400
Received: from il.qumranet.com ([82.166.9.18]:49773 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937211AbXGSPce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] ia64: Allow smp_call_function_single() to current cpu
Date: Thu, 19 Jul 2007 18:32:43 +0300
Message-Id: <11848591631239-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the requirement for callers to get_cpu() to check in simple
cases.  i386 and x86_64 already received a similar treatment.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kernel/smp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index b3a47f9..381f9bf 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -346,7 +346,7 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 }
 
 /*
- * Run a function on another CPU
+ * Run a function on a specific CPU
  *  <func>	The function to run. This must be fast and non-blocking.
  *  <info>	An arbitrary pointer to pass to the function.
  *  <nonatomic>	Currently unused.
@@ -366,9 +366,11 @@ smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int
 	int me = get_cpu(); /* prevent preemption and reschedule on another processor */
 
 	if (cpuid == me) {
-		printk(KERN_INFO "%s: trying to call self\n", __FUNCTION__);
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
 		put_cpu();
-		return -EBUSY;
+		return 0;
 	}
 
 	data.func = func;
-- 
1.5.2.4

