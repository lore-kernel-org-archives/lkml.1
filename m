Return-Path: <linux-kernel-owner+w=401wt.eu-S1763674AbYBGAI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763674AbYBGAI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764819AbYBFX5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:57:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:45949 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764808AbYBFX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:57:22 -0500
Date: Wed, 6 Feb 2008 15:52:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 31/73] SPARC64: Fix OOPS in dma_sync_*_for_device()
Message-ID: <20080206235248.GF13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-oops-in-dma_sync_-_for_device.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: David Miller <davem@davemloft.net>

[SPARC64]: Fix OOPS in dma_sync_*_for_device()

[ Upstream commit: 36bb61346d9e64b55285f27363e93a6e96f2abba ]

I included these operations vector cases for situations
where we never need to do anything, the entries aren't
filled in by any implementation, so we OOPS trying to
invoke NULL pointer functions.

Really make them NOPs, to fix the bug.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-sparc64/dma-mapping.h |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/include/asm-sparc64/dma-mapping.h
+++ b/include/asm-sparc64/dma-mapping.h
@@ -25,15 +25,9 @@ struct dma_ops {
 	void (*sync_single_for_cpu)(struct device *dev,
 				    dma_addr_t dma_handle, size_t size,
 				    enum dma_data_direction direction);
-	void (*sync_single_for_device)(struct device *dev,
-				       dma_addr_t dma_handle, size_t size,
-				       enum dma_data_direction direction);
 	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
 				int nelems,
 				enum dma_data_direction direction);
-	void (*sync_sg_for_device)(struct device *dev, struct scatterlist *sg,
-				   int nelems,
-				   enum dma_data_direction direction);
 };
 extern const struct dma_ops *dma_ops;
 
@@ -105,7 +99,7 @@ static inline void dma_sync_single_for_d
 					      size_t size,
 					      enum dma_data_direction direction)
 {
-	dma_ops->sync_single_for_device(dev, dma_handle, size, direction);
+	/* No flushing needed to sync cpu writes to the device.  */
 }
 
 static inline void dma_sync_single_range_for_cpu(struct device *dev,
@@ -123,7 +117,7 @@ static inline void dma_sync_single_range
 						    size_t size,
 						    enum dma_data_direction direction)
 {
-	dma_sync_single_for_device(dev, dma_handle+offset, size, direction);
+	/* No flushing needed to sync cpu writes to the device.  */
 }
 
 
@@ -138,7 +132,7 @@ static inline void dma_sync_sg_for_devic
 					  struct scatterlist *sg, int nelems,
 					  enum dma_data_direction direction)
 {
-	dma_ops->sync_sg_for_device(dev, sg, nelems, direction);
+	/* No flushing needed to sync cpu writes to the device.  */
 }
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)

-- 
