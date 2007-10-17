Return-Path: <linux-kernel-owner+w=401wt.eu-S934595AbXJQBmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbXJQBmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbXJQBmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:42:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37249 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760036AbXJQBmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:42:44 -0400
From: akepner@sgi.com
Date: Tue, 16 Oct 2007 18:41:28 -0700
To: akpm@linux-foundation.org
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] dma: add dma_flags_set/get_*() interfaces
Message-ID: <20071017014128.GJ5601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce the dma_flags_set/get_*() interfaces and give them 
default implementations. 

Architectures which allow DMA to be reordered between a device and 
host memory (within a NUMA interconnect) can redefine these to allow 
a driver to explicitly synchronize DMA from the device when necessary.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

--- 

Andrew, this is the first in a series of three patches:

  [1/3] dma: add dma_flags_set/get_*() interfaces
  [2/3] dma: redefine dma_flags_set/get_*() for sn-ia64
  [3/3] dma: document dma_flags_set/get_*()

Variants of these patches have been discussed on several 
occasions, most recently in a thread beginning:

http://marc.info/?l=linux-kernel&m=119137949604365&w=2

Please consider this for 2.6.24.

Jes, Tony, please note that I added an explicit test for 
CONFIG_IA64_SGI_SN2 in asm-ia64/sn/io.h (Yuck). This is 
needed for IA64_GENERIC to build, since there's at least one 
driver (qla1280) that includes asm-ia64/sn/io.h for 
CONFIG_IA64_GENERIC. 

 dma-mapping.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 0ebfafb..132b559 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -106,4 +106,22 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#define DMA_BARRIER_ATTR	0x1
+#ifndef ARCH_USES_DMA_ATTRS
+static inline int dma_flags_set_attr(u32 attr, enum dma_data_direction dir) 
+{
+	return dir;
+}
+
+static inline int dma_flags_get_dir(int flags)
+{
+	return flags;
+}
+
+static inline int dma_flags_get_attr(int flags)
+{
+	return 0;
+}
+#endif /* ARCH_USES_DMA_ATTRS */
+
 #endif
