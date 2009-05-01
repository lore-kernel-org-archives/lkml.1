Return-Path: <linux-kernel-owner+w=401wt.eu-S1763591AbZEARMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763591AbZEARMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764144AbZEARKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:10:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:43373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764171AbZEARKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:10:41 -0400
Date: Fri, 1 May 2009 17:08:59 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F95EAE.2050903@kernel.org>
References: <49F95EAE.2050903@kernel.org>
Subject: [tip:irq/numa] x86/irq: use move_irq_desc() in create_irq_nr()
Message-ID: <tip-15e957d08dd4a841359cfec59ecb74041e0097aa@git.kernel.org>
Git-Commit-ID: 15e957d08dd4a841359cfec59ecb74041e0097aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:09:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15e957d08dd4a841359cfec59ecb74041e0097aa
Gitweb:     http://git.kernel.org/tip/15e957d08dd4a841359cfec59ecb74041e0097aa
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 30 Apr 2009 01:17:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 May 2009 19:01:12 +0200

x86/irq: use move_irq_desc() in create_irq_nr()

move_irq_desc() will try to move irq_desc to the home node if
the allocated one is not correct, in create_irq_nr().

( This can happen on devices that are on different nodes that
  are using MSI, when drivers are loaded and unloaded randomly. )

v2: fix non-smp build
v3: add NUMA_IRQ_DESC to eliminate #ifdefs

[ Impact: improve irq descriptor locality on NUMA systems ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49F95EAE.2050903@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig               |    4 ++++
 arch/x86/kernel/apic/io_apic.c |    6 +-----
 include/linux/irq.h            |   11 +++++++++--
 kernel/irq/Makefile            |    2 +-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e1b2543..674e21e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -274,6 +274,10 @@ config SPARSE_IRQ
 
 	  If you don't know what to do here, say N.
 
+config NUMA_IRQ_DESC
+	def_bool y
+	depends on SPARSE_IRQ && NUMA
+
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9cd4806..e583291 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3197,11 +3197,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 		if (cfg_new->vector != 0)
 			continue;
 
-#ifdef CONFIG_NUMA_IRQ_DESC
-		/* different node ?*/
-		if (desc_new->node != node)
-			desc = move_irq_desc(desc, node);
-#endif
+		desc_new = move_irq_desc(desc_new, node);
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 4b95ddb..eedbb8e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -206,9 +206,16 @@ extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
-#else /* CONFIG_SPARSE_IRQ */
+#endif
+
+#ifdef CONFIG_NUMA_IRQ_DESC
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int node);
-#endif /* CONFIG_SPARSE_IRQ */
+#else
+static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
+{
+	return desc;
+}
+#endif
 
 extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 2f06527..7d04780 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -3,5 +3,5 @@ obj-y := handle.o manage.o spurious.o resend.o chip.o devres.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
-obj-$(CONFIG_SPARSE_IRQ) += numa_migrate.o
+obj-$(CONFIG_NUMA_IRQ_DESC) += numa_migrate.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
