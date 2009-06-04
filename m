Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZFDQVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZFDQVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZFDQTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:19:14 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48351 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbZFDQTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:19:01 -0400
Message-Id: <20090604161902.332403109@de.ibm.com>
References: <20090604161847.513682672@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 18:18:59 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/38] pm: add kernel_page_present
Content-Disposition: inline; filename=pm_kernel_page_present.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Joachim Picht <hans@linux.vnet.ibm.com>

Fix the following build failure caused by make allyesconfig using
CONFIG_HIBERNATION and CONFIG_DEBUG_PAGEALLOC

kernel/built-in.o: In function `saveable_page':
kernel/power/snapshot.c:897: undefined reference to `kernel_page_present'
kernel/built-in.o: In function `safe_copy_page':
kernel/power/snapshot.c:948: undefined reference to `kernel_page_present'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Hans-Joachim Picht <hans@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/mm/pgtable.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6/arch/s390/mm/pgtable.c
===================================================================
--- linux-2.6.orig/arch/s390/mm/pgtable.c
+++ linux-2.6/arch/s390/mm/pgtable.c
@@ -313,3 +313,22 @@ int s390_enable_sie(void)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_enable_sie);
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+#ifdef CONFIG_HIBERNATION
+bool kernel_page_present(struct page *page)
+{
+        unsigned long addr;
+	int cc;
+
+	addr = page_to_phys(page);
+	asm("lra %1,0(%1)\n"
+	    "ipm %0\n"
+            "srl %0,28"
+	    :"=d"(cc),"+a"(addr)::"cc");
+	return cc == 0;
+}
+
+#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_DEBUG_PAGEALLOC */
+

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

