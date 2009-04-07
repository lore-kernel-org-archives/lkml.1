Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbZDGRjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbZDGRjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbZDGRjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:39:09 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47579 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbZDGRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:39:08 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/13] x86: unify init_ISA_irqs() in irqinit_{32,64}.c
Date: Tue,  7 Apr 2009 16:48:34 +0300
Message-Id: <1239112120-676-7-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |    2 +-
 arch/x86/kernel/irqinit_64.c |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index ef2528d..4488b71 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -98,7 +98,7 @@ static void __init init_ISA_irqs(void)
 {
 	int i;
 
-#ifdef CONFIG_X86_LOCAL_APIC
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	init_bsp_APIC();
 #endif
 	init_8259A(0);
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 9e7c57d..61c9a92 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -84,9 +84,14 @@ static void __init init_ISA_irqs(void)
 {
 	int i;
 
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	init_bsp_APIC();
+#endif
 	init_8259A(0);
 
+	/*
+	 * 16 old-style INTA-cycle interrupts:
+	 */
 	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
@@ -94,11 +99,8 @@ static void __init init_ISA_irqs(void)
 		desc->action = NULL;
 		desc->depth = 1;
 
-		/*
-		 * 16 old-style INTA-cycle interrupts:
-		 */
 		set_irq_chip_and_handler_name(i, &i8259A_chip,
-						      handle_level_irq, "XT");
+					      handle_level_irq, "XT");
 	}
 }
 
-- 
1.5.6.3

