Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbXEPId6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbXEPId6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758695AbXEPIdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:33:13 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7089 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696AbXEPIdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:33:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/10] i386 sg: add support for chaining scatterlists
Date: Wed, 16 May 2007 10:31:37 +0200
Message-Id: <11793043003152-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <1179304300358-git-send-email-jens.axboe@oracle.com>
References: <1179304300358-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The core of the patch - allow the last sg element in a scatterlist
table to point to the start of a new table. This adds a pointer
to the sglist structure, and defines sg_chain_ptr() which the
generic code can use to look it up.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/asm-i386/scatterlist.h |    4 ++++
 include/linux/scatterlist.h    |   37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
index d7e45a8..794b68c 100644
--- a/include/asm-i386/scatterlist.h
+++ b/include/asm-i386/scatterlist.h
@@ -8,8 +8,11 @@ struct scatterlist {
     unsigned int	offset;
     dma_addr_t		dma_address;
     unsigned int	length;
+    struct scatterlist	*next;
 };
 
+#define ARCH_HAS_SG_CHAIN
+
 /* These macros should be used after a pci_map_sg call has been done
  * to get bus addresses of each of the SG entries and their lengths.
  * You should only work with the number of sg entries pci_map_sg
@@ -17,6 +20,7 @@ struct scatterlist {
  */
 #define sg_dma_address(sg)	((sg)->dma_address)
 #define sg_dma_len(sg)		((sg)->length)
+#define sg_chain_ptr(sg)	((sg)->next)
 
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index c5bffde..e3fc307 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -20,13 +20,44 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 	sg_set_buf(sg, buf, buflen);
 }
 
-#define sg_next(sg)		((sg) + 1)
-#define sg_last(sg, nents)	(&(sg[nents - 1]))
-
 /*
  * Loop over each sg element, following the pointer to a new list if necessary
  */
 #define for_each_sg(sglist, sg, nr, __i)	\
 	for (__i = 0, sg = (sglist); __i < nr; __i++, sg = sg_next(sg))
 
+#ifdef ARCH_HAS_SG_CHAIN
+#define sg_next(sg)	(sg_chain_ptr((sg)) ? : (sg) + 1)
+/*
+ * Chain previous sglist to this one
+ */
+static inline void sg_chain(struct scatterlist *prv, unsigned int nents,
+			    struct scatterlist *sgl)
+{
+	sg_chain_ptr(&prv[nents - 1]) = sgl;
+}
+
+/*
+ * We could improve this by passing in the maximum size of an sglist, so
+ * we could jump directly to the last table. That would eliminate this
+ * (potentially) lengthy scan.
+ */
+static inline struct scatterlist *sg_last(struct scatterlist *sgl,
+					  unsigned int nents)
+{
+	struct scatterlist *sg, *ret = NULL;
+	int i;
+
+	for_each_sg(sgl, sg, nents, i)
+		ret = sg;
+
+	return ret;
+}
+#else
+#define sg_next(sg)			((sg) + 1)
+#define sg_chain(prv, nents, sgl)	BUG()
+#define	sg_chain_ptr(sg)		NULL
+#define sg_last(sg, nents)		(&(sg[nents - 1]))
+#endif
+
 #endif /* _LINUX_SCATTERLIST_H */
-- 
1.5.2.rc1

