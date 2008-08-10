Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYHJHsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYHJHsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYHJHjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbYHJHiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lvoS5M4Nidyw+nmBsei3EFwDt9BSJUWkXdekM2ihQNLcIbQLZqHJG/cRt10KqUP9Fv
         ylL4m8Cjm8T0kQ4QVTUYwxNQ9VvBMMgE9GtaW0P+5cEyLNEnyP2x/TDzrtbqsszwiyy4
         66e608djh7oryIjr882LBt+iLC0N/rS6e7xpM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 30/43] x86: put timer_rand_state pointer into irq_desc
Date: Sun, 10 Aug 2008 00:36:19 -0700
Message-Id: <1218353792-3355-31-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-30-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-11-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-12-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-13-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-15-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-16-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-17-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-18-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-19-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-20-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-21-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-22-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-23-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-24-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-25-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-26-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-27-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-28-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-29-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-30-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could remove timer_rand_state pointer array
v2: keep the old way to support arch not support irq_desc

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/char/random.c |   66 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/irq.h   |    2 +
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 872669e..9af9bf7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -557,7 +557,7 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
-static struct timer_rand_state input_timer_state;
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 
 #ifdef CONFIG_HAVE_DYN_ARRAY
 static struct timer_rand_state **irq_timer_state;
@@ -566,6 +566,51 @@ DEFINE_DYN_ARRAY(irq_timer_state, sizeof(struct timer_rand_state *), nr_irqs, PA
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
 #endif
 
+static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
+{
+	if (irq >= nr_irqs)
+		return NULL;
+
+	return irq_timer_state[irq];
+}
+
+static void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
+{
+	if (irq >= nr_irqs)
+		return;
+
+	irq_timer_state[irq] = state;
+}
+
+#else
+
+static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+
+	if (!desc)
+		return NULL;
+
+	return desc->timer_rand_state;
+}
+
+static void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
+{
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+
+	if (!desc)
+		return;
+
+	desc->timer_rand_state = state;
+}
+#endif
+
+static struct timer_rand_state input_timer_state;
+
 /*
  * This function adds entropy to the entropy "pool" by using timing
  * delays.  It uses the timer_rand_state structure to make an estimate
@@ -653,11 +698,15 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 void add_interrupt_randomness(int irq)
 {
-	if (irq >= nr_irqs || irq_timer_state[irq] == NULL)
+	struct timer_rand_state *state;
+
+	state = get_timer_rand_state(irq);
+
+	if (state == NULL)
 		return;
 
 	DEBUG_ENT("irq event %d\n", irq);
-	add_timer_randomness(irq_timer_state[irq], 0x100 + irq);
+	add_timer_randomness(state, 0x100 + irq);
 }
 
 #ifdef CONFIG_BLOCK
@@ -917,7 +966,14 @@ void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
 
-	if (irq >= nr_irqs || irq_timer_state[irq])
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+	if (irq >= nr_irqs)
+		return;
+#endif
+
+	state = get_timer_rand_state(irq);
+
+	if (state)
 		return;
 
 	/*
@@ -926,7 +982,7 @@ void rand_initialize_irq(int irq)
 	 */
 	state = kzalloc(sizeof(struct timer_rand_state), GFP_KERNEL);
 	if (state)
-		irq_timer_state[irq] = state;
+		set_timer_rand_state(irq, state);
 }
 
 #ifdef CONFIG_BLOCK
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d447906..74f6bce 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -127,6 +127,7 @@ struct irq_chip {
 	const char	*typename;
 };
 
+struct timer_rand_state;
 /**
  * struct irq_desc - interrupt descriptor
  *
@@ -155,6 +156,7 @@ struct irq_desc {
 	unsigned int		irq;
 #ifdef CONFIG_HAVE_SPARSE_IRQ
 	struct irq_desc		*next;
+	struct timer_rand_state *timer_rand_state;
 #endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
-- 
1.5.4.5

