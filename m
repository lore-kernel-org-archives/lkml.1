Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbXKZL2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbXKZL2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 06:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXKZL2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 06:28:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:34165 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbXKZL2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 06:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=wWESFyLXFbLQ5blqKihpuePtDZRzfbS4Dip7F73pl2EYOWHyyUQnc2g6Ux1hKVcFTSfNcYyeJTF23lpZdD+2fRrGCxDzhj/nmsKuV5Qupww9pcLz/COBRoeVCvPnx7A+l/f5i1dRT9NG5wKTShekvd/oOu0no8PJIQ0kxaTb+Gg=
Date: Mon, 26 Nov 2007 20:28:32 +0900
From: Tejun Heo <htejun@gmail.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] scatterlist: add more safeguards
Message-ID: <20071126112832.GA9232@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add more safeguards to protect against misinterpreting a chain entry
as a normal scatterlist and vice-versa.

* Make sure the entry isn't a chain when assigning and reading a
  normal sg.

* Clear offset and length when chaining.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
While converting libata to use chained-sg, I felt a bit insecure and
added a few more safe guards.  Feel free to include or ignore them.

Thanks.

 include/linux/scatterlist.h |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

Index: work/include/linux/scatterlist.h
===================================================================
--- work.orig/include/linux/scatterlist.h
+++ work/include/linux/scatterlist.h
@@ -26,6 +26,16 @@
 
 #define SG_MAGIC	0x87654321
 
+/*
+ * We overload the LSB of the page pointer to indicate whether it's
+ * a valid sg entry, or whether it points to the start of a new scatterlist.
+ * Those low bits are there for everyone! (thanks mason :-)
+ */
+#define sg_is_chain(sg)		((sg)->page_link & 0x01)
+#define sg_is_last(sg)		((sg)->page_link & 0x02)
+#define sg_chain_ptr(sg)	\
+	((struct scatterlist *) ((sg)->page_link & ~0x03))
+
 /**
  * sg_assign_page - Assign a given page to an SG entry
  * @sg:		    SG entry
@@ -47,6 +57,7 @@ static inline void sg_assign_page(struct
 	BUG_ON((unsigned long) page & 0x03);
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
 #endif
 	sg->page_link = page_link | (unsigned long) page;
 }
@@ -73,7 +84,14 @@ static inline void sg_set_page(struct sc
 	sg->length = len;
 }
 
-#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
+static inline struct page *sg_page(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+	return (struct page *)((sg)->page_link & ~0x3);
+}
 
 /**
  * sg_set_buf - Set sg entry to point at given data
@@ -88,16 +106,6 @@ static inline void sg_set_buf(struct sca
 	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
 }
 
-/*
- * We overload the LSB of the page pointer to indicate whether it's
- * a valid sg entry, or whether it points to the start of a new scatterlist.
- * Those low bits are there for everyone! (thanks mason :-)
- */
-#define sg_is_chain(sg)		((sg)->page_link & 0x01)
-#define sg_is_last(sg)		((sg)->page_link & 0x02)
-#define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((sg)->page_link & ~0x03))
-
 /**
  * sg_next - return the next scatterlist entry in a list
  * @sg:		The current sg entry
@@ -179,6 +187,13 @@ static inline void sg_chain(struct scatt
 #ifndef ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
+
+	/*
+	 * offset and length are unused for chain entry.  Clear them.
+	 */
+	prv->offset = 0;
+	prv->length = 0;
+
 	/*
 	 * Set lowest bit to indicate a link pointer, and make sure to clear
 	 * the termination bit if it happens to be set.

