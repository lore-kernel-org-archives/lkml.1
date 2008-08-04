Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbYHDGnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbYHDGnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760595AbYHDGnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:43:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:58138 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760571AbYHDGnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:43:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,303,1215414000"; 
   d="scan'208";a="322819467"
Subject: [patch 2/2] reduce tlb/cache flush times of agpgart memory
	allocation
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: airlied@linux.ie, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 14:51:30 +0800
Message-Id: <1217832690.21811.9.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To reduce tlb/cache flush, makes agp memory allocation do one flush
after all pages in a region are changed to uc.

All agp drivers except agp-sgi uses agp_generic_alloc_page()
for .agp_alloc_page, so the patch should work for them. agp-sgi is only
for ia64, so not a problem too. 

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/char/agp/agp.h     |    4 ++++
 drivers/char/agp/generic.c |    4 +++-
 include/asm-x86/agp.h      |    3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

Index: linux/drivers/char/agp/generic.c
===================================================================
--- linux.orig/drivers/char/agp/generic.c	2008-08-04 12:03:37.000000000 +0800
+++ linux/drivers/char/agp/generic.c	2008-08-04 12:06:31.000000000 +0800
@@ -274,6 +274,7 @@ struct agp_memory *agp_allocate_memory(s
 		new->memory[i] = virt_to_gart(addr);
 		new->page_count++;
 	}
+	map_page_into_agp_global_flush();
 	new->bridge = bridge;
 
 	return new;
@@ -1186,7 +1187,8 @@ void *agp_generic_alloc_page(struct agp_
 	if (page == NULL)
 		return NULL;
 
-	map_page_into_agp(page);
+	/* agp_allocate_memory will do flush */
+	map_page_into_agp_noflush(page);
 
 	get_page(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
Index: linux/include/asm-x86/agp.h
===================================================================
--- linux.orig/include/asm-x86/agp.h	2008-08-04 12:03:37.000000000 +0800
+++ linux/include/asm-x86/agp.h	2008-08-04 12:06:31.000000000 +0800
@@ -15,6 +15,9 @@
 #define map_page_into_agp(page) set_pages_uc(page, 1)
 #define unmap_page_from_agp(page) set_pages_wb(page, 1)
 
+#define map_page_into_agp_noflush(page) set_pages_uc_noflush(page, 1)
+#define map_page_into_agp_global_flush() set_memory_flush_all()
+
 /*
  * Could use CLFLUSH here if the cpu supports it. But then it would
  * need to be called for each cacheline of the whole page so it may
Index: linux/drivers/char/agp/agp.h
===================================================================
--- linux.orig/drivers/char/agp/agp.h	2008-08-04 12:03:37.000000000 +0800
+++ linux/drivers/char/agp/agp.h	2008-08-04 12:06:31.000000000 +0800
@@ -30,6 +30,10 @@
 #define _AGP_BACKEND_PRIV_H 1
 
 #include <asm/agp.h>	/* for flush_agp_cache() */
+#ifndef map_page_into_agp_noflush
+#define map_page_into_agp_noflush(page) map_page_into_agp(page)
+#define map_page_into_agp_global_flush()
+#endif
 
 #define PFX "agpgart: "
 


