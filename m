Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZALWHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZALWHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZALWF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:05:29 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54677 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753377AbZALWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:05:22 -0500
Message-Id: <20090112220520.696603000@polaris-admin.engr.sgi.com>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Jan 2009 14:05:27 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>
Subject: [PATCH 8/8] sparc irq: update sparc for new irq_desc
Content-Disposition: inline; filename=irq:update-sparc-to-new-irq_desc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, update to new cpumask API

Irq_desc.affinity and irq_desc.pending_mask are now cpumask_var_t's
so access to them should be using the new cpumask API.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: <sparclinux@vger.kernel.org>
---
 arch/sparc/kernel/irq_64.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6-for-ingo.orig/arch/sparc/kernel/irq_64.c
+++ linux-2.6-for-ingo/arch/sparc/kernel/irq_64.c
@@ -247,9 +247,10 @@ struct irq_handler_data {
 #ifdef CONFIG_SMP
 static int irq_choose_cpu(unsigned int virt_irq)
 {
-	cpumask_t mask = irq_desc[virt_irq].affinity;
+	cpumask_t mask;
 	int cpuid;
 
+	cpumask_copy(&mask, irq_desc[virt_irq].affinity);
 	if (cpus_equal(mask, CPU_MASK_ALL)) {
 		static int irq_rover;
 		static DEFINE_SPINLOCK(irq_rover_lock);
@@ -854,7 +855,7 @@ void fixup_irqs(void)
 		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
 			if (irq_desc[irq].chip->set_affinity)
 				irq_desc[irq].chip->set_affinity(irq,
-					&irq_desc[irq].affinity);
+					irq_desc[irq].affinity);
 		}
 		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	}

-- 
