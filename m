Return-Path: <linux-kernel-owner+w=401wt.eu-S1762934AbXERGyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762934AbXERGyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXERGyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:54:09 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33028 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbXERGyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:54:07 -0400
Date: Fri, 18 May 2007 08:55:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH 08/14] mm: fix section mismatch warnings
Message-ID: <20070518065504.GH12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 90deffab03386508abfa1529fe4926a2fc7300f2 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 17 May 2007 23:29:25 +0200
Subject: [PATCH 08/14] mm: fix section mismatch warnings

modpost had two cases hardcoded for mm/
Shift over to __init_refok and kill the
hardcoded function names in modpost.

This has the drawback that the functions
will always be kept no matter configuration.
With previous code the function were placed in
init section if configuration allowed it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 mm/page_alloc.c       |    4 ++--
 mm/sparse.c           |    2 +-
 scripts/mod/modpost.c |   19 -------------------
 3 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ae96dd8..8b000d6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2165,7 +2165,7 @@ void __init setup_per_cpu_pageset(void)
 
 #endif
 
-static __meminit noinline
+static noinline __init_refok
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 {
 	int i;
@@ -2678,7 +2678,7 @@ static void __meminit free_area_init_core(struct pglist_data *pgdat,
 	}
 }
 
-static void __meminit alloc_node_mem_map(struct pglist_data *pgdat)
+static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	/* Skip empty nodes */
 	if (!pgdat->node_spanned_pages)
diff --git a/mm/sparse.c b/mm/sparse.c
index 6f3fff9..1302f83 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(page_to_nid);
 #endif
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-static struct mem_section noinline *sparse_index_alloc(int nid)
+static struct mem_section noinline __init_refok *sparse_index_alloc(int nid)
 {
 	struct mem_section *section = NULL;
 	unsigned long array_size = SECTIONS_PER_ROOT *
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ec056cf..4fc0ab8 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -641,12 +641,6 @@ static int strrcmp(const char *s, const char *sub)
  *  tosec   = .init.text
  *  fromsec  = .paravirtprobe
  *
- * Pattern 9:
- *  Some of functions are common code between boot time and hotplug
- *  time. The bootmem allocater is called only boot time in its
- *  functions. So it's ok to reference.
- *  tosec    = .init.text
- *
  * Pattern 10:
  *  ia64 has machvec table for each platform and
  *  powerpc has a machine desc table for each platform.
@@ -678,12 +672,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		NULL
 	};
 
-	const char *pat4sym[] = {
-		"sparse_index_alloc",
-		"zone_wait_table_init",
-		NULL
-	};
-
 	/* Check for pattern 0 */
 	if ((strcmp(fromsec, ".text.init.refok") == 0) ||
 	    (strcmp(fromsec, ".data.init.refok") == 0))
@@ -741,13 +729,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strcmp(fromsec, ".paravirtprobe") == 0))
 		return 1;
 
-	/* Check for pattern 9 */
-	if ((strcmp(tosec, ".init.text") == 0) &&
-	    (strcmp(fromsec, ".text") == 0))
-		for (s = pat4sym; *s; s++)
-			if (strcmp(atsym, *s) == 0)
-				return 1;
-
 	/* Check for pattern 10 */
 	if ((strcmp(fromsec, ".machvec") == 0) ||
 	    (strcmp(fromsec, ".machine.desc") == 0))
-- 
1.5.1.rc3.20.gaa453

