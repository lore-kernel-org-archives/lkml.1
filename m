Return-Path: <linux-kernel-owner+w=401wt.eu-S1422965AbXCGRy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422965AbXCGRy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422769AbXCGRy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:54:28 -0500
Received: from ns.suse.de ([195.135.220.2]:43568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422780AbXCGROK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:10 -0500
Message-Id: <20070307171232.790343072@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, David Moore <dcm@acm.org>
Subject: [patch 023/101] ieee1394: video1394: DMA fix
Content-Disposition: inline; filename=ieee1394-video1394-dma-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Moore <dcm@acm.org>

This together with the phys_to_virt fix in lib/swiotlb.c::swiotlb_sync_sg
fixes video1394 DMA on machines with DMA bounce buffers, especially Intel
x86-64 machines with > 3GB RAM.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: David Moore <dcm@acm.org>
Tested-by: Nicolas Turro <Nicolas.Turro@inrialpes.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ieee1394/video1394.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.20.1.orig/drivers/ieee1394/video1394.c
+++ linux-2.6.20.1/drivers/ieee1394/video1394.c
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
