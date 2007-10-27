Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbXJ0RCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbXJ0RCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXJ0RCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:02:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:19686 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbXJ0RCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=OPcb3YAskfJwp3x5fJKxpuHPE1901A+/+lBrQFJ/A06MHS95ZOvrb/s94efF8i9eC6Ms20ik9VgmR4EVKCwV0YucYcBo+QsJpNNTkwZRN0xUbRwyRKlqJm5p1lmxIBbyVb7wpqDqV9Lp7sRBj3fZ5NIcXYmGNKIni0eNnDVk7gQ=
Date: Sat, 27 Oct 2007 21:02:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] SG: set names for numeric constants
Message-ID: <20071027170228.GA7257@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch defines names for numeric constants that
used in scatter list for more convenient code reading.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

I'm not sure if it really needed but who knows ;)
Any comments are welcome.

 include/linux/scatterlist.h |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4571231..fcc05a5 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -25,6 +25,9 @@
  */
 
 #define SG_MAGIC	0x87654321
+#define SG_CHAIN	0x1
+#define SG_LAST		0x2
+#define SG_MASK		0x3
 
 /**
  * sg_assign_page - Assign a given page to an SG entry
@@ -38,13 +41,13 @@
  **/
 static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 {
-	unsigned long page_link = sg->page_link & 0x3;
+	unsigned long page_link = sg->page_link & SG_MASK;
 
 	/*
 	 * In order for the low bit stealing approach to work, pages
 	 * must be aligned at a 32-bit boundary as a minimum.
 	 */
-	BUG_ON((unsigned long) page & 0x03);
+	BUG_ON((unsigned long) page & SG_MASK);
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 #endif
@@ -73,7 +76,7 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 	sg->length = len;
 }
 
-#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
+#define sg_page(sg)	((struct page *) ((sg)->page_link & ~SG_MASK))
 
 /**
  * sg_set_buf - Set sg entry to point at given data
@@ -93,10 +96,10 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
  * a valid sg entry, or whether it points to the start of a new scatterlist.
  * Those low bits are there for everyone! (thanks mason :-)
  */
-#define sg_is_chain(sg)		((sg)->page_link & 0x01)
-#define sg_is_last(sg)		((sg)->page_link & 0x02)
+#define sg_is_chain(sg)		((sg)->page_link & SG_CHAIN)
+#define sg_is_last(sg)		((sg)->page_link & SG_LAST)
 #define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((sg)->page_link & ~0x03))
+	((struct scatterlist *) ((sg)->page_link & ~SG_MASK))
 
 /**
  * sg_next - return the next scatterlist entry in a list
@@ -179,7 +182,7 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 #ifndef ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
-	prv[prv_nents - 1].page_link = (unsigned long) sgl | 0x01;
+	prv[prv_nents - 1].page_link = (unsigned long) sgl | SG_CHAIN;
 }
 
 /**
@@ -193,12 +196,12 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
  **/
 static inline void sg_mark_end(struct scatterlist *sgl, unsigned int nents)
 {
-	sgl[nents - 1].page_link = 0x02;
+	sgl[nents - 1].page_link = SG_LAST;
 }
 
 static inline void __sg_mark_end(struct scatterlist *sg)
 {
-	sg->page_link |= 0x02;
+	sg->page_link |= SG_LAST;
 }
 
 /**
