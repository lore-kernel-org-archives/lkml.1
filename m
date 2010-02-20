Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0BTBaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:30:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:56156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab0BTBaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:30:02 -0500
Date: Sat, 20 Feb 2010 01:29:41 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A30A7660@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755A30A7660@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, apic: Remove ioapic_disable_legacy()
Message-ID: <tip-1f91233c26fd5f7d6525fd29b95e4b50ca7a3e88@git.kernel.org>
Git-Commit-ID: 1f91233c26fd5f7d6525fd29b95e4b50ca7a3e88
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Feb 2010 01:29:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f91233c26fd5f7d6525fd29b95e4b50ca7a3e88
Gitweb:     http://git.kernel.org/tip/1f91233c26fd5f7d6525fd29b95e4b50ca7a3e88
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Fri, 5 Feb 2010 04:06:56 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Feb 2010 17:16:38 -0800

x86, apic: Remove ioapic_disable_legacy()

The ioapic_disable_legacy() call is no longer needed for platforms do
not have legacy pic. the legacy pic abstraction has taken care it
automatically.

This patch also initialize irq-related static variables based on
information obtained from legacy_pic.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F0755A30A7660@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/io_apic.h |    2 --
 arch/x86/kernel/apic/io_apic.c |   10 +++++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7c7c16c..84fdd51 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -143,8 +143,6 @@ extern int noioapicreroute;
 /* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
 extern int timer_through_8259;
 
-extern void io_apic_disable_legacy(void);
-
 /*
  * If we use the IO-APIC for IRQ routing, disable automatic
  * assignment of PCI IRQ's.
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1704cd8..3592a72 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -143,11 +143,6 @@ static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
 static struct irq_cfg irq_cfgx[NR_IRQS];
 #endif
 
-void __init io_apic_disable_legacy(void)
-{
-	nr_irqs_gsi = 0;
-}
-
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
@@ -156,6 +151,11 @@ int __init arch_early_irq_init(void)
 	int node;
 	int i;
 
+	if (!legacy_pic->nr_legacy_irqs) {
+		nr_irqs_gsi = 0;
+		io_apic_irqs = ~0UL;
+	}
+
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
 	node= cpu_to_node(boot_cpu_id);
