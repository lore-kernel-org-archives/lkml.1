Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbXJVSPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbXJVSPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXJVSMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:32 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22195 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbXJVSM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:26 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 09/10] Change table chaining layout
Date: Mon, 22 Oct 2007 20:11:03 +0200
Message-Id: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the page member of the scatterlist structure to be an unsigned
long, and encode more stuff in the lower bits:

- Bits 0 and 1 zero: this is a normal sg entry. Next sg entry is located
  at sg + 1.
- Bit 0 set: this is a chain entry, the next real entry is at ->page_link
  with the two low bits masked off.
- Bit 1 set: this is the final entry in the sg entry. sg_next() will return
  NULL when passed such an entry.

It's thus important that sg table users use the proper accessors to get
and set the page member.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/asm-alpha/scatterlist.h     |    2 +-
 include/asm-arm/scatterlist.h       |    2 +-
 include/asm-avr32/scatterlist.h     |    2 +-
 include/asm-blackfin/scatterlist.h  |    2 +-
 include/asm-cris/scatterlist.h      |    2 +-
 include/asm-frv/scatterlist.h       |    2 +-
 include/asm-h8300/scatterlist.h     |    2 +-
 include/asm-ia64/scatterlist.h      |    2 +-
 include/asm-m32r/scatterlist.h      |    2 +-
 include/asm-m68k/scatterlist.h      |    2 +-
 include/asm-m68knommu/scatterlist.h |    2 +-
 include/asm-mips/scatterlist.h      |    2 +-
 include/asm-parisc/scatterlist.h    |    2 +-
 include/asm-powerpc/scatterlist.h   |    2 +-
 include/asm-s390/scatterlist.h      |    2 +-
 include/asm-sh/scatterlist.h        |    2 +-
 include/asm-sh64/scatterlist.h      |    2 +-
 include/asm-sparc/scatterlist.h     |    2 +-
 include/asm-sparc64/scatterlist.h   |    2 +-
 include/asm-v850/scatterlist.h      |    2 +-
 include/asm-x86/dma-mapping_32.h    |    4 +-
 include/asm-x86/scatterlist_32.h    |    2 +-
 include/asm-x86/scatterlist_64.h    |    2 +-
 include/asm-xtensa/scatterlist.h    |    2 +-
 include/linux/scatterlist.h         |   78 ++++++++++++++++++++++++-----------
 25 files changed, 79 insertions(+), 49 deletions(-)

diff --git a/include/asm-alpha/scatterlist.h b/include/asm-alpha/scatterlist.h
index 9173654..b764706 100644
--- a/include/asm-alpha/scatterlist.h
+++ b/include/asm-alpha/scatterlist.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
   
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 
 	unsigned int length;
diff --git a/include/asm-arm/scatterlist.h b/include/asm-arm/scatterlist.h
index de2f65e..ab1d85d 100644
--- a/include/asm-arm/scatterlist.h
+++ b/include/asm-arm/scatterlist.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;		/* buffer page			 */
+	unsigned long	page_link;
 	unsigned int	offset;		/* buffer offset		 */
 	dma_addr_t	dma_address;	/* dma address			 */
 	unsigned int	length;		/* length			 */
diff --git a/include/asm-avr32/scatterlist.h b/include/asm-avr32/scatterlist.h
index c6d5ce3..1356f29 100644
--- a/include/asm-avr32/scatterlist.h
+++ b/include/asm-avr32/scatterlist.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page		*page;
+    unsigned long	page_link;
     unsigned int	offset;
     dma_addr_t		dma_address;
     unsigned int	length;
diff --git a/include/asm-blackfin/scatterlist.h b/include/asm-blackfin/scatterlist.h
index 60e07b9..384af54 100644
--- a/include/asm-blackfin/scatterlist.h
+++ b/include/asm-blackfin/scatterlist.h
@@ -4,7 +4,7 @@
 #include <linux/mm.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 	dma_addr_t dma_address;
 	unsigned int length;
