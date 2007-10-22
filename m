Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbXJVSNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbXJVSNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXJVSM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22165 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbXJVSMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:24 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/10] [SG] Add helpers for manipulating SG entries
Date: Mon, 22 Oct 2007 20:10:55 +0200
Message-Id: <1193076664-13652-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can then transition drivers without changing the generated code.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/scatterlist.h |  112 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 104 insertions(+), 8 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2dc7464..1645795 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -2,24 +2,37 @@
 #define _LINUX_SCATTERLIST_H
 
 #include <asm/scatterlist.h>
+#include <asm/io.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 
+/**
+ * sg_set_page - Set sg entry to point at given page
+ * @sg:		 SG entry
+ * @page:	 The page
+ *
+ * Description:
+ *   Use this function to set an sg entry pointing at a page, never assign
+ *   the page directly. We encode sg table information in the lower bits
+ *   of the page pointer. See sg_page() for looking up the page belonging
+ *   to an sg entry.
+ *
+ **/
+static inline void sg_set_page(struct scatterlist *sg, struct page *page)
+{
+	sg->page = page;
+}
+
+#define sg_page(sg)	((sg)->page)
+
 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 			      unsigned int buflen)
 {
-	sg->page = virt_to_page(buf);
+	sg_set_page(sg, virt_to_page(buf));
 	sg->offset = offset_in_page(buf);
 	sg->length = buflen;
 }
 
-static inline void sg_init_one(struct scatterlist *sg, const void *buf,
-			       unsigned int buflen)
-{
-	memset(sg, 0, sizeof(*sg));
-	sg_set_buf(sg, buf, buflen);
-}
-
 /*
  * We overload the LSB of the page pointer to indicate whether it's
  * a valid sg entry, or whether it points to the start of a new scatterlist.
@@ -104,4 +117,87 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 	prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
 }
 
+/**
+ * sg_mark_end - Mark the end of the scatterlist
+ * @sgl:	Scatterlist
+ * @nents:	Number of entries in sgl
+ *
+ * Description:
+ *   Marks the last entry as the termination point for sg_next()
+ *
+ **/
+static inline void sg_mark_end(struct scatterlist *sgl, unsigned int nents)
+{
+}
+
+static inline void __sg_mark_end(struct scatterlist *sg)
+{
+}
+
+
+/**
+ * sg_init_one - Initialize a single entry sg list
+ * @sg:		 SG entry
+ * @buf:	 Virtual address for IO
+ * @buflen:	 IO length
+ *
+ * Notes:
+ *   This should not be used on a single entry that is part of a larger
+ *   table. Use sg_init_table() for that.
+ *
+ **/
+static inline void sg_init_one(struct scatterlist *sg, const void *buf,
+			       unsigned int buflen)
+{
+	memset(sg, 0, sizeof(*sg));
+	sg_mark_end(sg, 1);
+	sg_set_buf(sg, buf, buflen);
+}
+
+/**
+ * sg_init_table - Initialize SG table
+ * @sgl:	   The SG table
+ * @nents:	   Number of entries in table
+ *
+ * Notes:
+ *   If this is part of a chained sg table, sg_mark_end() should be
+ *   used only on the last table part.
+ *
+ **/
+static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
+{
+	memset(sgl, 0, sizeof(*sgl) * nents);
+	sg_mark_end(sgl, nents);
+}
+
+/**
+ * sg_phys - Return physical address of an sg entry
+ * @sg:	     SG entry
+ *
+ * Description:
+ *   This calls page_to_phys() on the page in this sg entry, and adds the
+ *   sg offset. The caller must know that it is legal to call page_to_phys()
+ *   on the sg page.
+ *
+ **/
+static inline unsigned long sg_phys(struct scatterlist *sg)
+{
+	return page_to_phys(sg_page(sg)) + sg->offset;
+}
+
+/**
+ * sg_virt - Return virtual address of an sg entry
+ * @sg:	     SG entry
+ *
+ * Description:
+ *   This calls page_address() on the page in this sg entry, and adds the
+ *   sg offset. The caller must know that the sg page has a valid virtual
+ *   mapping.
+ *
+ **/
+static inline void *sg_virt(struct scatterlist *sg)
+{
+	return page_address(sg_page(sg)) + sg->offset;
+}
+
 #endif /* _LINUX_SCATTERLIST_H */
-- 
1.5.3.GIT

