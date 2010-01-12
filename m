Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032Ab0ALPmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0ALPmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988Ab0ALPmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:42:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44592 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab0ALPmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:42:13 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
Subject: [RESEND PATCH] genirq: warn about IRQF_SHARED|IRQF_DISABLED at the right place
Date: Tue, 12 Jan 2010 16:42:02 +0100
Message-Id: <1263310922-5251-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For shared irqs IRQF_DISABLED is only guaranteed for the first handler.
So only warn starting at the second registration.

The warning is moved to __setup_irq having the additional benefit of
catching actions registered using setup_irq not only register_irq.

This doesn't fix the cases where setup order is wrong but it should
report the broken cases more reliably.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nicolas Pitre <nico@marvell.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Remy Bohmer <linux@bohmer.net>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Gallo <andrea.gallo@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: linux-arm-kernel@lists.infradead.org
---
Hello,

until Thomas or Peter get round to dump IRQF_DISABLED completely this
patch removes some false positive warnings and adds a valid warning in
some situations that weren't catched before.

Best regards
Uwe

 kernel/irq/manage.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bde4c66..d8f7415 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -702,6 +702,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			goto mismatch;
 #endif
 
+		/*
+		 * handle_IRQ_event() only honors IRQF_DISABLED for the _first_
+		 * irqaction.  As the first handler might reenable irqs all bets
+		 * are off for the later handlers even if the first one has
+		 * IRQF_DISABLED, too.
+		 */
+		if (new->flags & IRQF_DISABLED)
+			pr_warning("IRQ %d/%s: IRQF_DISABLED is not guaranteed "
+					"on shared IRQs\n", irq, new->name);
+
 		/* add new interrupt at end of irq queue */
 		do {
 			old_ptr = &old->next;
@@ -1008,19 +1018,6 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	struct irq_desc *desc;
 	int retval;
 
-	/*
-	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
-	 * the _first_ irqaction (sigh).  That can cause oopsing, but
-	 * the behavior is classified as "will not fix" so we need to
-	 * start nudging drivers away from using that idiom.
-	 */
-	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED)) ==
-					(IRQF_SHARED|IRQF_DISABLED)) {
-		pr_warning(
-		  "IRQ %d/%s: IRQF_DISABLED is not guaranteed on shared IRQs\n",
-			irq, devname);
-	}
-
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * Lockdep wants atomic interrupt handlers:
-- 
1.6.6

