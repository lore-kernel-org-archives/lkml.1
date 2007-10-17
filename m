Return-Path: <linux-kernel-owner+w=401wt.eu-S935743AbXJQBpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743AbXJQBpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758017AbXJQBpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:45:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51284 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755636AbXJQBpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:45:30 -0400
From: akepner@sgi.com
Date: Tue, 16 Oct 2007 18:44:17 -0700
To: akpm@linux-foundation.org
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] document dma_flags_set/get_*()
Message-ID: <20071017014417.GL5601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Document the dma_flags_set/get_*() interfaces.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

--- 

 DMA-API.txt |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index b939ebb..00919b0 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -547,3 +547,41 @@ size is the size (and should be a page-sized multiple).
 The return value will be either a pointer to the processor virtual
 address of the memory, or an error (via PTR_ERR()) if any part of the
 region is occupied.
+
+int 
+dma_flags_set_attr(u32 attr, enum dma_data_direction dir)
+
+Amend dir with a platform-specific "dma attribute".
+
+The only attribute currently defined is DMA_BARRIER_ATTR, which causes 
+in-flight DMA to be flushed when the associated memory region is written 
+to (see example below).  Setting DMA_BARRIER_ATTR provides a mechanism 
+to enforce ordering of DMA on platforms that permit DMA to be reordered 
+between device and host memory (within a NUMA interconnect).  On other 
+platforms this is a nop.
+
+DMA_BARRIER_ATTR would be set when the memory region is mapped for DMA, 
+e.g.:
+
+	int count;
+	int flags = dma_flags_set_attr(DMA_BARRIER_ATTR, DMA_BIDIRECTIONAL);
+	....
+	count = dma_map_sg(dev, sglist, nents, flags);
+
+As an example of a situation where this would be useful, suppose that 
+the device does a DMA write to indicate that data is ready and 
+available in memory.  The DMA of the "completion indication" could 
+race with data DMA.  Using DMA_BARRIER_ATTR on the memory used for 
+completion indications would prevent the race.
+
+int
+dma_flags_get_dir(int flags)
+
+Retrieve the original DMA direction, where flags was returned from 
+dma_flags_set_attr().
+
+int
+dma_flags_get_attr(int flags)
+
+Retrieve the "dma attributes", where flags was returned from 
+dma_flags_set_attr().
