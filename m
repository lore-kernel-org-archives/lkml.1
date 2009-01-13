Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZAMBbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZAMBbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbZAMB3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:01 -0500
Received: from kroah.org ([198.145.64.141]:35961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758008AbZAMB27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:28:59 -0500
Date: Mon, 12 Jan 2009 17:27:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Saeed Bishara <saeed@marvell.com>,
       Yuri Tikhonov <yur@emcraft.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [patch 07/21] async_xor: dma_map destination DMA_BIDIRECTIONAL
Message-ID: <20090113012702.GH4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="async_xor-dma_map-destination-dma_bidirectional.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit a06d568f7c5e40e34ea64881842deb8f4382babf upstream.

Mapping the destination multiple times is a misuse of the dma-api.
Since the destination may be reused as a source, ensure that it is only
mapped once and that it is mapped bidirectionally.  This appears to add
ugliness on the unmap side in that it always reads back the destination
address from the descriptor, but gcc can determine that dma_unmap is a
nop and not emit the code that calculates its arguments.

Cc: Saeed Bishara <saeed@marvell.com>
Acked-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/async_tx/async_xor.c |   11 +++++++++--
 drivers/dma/iop-adma.c      |   16 +++++++++++++---
 drivers/dma/mv_xor.c        |   15 ++++++++++++---
 3 files changed, 34 insertions(+), 8 deletions(-)

--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -53,10 +53,17 @@ do_async_xor(struct dma_chan *chan, stru
 	int xor_src_cnt;
 	dma_addr_t dma_dest;
 
-	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_FROM_DEVICE);
-	for (i = 0; i < src_cnt; i++)
+	/* map the dest bidrectional in case it is re-used as a source */
+	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
+	for (i = 0; i < src_cnt; i++) {
+		/* only map the dest once */
+		if (unlikely(src_list[i] == dest)) {
+			dma_src[i] = dma_dest;
+			continue;
+		}
 		dma_src[i] = dma_map_page(dma->dev, src_list[i], offset,
 					  len, DMA_TO_DEVICE);
+	}
 
 	while (src_cnt) {
 		async_flags = flags;
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -85,18 +85,28 @@ iop_adma_run_tx_complete_actions(struct 
 			enum dma_ctrl_flags flags = desc->async_tx.flags;
 			u32 src_cnt;
 			dma_addr_t addr;
+			dma_addr_t dest;
 
+			src_cnt = unmap->unmap_src_cnt;
+			dest = iop_desc_get_dest_addr(unmap, iop_chan);
 			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-				addr = iop_desc_get_dest_addr(unmap, iop_chan);
-				dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
+				enum dma_data_direction dir;
+
+				if (src_cnt > 1) /* is xor? */
+					dir = DMA_BIDIRECTIONAL;
+				else
+					dir = DMA_FROM_DEVICE;
+
+				dma_unmap_page(dev, dest, len, dir);
 			}
 
 			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-				src_cnt = unmap->unmap_src_cnt;
 				while (src_cnt--) {
 					addr = iop_desc_get_src_addr(unmap,
 								     iop_chan,
 								     src_cnt);
+					if (addr == dest)
+						continue;
 					dma_unmap_page(dev, addr, len,
 						       DMA_TO_DEVICE);
 				}
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -311,17 +311,26 @@ mv_xor_run_tx_complete_actions(struct mv
 			enum dma_ctrl_flags flags = desc->async_tx.flags;
 			u32 src_cnt;
 			dma_addr_t addr;
+			dma_addr_t dest;
 
+			src_cnt = unmap->unmap_src_cnt;
+			dest = mv_desc_get_dest_addr(unmap);
 			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-				addr = mv_desc_get_dest_addr(unmap);
-				dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
+				enum dma_data_direction dir;
+
+				if (src_cnt > 1) /* is xor ? */
+					dir = DMA_BIDIRECTIONAL;
+				else
+					dir = DMA_FROM_DEVICE;
+				dma_unmap_page(dev, dest, len, dir);
 			}
 
 			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-				src_cnt = unmap->unmap_src_cnt;
 				while (src_cnt--) {
 					addr = mv_desc_get_src_addr(unmap,
 								    src_cnt);
+					if (addr == dest)
+						continue;
 					dma_unmap_page(dev, addr, len,
 						       DMA_TO_DEVICE);
 				}

