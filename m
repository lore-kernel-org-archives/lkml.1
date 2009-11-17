Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZKQOno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZKQOno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZKQOnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:43:43 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:38192 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZKQOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:43:42 -0500
X-Spam-Processed: digidescorp.com, Tue, 17 Nov 2009 08:43:47 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1572194246=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH, RESEND] microblaze: Fix level interrupt ACKing
Date: Tue, 17 Nov 2009 08:43:39 -0600
Message-Id: <1258469019-3863-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Level interrupts need to be ack'd in the unmask handler, as in powerpc. 
Among other issues, this bug causes the system clock to appear to run at 
double-speed.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
--- a/arch/microblaze/kernel/intc.c	2009-06-02 15:26:28.000000000 -0500
+++ b/arch/microblaze/kernel/intc.c	2009-06-02 15:27:39.000000000 -0500
@@ -41,8 +41,16 @@ unsigned int nr_irq;
 
 static void intc_enable_or_unmask(unsigned int irq)
 {
+	unsigned long mask = 1 << irq;
 	pr_debug("enable_or_unmask: %d\n", irq);
-	out_be32(INTC_BASE + SIE, 1 << irq);
+	out_be32(INTC_BASE + SIE, mask);
+
+	/* ack level irqs because they can't be acked during
+	 * ack function since the handle_level_irq function
+	 * acks the irq before calling the interrupt handler
+	 */
+	if (irq_desc[irq].status & IRQ_LEVEL)
+		out_be32(INTC_BASE + IAR, mask);
 }
 
 static void intc_disable_or_mask(unsigned int irq)

