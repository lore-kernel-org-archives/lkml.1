Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZJNUcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZJNUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZJNUcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:32:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZJNUcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:32:08 -0400
Date: Wed, 14 Oct 2009 16:31:39 -0400
From: Dave Jones <davej@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [X86] PCI: Use generic cacheline sizing instead of per-vendor
	tests.
Message-ID: <20091014203139.GA2336@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the PCI code needing to have code to determine the 
cacheline size of each processor, use the data the cpu identification
code should have already determined during early boot.

(The vendor checks are also incomplete, and don't take into account
 modern CPUs)

I've been carrying a variant of this code in Fedora for a while,
that prints debug information.  There are a number of cases where we
are currently setting the PCI cacheline size to 32 bytes, when the CPU
cacheline size is 64 bytes.  With this patch, we set them both the same.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 1331fcf..b9f9373 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -422,15 +422,20 @@ int __init pcibios_init(void)
 	}
 
 	/*
-	 * Assume PCI cacheline size of 32 bytes for all x86s except K7/K8
-	 * and P4. It's also good for 386/486s (which actually have 16)
+	 * Set PCI cacheline size to that of the CPU if the CPU has reported it.
+	 * (For older CPUs that don't support cpuid, we se it to 32 bytes
+	 * It's also good for 386/486s (which actually have 16)
 	 * as quite a few PCI devices do not support smaller values.
 	 */
-	pci_cache_line_size = 32 >> 2;
-	if (c->x86 >= 6 && c->x86_vendor == X86_VENDOR_AMD)
-		pci_cache_line_size = 64 >> 2;	/* K7 & K8 */
-	else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
-		pci_cache_line_size = 128 >> 2;	/* P4 */
+
+	if (c->x86_clflush_size > 0) {
+		pci_cache_line_size = c->x86_clflush_size >> 2;
+		printk(KERN_DEBUG "PCI: pci_cache_line_size set to %d bytes\n",
+			pci_cache_line_size << 2);
+	} else {
+		pci_cache_line_size = 32 >> 2;
+		printk(KERN_DEBUG "PCI: Unknown cacheline size. Setting to 32 bytes\n");
+	}
 
 	pcibios_resource_survey();
 
