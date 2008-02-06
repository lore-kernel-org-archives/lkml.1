Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbYBFDXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbYBFDXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 22:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbYBFDWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 22:22:55 -0500
Received: from relay2.sgi.com ([192.48.171.30]:49036 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750943AbYBFDWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 22:22:54 -0500
From: akepner@sgi.com
Date: Tue, 5 Feb 2008 19:21:28 -0800
To: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3 v2] dma/doc: document dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080206032128.GO9904@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Document the new dma_{un}map_{single|sg}_attrs() functions.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 DMA-API.txt        |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 DMA-attributes.txt |   29 +++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index b939ebb..4c471fc 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -395,6 +395,71 @@ Notes:  You must do this:
 
 See also dma_map_single().
 
+dma_addr_t 
+dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size, 
+		     enum dma_data_direction dir, 
+		     struct dma_attrs* attrs)
+
+void 
+dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
+		       size_t size, enum dma_data_direction dir,
+		       struct dma_attrs* attrs)
+
+int 
+dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
+		 int nents, enum dma_data_direction dir, 
+		 struct dma_attrs *attrs)
+
+void 
+dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl, 
+		   int nents, enum dma_data_direction dir,
+		   struct dma_attrs *attrs)
+
+The four functions above are just like the counterpart functions 
+without the _attrs suffixes, except that they pass an optional 
+struct dma_attrs*. 
+
+struct dma_attrs encapsulates a set of "dma attributes". For the 
+definition of struct dma_attrs see linux/dma-attrs.h. 
+
+The interpretation of dma attributes is architecture-specific, and 
+each attribute should be documented in Documentation/DMA-attributes.txt. 
+
+If struct dma_attrs* is NULL, the semantics of each of these 
+functions is identical to those of the corresponding function 
+without the _attrs suffix. As a result dma_map_single_attrs() 
+can generally replace dma_map_single(), etc.
+
+As an example of the use of the *_attrs functions, here's how 
+you could pass an attribute DMA_ATTR_FOO when mapping memory 
+for DMA:
+
+#include <linux/dma-attrs.h>
+/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and 
+ * documented in Documentation/DMA-attributes.txt */
+...
+
+	DECLARE_DMA_ATTRS(attrs);
+	dma_set_attr(&attrs, DMA_ATTR_FOO);
+	....
+	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
+	....
+
+Architectures that care about DMA_ATTR_FOO would check for its 
+presence in their implementations of the mapping and unmapping 
+routines, e.g.:
+
+void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr, 
+			     size_t size, enum dma_data_direction dir, 
+			     struct dma_attrs* attrs)
+{
+	....
+	int foo =  dma_get_attr(attrs, DMA_ATTR_FOO);
+	....
+	if (foo) 
+		/* twizzle the frobnozzle */
+	....
+
 
 Part II - Advanced dma_ usage
 -----------------------------
diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index e69de29..36baea5 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -0,0 +1,29 @@
+			DMA attributes
+			==============
+
+This document describes the semantics of the DMA attributes that are 
+defined in linux/dma-attrs.h. 
+
+
+DMA_ATTR_SYNC_ON_WRITE
+----------------------
+
+DMA_ATTR_SYNC_ON_WRITE is used on the IA64_SGI_SN2 architecture.
+It provides a mechanism for devices to explicitly order their DMA 
+writes.
+
+On IA64_SGI_SN2 machines, DMA may be reordered within the NUMA 
+interconnect. Allowing reordering improves performance, but in some 
+situations it may be necessary to ensure that one DMA write is 
+complete before another is visible. For example, if the device does 
+a DMA write to indicate that data is available in memory, DMA of the 
+"completion indication" can race with DMA of data.
+
+When a memory region is mapped with the DMA_ATTR_SYNC_ON_WRITE attribute, 
+a write to that region causes all in-flight DMA to be flushed to memory. 
+Any pending DMA will complete and be visible in memory before the write 
+to the region with the DMA_ATTR_SYNC_ON_WRITE attribute becomes visible. 
+
+(For more information, see the document titled "SGI Altix Architecture 
+Considerations for Linux Device Drivers" at http://techpubs.sgi.com/.)
+
