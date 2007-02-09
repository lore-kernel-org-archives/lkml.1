Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbXBIXmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbXBIXmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXBIXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:42:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44531 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbXBIXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:42:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 10 Feb 2007 00:41:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [stable patch 2.6.20 2/3] ieee1394: video1394: DMA fix
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.3758c666718465a8@s5r6.in-berlin.de>
Message-ID: <tkrat.c5f99af899e152d1@s5r6.in-berlin.de>
References: <tkrat.3758c666718465a8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Sat, 03 Feb 2007 03:09:09 -0500
From: David Moore <dcm@acm.org>

This together with the phys_to_virt fix in lib/swiotlb.c::swiotlb_sync_sg
fixes video1394 DMA on machines with DMA bounce buffers, especially Intel
x86-64 machines with > 3GB RAM.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: David Moore <dcm@acm.org>
Tested-by: Nicolas Turro <Nicolas.Turro@inrialpes.fr>
---
 drivers/ieee1394/video1394.c |    8 ++++++++
 1 file changed, 8 insertions(+)

same as commit a5782010b4e75cba571357efaa27df22a89427c2 in linux-2.6.20-git#

Index: linux-2.6.20/drivers/ieee1394/video1394.c
===================================================================
--- linux-2.6.20.orig/drivers/ieee1394/video1394.c
+++ linux-2.6.20/drivers/ieee1394/video1394.c
@@ -489,6 +489,9 @@ static void wakeup_dma_ir_ctx(unsigned l
 			reset_ir_status(d, i);
 			d->buffer_status[d->buffer_prg_assignment[i]] = VIDEO1394_BUFFER_READY;
 			do_gettimeofday(&d->buffer_time[d->buffer_prg_assignment[i]]);
+			dma_region_sync_for_cpu(&d->dma,
+				d->buffer_prg_assignment[i] * d->buf_size,
+				d->buf_size);
 		}
 	}
 
@@ -1096,6 +1099,8 @@ static long video1394_ioctl(struct file 
 			DBGMSG(ohci->host->id, "Starting iso transmit DMA ctx=%d",
 			       d->ctx);
 			put_timestamp(ohci, d, d->last_buffer);
+			dma_region_sync_for_device(&d->dma,
+				v.buffer * d->buf_size, d->buf_size);
 
 			/* Tell the controller where the first program is */
 			reg_write(ohci, d->cmdPtr,
@@ -1111,6 +1116,9 @@ static long video1394_ioctl(struct file 
 				      "Waking up iso transmit dma ctx=%d",
 				      d->ctx);
 				put_timestamp(ohci, d, d->last_buffer);
+				dma_region_sync_for_device(&d->dma,
+					v.buffer * d->buf_size, d->buf_size);
+
 				reg_write(ohci, d->ctrlSet, 0x1000);
 			}
 		}


-- 
Stefan Richter
-=====-=-=== --=- -=-=-
http://arcgraph.de/sr/

