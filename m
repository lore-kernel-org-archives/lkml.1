Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZGRPNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZGRPNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZGRPNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:13:05 -0400
Received: from mail-pz0-f195.google.com ([209.85.222.195]:46641 "EHLO
	mail-pz0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZGRPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RpafKprIQDrZHXhQ/tL3RexAsy8JkEXTjLGMr6nDiynGM5TOF024bsy2dSDdp4XCKj
         u6iTWsci9eS9HCxh+w1GCJGhRtj6RQj0cZy8TnMM/ao4bp7FEdOWEO+v+a2eyt12qzY3
         8821QOZd+MyM0Vn6PFWo1WtQgYEi7MQqfIViY=
Date: Sun, 19 Jul 2009 00:09:56 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH 2/4] x86: remove unused patch_espfix_desc()
Message-ID: <20090718150955.GB11294@localhost.localdomain>
References: <20090718150853.GA11294@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090718150853.GA11294@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch_espfix_desc() is not used after commit
dc4c2a0aed3b09f6e255bd5c3faa50fe6e0b2ded

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
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
-- 
1.6.0.6

