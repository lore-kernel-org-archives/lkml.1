Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZGTMCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZGTMCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZGTMCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:02:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:45386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbZGTMCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:02:01 -0400
Date: Mon, 20 Jul 2009 12:01:29 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090718150955.GB11294@localhost.localdomain>
References: <20090718150955.GB11294@localhost.localdomain>
Subject: [tip:x86/asm] x86: Remove unused patch_espfix_desc()
Message-ID: <tip-fde0312d01b60a3fd5dc56e69a9613defbbc7097@git.kernel.org>
Git-Commit-ID: fde0312d01b60a3fd5dc56e69a9613defbbc7097
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 20 Jul 2009 12:01:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fde0312d01b60a3fd5dc56e69a9613defbbc7097
Gitweb:     http://git.kernel.org/tip/fde0312d01b60a3fd5dc56e69a9613defbbc7097
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Sun, 19 Jul 2009 00:09:56 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Jul 2009 18:27:52 +0200

x86: Remove unused patch_espfix_desc()

patch_espfix_desc() is not used after commit
dc4c2a0aed3b09f6e255bd5c3faa50fe6e0b2ded

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090718150955.GB11294@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/traps.h |    4 +---
 arch/x86/kernel/traps.c      |   21 ---------------------
 2 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index bfd74c0..4da91ad 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -81,9 +81,7 @@ extern int panic_on_unrecovered_nmi;
 
 void math_error(void __user *);
 void math_emulate(struct math_emu_info *);
-#ifdef CONFIG_X86_32
-unsigned long patch_espfix_desc(unsigned long, unsigned long);
-#else
+#ifndef CONFIG_X86_32
 asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5204332..2367941 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -786,27 +786,6 @@ do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
-{
-	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
-	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
-	unsigned long new_kesp = kesp - base;
-	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
-	__u64 desc = *(__u64 *)&gdt[GDT_ENTRY_ESPFIX_SS];
-
-	/* Set up base for espfix segment */
-	desc &= 0x00f0ff0000000000ULL;
-	desc |=	((((__u64)base) << 16) & 0x000000ffffff0000ULL) |
-		((((__u64)base) << 32) & 0xff00000000000000ULL) |
-		((((__u64)lim_pages) << 32) & 0x000f000000000000ULL) |
-		(lim_pages & 0xffff);
-	*(__u64 *)&gdt[GDT_ENTRY_ESPFIX_SS] = desc;
-
-	return new_kesp;
-}
-#endif
-
 asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
 {
 }
