Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZEMDOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZEMDOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbZEMDGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:24 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36225
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756066AbZEMDGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:11 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/10] x86/PCI: Enable scanning of all pci functions
Date: Tue, 12 May 2009 14:48:07 -0700
Message-Id: <1242164891-3859-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242164891-3859-1-git-send-email-jeremy@goop.org>
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Xen may want to enable scanning of all pci functions - if for example
the device at function 0 is not passed through to the guest, but the
device at function 1 is.

[Impact: allow passthrough of just some PCI functions.]
Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/x86/include/asm/pci.h |    8 +++++++-
 arch/x86/pci/common.c      |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index b51a1e8..092706e 100644
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
@@ -130,6 +135,7 @@ extern void pci_iommu_alloc(void);
 
 /* generic pci stuff */
 #include <asm-generic/pci.h>
+#undef pcibios_scan_all_fns
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
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
-- 
1.6.0.6

