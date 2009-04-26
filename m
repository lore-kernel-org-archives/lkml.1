Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZDZROS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZDZROS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZDZROE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:14:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbZDZROC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:14:02 -0400
Date: Sun, 26 Apr 2009 19:13:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20090426171340.GA19477@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Pallipadi, Venkatesh (1):
      x86, irq: Remove IRQ_DISABLED check in process context IRQ move

Yinghai Lu (1):
      x86/irq: mark NUMA_MIGRATE_IRQ_DESC broken


 arch/x86/Kconfig               |    1 +
 arch/x86/kernel/apic/io_apic.c |    2 ++
 kernel/irq/manage.c            |    5 ++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bc25b9f..b1d2be7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -277,6 +277,7 @@ config SPARSE_IRQ
 config NUMA_MIGRATE_IRQ_DESC
 	bool "Move irq desc when changing irq smp_affinity"
 	depends on SPARSE_IRQ && NUMA
+	depends on BROKEN
 	default n
 	---help---
 	  This enables moving irq_desc to cpu/node that irq will use handled.
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a2789e4..30da617 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3670,12 +3670,14 @@ int arch_setup_hpet_msi(unsigned int irq)
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	ret = msi_compose_msg(NULL, irq, &msg);
 	if (ret < 0)
 		return ret;
 
 	hpet_msi_write(irq, &msg);
+	desc->status |= IRQ_MOVE_PCNTXT;
 	set_irq_chip_and_handler_name(irq, &hpet_msi_type, handle_edge_irq,
 		"edge");
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 7e2e7dd..2734eca 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -109,10 +109,9 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	spin_lock_irqsave(&desc->lock, flags);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
-		cpumask_copy(desc->affinity, cpumask);
+	if (desc->status & IRQ_MOVE_PCNTXT)
 		desc->chip->set_affinity(irq, cpumask);
-	} else {
+	else {
 		desc->status |= IRQ_MOVE_PENDING;
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
