Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYAPWZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYAPWZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbYAPWPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:55261 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbYAPWPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:30 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [29/36] CPA: Only unmap kernel init pages in text mapping when CONFIG_DEBUG_RODATA is set
Message-Id: <20080116221529.38C29150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Otherwise the kernel will likely always run with 4K pages instead of 2MB pages,
which is costly in terms of TLBs.

Also optimize it a little bit by using only a single change_page_attr() calls.
This is particularly useful if debugging is enabled inside it because it spams
the logs much less.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_64.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -694,13 +694,16 @@ void free_init_pages(char *what, unsigne
 		init_page_count(virt_to_page(addr));
 		memset((void *)(addr & ~(PAGE_SIZE-1)),
 			POISON_FREE_INITMEM, PAGE_SIZE);
-		if (addr >= __START_KERNEL_map)
-			change_page_attr_addr(addr, 1, __pgprot(0));
 		free_page(addr);
 		totalram_pages++;
 	}
-	if (addr > __START_KERNEL_map)
+#ifdef CONFIG_DEBUG_RODATA
+	if (begin >= __START_KERNEL_map) {
+		change_page_attr_addr(begin, (end - begin)/PAGE_SIZE,
+					__pgprot(0));
 		global_flush_tlb();
+	}
+#endif
 }
 
 void free_initmem(void)
