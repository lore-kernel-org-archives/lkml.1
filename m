Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbXJ0RrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbXJ0RrQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbXJ0Rqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:46:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:59942 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbXJ0Rqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=M664JPzxYFoD8LM+Nbr9PWOeM4joYump1BEdmf/tphnOnCQphmw/iI+xJwIT7JzoeooR8cvAnlFYNq+mZ8A1005itseZq6zv3zx5iSoyHrRRebIvxIPcMiUu5Q7uDDhh6EpRPQ9uwavkR2PpopRURY40s6N9qhhuQKUQE63PPb8=
Date: Sat, 27 Oct 2007 21:46:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] SG: set names for numeric constants
Message-ID: <20071027174632.GB7257@cvg>
References: <20071027170228.GA7257@cvg> <Pine.LNX.4.64.0710271312190.9802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710271312190.9802@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Robert P. J. Day - Sat, Oct 27, 2007 at 01:14:22PM -0400]
| On Sat, 27 Oct 2007, Cyrill Gorcunov wrote:
| 
| >
| > This patch defines names for numeric constants that
| > used in scatter list for more convenient code reading.
| >
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| ...
| > @@ -73,7 +76,7 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page,
| >  	sg->length = len;
| >  }
| >
| > -#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
| > +#define sg_page(sg)	((struct page *) ((sg)->page_link & ~SG_MASK))
| >
| > -#define sg_is_chain(sg)		((sg)->page_link & 0x01)
| > -#define sg_is_last(sg)		((sg)->page_link & 0x02)
| > +#define sg_is_chain(sg)		((sg)->page_link & SG_CHAIN)
| > +#define sg_is_last(sg)		((sg)->page_link & SG_LAST)
| >  #define sg_chain_ptr(sg)	\
| > -	((struct scatterlist *) ((sg)->page_link & ~0x03))
| > +	((struct scatterlist *) ((sg)->page_link & ~SG_MASK))
| 
| while you're at it, could you move all those macros to the top of the
| file, rather than leaving them scattered across the first 100 lines or
| so?  it would just make them easier to find when you're perusing the
| code.
| 
| rday
| -- 
| ========================================================================
| Robert P. J. Day
| Linux Consulting, Training and Annoying Kernel Pedantry
| Waterloo, Ontario, CANADA
| 
| http://crashcourse.ca
| ========================================================================
| 

This patch defines names for numeric constants that
used in scatter list for more convenient code reading.
Also groups all macroses on the top of the file.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Robert, what about this one?

 include/linux/scatterlist.h |   47 ++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4571231..3edd6ca 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -25,6 +25,25 @@
  */
 
 #define SG_MAGIC	0x87654321
+#define SG_CHAIN	0x1
+#define SG_LAST		0x2
+#define SG_MASK		0x3
+
+/*
+ * We overload the LSB of the page pointer to indicate whether it's
+ * a valid sg entry, or whether it points to the start of a new scatterlist.
+ * Those low bits are there for everyone! (thanks mason :-)
+ */
+#define sg_is_chain(sg)		((sg)->page_link & SG_CHAIN)
+#define sg_is_last(sg)		((sg)->page_link & SG_LAST)
+#define sg_chain_ptr(sg)	((struct scatterlist *)((sg)->page_link & ~SG_MASK))
+#define sg_page(sg)		((struct page *)((sg)->page_link & ~SG_MASK))
+
+/*
+ * Loop over each sg element, following the pointer to a new list if necessary
+ */
+#define for_each_sg(sglist, sg, nr, __i)	\
+	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
 
 /**
  * sg_assign_page - Assign a given page to an SG entry
@@ -38,13 +57,13 @@
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
@@ -73,8 +92,6 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 	sg->length = len;
 }
 
-#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
-
 /**
  * sg_set_buf - Set sg entry to point at given data
  * @sg:		 SG entry
@@ -88,16 +105,6 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
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
@@ -123,12 +130,6 @@ static inline struct scatterlist *sg_next(struct scatterlist *sg)
 	return sg;
 }
 
-/*
- * Loop over each sg element, following the pointer to a new list if necessary
- */
-#define for_each_sg(sglist, sg, nr, __i)	\
-	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
-
 /**
  * sg_last - return the last scatterlist entry in a list
  * @sgl:	First entry in the scatterlist
@@ -179,7 +180,7 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 #ifndef ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
-	prv[prv_nents - 1].page_link = (unsigned long) sgl | 0x01;
+	prv[prv_nents - 1].page_link = (unsigned long) sgl | SG_CHAIN;
 }
 
 /**
@@ -193,12 +194,12 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
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
