Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYANWRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYANWRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYANWQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:36 -0500
Received: from ns2.suse.de ([195.135.220.15]:54834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbYANWQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:34 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [2/31] CPA: Do a simple self test at boot
Message-Id: <20080114221633.B6A4814F93@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When CONFIG_DEBUG_RODATA is enabled undo the ro mapping and redo it again.
This gives some simple testing for change_page_attr()

Optional patch, but I find it useful.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/Kconfig.debug |    5 +++++
 arch/x86/mm/init_32.c  |   26 ++++++++++++++++++++++++++
 arch/x86/mm/init_64.c  |   10 ++++++++++
 3 files changed, 41 insertions(+)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -603,6 +603,16 @@ void mark_rodata_ro(void)
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
@@ -793,6 +793,20 @@ void mark_rodata_ro(void)
 		change_page_attr(virt_to_page(start),
 		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
 		printk("Write protecting the kernel text: %luk\n", size >> 10);
+
+#ifdef CONFIG_CPA_DEBUG
+		global_flush_tlb();
+
+		printk("Testing CPA: Reverting %lx-%lx\n", start, start+size);
+		change_page_attr(virt_to_page(start), size>>PAGE_SHIFT,
+				 PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+
+		printk("Testing CPA: write protecting again\n");
+		change_page_attr(virt_to_page(start), size>>PAGE_SHIFT,
+				PAGE_KERNEL_RX);
+		global_flush_tlb();
+#endif
 	}
 #endif
 	start += size;
@@ -809,6 +823,18 @@ void mark_rodata_ro(void)
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+
+#ifdef CONFIG_CPA_DEBUG
+	printk("Testing CPA: undo %lx-%lx\n", start, start + size);
+	change_page_attr(virt_to_page(start), size >> PAGE_SHIFT,
+				PAGE_KERNEL);
+	global_flush_tlb();
+
+	printk("Testing CPA: write protecting again\n");
+	change_page_attr(virt_to_page(start), size >> PAGE_SHIFT,
+				PAGE_KERNEL_RO);
+	global_flush_tlb();
+#endif
 }
 #endif
 
Index: linux/arch/x86/Kconfig.debug
===================================================================
--- linux.orig/arch/x86/Kconfig.debug
+++ linux/arch/x86/Kconfig.debug
@@ -192,4 +192,9 @@ config DEBUG_BOOT_PARAMS
 	help
 	  This option will cause struct boot_params to be exported via debugfs.
 
+config CPA_DEBUG
+	bool "CPA self test code"
+	help
+	  Do change_page_attr self tests at boot.
+
 endmenu
