Return-Path: <linux-kernel-owner+w=401wt.eu-S965959AbXC2FS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959AbXC2FS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXC2FS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:18:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56669 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbXC2FS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:18:28 -0400
Date: Thu, 29 Mar 2007 14:17:54 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC:PATCH]regster memory init functions into white list of section mismatch.
Cc: Miles Lane <miles.lane@gmail.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070323161903.GA7485@uranus.ravnborg.org>
References: <20070323214418.3F04.Y-GOTO@jp.fujitsu.com> <20070323161903.GA7485@uranus.ravnborg.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070329140635.63F4.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > WARNING: mm/built-in.o - Section mismatch: reference to
> > > > .init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
> > > > offset 0x15c8f) and '__section_nr'
> > > I took a look at this one.
> > > You have SPARSEMEM enabled in your config.
> > > And then I see that in sparse.c we call alloc_bootmem_node()
> > > from a function I thought should be marked __devinit (it
> > > is used by memory_hotplug.c).
> > > But I am not familiar enough to judge if __alloc_bootmen_node
> > > are marked correct with __init or __devinit (to say
> > > this is used in the HOTPLUG case) is more correct.
> > > Anyone?
> > > 
> > > > WARNING: mm/built-in.o - Section mismatch: reference to
> > > > .init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
> > > > offset 0x15d02) and '__section_nr'
> > > Same as above....
> > 
> > Memory hotplug code has __meminit for its purpose.
> > But, I suspect that many other places of memory hotplug code may have
> > same issue. I will chase them.


Hello.

  I chased section mismatch codes on memory hotplug code. Many of
  them should be defined as __meminit. (This check was great helpful
  for checking it. Thanks!)
  But, I would like to add a new pattern in white list for some of
  them. (I'll post another patch for others.)
  
  sparse.c (sparse_index_alloc()) calles alloc_bootmem_node() as you mentioned.
  And, zone_wait_table_init() calles it too.
  These functions call it on only boot time, and call
  vmalloc()/kmalloc() on hotplug time. It is distinguished by
  system_state value or slab_is_available(). Just refrerences remain
  at them after boot.
  
  Bootmem allocation functions are called by many functions and it must be
  used only at boot time. I think __init of them should keep for
  section mismatch check. So, I would like to register sparse_index_alloc()
  and zone_wait_table_init() into white list.

  Please comment. If there is a more good way, please let me know...

Thanks.

P.S.
  Pattarn 10 is for ia64 (not for memory hotplug). 
  ia64's .machvec section is mixture table of .init functions and normal text.
  It is defined for platform dependent functions. This is also cause of 
  warnings. I think this should be registered too. 


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/page_alloc.c       |    2 +-
 mm/sparse.c           |    2 +-
 scripts/mod/modpost.c |   29 +++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

Index: current_test/scripts/mod/modpost.c
===================================================================
--- current_test.orig/scripts/mod/modpost.c	2007-03-27 20:21:20.000000000 +0900
+++ current_test/scripts/mod/modpost.c	2007-03-29 14:16:05.000000000 +0900
@@ -643,6 +643,17 @@ static int strrcmp(const char *s, const 
  *  The pattern is:
  *  tosec    = .init.text
  *  fromsec  = __ksymtab*
+ *
+ * Pattern 9:
+ *  Some of functions are common code between boot time and hotplug
+ *  time. The bootmem allocater is called only boot time in its
+ *  functions. So it's ok to reference.
+ *  tosec    = .init.text
+ *
+ * Pattern 10:
+ *  ia64 has machvec table for each platform. It is mixture of function
+ *  pointer of .init.text and .text.
+ *  fromsec  = .machvec
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -669,6 +680,12 @@ static int secref_whitelist(const char *
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
@@ -725,6 +742,18 @@ static int secref_whitelist(const char *
 	if ((strcmp(tosec, ".init.text") == 0) &&
 	    (strncmp(fromsec, "__ksymtab", strlen("__ksymtab")) == 0))
 		return 1;
+
+	/* Check for pattern 9 */
+	if ((strcmp(tosec, ".init.text") == 0) &&
+	    (strcmp(fromsec, ".text") == 0))
+		for (s = pat4sym; *s; s++)
+			if (strcmp(atsym, *s) == 0)
+				return 1;
+
+	/* Check for pattern 10 */
+	if (strcmp(fromsec, ".machvec") == 0)
+		return 1;
+
 	return 0;
 }
 
Index: current_test/mm/page_alloc.c
===================================================================
--- current_test.orig/mm/page_alloc.c	2007-03-27 16:04:41.000000000 +0900
+++ current_test/mm/page_alloc.c	2007-03-29 14:14:42.000000000 +0900
@@ -2673,7 +2673,7 @@ void __init setup_per_cpu_pageset(void)
 
 #endif
 
-static __meminit
+static __meminit noinline
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 {
 	int i;
Index: current_test/mm/sparse.c
===================================================================
--- current_test.orig/mm/sparse.c	2007-03-27 16:04:41.000000000 +0900
+++ current_test/mm/sparse.c	2007-03-29 14:15:00.000000000 +0900
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


