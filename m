Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYHPKKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYHPKKD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYHPKIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:08:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:46012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYHPKIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=azTUBLR/Q6Nv4LNwQJCp4sqahh67Wyd9wL5rGyaW0jr4S2OtE+hLU8nPmJpcaIWn/m
         dWaqOalT0WhetkQoy+KY0Fl3+LmakSgDajGlokinCB4bF1NAdClJx0x7mfAmbId9tZ05
         sWaDpYm0YHyOCcS+wY8HeY800zU4l99ZwbBO0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/5] x86: unify ack_apic_edge
Date: Sat, 16 Aug 2008 03:07:29 -0700
Message-Id: <1218881249-3028-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218881249-3028-5-git-send-email-yhlu.kernel@gmail.com>
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-2-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-3-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-4-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-5-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use code in 64 to replace
	move_native_irq(irq, desc);
in 32 bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic.c |   73 ++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 38 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -389,7 +389,6 @@ static inline void io_apic_modify(unsign
 	writel(value, &io_apic->data);
 }
 
-#ifdef CONFIG_X86_64
 static bool io_apic_level_ack_pending(unsigned int irq)
 {
 	struct irq_pin_list *entry;
@@ -419,7 +418,6 @@ static bool io_apic_level_ack_pending(un
 
 	return false;
 }
-#endif
 
 union entry_union {
 	struct { u32 w1, w2; };
@@ -2397,9 +2395,16 @@ static void ack_apic_edge(unsigned int i
 	ack_APIC_irq();
 }
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_32
+atomic_t irq_mis_count;
+#endif
+
 static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
 {
+#ifdef CONFIG_X86_32
+	unsigned long v;
+	int i;
+#endif
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
@@ -2411,6 +2416,31 @@ static void ack_apic_level(unsigned int
 	}
 #endif
 
+#ifdef CONFIG_X86_32
+	/*
+	* It appears there is an erratum which affects at least version 0x11
+	* of I/O APIC (that's the 82093AA and cores integrated into various
+	* chipsets).  Under certain conditions a level-triggered interrupt is
+	* erroneously delivered as edge-triggered one but the respective IRR
+	* bit gets set nevertheless.  As a result the I/O unit expects an EOI
+	* message but it will never arrive and further interrupts are blocked
+	* from the source.  The exact reason is so far unknown, but the
+	* phenomenon was observed when two consecutive interrupt requests
+	* from a given source get delivered to the same CPU and the source is
+	* temporarily disabled in between.
+	*
+	* A workaround is to simulate an EOI message manually.  We achieve it
+	* by setting the trigger mode to edge and then to level when the edge
+	* trigger mode gets detected in the TMR of a local APIC for a
+	* level-triggered interrupt.  We mask the source for the time of the
+	* operation to prevent an edge-triggered interrupt escaping meanwhile.
+	* The idea is from Manfred Spraul.  --macro
+	*/
+	i = irq_cfg(irq)->vector;
+
+	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
+#endif
+
 	/*
 	 * We must acknowledge the irq before we move it or the acknowledge will
 	 * not propagate properly.
@@ -2449,41 +2479,8 @@ static void ack_apic_level(unsigned int
 			move_masked_irq(irq, desc);
 		unmask_IO_APIC_irq(irq);
 	}
-}
-#else
-atomic_t irq_mis_count;
-static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
-{
-	unsigned long v;
-	int i;
-
-	irq_complete_move(irq);
-	move_native_irq(irq, desc);
-	/*
-	* It appears there is an erratum which affects at least version 0x11
-	* of I/O APIC (that's the 82093AA and cores integrated into various
-	* chipsets).  Under certain conditions a level-triggered interrupt is
-	* erroneously delivered as edge-triggered one but the respective IRR
-	* bit gets set nevertheless.  As a result the I/O unit expects an EOI
-	* message but it will never arrive and further interrupts are blocked
-	* from the source.  The exact reason is so far unknown, but the
-	* phenomenon was observed when two consecutive interrupt requests
-	* from a given source get delivered to the same CPU and the source is
-	* temporarily disabled in between.
-	*
-	* A workaround is to simulate an EOI message manually.  We achieve it
-	* by setting the trigger mode to edge and then to level when the edge
-	* trigger mode gets detected in the TMR of a local APIC for a
-	* level-triggered interrupt.  We mask the source for the time of the
-	* operation to prevent an edge-triggered interrupt escaping meanwhile.
-	* The idea is from Manfred Spraul.  --macro
-	*/
-	i = irq_cfg(irq)->vector;
-
-	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
-
-	ack_APIC_irq();
 
+#ifdef CONFIG_X86_32
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 		spin_lock(&ioapic_lock);
@@ -2491,8 +2488,8 @@ static void ack_apic_level(unsigned int
 		__unmask_and_level_IO_APIC_irq(irq);
 		spin_unlock(&ioapic_lock);
 	}
-}
 #endif
+}
 
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name 		= "IO-APIC",
