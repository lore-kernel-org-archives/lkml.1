Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZK0VKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZK0VKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 16:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZK0VKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 16:10:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47006 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZK0VKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 16:10:06 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH] warn about shared irqs requesting IRQF_DISABLED registered with setup_irq
Date: Fri, 27 Nov 2009 22:10:06 +0100
Message-Id: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091127195857.GB28193@n2100.arm.linux.org.uk>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk>
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

IRQF_DISABLED is not guaranteed on shared irqs.  There is already a
warning in place for irqs registered with request_irq (introduced in
470c66239ef03).  Move it to __setup_irq, this way it triggers for both
request_irq and setup_irq.

One irq that is now warned about is the timer tick on at91 (ARCH=arm).

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nicolas Pitre <nico@marvell.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Remy Bohmer <linux@bohmer.net>,
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
Cc: Andrea Gallo <andrea.gallo@stericsson.com>,
Cc: Thomas Gleixner <tglx@linutronix.de>,
Cc: linux-arm-kernel@lists.infradead.org
---
 kernel/irq/manage.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bde4c66..59f4b54 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -613,6 +613,19 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	int nested, shared = 0;
 	int ret;
 
+	/*
+	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
+	 * the _first_ irqaction (sigh).  That can cause oopsing, but
+	 * the behavior is classified as "will not fix" so we need to
+	 * start nudging drivers away from using that idiom.
+	 */
+	if ((new->flags & (IRQF_SHARED|IRQF_DISABLED)) ==
+					(IRQF_SHARED|IRQF_DISABLED)) {
+		pr_warning(
+		  "IRQ %d/%s: IRQF_DISABLED is not guaranteed on shared IRQs\n",
+			irq, new->name);
+	}
+
 	if (!desc)
 		return -EINVAL;
 
@@ -1008,19 +1021,6 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
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
1.6.5.2

