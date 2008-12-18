Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753455AbYLRSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYLRSfv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYLRSfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:35:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYLRSfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:35:36 -0500
Subject: Re: [PATCH] x86: traps.c declare functions before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh <jaswinderlinux@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20081218143335.GA10548@elte.hu>
References: <1229360145.15326.5.camel@jaswinder.satnam>
	 <20081216201956.GA14505@elte.hu>
	 <3f9a31f40812162028j5a0e12f5h2215daae12ce3441@mail.gmail.com>
	 <20081218143335.GA10548@elte.hu>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 00:03:56 +0530
Message-Id: <1229625236.3197.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 15:33 +0100, Ingo Molnar wrote:

> you should build-test your patch with MATH_EMULATION enabled.
> 

I am sorry for this mess. Now I tested on X86_32 with and without
MATH_EMULATION and also in X86_64. So here is new patch :

Subject: [PATCH] 86: traps.c declare functions before they get used

Impact: cleanup

In asm/traps.h :-
do_double_fault : added under X86_64
sync_regs : added under X86_64
math_error : moved out from X86_32 as it is common for both 32 and 64 bit
math_emulate : moved from X86_32 as it is common for both 32 and 64 bit
smp_thermal_interrupt : added under X86_64
mce_threshold_interrupt : added under X86_64

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/include/asm/traps.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 45dee28..2ee0a3b 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -46,6 +46,10 @@ dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
 dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
 dotraplinkage void do_segment_not_present(struct pt_regs *, long);
 dotraplinkage void do_stack_segment(struct pt_regs *, long);
+#ifdef CONFIG_X86_64
+dotraplinkage void do_double_fault(struct pt_regs *, long);
+asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
+#endif
 dotraplinkage void do_general_protection(struct pt_regs *, long);
 dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
 dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
@@ -72,10 +76,13 @@ static inline int get_si_code(unsigned long condition)
 extern int panic_on_unrecovered_nmi;
 extern int kstack_depth_to_print;
 
-#ifdef CONFIG_X86_32
 void math_error(void __user *);
-unsigned long patch_espfix_desc(unsigned long, unsigned long);
 asmlinkage void math_emulate(long);
+#ifdef CONFIG_X86_32
+unsigned long patch_espfix_desc(unsigned long, unsigned long);
+#else
+asmlinkage void smp_thermal_interrupt(void);
+asmlinkage void mce_threshold_interrupt(void);
 #endif
 
 #endif /* _ASM_X86_TRAPS_H */
-- 
1.5.5.1



