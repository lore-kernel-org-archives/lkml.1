Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZKBQTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZKBQTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZKBQTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:19:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:53702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZKBQTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:19:09 -0500
Date: Mon, 2 Nov 2009 16:17:58 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091026230002.043281924@sbs-t61.sc.intel.com>
References: <20091026230002.043281924@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Remove local_irq_enable()/local_irq_disable() in fixup_irqs()
Message-ID: <tip-5231a68614b94f60e8f6c56bc6e3d75955b9e75e@git.kernel.org>
Git-Commit-ID: 5231a68614b94f60e8f6c56bc6e3d75955b9e75e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5231a68614b94f60e8f6c56bc6e3d75955b9e75e
Gitweb:     http://git.kernel.org/tip/5231a68614b94f60e8f6c56bc6e3d75955b9e75e
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 26 Oct 2009 14:24:36 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:56:37 +0100

x86: Remove local_irq_enable()/local_irq_disable() in fixup_irqs()

To ensure that we handle all the pending interrupts (destined
for this cpu that is going down) in the interrupt subsystem
before the cpu goes offline, fixup_irqs() does:

	local_irq_enable();
	mdelay(1);
	local_irq_disable();

Enabling interrupts is not a good thing as this cpu is already
offline. So this patch replaces that logic with,

	mdelay(1);
	check APIC_IRR bits
	Retrigger the irq at the new destination if any interrupt has arrived
	via IPI.

For IO-APIC level triggered interrupts, this retrigger IPI will
appear as an edge interrupt. ack_apic_level() will detect this
condition and IO-APIC RTE's remoteIRR is cleared using directed
EOI(using IO-APIC EOI register) on Intel platforms and for
others it uses the existing mask+edge logic followed by
unmask+level.

We can also remove mdelay() and then send spuriuous interrupts
to new cpu targets for all the irqs that were handled previously
by this cpu that is going offline. While it works, I have seen
spurious interrupt messages (nothing wrong but still annoying
messages during cpu offline, which can be seen during
suspend/resume etc)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <20091026230002.043281924@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index b10a5e1..8a82728 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -281,7 +281,7 @@ EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
 {
-	unsigned int irq;
+	unsigned int irq, vector;
 	static int warned;
 	struct irq_desc *desc;
 
@@ -336,9 +336,33 @@ void fixup_irqs(void)
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
+	/*
+	 * We can remove mdelay() and then send spuriuous interrupts to
+	 * new cpu targets for all the irqs that were handled previously by
+	 * this cpu. While it works, I have seen spurious interrupt messages
+	 * (nothing wrong but still...).
+	 *
+	 * So for now, retain mdelay(1) and check the IRR and then send those
+	 * interrupts to new targets as this cpu is already offlined...
+	 */
 	mdelay(1);
-	local_irq_disable();
+
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		unsigned int irr;
+
+		if (__get_cpu_var(vector_irq)[vector] < 0)
+			continue;
+
+		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+		if (irr  & (1 << (vector % 32))) {
+			irq = __get_cpu_var(vector_irq)[vector];
+
+			desc = irq_to_desc(irq);
+			spin_lock(&desc->lock);
+			if (desc->chip->retrigger)
+				desc->chip->retrigger(irq);
+			spin_unlock(&desc->lock);
+		}
+	}
 }
 #endif
