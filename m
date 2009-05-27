Return-Path: <linux-kernel-owner+w=401wt.eu-S1762499AbZE0H13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762499AbZE0H13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761194AbZE0HZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:25:25 -0400
Received: from claw.goop.org ([74.207.240.146]:33612 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762125AbZE0HZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:25:23 -0400
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
Subject: [PATCH 05/10] x86/PCI: Clean up pci_cache_line_size
Date: Wed, 27 May 2009 00:24:37 -0700
Message-Id: <1243409082-21349-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409082-21349-1-git-send-email-jeremy@goop.org>
References: <1243409082-21349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Separate out x86 cache_line_size initialisation code into its own
function (so it can be shared by Xen later in this patch series)

[ Impact: cleanup ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
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
index 2202b62..011ff45 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -412,26 +412,31 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 
 extern u8 pci_cache_line_size;
 
-int __init pcibios_init(void)
+void __init pcibios_set_cache_line_size(void)
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

