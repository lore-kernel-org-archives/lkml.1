Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0BXIs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:48:27 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:33647 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab0BXIow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:44:52 -0500
Message-Id: <20100224084450.813624264@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 09:44:48 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 18/32] [PATCH] free_initmem: reduce code duplication
References: <20100224084430.193562869@de.ibm.com>
Content-Disposition: inline; filename=117-free-initmem.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

free_initmem() and free_initrd_mem() are nearly identical. So make them
call a common function.
Also fixes a bug: if the initrd wouldn't start on a page boundary also
memory after the initrd would be initialized with the poison value.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/mm/init.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

Index: quilt-2.6/arch/s390/mm/init.c
===================================================================
--- quilt-2.6.orig/arch/s390/mm/init.c	2010-02-24 09:28:13.000000000 +0100
+++ quilt-2.6/arch/s390/mm/init.c	2010-02-24 09:44:26.000000000 +0100
@@ -143,33 +143,34 @@
 }
 #endif
 
-void free_initmem(void)
+void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
-        unsigned long addr;
+	unsigned long addr = begin;
 
-        addr = (unsigned long)(&__init_begin);
-        for (; addr < (unsigned long)(&__init_end); addr += PAGE_SIZE) {
+	if (begin >= end)
+		return;
+	for (; addr < end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
-		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
+		memset((void *)(addr & PAGE_MASK), POISON_FREE_INITMEM,
+		       PAGE_SIZE);
 		free_page(addr);
 		totalram_pages++;
-        }
-        printk ("Freeing unused kernel memory: %ldk freed\n",
-		((unsigned long)&__init_end - (unsigned long)&__init_begin) >> 10);
+	}
+	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
+}
+
+void free_initmem(void)
+{
+	free_init_pages("unused kernel memory",
+			(unsigned long)&__init_begin,
+			(unsigned long)&__init_end);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-        if (start < end)
-                printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-        for (; start < end; start += PAGE_SIZE) {
-                ClearPageReserved(virt_to_page(start));
-                init_page_count(virt_to_page(start));
-                free_page(start);
-                totalram_pages++;
-        }
+	free_init_pages("initrd memory", start, end);
 }
 #endif
 

