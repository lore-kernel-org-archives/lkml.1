Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbZCMRCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbZCMRCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbZCMRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:00:57 -0400
Received: from gw.goop.org ([64.81.55.164]:57395 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759401AbZCMRAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:00:55 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/27] x86/PCI: Enable scanning of all pci functions
Date: Fri, 13 Mar 2009 09:59:51 -0700
Message-Id: <1236963612-14287-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Xen may want to enable scanning of all pci functions - if for example
the device at function 0 is not passed through to the guest, but the
device at function 1 is.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pci.h |    8 +++++++-
 arch/x86/pci/common.c      |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index a977de2..cd50c02 100644
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
@@ -99,6 +104,7 @@ extern void pci_iommu_alloc(void);
 
 /* generic pci stuff */
 #include <asm-generic/pci.h>
+#undef pcibios_scan_all_fns
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 081ebd5..05525bf 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -22,6 +22,7 @@ unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 unsigned int pci_early_dump_regs;
 static int pci_bf_sort;
 int pci_routeirq;
+int pci_scan_all_fns = 0;
 int noioapicquirk;
 #ifdef CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 int noioapicreroute = 0;
-- 
1.6.0.6

