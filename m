Return-Path: <linux-kernel-owner+w=401wt.eu-S1759103AbZBERtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbZBERtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZBERtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:49:03 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45435 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbZBERtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:49:01 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH] floppy: request only the ports we actually use
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Philippe De Muyter <phdm@macqel.be>,
       Robert Hancock <hancockrwd@gmail.com>, Adam M Belay <abelay@mit.edu>,
       Len Brown <lenb@kernel.org>
Date: Thu, 05 Feb 2009 10:48:59 -0700
Message-ID: <20090205174859.18396.68512.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The floppy driver requests an I/O port it doesn't need, and
sometimes this causes a conflict with a motherboard device
reported by PNPBIOS.

This patch makes the floppy driver request only the ports it
actually uses.

The current floppy driver uses only these ports:
    0x3f2 (FD_DOR)
    0x3f4 (FD_STATUS)
    0x3f5 (FD_DATA)
    0x3f7 (FD_DCR/FD_DIR)
but it requests 0x3f2-0x3f5 and 0x3f7, which includes the
unused port 0x3f3.

Some BIOSes report 0x3f3 as a motherboard resource.  The PNP system
driver reserves that, which causes a conflict when the floppy driver
requests 0x3f2-0x3f5 later.

Philippe reported that this conflict broke the floppy driver between
2.6.11 and 2.6.22.  His PNPBIOS reports these devices:

    $ cat 00:07/id 00:07/resources	# motherboard device
    PNP0c02
    state = active
    io 0x80-0x80
    io 0x10-0x1f
    io 0x22-0x3f
    io 0x44-0x5f
    io 0x90-0x9f
    io 0xa2-0xbf
    io 0x3f0-0x3f1
    io 0x3f3-0x3f3

    $ cat 00:03/id 00:03/resources	# floppy device
    PNP0700
    state = active
    io 0x3f4-0x3f5
    io 0x3f2-0x3f2

Reference:
    http://lkml.org/lkml/2009/1/31/162

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Reported-by: Philippe De Muyter <phdm@macqel.be>
Tested-by: Philippe De Muyter <phdm@macqel.be>
CC: Adam M Belay <abelay@mit.edu>
CC: Robert Hancock <hancockrwd@gmail.com>
---
 drivers/block/floppy.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cf29cc4..44f711b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4399,15 +4399,20 @@ static int floppy_grab_irq_and_dma(void)
 
 	for (fdc = 0; fdc < N_FDC; fdc++) {
 		if (FDCS->address != -1) {
-			if (!request_region(FDCS->address + 2, 4, "floppy")) {
+			if (!request_region(FDCS->address + 2, 1, "floppy")) {
 				DPRINT("Floppy io-port 0x%04lx in use\n",
 				       FDCS->address + 2);
 				goto cleanup1;
 			}
+			if (!request_region(FDCS->address + 4, 2, "floppy")) {
+				DPRINT("Floppy io-port 0x%04lx in use\n",
+				       FDCS->address + 4);
+				goto cleanup2;
+			}
 			if (!request_region(FDCS->address + 7, 1, "floppy DIR")) {
 				DPRINT("Floppy io-port 0x%04lx in use\n",
 				       FDCS->address + 7);
-				goto cleanup2;
+				goto cleanup3;
 			}
 			/* address + 6 is reserved, and may be taken by IDE.
 			 * Unfortunately, Adaptec doesn't know this :-(, */
@@ -4432,13 +4437,16 @@ static int floppy_grab_irq_and_dma(void)
 	fdc = 0;
 	irqdma_allocated = 1;
 	return 0;
+cleanup3:
+	release_region(FDCS->address + 4, 2);
 cleanup2:
-	release_region(FDCS->address + 2, 4);
+	release_region(FDCS->address + 2, 1);
 cleanup1:
 	fd_free_irq();
 	fd_free_dma();
 	while (--fdc >= 0) {
-		release_region(FDCS->address + 2, 4);
+		release_region(FDCS->address + 2, 1);
+		release_region(FDCS->address + 4, 2);
 		release_region(FDCS->address + 7, 1);
 	}
 	spin_lock_irqsave(&floppy_usage_lock, flags);

