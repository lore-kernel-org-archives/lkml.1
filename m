Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZABKl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZABKl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZABKlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:37 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:47480 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZABKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:35 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: amiga core - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:14 +0100
Message-Id: <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/amiints.c |   12 ++++++++----
 arch/m68k/amiga/cia.c     |    4 +++-
 arch/m68k/amiga/config.c  |    3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index 907a553..c5b5212 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -72,10 +72,14 @@ static struct irq_controller amiga_irq_controller = {
 
 void __init amiga_init_IRQ(void)
 {
-	request_irq(IRQ_AUTO_1, ami_int1, 0, "int1", NULL);
-	request_irq(IRQ_AUTO_3, ami_int3, 0, "int3", NULL);
-	request_irq(IRQ_AUTO_4, ami_int4, 0, "int4", NULL);
-	request_irq(IRQ_AUTO_5, ami_int5, 0, "int5", NULL);
+	if (request_irq(IRQ_AUTO_1, ami_int1, 0, "int1", NULL))
+		pr_err("Couldn't register int%d\n", 1);
+	if (request_irq(IRQ_AUTO_3, ami_int3, 0, "int3", NULL))
+		pr_err("Couldn't register int%d\n", 3);
+	if (request_irq(IRQ_AUTO_4, ami_int4, 0, "int4", NULL))
+		pr_err("Couldn't register int%d\n", 4);
+	if (request_irq(IRQ_AUTO_5, ami_int5, 0, "int5", NULL))
+		pr_err("Couldn't register int%d\n", 5);
 
 	m68k_setup_irq_controller(&amiga_irq_controller, IRQ_USER, AMI_STD_IRQS);
 
diff --git a/arch/m68k/amiga/cia.c b/arch/m68k/amiga/cia.c
index 343fab4..ecd0f7c 100644
--- a/arch/m68k/amiga/cia.c
+++ b/arch/m68k/amiga/cia.c
@@ -176,5 +176,7 @@ void __init cia_init_IRQ(struct ciabase *base)
 	/* override auto int and install CIA handler */
 	m68k_setup_irq_controller(&auto_irq_controller, base->handler_irq, 1);
 	m68k_irq_startup(base->handler_irq);
-	request_irq(base->handler_irq, cia_handler, IRQF_SHARED, base->name, base);
+	if (request_irq(base->handler_irq, cia_handler, IRQF_SHARED,
+			base->name, base))
+		pr_err("Couldn't register %s interrupt\n", base->name);
 }
diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 78466f3..71232cd 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -499,7 +499,8 @@ static void __init amiga_sched_init(irq_handler_t timer_routine)
 	 * Please don't change this to use ciaa, as it interferes with the
 	 * SCSI code. We'll have to take a look at this later
 	 */
-	request_irq(IRQ_AMIGA_CIAB_TA, timer_routine, 0, "timer", NULL);
+	if (request_irq(IRQ_AMIGA_CIAB_TA, timer_routine, 0, "timer", NULL))
+		pr_err("Couldn't register timer interrupt\n");
 	/* start timer */
 	ciab.cra |= 0x11;
 }
-- 
1.5.6.5

