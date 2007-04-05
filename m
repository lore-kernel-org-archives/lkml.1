Return-Path: <linux-kernel-owner+w=401wt.eu-S1946065AbXDEICO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946065AbXDEICO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946069AbXDEICN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:02:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39687 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946065AbXDEICG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:02:06 -0400
Date: Thu, 05 Apr 2007 17:01:12 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Subject: [Patch] Add white list into modpost.c for memory hotplug code and ia64's machvec section
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070405164324.424A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is add white list into modpost.c for some functions and
ia64's section to fix section mismatchs.

  sparse_index_alloc() and zone_wait_table_init() calls bootmem allocator
  at boot time, and kmalloc/vmalloc at hotplug time. If config
  memory hotplug is on, there are references of bootmem allocater(init text)
  from them (normal text). This is cause of section mismatch.
  
  Bootmem is called by many functions and it must be
  used only at boot time. I think __init of them should keep for
  section mismatch check. So, I would like to register sparse_index_alloc()
  and zone_wait_table_init() into white list.
  
  In addition, ia64's .machvec section is function table of some platform
  dependent code. It is mixture of .init.text and normal text. These
  reference of __init functions are valid too.

  This is for 2.6.21-rc5-mm4.

Please apply.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

-------
 mm/page_alloc.c       |    2 +-
 mm/sparse.c           |    2 +-
 scripts/mod/modpost.c |   28 ++++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

Index: current_test/scripts/mod/modpost.c
===================================================================
--- current_test.orig/scripts/mod/modpost.c	2007-04-03 16:04:57.000000000 +0900
+++ current_test/scripts/mod/modpost.c	2007-04-03 16:09:59.000000000 +0900
@@ -649,6 +649,17 @@ static int strrcmp(const char *s, const 
  *  The pattern is:
  *  tosec   = .init.text
  *  fromsec  = .paravirtprobe
+ *
+ * Pattern 10:
+ *  Some of functions are common code between boot time and hotplug
+ *  time. The bootmem allocater is called only boot time in its
+ *  functions. So it's ok to reference.
+ *  tosec    = .init.text
+ *
+ * Pattern 11:
+ *  ia64 has machvec table for each platform. It is mixture of function
+ *  pointer of .init.text and .text.
+ *  fromsec  = .machvec
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -675,6 +686,12 @@ static int secref_whitelist(const char *
 		NULL
 	};
 
+	const char *pat4sym[] = {
+		"sparse_index_alloc",
+		"zone_wait_table_init",
+		NULL
+	};
+
 	/* Check for pattern 1 */
 	if (strcmp(tosec, ".init.data") != 0)
 		f1 = 0;
@@ -738,6 +755,17 @@ static int secref_whitelist(const char *
 	    (strcmp(fromsec, ".paravirtprobe") == 0))
 		return 1;
 
+	/* Check for pattern 10 */
+	if ((strcmp(tosec, ".init.text") == 0) &&
+	    (strcmp(fromsec, ".text") == 0))
+		for (s = pat4sym; *s; s++)
+			if (strcmp(atsym, *s) == 0)
+				return 1;
+
+	/* Check for pattern 11 */
+	if (strcmp(fromsec, ".machvec") == 0)
+		return 1;
+
 	return 0;
 }
 
Index: current_test/mm/page_alloc.c
===================================================================
--- current_test.orig/mm/page_alloc.c	2007-04-03 16:04:57.000000000 +0900
+++ current_test/mm/page_alloc.c	2007-04-03 16:05:26.000000000 +0900
@@ -2667,7 +2667,7 @@ void __init setup_per_cpu_pageset(void)
 
 #endif
 
-static __meminit
+static __meminit noinline
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 {
 	int i;
Index: current_test/mm/sparse.c
===================================================================
--- current_test.orig/mm/sparse.c	2007-04-03 16:04:57.000000000 +0900
+++ current_test/mm/sparse.c	2007-04-03 16:05:26.000000000 +0900
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(page_to_nid);
 #endif
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-static struct mem_section *sparse_index_alloc(int nid)
+static struct mem_section noinline *sparse_index_alloc(int nid)
 {
 	struct mem_section *section = NULL;
 	unsigned long array_size = SECTIONS_PER_ROOT *

-- 
Yasunori Goto 


