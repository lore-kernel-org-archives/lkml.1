Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYA3FwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYA3FwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYA3FwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:52:08 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47189 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753799AbYA3FwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:52:06 -0500
From: akepner@sgi.com
Date: Tue, 29 Jan 2008 21:50:40 -0800
To: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dma: document dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080130055040.GS30022@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Document the new dma_{un}map_{single|sg}_attrs() functions. 

Signed-off-by: Arthur Kepner <akepner@sgi.com>

--

 DMA-API.txt |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index b939ebb..fad05e0 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -395,6 +395,69 @@ Notes:  You must do this:
 
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
+The interpretation of dma attributes is architecture-specific. 
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
+/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h */
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
