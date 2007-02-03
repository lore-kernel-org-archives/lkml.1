Return-Path: <linux-kernel-owner+w=401wt.eu-S1946277AbXBCCl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946277AbXBCCl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946271AbXBCCla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:41:30 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53291 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946275AbXBCCju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:39:50 -0500
Message-Id: <20070203024425.669639000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:46 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 42/59] libata: use kmap_atomic(KM_IRQ0) in SCSI simulator
Content-Disposition: inline; filename=use-kmap_atomic-in-scsi-simulator.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Jeff Garzik <jeff@garzik.org>

We are inside spin_lock_irqsave().  quoth akpm's debug facility:

 [  231.948000] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
 [  232.232000] ata1.00: configured for UDMA/33
 [  232.404000] WARNING (1) at arch/i386/mm/highmem.c:47 kmap_atomic()
 [  232.404000]  [<c01162e6>] kmap_atomic+0xa9/0x1ab
 [  232.404000]  [<c0242c81>] ata_scsi_rbuf_get+0x1c/0x30
 [  232.404000]  [<c0242caf>] ata_scsi_rbuf_fill+0x1a/0x87
 [  232.404000]  [<c0243ab2>] ata_scsiop_mode_sense+0x0/0x309
 [  232.404000]  [<c01729d5>] end_bio_bh_io_sync+0x0/0x37
 [  232.404000]  [<c02311c6>] scsi_done+0x0/0x16
 [  232.404000]  [<c02311c6>] scsi_done+0x0/0x16
 [  232.404000]  [<c0242dcc>] ata_scsi_simulate+0xb0/0x13f
[...]

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/ata/libata-scsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/drivers/ata/libata-scsi.c
+++ linux-2.6.19.2/drivers/ata/libata-scsi.c
@@ -1648,7 +1648,7 @@ static unsigned int ata_scsi_rbuf_get(st
 		struct scatterlist *sg;
 
 		sg = (struct scatterlist *) cmd->request_buffer;
-		buf = kmap_atomic(sg->page, KM_USER0) + sg->offset;
+		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 		buflen = sg->length;
 	} else {
 		buf = cmd->request_buffer;
@@ -1676,7 +1676,7 @@ static inline void ata_scsi_rbuf_put(str
 		struct scatterlist *sg;
 
 		sg = (struct scatterlist *) cmd->request_buffer;
-		kunmap_atomic(buf - sg->offset, KM_USER0);
+		kunmap_atomic(buf - sg->offset, KM_IRQ0);
 	}
 }
 

--
