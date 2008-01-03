Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYACPba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYACPba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYACPYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:45 -0500
Received: from ns2.suse.de ([195.135.220.15]:43034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbYACPYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:40 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: jbeulich@novell.com, linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [24/28] CPA: Only unmap kernel init pages in text mapping when CONFIG_DEBUG_RODATA is set
Message-Id: <20080103152439.7A3DF14E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Otherwise the kernel will likely always run with 4K pages instead of 2MB pages,
which is costly in terms of TLBs.

Also optimize it a little bit by using only a single change_page_attr() calls.
This is particularly useful if debugging is enabled inside it because it spams
the logs much less.

Cc: jbeulich@novell.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_64.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -546,13 +546,15 @@ void free_init_pages(char *what, unsigne
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
+		change_page_attr_addr(begin, (end - begin)/PAGE_SIZE, __pgprot(0));
 		global_flush_tlb();
+	}
+#endif
 }
 
 void free_initmem(void)
