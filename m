Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZFDTCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZFDTCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZFDTCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:02:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:2665 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZFDTCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:02:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,306,1241420400"; 
   d="scan'208";a="521834479"
Subject: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for
 interrupt-remapping
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, andi@linux.intel.com,
       travis@sgi.com, steiner@sgi.com
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 04 Jun 2009 11:59:49 -0700
Message-Id: <1244141989.27006.10369.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping

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
Cc: Eric W. Biederman <ebiederm@xmission.com>
---

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 977d8b4..82265a5 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -95,7 +95,7 @@ void fixup_irqs(void)
 			affinity = cpu_all_mask;
 		}
 
-		if (desc->chip->mask)
+		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
 			desc->chip->mask(irq);
 
 		if (desc->chip->set_affinity)
@@ -103,7 +103,7 @@ void fixup_irqs(void)
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (desc->chip->unmask)
+		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
 			desc->chip->unmask(irq);
 
 		spin_unlock(&desc->lock);


