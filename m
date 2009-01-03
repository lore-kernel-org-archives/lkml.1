Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbZACIH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbZACIH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 03:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZACIHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 03:07:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:36307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZACIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 03:07:15 -0500
Message-ID: <495F1C8A.7030308@kernel.org>
Date: Sat, 03 Jan 2009 00:06:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] sparseirq: move set/get_timer_rand_state back to .c
References: <1230748169.19620.132.camel@calx> <495BFB48.8080506@kernel.org> <1230766826.19620.150.camel@calx> <86802c440812311614n4a0ef459u4bb8be65d33994a@mail.gmail.com> <1230802316.3204.4.camel@calx> <20090102155922.GD1180@elte.hu>
In-Reply-To: <20090102155922.GD1180@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

those two functions only used in that .c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/char/random.c  |   40 +++++++++++++++++++++++++++++++++------
 include/linux/random.h |   50 -------------------------------------------------
 2 files changed, 34 insertions(+), 56 deletions(-)

Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
@@ -559,7 +559,40 @@ struct timer_rand_state {
 };
 
 #ifndef CONFIG_SPARSE_IRQ
-struct timer_rand_state *irq_timer_state[NR_IRQS];
+
+static struct timer_rand_state *irq_timer_state[NR_IRQS];
+
+static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
+{
+	return irq_timer_state[irq];
+}
+
+static void set_timer_rand_state(unsigned int irq,
+				 struct timer_rand_state *state)
+{
+	irq_timer_state[irq] = state;
+}
+
+#else
+
+static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	return desc->timer_rand_state;
+}
+
+static void set_timer_rand_state(unsigned int irq,
+				 struct timer_rand_state *state)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	desc->timer_rand_state = state;
+}
 #endif
 
 static struct timer_rand_state input_timer_state;
@@ -919,11 +952,6 @@ void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
 
-#ifndef CONFIG_SPARSE_IRQ
-	if (irq >= nr_irqs)
-		return;
-#endif
-
 	state = get_timer_rand_state(irq);
 
 	if (state)
Index: linux-2.6/include/linux/random.h
===================================================================
--- linux-2.6.orig/include/linux/random.h
+++ linux-2.6/include/linux/random.h
@@ -45,56 +45,6 @@ struct rand_pool_info {
 
 extern void rand_initialize_irq(int irq);
 
-struct timer_rand_state;
-#ifndef CONFIG_SPARSE_IRQ
-
-extern struct timer_rand_state *irq_timer_state[];
-
-static inline struct timer_rand_state *get_timer_rand_state(unsigned int irq)
-{
-	if (irq >= nr_irqs)
-		return NULL;
-
-	return irq_timer_state[irq];
-}
-
-static inline void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
-{
-	if (irq >= nr_irqs)
-		return;
-
-	irq_timer_state[irq] = state;
-}
-
-#else
-
-#include <linux/irq.h>
-static inline struct timer_rand_state *get_timer_rand_state(unsigned int irq)
-{
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
-	if (!desc)
-		return NULL;
-
-	return desc->timer_rand_state;
-}
-
-static inline void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
-{
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
-	if (!desc)
-		return;
-
-	desc->timer_rand_state = state;
-}
-#endif
-
-
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
 extern void add_interrupt_randomness(int irq);
