Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbZINUWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbZINUWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbZINUIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54008 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbZINUIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:21 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 09/72] Blackfin: use generic name for EVT14 handler
Date: Mon, 14 Sep 2009 16:07:13 -0400
Message-Id: <1252958896-25150-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

The purpose of the EVT14 handler may depend on whether CONFIG_IPIPE is
enabled, albeit its implementation can be the same in both cases. When
the interrupt pipeline is enabled, EVT14 can be used to raise the core
priority level for the running code; when CONFIG_IPIPE is off, EVT14
can be used to lower this level before running softirq handlers.

Rename evt14_softirq to evt_evt14 to pick an identifier that fits
both, which allows to reuse the same vector setup code as well.

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/bfin-global.h   |    1 -
 arch/blackfin/include/asm/irq_handler.h   |    1 +
 arch/blackfin/mach-common/entry.S         |    8 ++++----
 arch/blackfin/mach-common/ints-priority.c |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin-global.h b/arch/blackfin/include/asm/bfin-global.h
index e39277e..e6ecbe4 100644
--- a/arch/blackfin/include/asm/bfin-global.h
+++ b/arch/blackfin/include/asm/bfin-global.h
@@ -66,7 +66,6 @@ extern void program_IAR(void);
 
 extern asmlinkage void lower_to_irq14(void);
 extern asmlinkage void bfin_return_from_exception(void);
-extern asmlinkage void evt14_softirq(void);
 extern asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs);
 extern int bfin_internal_set_wake(unsigned int irq, unsigned int state);
 
diff --git a/arch/blackfin/include/asm/irq_handler.h b/arch/blackfin/include/asm/irq_handler.h
index 139b520..7d9e2d3 100644
--- a/arch/blackfin/include/asm/irq_handler.h
+++ b/arch/blackfin/include/asm/irq_handler.h
@@ -17,6 +17,7 @@ asmlinkage void evt_evt10(void);
 asmlinkage void evt_evt11(void);
 asmlinkage void evt_evt12(void);
 asmlinkage void evt_evt13(void);
+asmlinkage void evt_evt14(void);
 asmlinkage void evt_soft_int1(void);
 asmlinkage void evt_system_call(void);
 asmlinkage void init_exception_buff(void);
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 4c07fcb..919f7ae 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -975,10 +975,10 @@ ENTRY(_lower_to_irq14)
 #endif
 
 #ifdef CONFIG_DEBUG_HWERR
-	/* enable irq14 & hwerr interrupt, until we transition to _evt14_softirq */
+	/* enable irq14 & hwerr interrupt, until we transition to _evt_evt14 */
 	r0 = (EVT_IVG14 | EVT_IVHW | EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
 #else
-	/* Only enable irq14 interrupt, until we transition to _evt14_softirq */
+	/* Only enable irq14 interrupt, until we transition to _evt_evt14 */
 	r0 = (EVT_IVG14 | EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
 #endif
 	sti r0;
@@ -986,7 +986,7 @@ ENTRY(_lower_to_irq14)
 	rti;
 ENDPROC(_lower_to_irq14)
 
-ENTRY(_evt14_softirq)
+ENTRY(_evt_evt14)
 #ifdef CONFIG_DEBUG_HWERR
 	r0 = (EVT_IVHW | EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
 	sti r0;
@@ -996,7 +996,7 @@ ENTRY(_evt14_softirq)
 	[--sp] = RETI;
 	SP += 4;
 	rts;
-ENDPROC(_evt14_softirq)
+ENDPROC(_evt_evt14)
 
 ENTRY(_schedule_and_signal_from_int)
 	/* To end up here, vector 15 was changed - so we have to change it
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index b421501..4cc55bc 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -967,7 +967,7 @@ void __cpuinit init_exception_vectors(void)
 	bfin_write_EVT11(evt_evt11);
 	bfin_write_EVT12(evt_evt12);
 	bfin_write_EVT13(evt_evt13);
-	bfin_write_EVT14(evt14_softirq);
+	bfin_write_EVT14(evt_evt14);
 	bfin_write_EVT15(evt_system_call);
 	CSYNC();
 }
-- 
1.6.4.2

