Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbXIYXo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbXIYXo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbXIYXm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:42:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36402 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751822AbXIYXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:50 -0400
Message-Id: <20070925234249.866179367@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:07 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [03/17] i386: Resolve dependency of asm-i386/pgtable.h on highmem.h
Content-Disposition: inline; filename=vcompound_fix_i386_pgtable_mess
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pgtable.h does not include highmem.h but uses various constants from
highmem.h. We cannot include highmem.h because highmem.h will in turn
include many other include files that also depend on pgtable.h

So move the definitions from highmem.h into pgtable.h.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-i386/highmem.h |    6 ------
 include/asm-i386/pgtable.h |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6/include/asm-i386/highmem.h
===================================================================
--- linux-2.6.orig/include/asm-i386/highmem.h	2007-09-20 23:54:57.000000000 -0700
+++ linux-2.6/include/asm-i386/highmem.h	2007-09-20 23:55:40.000000000 -0700
@@ -38,11 +38,6 @@ extern pte_t *pkmap_page_table;
  * easily, subsequent pte tables have to be allocated in one physical
  * chunk of RAM.
  */
-#ifdef CONFIG_X86_PAE
-#define LAST_PKMAP 512
-#else
-#define LAST_PKMAP 1024
-#endif
 /*
  * Ordering is:
  *
@@ -58,7 +53,6 @@ extern pte_t *pkmap_page_table;
  * VMALLOC_START
  * high_memory
  */
-#define PKMAP_BASE ( (FIXADDR_BOOT_START - PAGE_SIZE*(LAST_PKMAP + 1)) & PMD_MASK )
 #define LAST_PKMAP_MASK (LAST_PKMAP-1)
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
Index: linux-2.6/include/asm-i386/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-i386/pgtable.h	2007-09-20 23:55:16.000000000 -0700
+++ linux-2.6/include/asm-i386/pgtable.h	2007-09-20 23:56:21.000000000 -0700
@@ -81,6 +81,14 @@ void paging_init(void);
 #define VMALLOC_OFFSET	(8*1024*1024)
 #define VMALLOC_START	(((unsigned long) high_memory + \
 			2*VMALLOC_OFFSET-1) & ~(VMALLOC_OFFSET-1))
+#ifdef CONFIG_X86_PAE
+#define LAST_PKMAP 512
+#else
+#define LAST_PKMAP 1024
+#endif
+
+#define PKMAP_BASE ( (FIXADDR_BOOT_START - PAGE_SIZE*(LAST_PKMAP + 1)) & PMD_MASK )
+
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE-2*PAGE_SIZE)
 #else

-- 
