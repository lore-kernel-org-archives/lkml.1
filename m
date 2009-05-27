Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZE0Hr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZE0Hr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZE0Hrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:47:47 -0400
Received: from claw.goop.org ([74.207.240.146]:53658 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbZE0Hrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:47:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 17/17] xen: disable MSI
Date: Wed, 27 May 2009 00:37:30 -0700
Message-Id: <1243409850-21577-18-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409850-21577-1-git-send-email-jeremy@goop.org>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Disable MSI until we support it properly.

[ Impact: prevent MSI subsystem from crashing ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/apic.c |    3 +++
 drivers/pci/pci.h   |    2 --
 include/linux/pci.h |    6 ++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index 35a8af7..fece57a 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/bitmap.h>
+#include <linux/pci.h>
 
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
@@ -54,6 +55,8 @@ void xen_init_apic(void)
 	if (!xen_initial_domain())
 		return;
 
+	pci_no_msi();
+
 	set_io_apic_ops(&xen_ioapic_ops);
 
 #ifdef CONFIG_ACPI
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

