Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYACPdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYACPdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYACPYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYACPYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:17 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [2/28] CPA: Do a simple self test at boot
Message-Id: <20080103152416.1D59D14E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When CONFIG_DEBUG_RODATA is enabled undo the ro mapping and redo it again.
This gives some simple testing for change_page_attr()

Optional patch, but I find it useful.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/Kconfig.debug |    5 +++++
 arch/x86/mm/init_32.c  |   22 ++++++++++++++++++++++
 arch/x86/mm/init_64.c  |   10 ++++++++++
 3 files changed, 37 insertions(+)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -596,6 +596,16 @@ void mark_rodata_ro(void)
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+
+#ifdef CONFIG_CPA_DEBUG
+	printk("Testing CPA: undo %lx-%lx\n", start, end);
+	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT, PAGE_KERNEL);
+	global_flush_tlb();
+
+	printk("Testing CPA: again\n");
+	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT, PAGE_KERNEL_RO);
+	global_flush_tlb();
+#endif
 }
 #endif
 
Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -792,6 +792,18 @@ void mark_rodata_ro(void)
 		change_page_attr(virt_to_page(start),
 		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
 		printk("Write protecting the kernel text: %luk\n", size >> 10);
+
+#ifdef CONFIG_CPA_DEBUG
+		global_flush_tlb();
+
+		printk("Testing CPA: undo %lx-%lx\n", start, start+size);
+		change_page_attr(virt_to_page(start), size>>PAGE_SHIFT, PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+
+		printk("Testing CPA: write protecting again\n");
+		change_page_attr(virt_to_page(start),size>>PAGE_SHIFT,PAGE_KERNEL_RX);
+		global_flush_tlb();
+#endif
 	}
 #endif
 	start += size;
@@ -808,6 +820,16 @@ void mark_rodata_ro(void)
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+
+#ifdef CONFIG_CPA_DEBUG
+	printk("Testing CPA: undo %lx-%lx\n", start, start + size);
+	change_page_attr(virt_to_page(start), size >> PAGE_SHIFT, PAGE_KERNEL);
+	global_flush_tlb();
+
+	printk("Testing CPA: write protecting again\n");
+	change_page_attr(virt_to_page(start), size >> PAGE_SHIFT, PAGE_KERNEL_RO);
+	global_flush_tlb();
+#endif
 }
 #endif
 
Index: linux/arch/x86/Kconfig.debug
===================================================================
--- linux.orig/arch/x86/Kconfig.debug
+++ linux/arch/x86/Kconfig.debug
@@ -185,4 +185,9 @@ config DEFAULT_IO_DELAY_TYPE
 	default IO_DELAY_TYPE_NONE
 endif
 
+config CPA_DEBUG
+	bool "CPA self test code"
+	help
+	  Do change_page_attr self tests at boot.
+
 endmenu
