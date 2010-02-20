Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0BTB2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:28:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:56044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab0BTB2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:28:34 -0500
Date: Sat, 20 Feb 2010 01:28:23 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D00@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D00@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86: Add pcibios_fixup_irqs to x86_init
Message-ID: <tip-9325a28ce2fa7c597e5ed41455a06c30b82b5710@git.kernel.org>
Git-Commit-ID: 9325a28ce2fa7c597e5ed41455a06c30b82b5710
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Feb 2010 01:28:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9325a28ce2fa7c597e5ed41455a06c30b82b5710
Gitweb:     http://git.kernel.org/tip/9325a28ce2fa7c597e5ed41455a06c30b82b5710
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 29 Aug 2009 17:51:26 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Feb 2010 16:12:39 -0800

x86: Add pcibios_fixup_irqs to x86_init

Platforms like Moorestown want to override the pcibios_fixup_irqs
default function. Add it to x86_init.pci.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D00@orsmsx508.amr.corp.intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/pci_x86.h  |    3 +++
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/x86_init.c      |    2 ++
 arch/x86/pci/irq.c              |    4 ++--
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 46511c5..6e69edf 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -113,6 +113,7 @@ extern int __init pci_acpi_init(void);
 extern void __init pcibios_irq_init(void);
 extern int __init pcibios_init(void);
 extern int pci_legacy_init(void);
+extern void pcibios_fixup_irqs(void);
 
 /* pci-mmconfig.c */
 
@@ -188,7 +189,9 @@ static inline void mmio_config_writel(void __iomem *pos, u32 val)
 #  define x86_default_pci_init		pci_legacy_init
 # endif
 # define x86_default_pci_init_irq	pcibios_irq_init
+# define x86_default_pci_fixup_irqs	pcibios_fixup_irqs
 #else
 # define x86_default_pci_init		NULL
 # define x86_default_pci_init_irq	NULL
+# define x86_default_pci_fixup_irqs	NULL
 #endif
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 34f61cd..8ef56f2 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -102,10 +102,12 @@ struct x86_init_iommu {
   * struct x86_init_pci - platform specific pci init functions
  * @init:			platform specific pci init
  * @init_irq:			platform specific pci irq init
+ * @fixup_irqs:			platform specific pci irq fixup
  */
 struct x86_init_pci {
 	int (*init)(void);
 	void (*init_irq)(void);
+	void (*fixup_irqs)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 203f26f..1817cd7 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -4,6 +4,7 @@
  *  For licencing details see kernel-base/COPYING
  */
 #include <linux/init.h>
+#include <linux/ioport.h>
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
@@ -75,6 +76,7 @@ struct x86_init_ops x86_init __initdata = {
 	.pci = {
 		.init			= x86_default_pci_init,
 		.init_irq		= x86_default_pci_init_irq,
+		.fixup_irqs		= x86_default_pci_fixup_irqs,
 	},
 };
 
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 0f40ff2..a60deb6 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1016,7 +1016,7 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 	return 1;
 }
 
-static void __init pcibios_fixup_irqs(void)
+void __init pcibios_fixup_irqs(void)
 {
 	struct pci_dev *dev = NULL;
 	u8 pin;
@@ -1142,7 +1142,7 @@ void __init pcibios_irq_init(void)
 			pirq_table = NULL;
 	}
 
-	pcibios_fixup_irqs();
+	x86_init.pci.fixup_irqs();
 
 	if (io_apic_assign_pci_irqs && pci_routeirq) {
 		struct pci_dev *dev = NULL;
