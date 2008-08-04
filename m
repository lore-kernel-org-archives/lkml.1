Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYHDKLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYHDKLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYHDKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:10:58 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:26698 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbYHDKK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DDsdNC4p//nasU8Z/YLDGYKAEgn/aOoOSQFncmNBE2H1WL3OLHaIoGyerQHC4yv53E
         WRDmf3wq/62lHCmCSVpzE7/nhwIPFED0NVqX0hu7Hu3Y0TrwrT75XIGBmb3EMiz2QJpv
         T05m/O3T3OmmjZazK1HNnqOiUdoAoONbth6HU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 03/04] x86: put timer_rand_state pointer into irq_desc
Date: Mon,  4 Aug 2008 03:10:00 -0700
Message-Id: <1217844601-4298-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217844601-4298-3-git-send-email-yhlu.kernel@gmail.com>
References: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>
 <1217844601-4298-2-git-send-email-yhlu.kernel@gmail.com>
 <1217844601-4298-3-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could remove timer_rand_state pointer array

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
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
 
-	if (irq >= nr_irqs || irq_timer_state[irq])
+	desc = get_irq_desc(irq);
+	state = desc->timer_rand_state;
+
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
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -129,6 +129,7 @@ struct irq_chip {
 	const char	*typename;
 };
 
+struct timer_rand_state;
 /**
  * struct irq_desc - interrupt descriptor
  *
@@ -158,6 +159,7 @@ struct irq_desc {
 	unsigned int		irq;
 	struct irq_desc		*next;
 #endif
+	struct timer_rand_state *timer_rand_state;
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
