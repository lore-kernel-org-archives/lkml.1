Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbZEGASX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbZEGASX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758953AbZEGARx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:17:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:8768 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZEGARw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:17:52 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] genirq: ensure IRQs are lazy disabled before suspend
Date: Wed,  6 May 2009 17:17:48 -0700
Message-Id: <1241655468-5750-2-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1241655468-5750-1-git-send-email-khilman@deeprootsystems.com>
References: <1241655468-5750-1-git-send-email-khilman@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 76d2160147f43f982dfe881404cfde9fd0a9da21, the default
behavior of disable_irq() was changed to delay the disable until it is
next handled.

However, this leaves open the possibility that the system can go into
suspend with an interrupt enabled.  For example, if a driver calls
disable_irq() in its suspend_hook (for example, to prevent that device
IRQ from causing a system wakeup) there's now a possibility that the
system is suspended before the lazy disable happens.

The result is an unwanted wakeup from suspend if the IRQ is capable of
waking the system (common on embedded SoCs.)

This patch ensures that the lazy disable is done, and masked by
the irq_chip before the system goes into suspend.

Note that even though __disable_irq() also calls irq_chip->disable, it
is quite common for the irq_chip not to provide a disable hook in
which case the IRQ is never masked/disabled in hardware before going
into suspend.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 kernel/irq/manage.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2734eca..5d2cc1c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -190,6 +190,11 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 		if (!desc->action || (desc->action->flags & IRQF_TIMER))
 			return;
 		desc->status |= IRQ_SUSPENDED;
+
+		/* Lazy disable: handles case where lazy disable in
+		 * handler doesn't happen before suspend. */
+		if (desc->status & IRQ_DISABLED)
+			desc->chip->mask(irq);
 	}
 
 	if (!desc->depth++) {
-- 
1.6.2.2

