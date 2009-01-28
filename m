Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZA1EbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZA1EbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZA1Eay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:30:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:55391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZA1Eax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:30:53 -0500
Message-ID: <497FDF7C.8080706@kernel.org>
Date: Wed, 28 Jan 2009 13:30:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2 x86#stackprotector] x86: cleanup stack protector
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 04:30:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Make the following cleanups.

* remove duplicate comment from boot_init_stack_canary() which fits
  better in the other place - cpu_idle().

* move stack_canary offset check from __switch_to() to
  boot_init_stack_canary().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This was part of core/percpu branch before rebasing but really belongs
to stackprotector branch.

 arch/x86/include/asm/pda.h            |    2 --
 arch/x86/include/asm/stackprotector.h |   13 ++++++-------
 arch/x86/kernel/process_64.c          |    7 -------
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 5976cd8..4a8c9d3 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -40,6 +40,4 @@ extern void pda_init(int);
 
 #endif
 
-#define refresh_stack_canary() write_pda(stack_canary, current->stack_canary)
-
 #endif /* _ASM_X86_PDA_H */
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index c7f0d10..2383e5b 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -16,13 +16,12 @@ static __always_inline void boot_init_stack_canary(void)
 	u64 tsc;
 
 	/*
-	 * If we're the non-boot CPU, nothing set the PDA stack
-	 * canary up for us - and if we are the boot CPU we have
-	 * a 0 stack canary. This is a good place for updating
-	 * it, as we wont ever return from this function (so the
-	 * invalid canaries already on the stack wont ever
-	 * trigger).
-	 *
+	 * Build time only check to make sure the stack_canary is at
+	 * offset 40 in the pda; this is a gcc ABI requirement
+	 */
+	BUILD_BUG_ON(offsetof(struct x8664_pda, stack_canary) != 40);
+
+	/*
 	 * We both use the random pool and the current TSC as a source
 	 * of randomness. The TSC only matters for very early init,
 	 * there it already has some randomness on most systems. Later
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index aa89eab..088bc9a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -638,13 +638,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	percpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
-#ifdef CONFIG_CC_STACKPROTECTOR
-	/*
-	 * Build time only check to make sure the stack_canary is at
-	 * offset 40 in the pda; this is a gcc ABI requirement
-	 */
-	BUILD_BUG_ON(offsetof(struct x8664_pda, stack_canary) != 40);
-#endif
 
 	/*
 	 * Now maybe reload the debug registers and handle I/O bitmaps
-- 
1.6.0.2

