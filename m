Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZBJTIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZBJTIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZBJTDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:40 -0500
Received: from kroah.org ([198.145.64.141]:53737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755345AbZBJTDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:39 -0500
Date: Tue, 10 Feb 2009 11:00:07 -0800
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
       alan@lxorguk.ukuu.org.uk, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 14/53] firewire: sbp2: fix DMA mapping leak on the failure
	path
Message-ID: <20090210190007.GO14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-sbp2-fix-dma-mapping-leak-on-the-failure-path.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Commit 5e2125677fd72d36396cc537466e07ffcbbd4b2b upstream.

Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
who also provided a first version of the fix.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-sbp2.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1282,6 +1282,19 @@ static struct fw_driver sbp2_driver = {
 	.id_table = sbp2_id_table,
 };
 
+static void sbp2_unmap_scatterlist(struct device *card_device,
+				   struct sbp2_command_orb *orb)
+{
+	if (scsi_sg_count(orb->cmd))
+		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
+			     scsi_sg_count(orb->cmd),
+			     orb->cmd->sc_data_direction);
+
+	if (orb->request.misc & cpu_to_be32(COMMAND_ORB_PAGE_TABLE_PRESENT))
+		dma_unmap_single(card_device, orb->page_table_bus,
+				 sizeof(orb->page_table), DMA_TO_DEVICE);
+}
+
 static unsigned int
 sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
 {
@@ -1361,15 +1374,7 @@ complete_command_orb(struct sbp2_orb *ba
 
 	dma_unmap_single(device->card->device, orb->base.request_bus,
 			 sizeof(orb->request), DMA_TO_DEVICE);
-
-	if (scsi_sg_count(orb->cmd) > 0)
-		dma_unmap_sg(device->card->device, scsi_sglist(orb->cmd),
-			     scsi_sg_count(orb->cmd),
-			     orb->cmd->sc_data_direction);
-
-	if (orb->page_table_bus != 0)
-		dma_unmap_single(device->card->device, orb->page_table_bus,
-				 sizeof(orb->page_table), DMA_TO_DEVICE);
+	sbp2_unmap_scatterlist(device->card->device, orb);
 
 	orb->cmd->result = result;
 	orb->done(orb->cmd);
@@ -1500,8 +1505,10 @@ static int sbp2_scsi_queuecommand(struct
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
-	if (dma_mapping_error(device->card->device, orb->base.request_bus))
+	if (dma_mapping_error(device->card->device, orb->base.request_bus)) {
+		sbp2_unmap_scatterlist(device->card->device, orb);
 		goto out;
+	}
 
 	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, generation,
 		      lu->command_block_agent_address + SBP2_ORB_POINTER);

