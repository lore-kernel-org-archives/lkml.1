Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab0BZK04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:26:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:34443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313Ab0BZK0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:26:51 -0500
Date: Fri, 26 Feb 2010 10:26:10 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100207210250.GB8256@jenkins.home.ifup.org>
References: <20100207210250.GB8256@jenkins.home.ifup.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86: apic: Fix mismerge, add arch_probe_nr_irqs() again
Message-ID: <tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
Git-Commit-ID: f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 10:26:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4
Gitweb:     http://git.kernel.org/tip/f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 26 Feb 2010 11:17:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 11:17:16 +0100

x86: apic: Fix mismerge, add arch_probe_nr_irqs() again

Merge commit aef55d4922 mis-merged io_apic.c so we lost the
arch_probe_nr_irqs() method.

This caused subtle boot breakages (udev confusion likely
due to missing drivers) with certain configs.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20100207210250.GB8256@jenkins.home.ifup.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 527390c..c13ab8f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3874,6 +3874,28 @@ void __init probe_nr_irqs_gsi(void)
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+int __init arch_probe_nr_irqs(void)
+{
+	int nr;
+
+	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
+		nr_irqs = NR_VECTORS * nr_cpu_ids;
+
+	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
+#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
+	/*
+	 * for MSI and HT dyn irq
+	 */
+	nr += nr_irqs_gsi * 16;
+#endif
+	if (nr < nr_irqs)
+		nr_irqs = nr;
+
+	return 0;
+}
+#endif
+
 static int __io_apic_set_pci_routing(struct device *dev, int irq,
 				struct io_apic_irq_attr *irq_attr)
 {
