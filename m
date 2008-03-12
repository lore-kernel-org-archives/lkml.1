Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbYCLHwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbYCLHwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYCLHvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:51:55 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:10022 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751032AbYCLHvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:51:54 -0400
Date: Wed, 12 Mar 2008 16:51:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] nommu: Provide is_vmalloc_addr() stub.
Message-ID: <20080312075131.GA21507@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Greg Ungerer <gerg@snapgear.com>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced in commit-id 9e2779fa281cfda13ac060753d674bbcaa23367e and
ifdef'ed out for nommu in 8ca3ed87db062201e1fa15b64a9214e193fc3a8a, both
approaches end up breaking the nommu build in different ways. An
impressive feat for a 2-liner.

Current is_vmalloc_addr() users fall in to two camps:

	- Determining whether to use vfree()/kfree()
	- Whether to do vmlist traversal (only /proc/kcore).

Since we don't support /proc/kcore on nommu, that leaves the
vfree()/kfree() determination use cases. nommu vfree() happens to be a
wrapper to kfree() anyways, so is_vmalloc_addr() can always return 0
and end up with the right behaviour. 

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/linux/mm.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3f3ccfe..b695875 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -235,15 +235,22 @@ static inline int get_page_unless_zero(struct page *page)
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
-#ifdef CONFIG_MMU
-/* Determine if an address is within the vmalloc range */
+/*
+ * Determine if an address is within the vmalloc range
+ *
+ * On nommu, vmalloc/vfree wrap through kmalloc/kfree directly, so there
+ * is no special casing required.
+ */
 static inline int is_vmalloc_addr(const void *x)
 {
+#ifdef CONFIG_MMU
 	unsigned long addr = (unsigned long)x;
 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
-}
+#else
+	return 0;
 #endif
+}
 
 static inline struct page *compound_head(struct page *page)
 {
