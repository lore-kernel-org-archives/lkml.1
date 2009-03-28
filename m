Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZC1Ens@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZC1Ens (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 00:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZC1Enj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 00:43:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:40886 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZC1Eni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 00:43:38 -0400
Message-ID: <49CDAAD5.9010202@kernel.org>
Date: Fri, 27 Mar 2009 21:43:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Chris Leech <christopher.leech@intel.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] irq: mask irq before move it
References: <20090326220411.GA16286@cleech-lnx.jf.intel.com> <86802c440903261929s775fe85cv86b900e2610acf1d@mail.gmail.com> <20090327163438.GA10185@cleech-lnx.jf.intel.com>
In-Reply-To: <20090327163438.GA10185@cleech-lnx.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Imapct: fix panic

try to mask the irq, before move the irq desc

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/numa_migrate.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -112,17 +112,21 @@ struct irq_desc *move_irq_desc(struct ir
 {
 	int old_cpu;
 	int node, old_node;
+	unsigned int irq = desc->irq;
 
 	/* those all static, do move them */
-	if (desc->irq < NR_IRQS_LEGACY)
+	if (irq < NR_IRQS_LEGACY)
 		return desc;
 
 	old_cpu = desc->cpu;
 	if (old_cpu != cpu) {
 		node = cpu_to_node(cpu);
 		old_node = cpu_to_node(old_cpu);
-		if (old_node != node)
+		if (old_node != node) {
+			desc->chip->mask(irq);
 			desc = __real_move_irq_desc(desc, cpu);
+			desc->chip->unmask(irq);
+		}
 		else
 			desc->cpu = cpu;
 	}
