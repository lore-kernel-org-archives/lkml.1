Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbYARCwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbYARCwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYARCw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:52:28 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:34221 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbYARCw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:52:27 -0500
Message-ID: <4790145C.9060102@ct.jp.nec.com>
Date: Thu, 17 Jan 2008 18:52:12 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: x86: kdump failure
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu>
In-Reply-To: <20080114190904.GA2288@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

on recent x86.git kernel fails to kdump with following BUG.

SysRq : Trigger a crashdump
------------[ cut here ]------------
kernel BUG at include/linux/elfcore.h:105!
invalid opcode: 0000 [1] PREEMPT SMP

In crash_save_cpu(), elf_core_copy_regs() is called and
ELF_CORE_COPY_REGS macro is required because struct pt_regs
and elf_gregset_t are different.

---
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86: kdump needs ELF_CORE_COPY_REGS macro

kdump needs ELF_CORE_COPY_REGS in crash_save_cpu().
This lack of the macro causes the following BUG.

SysRq : Trigger a crashdump
------------[ cut here ]------------
kernel BUG at include/linux/elfcore.h:105!
invalid opcode: 0000 [1] PREEMPT SMP

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/asm-x86/elf.h |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index dab4744..d9c94e7 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -106,6 +106,31 @@ extern unsigned int vdso_enabled;
 	_r->ax = 0; \
 } while (0)
 
+/*
+ * regs is struct pt_regs, pr_reg is elf_gregset_t (which is
+ * now struct_user_regs, they are different)
+ */
+
+#define ELF_CORE_COPY_REGS(pr_reg, regs) do {		\
+	pr_reg[0] = regs->bx;				\
+	pr_reg[1] = regs->cx;				\
+	pr_reg[2] = regs->dx;				\
+	pr_reg[3] = regs->si;				\
+	pr_reg[4] = regs->di;				\
+	pr_reg[5] = regs->bp;				\
+	pr_reg[6] = regs->ax;				\
+	pr_reg[7] = regs->ds & 0xffff;			\
+	pr_reg[8] = regs->es & 0xffff;			\
+	pr_reg[9] = regs->fs & 0xffff;			\
+	savesegment(gs, pr_reg[10]);			\
+	pr_reg[11] = regs->orig_ax;			\
+	pr_reg[12] = regs->ip;				\
+	pr_reg[13] = regs->cs & 0xffff;			\
+	pr_reg[14] = regs->flags;			\
+	pr_reg[15] = regs->sp;				\
+	pr_reg[16] = regs->ss & 0xffff;			\
+} while (0);
+
 #define ELF_PLATFORM	(utsname()->machine)
 #define set_personality_64bit()	do { } while (0)
 
@@ -165,6 +190,43 @@ static inline void elf_common_init(struct thread_struct *t,
 	} while (0)
 #define COMPAT_ELF_PLATFORM			("i686")
 
+/*
+ * regs is struct pt_regs, pr_reg is elf_gregset_t (which is
+ * now struct_user_regs, they are different). Assumes current is the process
+ * getting dumped.
+ */
+
+#define ELF_CORE_COPY_REGS(pr_reg, regs)  do {			\
+	unsigned v;						\
+	(pr_reg)[0] = (regs)->r15;				\
+	(pr_reg)[1] = (regs)->r14;				\
+	(pr_reg)[2] = (regs)->r13;				\
+	(pr_reg)[3] = (regs)->r12;				\
+	(pr_reg)[4] = (regs)->bp;				\
+	(pr_reg)[5] = (regs)->bx;				\
+	(pr_reg)[6] = (regs)->r11;				\
+	(pr_reg)[7] = (regs)->r10;				\
+	(pr_reg)[8] = (regs)->r9;				\
+	(pr_reg)[9] = (regs)->r8;				\
+	(pr_reg)[10] = (regs)->ax;				\
+	(pr_reg)[11] = (regs)->cx;				\
+	(pr_reg)[12] = (regs)->dx;				\
+	(pr_reg)[13] = (regs)->si;				\
+	(pr_reg)[14] = (regs)->di;				\
+	(pr_reg)[15] = (regs)->orig_ax;				\
+	(pr_reg)[16] = (regs)->ip;				\
+	(pr_reg)[17] = (regs)->cs;				\
+	(pr_reg)[18] = (regs)->flags;				\
+	(pr_reg)[19] = (regs)->sp;				\
+	(pr_reg)[20] = (regs)->ss;				\
+	(pr_reg)[21] = current->thread.fs;			\
+	(pr_reg)[22] = current->thread.gs;			\
+	asm("movl %%ds,%0" : "=r" (v)); (pr_reg)[23] = v;	\
+	asm("movl %%es,%0" : "=r" (v)); (pr_reg)[24] = v;	\
+	asm("movl %%fs,%0" : "=r" (v)); (pr_reg)[25] = v;	\
+	asm("movl %%gs,%0" : "=r" (v)); (pr_reg)[26] = v;	\
+} while (0);
+
 /* I'm not sure if we can use '-' here */
 #define ELF_PLATFORM       ("x86_64")
 extern void set_personality_64bit(void);
-- 
1.5.3.7


