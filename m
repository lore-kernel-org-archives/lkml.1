Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbXISRDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbXISRDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760612AbXISRDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:03:08 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53146 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbXISRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:03:05 -0400
Date: Wed, 19 Sep 2007 13:02:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 7/11] UML - clocksource support
Message-ID: <20070919170226.GA10191@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add clocksource support.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/time.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6.20/arch/um/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/kernel/time.c	2007-09-19 12:25:07.000000000 -0400
+++ linux-2.6.20/arch/um/kernel/time.c	2007-09-19 12:25:07.000000000 -0400
@@ -97,6 +97,21 @@ static irqreturn_t um_timer(int irq, voi
 	return IRQ_HANDLED;
 }
 
+static cycle_t itimer_read(void)
+{
+	return os_nsecs();
+}
+
+static struct clocksource itimer_clocksource = {
+	.name		= "itimer",
+	.rating		= 300,
+	.read		= itimer_read,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 1,
+	.shift		= 0,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
 static void __init setup_itimer(void)
 {
 	int err;
@@ -106,6 +121,12 @@ static void __init setup_itimer(void)
 		printk(KERN_ERR "register_timer : request_irq failed - "
 		       "errno = %d\n", -err);
 
+	err = clocksource_register(&itimer_clocksource);
+	if (err) {
+		printk(KERN_ERR "clocksource_register returned %d\n", err);
+		return;
+	}
+
 	itimer_clockevent.mult = div_sc(HZ, NSEC_PER_SEC, 32);
 	itimer_clockevent.max_delta_ns =
 		clockevent_delta2ns(60 * HZ, &itimer_clockevent);
