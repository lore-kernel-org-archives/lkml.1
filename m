Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbYCMECx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYCMECx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 00:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYCMECp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 00:02:45 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42391 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750749AbYCMECo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 00:02:44 -0400
From: akepner@sgi.com
Date: Wed, 12 Mar 2008 21:01:17 -0700
To: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4 v4] dma: document dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080313040117.GK12370@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Document the new dma_{un}map_{single|sg}_attrs() functions.

Signed-off-by: Arthur Kepner <akepner@sgi.com>
Acked-by:  Jesse Barnes <jesse.barnes@intel.com>

--- 

 DMA-API.txt        |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 DMA-attributes.txt |   24 +++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index b939ebb..fdb82b0 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -395,6 +395,71 @@ Notes:  You must do this:
 
 See also dma_map_single().
 
+dma_addr_t 
+dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size, 
+		     enum dma_data_direction dir, 
+		     struct dma_attrs *attrs)
+
+void 
+dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
+		       size_t size, enum dma_data_direction dir,
+		       struct dma_attrs *attrs)
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
+			     struct dma_attrs *attrs)
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
index e69de29..a4106ec 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -0,0 +1,24 @@
+			DMA attributes
+			==============
+
+This document describes the semantics of the DMA attributes that are 
+defined in linux/dma-attrs.h. 
+
+DMA_ATTR_BARRIER
+----------------
+
+DMA_ATTR_BARRIER is a barrier attribute for DMA.  DMA to a memory 
+region with the DMA_ATTR_BARRIER attribute forces all pending DMA 
+writes to complete, and thus provides a mechanism to strictly order 
+DMA from a device across all intervening busses and bridges.  This 
+barrier is not specific to a particular type of interconnect, it 
+applies to the system as a whole, and so its implementation must 
+account for the idiosyncracies of the system all the way from the 
+DMA device to memory. 
+
+As an example of a situation where DMA_ATTR_BARRIER would be useful, 
+suppose that a device does a DMA write to indicate that data is ready 
+and available in memory.  The DMA of the "completion indication" could
+race with data DMA.  Mapping the memory used for completion indications 
+with DMA_ATTR_BARRIER would prevent the race.
+
