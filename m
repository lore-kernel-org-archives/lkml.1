Return-Path: <linux-kernel-owner+w=401wt.eu-S1764839AbYHHWFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764839AbYHHWFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761945AbYHHVy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762175AbYHHVyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RlhJlR4GlD85MJmSgrvbnYIf4CwqUNrT+C5ZFNUN8xE306uIVgQPLg5ZiJOZjGjm3K
         abrYRFgP05WI5GBOIhp/fsHDKTysUB7PaCDEMumDqff84M5qzV9pI4s0GAkOc7OE6Qw5
         y+vu8IT/bTlAJ6FfTPQAHuhh2yvBcfL0lZETc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 29/42] x86: put timer_rand_state pointer into irq_desc
Date: Fri,  8 Aug 2008 14:52:35 -0700
Message-Id: <1218232368-31228-30-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-29-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-24-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-25-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-27-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-28-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-29-git-send-email-yhlu.kernel@gmail.com>
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
index 872669e..d683576 100644
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
+	desc = irq_desc(irq);
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
+	desc = irq_desc(irq);
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
index 4172140..ed2a79e 100644
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

