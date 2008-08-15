Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbYHOCXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbYHOCXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbYHOCVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:21:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:58827 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbYHOCVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ffsjTaYAze1seZEwA1W2j/RuB4xjCEcGoYAGTJHMV4z3cJVZOiG8bjACfR7Axl2moy
         VGFtu5YIPoIubU02LrBw3Qw5Pn038a2aLFrL25bP1I590oNpL+dHYHnI2daxHJDzNdSy
         Nsb7hXz81X2JfyzcRuyrWyahmoFrBGAVERmEs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 7/7] x86: ordering functions in io_apic_64.c
Date: Thu, 14 Aug 2008 19:20:32 -0700
Message-Id: <1218766832-20476-8-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218766832-20476-7-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-4-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-5-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-6-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-7-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try to make functions in the same order

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   67 ++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index e4f03cc..a14c29e 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -409,40 +409,6 @@ static bool io_apic_level_ack_pending(unsigned int irq)
 	return false;
 }
 
-/*
- * Synchronize the IO-APIC and the CPU by doing
- * a dummy read from the IO-APIC
- */
-static inline void io_apic_sync(unsigned int apic)
-{
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
-	readl(&io_apic->data);
-}
-
-#define __DO_ACTION(R, ACTION, FINAL)					\
-									\
-{									\
-	int pin;							\
-	struct irq_cfg *cfg;						\
-	struct irq_pin_list *entry;					\
-									\
-	cfg = irq_cfg(irq);						\
-	entry = cfg->irq_2_pin;						\
-	for (;;) {							\
-		unsigned int reg;					\
-		if (!entry)						\
-			break;						\
-		pin = entry->pin;					\
-		reg = io_apic_read(entry->apic, 0x10 + R + pin*2);	\
-		reg ACTION;						\
-		io_apic_modify(entry->apic, reg);			\
-		FINAL;							\
-		if (!entry->next)					\
-			break;						\
-		entry = entry->next;					\
-	}								\
-}
-
 union entry_union {
 	struct { u32 w1, w2; };
 	struct IO_APIC_route_entry entry;
@@ -625,6 +591,39 @@ static void __init replace_pin_at_irq(unsigned int irq,
 		add_pin_to_irq(irq, newapic, newpin);
 }
 
+/*
+ * Synchronize the IO-APIC and the CPU by doing
+ * a dummy read from the IO-APIC
+ */
+static inline void io_apic_sync(unsigned int apic)
+{
+	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	readl(&io_apic->data);
+}
+
+#define __DO_ACTION(R, ACTION, FINAL)					\
+									\
+{									\
+	int pin;							\
+	struct irq_cfg *cfg;						\
+	struct irq_pin_list *entry;					\
+									\
+	cfg = irq_cfg(irq);						\
+	entry = cfg->irq_2_pin;						\
+	for (;;) {							\
+		unsigned int reg;					\
+		if (!entry)						\
+			break;						\
+		pin = entry->pin;					\
+		reg = io_apic_read(entry->apic, 0x10 + R + pin*2);	\
+		reg ACTION;						\
+		io_apic_modify(entry->apic, reg);			\
+		FINAL;							\
+		if (!entry->next)					\
+			break;						\
+		entry = entry->next;					\
+	}								\
+}
 
 #define DO_ACTION(name,R,ACTION, FINAL)					\
 									\
-- 
1.5.4.5

