Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZDIQV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZDIQV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934884AbZDIQVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:21:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:54107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934441AbZDIQVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:21:04 -0400
Subject: [PATCH -tip] x86: apic/io_apic.c declare
 smp_irq_move_cleanup_interrupt before they get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 21:50:41 +0530
Message-Id: <1239294041.3296.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warning:
  arch/x86/kernel/apic/io_apic.c:2431:17: warning: symbol 'smp_irq_move_cleanup_interrupt' was not declared. Should it be static?

smp_irq_move_cleanup_interrupt needs asmlinkage only for 64 bit.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/hw_irq.h  |    9 +++++++++
 arch/x86/kernel/apic/io_apic.c |    6 +++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 7309c0a..03316a8 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -93,6 +93,15 @@ extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 #endif
 
+#ifdef CONFIG_X86_IO_APIC
+#ifdef CONFIG_X86_32
+extern void smp_irq_move_cleanup_interrupt(void);
+#else
+extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
+#endif
+#endif
+
+
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
 typedef int vector_irq_t[NR_VECTORS];
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7c9d045..7d7d429 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -59,6 +59,7 @@
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
+#include <asm/hw_irq.h>		/* smp_irq_move_cleanup_interrupt */
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
 
@@ -2428,7 +2429,10 @@ static inline void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 }
 #endif
 
-asmlinkage void smp_irq_move_cleanup_interrupt(void)
+#ifdef CONFIG_X86_64
+asmlinkage
+#endif
+void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
 
-- 
1.6.0.6



