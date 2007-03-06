Return-Path: <linux-kernel-owner+w=401wt.eu-S933915AbXCFM6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbXCFM6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934101AbXCFM6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:58:16 -0500
Received: from ozlabs.org ([203.10.76.45]:56499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933915AbXCFM6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:58:15 -0500
Subject: [PATCH 4/8] Cleanup setup_pda
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <1173185734.4644.32.camel@localhost.localdomain>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 23:57:07 +1100
Message-Id: <1173185827.4644.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above this function has never been true in mainline:
talking to Jeremy it's from previous patch churn.  What setup_pda
actually does is to write the segment entry for boot_pda into the
boot_gdt_table.  Ideally, this would be a static initialization, but
because the addresses are split over multiple parts in the funk bit
layout of the GDT entry (thanks Intel!) that's not a valid C
initializer.

We in fact call this routine on every CPU bringup, but that's
harmless.  Non-boot CPUs switch to their own GDTs immediately in
initialize_secondary.

VMI certainly doesn't need to call it explicitly.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 2d9aa53572e2 arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Tue Mar 06 19:01:08 2007 +1100
+++ b/arch/i386/kernel/head.S	Tue Mar 06 19:01:12 2007 +1100
@@ -365,17 +365,10 @@ 1:	movb $1,X86_HARD_MATH
 	.byte 0xDB,0xE4		/* fsetpm for 287, ignored by 387 */
 	ret
 
-/*
- * Point the GDT at this CPU's PDA.  On boot this will be
- * cpu_gdt_table and boot_pda; for secondary CPUs, these will be
- * that CPU's GDT and PDA.
- */
-ENTRY(setup_pda)
-	/* get the PDA pointer */
-	movl start_pda, %eax
-
-	/* slot the PDA address into the GDT */
-	mov early_gdt_descr+2, %ecx
+/* Initialize the boot_gdt_table's GDT_ENTRY_PDA (can't be done statically) */
+setup_pda:
+	movl $boot_pda, %eax
+	movl $boot_gdt_table, %ecx
 	mov %ax, (__KERNEL_PDA+0+2)(%ecx)		/* base & 0x0000ffff */
 	shr $16, %eax
 	mov %al, (__KERNEL_PDA+4+0)(%ecx)		/* base & 0x00ff0000 */
@@ -554,9 +547,6 @@ ENTRY(empty_zero_page)
  * This starts the data section.
  */
 .data
-ENTRY(start_pda)
-	.long boot_pda
-
 ENTRY(stack_start)
 	.long init_thread_union+THREAD_SIZE
 	.long __BOOT_DS
diff -r 2d9aa53572e2 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Tue Mar 06 19:01:08 2007 +1100
+++ b/arch/i386/kernel/vmi.c	Tue Mar 06 19:01:47 2007 +1100
@@ -525,8 +525,6 @@ void vmi_pmd_clear(pmd_t *pmd)
 #endif
 
 #ifdef CONFIG_SMP
-extern void setup_pda(void);
-
 static void __devinit
 vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 		     unsigned long start_esp)
@@ -555,8 +553,6 @@ vmi_startup_ipi_hook(int phys_apicid, un
 	ap.gs = 0;
 
 	ap.eflags = 0;
-
-	setup_pda();
 
 #ifdef CONFIG_X86_PAE
 	/* efer should match BSP efer. */


