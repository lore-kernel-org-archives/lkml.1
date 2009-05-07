Return-Path: <linux-kernel-owner+w=401wt.eu-S1763985AbZEHAXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763985AbZEHAXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZEHAKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:32 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52713
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757120AbZEHAKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:04 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 16/18] xen: disable MSI
Date: Thu,  7 May 2009 14:14:41 -0700
Message-Id: <1241730883-4917-17-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: prevent MSI subsystem from crashing

Disable MSI until we support it properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/apic.c |    3 +++
 drivers/pci/pci.h   |    2 --
 include/linux/pci.h |    6 ++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index e9d9ea7..3f890c4 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/bitmap.h>
+#include <linux/pci.h>
 
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
@@ -47,6 +48,8 @@ void xen_init_apic(void)
 	if (!xen_initial_domain())
 		return;
 
+	pci_no_msi();
+
 #ifdef CONFIG_ACPI
 	/*
 	 * Pretend ACPI found our lapic even though we've disabled it,
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d03f6b9..79ada7b 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -111,10 +111,8 @@ extern struct rw_semaphore pci_bus_sem;
 extern unsigned int pci_pm_d3_delay;
 
 #ifdef CONFIG_PCI_MSI
-void pci_no_msi(void);
 extern void pci_msi_init_pci_dev(struct pci_dev *dev);
 #else
-static inline void pci_no_msi(void) { }
 static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
 #endif
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 72698d8..724d030 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1253,5 +1253,11 @@ static inline irqreturn_t pci_sriov_migration(struct pci_dev *dev)
 }
 #endif
 
+#ifdef CONFIG_PCI_MSI
+void pci_no_msi(void);
+#else
+static inline void pci_no_msi(void) { }
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
-- 
1.6.0.6

