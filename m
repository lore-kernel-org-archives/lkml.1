Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZDGSyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZDGSyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZDGSyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:54:08 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:40576 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZDGSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:54:07 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/13] x86: define IA32_SYSCALL_VECTOR on 32-bit to reduce ifdefs
Date: Tue,  7 Apr 2009 16:48:39 +0300
Message-Id: <1239112120-676-12-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

We can remove some #ifdefs if we define IA32_SYSCALL_VECTOR on 32-bit.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/include/asm/irq_vectors.h |    1 +
 arch/x86/kernel/irqinit.c          |    6 ------
 arch/x86/kernel/traps.c            |    5 +----
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 3cbd79b..910b5a3 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -34,6 +34,7 @@
 
 #ifdef CONFIG_X86_32
 # define SYSCALL_VECTOR			0x80
+# define IA32_SYSCALL_VECTOR		0x80
 #else
 # define IA32_SYSCALL_VECTOR		0x80
 #endif
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f3be5e9..f2c60a5 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -242,15 +242,9 @@ void __init native_init_IRQ(void)
 	 * 'special' SMP interrupts)
 	 */
 	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
-#ifdef CONFIG_X86_32
-		/* SYSCALL_VECTOR was reserved in trap_init. */
-		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
-#else
 		/* IA32_SYSCALL_VECTOR was reserved in trap_init. */
 		if (i != IA32_SYSCALL_VECTOR)
 			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
-#endif
 	}
 
 	apic_intr_init();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..2310700 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -969,11 +969,8 @@ void __init trap_init(void)
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
 		set_bit(i, used_vectors);
 
-#ifdef CONFIG_X86_64
 	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
-#else
-	set_bit(SYSCALL_VECTOR, used_vectors);
-#endif
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
-- 
1.5.6.3

