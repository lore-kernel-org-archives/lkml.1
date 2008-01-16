Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYAPWRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYAPWRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYAPWPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:11 -0500
Received: from ns2.suse.de ([195.135.220.15]:38234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYAPWPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:07 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [8/36] CPA: Do a simple self test at boot
Message-Id: <20080116221506.DAB9A150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When CONFIG_DEBUG_RODATA is enabled undo the ro mapping and redo it again.
This gives some simple testing for change_page_attr()

Optional patch, but I find it useful.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig.debug |    5 +++++
 arch/x86/mm/init_32.c  |   26 ++++++++++++++++++++++++++
 arch/x86/mm/init_64.c  |   10 ++++++++++
 3 files changed, 41 insertions(+)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -744,6 +744,16 @@ void mark_rodata_ro(void)
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
@@ -822,6 +822,20 @@ void mark_rodata_ro(void)
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
@@ -838,6 +852,18 @@ void mark_rodata_ro(void)
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