diff --git a/include/asm-cris/scatterlist.h b/include/asm-cris/scatterlist.h
index 4bdc44c..5a8a834 100644
--- a/include/asm-cris/scatterlist.h
+++ b/include/asm-cris/scatterlist.h
@@ -6,7 +6,7 @@ struct scatterlist {
 	unsigned int length;
 
 	/* The following is i386 highmem junk - not used by us */
-	struct page * page; /* Location for highmem page, if any */
+	unsigned long page_link;
 	unsigned int offset;/* for highmem, page offset */
 
 };
diff --git a/include/asm-frv/scatterlist.h b/include/asm-frv/scatterlist.h
index 8e827fa..53dade7 100644
--- a/include/asm-frv/scatterlist.h
+++ b/include/asm-frv/scatterlist.h
@@ -22,7 +22,7 @@
  * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
  */
 struct scatterlist {
-	struct page	*page;		/* Location for highmem page, if any */
+	unsigned long	page_link;
 	unsigned int	offset;		/* for highmem, page offset */
 
 	dma_addr_t	dma_address;
diff --git a/include/asm-h8300/scatterlist.h b/include/asm-h8300/scatterlist.h
index 985fdf5..7e41983 100644
--- a/include/asm-h8300/scatterlist.h
+++ b/include/asm-h8300/scatterlist.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
 	unsigned int	length;
diff --git a/include/asm-ia64/scatterlist.h b/include/asm-ia64/scatterlist.h
index 7d5234d..2f76ce3 100644
--- a/include/asm-ia64/scatterlist.h
+++ b/include/asm-ia64/scatterlist.h
@@ -9,7 +9,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;	/* buffer length */
 
diff --git a/include/asm-m32r/scatterlist.h b/include/asm-m32r/scatterlist.h
index 352415f..33b4b4d 100644
--- a/include/asm-m32r/scatterlist.h
+++ b/include/asm-m32r/scatterlist.h
@@ -6,7 +6,7 @@
 struct scatterlist {
     char *  address;    /* Location data is to be transferred to, NULL for
                          * highmem page */
-    struct page * page; /* Location for highmem page, if any */
+    unsigned long page_link;
     unsigned int offset;/* for highmem, page offset */
 
     dma_addr_t dma_address;
diff --git a/include/asm-m68k/scatterlist.h b/include/asm-m68k/scatterlist.h
index 24887a2..e06bb89 100644
--- a/include/asm-m68k/scatterlist.h
+++ b/include/asm-m68k/scatterlist.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;
 
diff --git a/include/asm-m68knommu/scatterlist.h b/include/asm-m68knommu/scatterlist.h
index 4da79d3..28bed41 100644
--- a/include/asm-m68knommu/scatterlist.h
+++ b/include/asm-m68knommu/scatterlist.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
 	unsigned int	length;
diff --git a/include/asm-mips/scatterlist.h b/include/asm-mips/scatterlist.h
index 7af104c..787797c 100644
--- a/include/asm-mips/scatterlist.h
+++ b/include/asm-mips/scatterlist.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page *	page;
+	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
 	unsigned int	length;
diff --git a/include/asm-parisc/scatterlist.h b/include/asm-parisc/scatterlist.h
index e7211c7..26da914 100644
--- a/include/asm-parisc/scatterlist.h
+++ b/include/asm-parisc/scatterlist.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 
 	unsigned int length;
diff --git a/include/asm-powerpc/scatterlist.h b/include/asm-powerpc/scatterlist.h
index b075f61..b9f1dbc 100644
--- a/include/asm-powerpc/scatterlist.h
+++ b/include/asm-powerpc/scatterlist.h
@@ -14,7 +14,7 @@
 #include <asm/dma.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;
 
diff --git a/include/asm-s390/scatterlist.h b/include/asm-s390/scatterlist.h
index a43b3af..eb39486 100644
--- a/include/asm-s390/scatterlist.h
+++ b/include/asm-s390/scatterlist.h
@@ -2,7 +2,7 @@
 #define _ASMS390_SCATTERLIST_H
 
 struct scatterlist {
-    struct page *page;
+    unsigned long page_link;
     unsigned int offset;
     unsigned int length;
 };
diff --git a/include/asm-sh/scatterlist.h b/include/asm-sh/scatterlist.h
index b9ae53c..bc7c809 100644
--- a/include/asm-sh/scatterlist.h
+++ b/include/asm-sh/scatterlist.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page * page; /* Location for highmem page, if any */
+    unsigned long page_link;
     unsigned int offset;/* for highmem, page offset */
     dma_addr_t dma_address;
     unsigned int length;
diff --git a/include/asm-sh64/scatterlist.h b/include/asm-sh64/scatterlist.h
index 1c723f2..0afd856 100644
--- a/include/asm-sh64/scatterlist.h
+++ b/include/asm-sh64/scatterlist.h
@@ -14,7 +14,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page * page; /* Location for highmem page, if any */
+    unsigned long page_link;
     unsigned int offset;/* for highmem, page offset */
     dma_addr_t dma_address;
     unsigned int length;
diff --git a/include/asm-sparc/scatterlist.h b/include/asm-sparc/scatterlist.h
index 4055af9..45b16f1 100644
--- a/include/asm-sparc/scatterlist.h
+++ b/include/asm-sparc/scatterlist.h
@@ -5,7 +5,7 @@
 #include <linux/types.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 
 	unsigned int length;
diff --git a/include/asm-sparc64/scatterlist.h b/include/asm-sparc64/scatterlist.h
index 703c5bb..4cbaf7c 100644
--- a/include/asm-sparc64/scatterlist.h
+++ b/include/asm-sparc64/scatterlist.h
@@ -6,7 +6,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+	unsigned long	page_link;
 	unsigned int	offset;
 
 	unsigned int	length;
diff --git a/include/asm-v850/scatterlist.h b/include/asm-v850/scatterlist.h
index 56f4029..db91feb 100644
--- a/include/asm-v850/scatterlist.h
+++ b/include/asm-v850/scatterlist.h
@@ -17,7 +17,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+	unsigned long	page_link;
 	unsigned	offset;
 	dma_addr_t	dma_address;
 	unsigned	length;
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index 6a2d26c..55f01bd 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -45,9 +45,9 @@ dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	WARN_ON(nents == 0 || sglist[0].length == 0);
 
 	for_each_sg(sglist, sg, nents, i) {
-		BUG_ON(!sg->page);
+		BUG_ON(!sg_page(sg));
 
-		sg->dma_address = page_to_phys(sg->page) + sg->offset;
+		sg->dma_address = sg_phys(sg);
 	}
 
 	flush_write_buffers();
diff --git a/include/asm-x86/scatterlist_32.h b/include/asm-x86/scatterlist_32.h
index bd5164a..140a5b3 100644
--- a/include/asm-x86/scatterlist_32.h
+++ b/include/asm-x86/scatterlist_32.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page		*page;
+    unsigned long	page_link;
     unsigned int	offset;
     dma_addr_t		dma_address;
     unsigned int	length;
diff --git a/include/asm-x86/scatterlist_64.h b/include/asm-x86/scatterlist_64.h
index ef3986b..e344784 100644
--- a/include/asm-x86/scatterlist_64.h
+++ b/include/asm-x86/scatterlist_64.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page		*page;
+    unsigned long	page_link;
     unsigned int	offset;
     unsigned int	length;
     dma_addr_t		dma_address;
diff --git a/include/asm-xtensa/scatterlist.h b/include/asm-xtensa/scatterlist.h
index ca337a2..3b8aba5 100644
--- a/include/asm-xtensa/scatterlist.h
+++ b/include/asm-xtensa/scatterlist.h
@@ -14,7 +14,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page 	*page;
+	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
 	unsigned int	length;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 1645795..c6136e8 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -2,9 +2,26 @@
 #define _LINUX_SCATTERLIST_H
 
 #include <asm/scatterlist.h>
-#include <asm/io.h>
 #include <linux/mm.h>
 #include <linux/string.h>
+#include <asm/io.h>
+
+/*
+ * Notes on SG table design.
+ *
+ * Architectures must provide an unsigned long page_link field in the
+ * scatterlist struct. We use that to place the page pointer AND encode
+ * information about the sg table as well. The two lower bits are reserved
+ * for this information.
+ *
+ * If bit 0 is set, then the page_link contains a pointer to the next sg
+ * table list. Otherwise the next entry is at sg + 1.
+ *
+ * If bit 1 is set, then this sg entry is the last element in a list.
+ *
+ * See sg_next().
+ *
+ */
 
 /**
  * sg_set_page - Set sg entry to point at given page
@@ -20,11 +37,20 @@
  **/
 static inline void sg_set_page(struct scatterlist *sg, struct page *page)
 {
-	sg->page = page;
+	unsigned long page_link = sg->page_link & 0x3;
+
+	sg->page_link = page_link | (unsigned long) page;
 }
 
-#define sg_page(sg)	((sg)->page)
+#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
 
+/**
+ * sg_set_buf - Set sg entry to point at given data
+ * @sg:		 SG entry
+ * @buf:	 Data
+ * @buflen:	 Data length
+ *
+ **/
 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 			      unsigned int buflen)
 {
@@ -38,26 +64,27 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
  * a valid sg entry, or whether it points to the start of a new scatterlist.
  * Those low bits are there for everyone! (thanks mason :-)
  */
-#define sg_is_chain(sg)		((unsigned long) (sg)->page & 0x01)
+#define sg_is_chain(sg)		((sg)->page_link & 0x01)
+#define sg_is_last(sg)		((sg)->page_link & 0x02)
 #define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))
+	((struct scatterlist *) ((sg)->page_link & ~0x03))
 
 /**
  * sg_next - return the next scatterlist entry in a list
  * @sg:		The current sg entry
  *
- * Usually the next entry will be @sg@ + 1, but if this sg element is part
- * of a chained scatterlist, it could jump to the start of a new
- * scatterlist array.
- *
- * Note that the caller must ensure that there are further entries after
- * the current entry, this function will NOT return NULL for an end-of-list.
+ * Description:
+ *   Usually the next entry will be @sg@ + 1, but if this sg element is part
+ *   of a chained scatterlist, it could jump to the start of a new
+ *   scatterlist array.
  *
- */
+ **/
 static inline struct scatterlist *sg_next(struct scatterlist *sg)
 {
-	sg++;
+	if (sg_is_last(sg))
+		return NULL;
 
+	sg++;
 	if (unlikely(sg_is_chain(sg)))
 		sg = sg_chain_ptr(sg);
 
@@ -75,14 +102,15 @@ static inline struct scatterlist *sg_next(struct scatterlist *sg)
  * @sgl:	First entry in the scatterlist
  * @nents:	Number of entries in the scatterlist
  *
- * Should only be used casually, it (currently) scan the entire list
- * to get the last entry.
+ * Description:
+ *   Should only be used casually, it (currently) scan the entire list
+ *   to get the last entry.
  *
- * Note that the @sgl@ pointer passed in need not be the first one,
- * the important bit is that @nents@ denotes the number of entries that
- * exist from @sgl@.
+ *   Note that the @sgl@ pointer passed in need not be the first one,
+ *   the important bit is that @nents@ denotes the number of entries that
+ *   exist from @sgl@.
  *
- */
+ **/
 static inline struct scatterlist *sg_last(struct scatterlist *sgl,
 					  unsigned int nents)
 {
@@ -105,16 +133,17 @@ static inline struct scatterlist *sg_last(struct scatterlist *sgl,
  * @prv_nents:	Number of entries in prv
  * @sgl:	Second scatterlist
  *
- * Links @prv@ and @sgl@ together, to form a longer scatterlist.
+ * Description:
+ *   Links @prv@ and @sgl@ together, to form a longer scatterlist.
  *
- */
+ **/
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
 #ifndef ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
-	prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
+	prv[prv_nents - 1].page_link = (unsigned long) sgl | 0x01;
 }
 
 /**
@@ -128,13 +157,14 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
  **/
 static inline void sg_mark_end(struct scatterlist *sgl, unsigned int nents)
 {
+	sgl[nents - 1].page_link = 0x02;
 }
 
 static inline void __sg_mark_end(struct scatterlist *sg)
 {
+	sg->page_link |= 0x02;
 }
 
-
 /**
  * sg_init_one - Initialize a single entry sg list
  * @sg:		 SG entry
@@ -187,7 +217,7 @@ static inline unsigned long sg_phys(struct scatterlist *sg)
 
 /**
  * sg_virt - Return virtual address of an sg entry
- * @sg:	     SG entry
+ * @sg:      SG entry
  *
  * Description:
  *   This calls page_address() on the page in this sg entry, and adds the
-- 
1.5.3.GIT

