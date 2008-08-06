Return-Path: <linux-kernel-owner+w=401wt.eu-S1765006AbYHFJDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765006AbYHFJDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758223AbYHFIpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:45:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:13145 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYHFIpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sJPeHl5zIkMt0Y6VJwN2z41dZB6OvOquC+kueQwk4O/VVrkgdY89L148tg9gAk8xtP
         KBFE92mtpkkB7tPn5BluwcmRoVje0cxgAQrZl0Pvu81F6+IPOyYoNa/s9a3LeMFzr/j7
         8ApNp8RfsYRhtFkg0UoWNNwnF9GIidNy/wXoc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 29/33] x86: put timer_rand_state pointer into irq_desc
Date: Wed,  6 Aug 2008 01:43:11 -0700
Message-Id: <1218012195-10429-30-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-29-git-send-email-yhlu.kernel@gmail.com>
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-2-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-3-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-4-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-5-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-6-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-7-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-10-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-11-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-12-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-13-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-14-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-15-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-16-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-17-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-18-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-19-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-20-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-21-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-22-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-23-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-24-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-25-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-26-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-27-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-28-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-29-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could remove timer_rand_state pointer array

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/char/random.c |   31 ++++++++++++++++++++-----------
 include/linux/irq.h   |    2 ++
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 872669e..d9e7a08 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -559,13 +559,6 @@ struct timer_rand_state {
 
 static struct timer_rand_state input_timer_state;
 
-#ifdef CONFIG_HAVE_DYN_ARRAY
-static struct timer_rand_state **irq_timer_state;
-DEFINE_DYN_ARRAY(irq_timer_state, sizeof(struct timer_rand_state *), nr_irqs, PAGE_SIZE, NULL);
-#else
-static struct timer_rand_state *irq_timer_state[NR_IRQS];
-#endif
-
 /*
  * This function adds entropy to the entropy "pool" by using timing
  * delays.  It uses the timer_rand_state structure to make an estimate
@@ -653,11 +646,20 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 void add_interrupt_randomness(int irq)
 {
-	if (irq >= nr_irqs || irq_timer_state[irq] == NULL)
+	struct timer_rand_state *state;
+	struct irq_desc *desc;
+
+	if (irq >= nr_irqs)
+		return;
+
+	desc = get_irq_desc(irq);
+	state = desc->timer_rand_state;
+
+	if (state == NULL)
 		return;
 
 	DEBUG_ENT("irq event %d\n", irq);
-	add_timer_randomness(irq_timer_state[irq], 0x100 + irq);
+	add_timer_randomness(state, 0x100 + irq);
 }
 
 #ifdef CONFIG_BLOCK
@@ -916,8 +918,15 @@ module_init(rand_initialize);
 void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
+	struct irq_desc *desc;
+
+	if (irq >= nr_irqs)
+		return;
+
+	desc = get_irq_desc(irq);
+	state = desc->timer_rand_state;
 
-	if (irq >= nr_irqs || irq_timer_state[irq])
+	if (state)
 		return;
 
 	/*
@@ -926,7 +935,7 @@ void rand_initialize_irq(int irq)
 	 */
 	state = kzalloc(sizeof(struct timer_rand_state), GFP_KERNEL);
 	if (state)
-		irq_timer_state[irq] = state;
+		desc->timer_rand_state = state;
 }
 
 #ifdef CONFIG_BLOCK
diff --git a/include/linux/irq.h b/include/linux/irq.h
index aaf2029..3abdf48 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -129,6 +129,7 @@ struct irq_chip {
 	const char	*typename;
 };
 
+struct timer_rand_state;
 /**
  * struct irq_desc - interrupt descriptor
  *
@@ -158,6 +159,7 @@ struct irq_desc {
 #ifdef CONFIG_HAVE_SPARSE_IRQ
 	struct irq_desc		*next;
 #endif
+	struct timer_rand_state *timer_rand_state;
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
-- 
1.5.4.5

