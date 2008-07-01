Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbYGAPwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbYGAPwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYGAPwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:52:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:28250 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYGAPwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=TPaPSFZQaEB7Yrmv4bpE5WKy0l3YG4clmPIH/yGsnJgZSZeSwUzAfxxI+a5GlcRxQr
         5LpEMm9dWQCPd12p0aSUW3HT+fo0Q8jUv+TOGm8rSRqHoLjUm8M82A0MuXbk5o74vDDv
         l4BeTOx3ARdf3kvgJEQpT7hkPQj30/haqjnFc=
Date: Tue, 1 Jul 2008 17:52:17 +0200
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: small unifications of address printing
Message-ID: <20080701155217.GA22318@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend to lkml)

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 1 Jul 2008 14:51:08 +0200
Subject: [PATCH] x86: small unifications of address printing

'man 3 printf' tells me that %p should be printed as if by %#x, but
this is not true for the kernel, which does not use the '0x' prefix
for the %p conversion specifier.

A small cast to (void *) is also prettier than #ifdef/#else/#endif.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/mm/fault.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index cd0ea9d..179c159 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -409,11 +409,7 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 		printk(KERN_CONT "NULL pointer dereference");
 	else
 		printk(KERN_CONT "paging request");
-#ifdef CONFIG_X86_32
-	printk(KERN_CONT " at %08lx\n", address);
-#else
-	printk(KERN_CONT " at %016lx\n", address);
-#endif
+	printk(KERN_CONT " at %p\n", (void *) address);
 	printk(KERN_ALERT "IP:");
 	printk_address(regs->ip, 1);
 	dump_pagetable(address);
@@ -830,14 +826,10 @@ bad_area_nosemaphore:
 		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 		    printk_ratelimit()) {
 			printk(
-#ifdef CONFIG_X86_32
-			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx",
-#else
-			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx",
-#endif
+			"%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
 			task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
-			tsk->comm, task_pid_nr(tsk), address, regs->ip,
-			regs->sp, error_code);
+			tsk->comm, task_pid_nr(tsk), address,
+			(void *) regs->ip, (void *) regs->sp, error_code);
 			print_vma_addr(" in ", regs->ip);
 			printk("\n");
 		}
-- 
1.5.4.1

