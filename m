Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbYASPx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbYASPx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbYASPxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:53:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34201 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752912AbYASPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:53:20 -0500
Date: Sat, 19 Jan 2008 15:51:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pata_pdc202xx_old: Fix crashes with ATAPI
Message-ID: <20080119155126.180a010d@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PDC202xx older devices do not support ATAPI DMA via the usual
interfaces. What documentation I have isn't sufficient to support DMA and
it isn't clear if the Windows drivers do this or it is possible at all.
(Neither do the drivers/ide old drivers)

So turn it ATAPI DMA off, these are disk optimised controllers.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/drivers/ata/pata_pdc202xx_old.c linux-2.6.24-rc8-mm1/drivers/ata/pata_pdc202xx_old.c
--- linux.vanilla-2.6.24-rc8-mm1/drivers/ata/pata_pdc202xx_old.c	2008-01-19 14:47:56.000000000 +0000
+++ linux-2.6.24-rc8-mm1/drivers/ata/pata_pdc202xx_old.c	2008-01-19 15:19:25.000000000 +0000
@@ -243,6 +243,24 @@
 	return ata_sff_port_start(ap);
 }
 
+/**
+ *	pdc2026x_check_atapi_dma - Check whether ATAPI DMA can be supported for this command
+ *	@qc: Metadata associated with taskfile to check
+ *
+ *	Just say no - not supported on older Promise.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ *
+ *	RETURNS: 0 when ATAPI DMA can be used
+ *		 1 otherwise
+ */
+
+static int pdc2026x_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	return 1;
+}
+
 static struct scsi_host_template pdc202xx_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -310,6 +328,7 @@
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.cable_detect	= pdc2026x_cable_detect,
 
+	.check_atapi_dma= pdc2026x_check_atapi_dma,
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= pdc2026x_bmdma_start,
 	.bmdma_stop	= pdc2026x_bmdma_stop,
