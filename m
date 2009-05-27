Return-Path: <linux-kernel-owner+w=401wt.eu-S1762582AbZE0H1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762582AbZE0H1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762122AbZE0HZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:25:29 -0400
Received: from claw.goop.org ([74.207.240.146]:33623 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950AbZE0HZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:25:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/10] x86/PCI: Enable scanning of all pci functions
Date: Wed, 27 May 2009 00:24:38 -0700
Message-Id: <1243409082-21349-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409082-21349-1-git-send-email-jeremy@goop.org>
References: <1243409082-21349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Xen may want to enable scanning of all pci functions - if for example
the device at function 0 is not passed through to the guest, but the
device at function 1 is.

Jesse objected to the "#undef pcibios_scan_all_fns"'s ugliness,
so replace it with the more common HAVE_ARCH_ idiom.

[ Impact: allow passthrough of just some PCI functions. ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/include/asm/pci.h |    8 +++++++-
 arch/x86/pci/common.c      |    1 +
 include/asm-generic/pci.h  |    2 ++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index b51a1e8..cabea93 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -21,6 +21,7 @@ struct pci_sysdata {
 extern int pci_routeirq;
 extern int noioapicquirk;
 extern int noioapicreroute;
+extern int pci_scan_all_fns;
 
 /* scan a bus after allocating a pci_sysdata for it */
 extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops,
@@ -48,7 +49,11 @@ extern unsigned int pcibios_assign_all_busses(void);
 #else
 #define pcibios_assign_all_busses()	0
 #endif
-#define pcibios_scan_all_fns(a, b)	0
+
+static inline int pcibios_scan_all_fns(struct pci_bus *bus, int devfn)
+{
+	return pci_scan_all_fns;
+}
 
 extern unsigned long pci_mem_start;
 #define PCIBIOS_MIN_IO		0x1000
@@ -129,6 +134,7 @@ extern void pci_iommu_alloc(void);
 #include <asm-generic/pci-dma-compat.h>
 
 /* generic pci stuff */
+#define HAVE_ARCH_PCIBIOS_SCAN_ALL_FNS
 #include <asm-generic/pci.h>
 
 #ifdef CONFIG_NUMA
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 011ff45..6a522c2 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -22,6 +22,7 @@ unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 unsigned int pci_early_dump_regs;
 static int pci_bf_sort;
 int pci_routeirq;
+int pci_scan_all_fns;
 int noioapicquirk;
 #ifdef CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 int noioapicreroute = 0;
diff --git a/include/asm-generic/pci.h b/include/asm-generic/pci.h
index c36a77d..9ad9cb7 100644
--- a/include/asm-generic/pci.h
+++ b/include/asm-generic/pci.h
@@ -43,7 +43,9 @@ pcibios_select_root(struct pci_dev *pdev, struct resource *res)
 	return root;
 }
 
+#ifndef HAVE_ARCH_PCIBIOS_SCAN_ALL_FNS
 #define pcibios_scan_all_fns(a, b)	0
+#endif
 
 #ifndef HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
-- 
1.6.0.6

