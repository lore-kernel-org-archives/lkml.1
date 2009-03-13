Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbZCMREQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbZCMREQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759729AbZCMRBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:09 -0400
Received: from gw.goop.org ([64.81.55.164]:57394 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759219AbZCMRBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:08 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/27] x86/PCI: Clean up pci_cache_line_size
Date: Fri, 13 Mar 2009 09:59:50 -0700
Message-Id: <1236963612-14287-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Separate out x86 cache_line_size initialisation code into its own
function (so it can be shared by Xen later in this patch series)

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pci_x86.h |    1 +
 arch/x86/pci/common.c          |   17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index e60fd3e..5401ca2 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -45,6 +45,7 @@ enum pci_bf_sort_state {
 extern unsigned int pcibios_max_latency;
 
 void pcibios_resource_survey(void);
+void pcibios_set_cache_line_size(void);
 
 /* pci-pc.c */
 
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 82d22fc..081ebd5 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -409,26 +409,31 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 
 extern u8 pci_cache_line_size;
 
-int __init pcibios_init(void)
+void pcibios_set_cache_line_size(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	if (!raw_pci_ops) {
-		printk(KERN_WARNING "PCI: System does not support PCI\n");
-		return 0;
-	}
-
 	/*
 	 * Assume PCI cacheline size of 32 bytes for all x86s except K7/K8
 	 * and P4. It's also good for 386/486s (which actually have 16)
 	 * as quite a few PCI devices do not support smaller values.
 	 */
+
 	pci_cache_line_size = 32 >> 2;
 	if (c->x86 >= 6 && c->x86_vendor == X86_VENDOR_AMD)
 		pci_cache_line_size = 64 >> 2;	/* K7 & K8 */
 	else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
 		pci_cache_line_size = 128 >> 2;	/* P4 */
+}
+
+int __init pcibios_init(void)
+{
+	if (!raw_pci_ops) {
+		printk(KERN_WARNING "PCI: System does not support PCI\n");
+		return 0;
+	}
 
+	pcibios_set_cache_line_size();
 	pcibios_resource_survey();
 
 	if (pci_bf_sort >= pci_force_bf)
-- 
1.6.0.6

