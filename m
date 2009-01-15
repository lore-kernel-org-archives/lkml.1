Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbZAOUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbZAOUId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765867AbZAOUAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:34 -0500
Received: from kroah.org ([198.145.64.141]:48827 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763716AbZAOUA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:26 -0500
Date: Thu, 15 Jan 2009 11:57:41 -0800
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
       alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 13/94] SCSI: eata: fix the data buffer accessors conversion
	regression
Message-ID: <20090115195741.GM14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-eata-fix-the-data-buffer-accessors-conversion-regression.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 20c09df7eb9c92a40e0ecf654b6e8f14c8583b9e upstream.

This fixes the regression introduced by the commit
58e2a02eb18393e76a469580fedf7caec190eb5e (eata: convert to use the
data buffer accessors), reported:

http://marc.info/?t=122987621300006&r=1&w=2

- fix DMA_NONE handling in map_dma()

- this driver can't use scsi_dma_map since host->shost_gendev.parent
is not set properly (it uses scsi_register).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/eata.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1626,8 +1626,15 @@ static void map_dma(unsigned int i, stru
 
 	cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
-	count = scsi_dma_map(SCpnt);
-	BUG_ON(count < 0);
+	if (!scsi_sg_count(SCpnt)) {
+		cpp->data_len = 0;
+		return;
+	}
+
+	count = pci_map_sg(ha->pdev, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			   pci_dir);
+	BUG_ON(!count);
+
 	scsi_for_each_sg(SCpnt, sg, count, k) {
 		cpp->sglist[k].address = H2DEV(sg_dma_address(sg));
 		cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(sg));
@@ -1655,7 +1662,9 @@ static void unmap_dma(unsigned int i, st
 		pci_unmap_single(ha->pdev, DEV2H(cpp->sense_addr),
 				 DEV2H(cpp->sense_len), PCI_DMA_FROMDEVICE);
 
-	scsi_dma_unmap(SCpnt);
+	if (scsi_sg_count(SCpnt))
+		pci_unmap_sg(ha->pdev, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			     pci_dir);
 
 	if (!DEV2H(cpp->data_len))
 		pci_dir = PCI_DMA_BIDIRECTIONAL;

