Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZJZWCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZJZWCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZJZWCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:02:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:35298 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZJZWCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:02:33 -0400
X-ExtLoop1: 1
Message-Id: <20091026230001.661423939@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 26 Oct 2009 14:24:32 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, ebiederm@xmission.com
Cc: garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [patch 2/6] x86, intr-remap: Avoid irq_chip mask/unmask in fixup_irqs() for intr-remapping
References: <20091026222430.313656103@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_fixup_irqs_intr_remap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the presence of interrupt-remapping, irqs will be migrated in the
process context and we don't do (and there is no need to) irq_chip mask/unmask
while migrating the interrupt.

Similarly fix the fixup_irqs() that get called during cpu offline and avoid
calling irq_chip mask/unmask for irqs that are ok to be migrated in the
process context.

While we didn't observe any race condition with the existing code,
this change takes complete advantage of interrupt-remapping in
the newer generation platforms and avoids any potential HW lockup's
(that often worry Eric :)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: tree/arch/x86/kernel/irq.c
===================================================================
--- tree.orig/arch/x86/kernel/irq.c
+++ tree/arch/x86/kernel/irq.c
@@ -308,7 +308,7 @@ void fixup_irqs(void)
 			affinity = cpu_all_mask;
 		}
 
-		if (desc->chip->mask)
+		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
 			desc->chip->mask(irq);
 
 		if (desc->chip->set_affinity)
@@ -316,7 +316,7 @@ void fixup_irqs(void)
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (desc->chip->unmask)
+		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
 			desc->chip->unmask(irq);
 
 		spin_unlock(&desc->lock);


