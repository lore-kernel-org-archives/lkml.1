Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbXJRB0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbXJRB0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXJRBZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:25:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:41500 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbXJRBZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:25:52 -0400
Subject: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 11:25:42 +1000
Message-Id: <1192670742.12879.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

synchronize_irq needs at the very least a compiler barrier and a
read barrier on SMP, but there are enough cases around where a
write barrier is also needed and it's not a hot path so I prefer
using a full smp_mb() here.

It will degrade to a compiler barrier on !SMP.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/kernel/irq/manage.c
===================================================================
--- linux-work.orig/kernel/irq/manage.c	2007-10-18 11:22:16.000000000 +1000
+++ linux-work/kernel/irq/manage.c	2007-10-18 11:22:20.000000000 +1000
@@ -33,6 +33,7 @@ void synchronize_irq(unsigned int irq)
 	if (irq >= NR_IRQS)
 		return;
 
+	smp_mb();
 	while (desc->status & IRQ_INPROGRESS)
 		cpu_relax();
 }


