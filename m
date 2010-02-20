Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0BTB3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:29:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:56092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab0BTB3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:29:01 -0500
Date: Sat, 20 Feb 2010 01:28:39 GMT
From: tip-bot for Alek Du <alek.du@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       alek.du@intel.com, jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       alek.du@intel.com, jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, ioapic: Improve handling of i8259A irq init
Message-ID: <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org>
Git-Commit-ID: d39f6495f66616b637260405d0b5dc2656bc490e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Feb 2010 01:28:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d39f6495f66616b637260405d0b5dc2656bc490e
Gitweb:     http://git.kernel.org/tip/d39f6495f66616b637260405d0b5dc2656bc490e
Author:     Alek Du <alek.du@intel.com>
AuthorDate: Mon, 7 Sep 2009 16:25:45 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Feb 2010 16:25:17 -0800

x86, ioapic: Improve handling of i8259A irq init

Since we already track the number of legacy vectors by nr_legacy_irqs, we
can avoid use static vector allocations -- we can use dynamic one.

Signed-off-by: Alek Du <alek.du@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 53243ca..75265ab 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -140,27 +140,10 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
-static struct irq_cfg irq_cfgx[] = {
+static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
 #else
-static struct irq_cfg irq_cfgx[NR_IRQS] = {
+static struct irq_cfg irq_cfgx[NR_IRQS];
 #endif
-	[0]  = { .vector = IRQ0_VECTOR,  },
-	[1]  = { .vector = IRQ1_VECTOR,  },
-	[2]  = { .vector = IRQ2_VECTOR,  },
-	[3]  = { .vector = IRQ3_VECTOR,  },
-	[4]  = { .vector = IRQ4_VECTOR,  },
-	[5]  = { .vector = IRQ5_VECTOR,  },
-	[6]  = { .vector = IRQ6_VECTOR,  },
-	[7]  = { .vector = IRQ7_VECTOR,  },
-	[8]  = { .vector = IRQ8_VECTOR,  },
-	[9]  = { .vector = IRQ9_VECTOR,  },
-	[10] = { .vector = IRQ10_VECTOR, },
-	[11] = { .vector = IRQ11_VECTOR, },
-	[12] = { .vector = IRQ12_VECTOR, },
-	[13] = { .vector = IRQ13_VECTOR, },
-	[14] = { .vector = IRQ14_VECTOR, },
-	[15] = { .vector = IRQ15_VECTOR, },
-};
 
 void __init io_apic_disable_legacy(void)
 {
@@ -181,6 +164,8 @@ int __init arch_early_irq_init(void)
 	node= cpu_to_node(boot_cpu_id);
 
 	for (i = 0; i < count; i++) {
+		if (i < nr_legacy_irqs)
+			cfg[i].vector = IRQ0_VECTOR + i;
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
