Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbXEJLm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbXEJLm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbXEJLlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:41:15 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4888 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758276AbXEJLlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:41:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/12] i386 sg: add support for chaining scatterlists
Date: Thu, 10 May 2007 13:40:32 +0200
Message-Id: <11787972373410-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11787972373654-git-send-email-jens.axboe@oracle.com>
References: <11787972373654-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The core of the patch - allow the last sg element in a scatterlist
table to point to the start of a new table. We overload the LSB of
the page pointer to indicate whether this is a valid sg entry, or
merely a link to the next list.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/asm-i386/scatterlist.h |    2 +
 include/linux/scatterlist.h    |   52 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
index d7e45a8..bd5164a 100644
--- a/include/asm-i386/scatterlist.h
+++ b/include/asm-i386/scatterlist.h
@@ -10,6 +10,8 @@ struct scatterlist {
     unsigned int	length;
 };
 
+#define ARCH_HAS_SG_CHAIN
+
 /* These macros should be used after a pci_map_sg call has been done
  * to get bus addresses of each of the SG entries and their lengths.
  * You should only work with the number of sg entries pci_map_sg
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index bed5ab4..fa2dc1c 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -20,8 +20,23 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 	sg_set_buf(sg, buf, buflen);
 }
 
-#define sg_next(sg)		((sg) + 1)
-#define sg_last(sg, nents)	(&(sg[(nents) - 1]))
+#define sg_is_chain(sg)		((unsigned long) (sg)->page & 0x01)
+#define sg_chain_ptr(sg)	\
+	((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))
+
+/*
+ * We overload the meaning of ->page for sg chaining. If the LSB is
+ * set, the page member contains a pointer to the next sgtable.
+ */
+static inline struct scatterlist *sg_next(struct scatterlist *sg)
+{
+	sg++;
+
+	if (unlikely(sg_is_chain(sg)))
+		sg = sg_chain_ptr(sg);
+
+	return sg;
+}
 
 /*
  * Loop over each sg element, following the pointer to a new list if necessary
@@ -29,4 +44,37 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 #define for_each_sg(sglist, sg, nr, __i)	\
 	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
 
+/*
+ * We could improve this by passing in the maximum size of an sglist, so
+ * we could jump directly to the last table. That would eliminate this
+ * (potentially) lengthy scan.
+ */
+static inline struct scatterlist *sg_last(struct scatterlist *sgl,
+					  unsigned int nents)
+{
+#ifdef ARCH_HAS_SG_CHAIN
+	struct scatterlist *ret = &sgl[nents - 1];
+#else
+	struct scatterlist *sg, *ret = NULL;
+	int i;
+
+	for_each_sg(sgl, sg, nents, i)
+		ret = sg;
+
+#endif
+	return ret;
+}
+
+/*
+ * Chain previous sglist to this one
+ */
+static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
+			    struct scatterlist *sgl)
+{
+#ifndef ARCH_HAS_SG_CHAIN
+	BUG();
+#endif
+	prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
+}
+
 #endif /* _LINUX_SCATTERLIST_H */
-- 
1.5.2.rc1

