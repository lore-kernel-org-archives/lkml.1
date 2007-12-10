Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbXLJFKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbXLJFKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 00:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXLJFKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 00:10:04 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37886 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXLJFKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 00:10:01 -0500
Date: Sun, 9 Dec 2007 21:06:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de, mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [patch] x64/page.h: convert some macros to inlines
Message-Id: <20071209210653.6d9f9cf9.randy.dunlap@oracle.com>
In-Reply-To: <20071207163142.4e77f9c3.akpm@linux-foundation.org>
References: <20071205071547.701344000@nick.local0.net>
	<20071205071627.469118000@nick.local0.net>
	<20071207163142.4e77f9c3.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007 16:31:42 -0800 Andrew Morton wrote:

> Could someone *please* start a little project of extirpating this utter
> brain damage?  Convert those macros to typechecked static inlines on x86
> (at least) so this sort of thing (which happens again and again and again)
> is lessened?

Here's a start on it.  x86 only and only 4 functions so far.
Builds cleanly for i386 and x86_64.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Convert clear_page/copy_page macros to inline functions for type-checking.
Andrew wants to extirpate these ugly macros.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-x86/page_32.h |   39 +++++++++++++++++++++++++++++++++------
 include/asm-x86/page_64.h |   19 +++++++++++++++----
 2 files changed, 48 insertions(+), 10 deletions(-)

--- linux-2.6.24-rc4-git6.orig/include/asm-x86/page_32.h
+++ linux-2.6.24-rc4-git6/include/asm-x86/page_32.h
@@ -12,12 +12,21 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
+#include <linux/string.h>
+
 #ifdef CONFIG_X86_USE_3DNOW
 
 #include <asm/mmx.h>
 
-#define clear_page(page)	mmx_clear_page((void *)(page))
-#define copy_page(to,from)	mmx_copy_page(to,from)
+static inline void clear_page(void *page)
+{
+	mmx_clear_page(page);
+}
+
+static inline void copy_page(void *to, void *from)
+{
+	mmx_copy_page(to, from);
+}
 
 #else
 
@@ -26,13 +35,31 @@
  *	Maybe the K6-III ?
  */
  
-#define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
-#define copy_page(to,from)	memcpy((void *)(to), (void *)(from), PAGE_SIZE)
+static inline void clear_page(void *page)
+{
+	memset(page, 0, PAGE_SIZE);
+}
+
+static inline void copy_page(void *to, void *from)
+{
+	memcpy(to, from, PAGE_SIZE);
+}
 
 #endif
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
-#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
+struct page;
+
+static void inline clear_user_page(void *page, unsigned long vaddr,
+				struct page *pg)
+{
+	clear_page(page);
+}
+
+static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
+				struct page *topage)
+{
+	copy_page(to, from);
+}
 
 #define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
 	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
--- linux-2.6.24-rc4-git6.orig/include/asm-x86/page_64.h
+++ linux-2.6.24-rc4-git6/include/asm-x86/page_64.h
@@ -42,11 +42,22 @@
 
 extern unsigned long end_pfn;
 
-void clear_page(void *);
-void copy_page(void *, void *);
+void clear_page(void *page);
+void copy_page(void *to, void *from);
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
-#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
+struct page;
+
+static void inline clear_user_page(void *page, unsigned long vaddr,
+				struct page *pg)
+{
+	clear_page(page);
+}
+
+static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
+				struct page *topage)
+{
+	copy_page(to, from);
+}
 
 #define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
 	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
