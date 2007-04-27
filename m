Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbXD0WK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbXD0WK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbXD0WK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:10:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54553 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757487AbXD0WKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:10:06 -0400
Date: Fri, 27 Apr 2007 23:13:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: rct@gherkin.frus.com (Bob Tracy)
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: BAD_SG_DMA panic in aha1542
Message-ID: <20070427231346.647797bc@the-village.bc.nu>
In-Reply-To: <20070427214709.DC44BDBA2@gherkin.frus.com>
References: <20070427214709.DC44BDBA2@gherkin.frus.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As before, no problems using the sda hard disk (which is the boot drive):
> everything works reliably until I touch the cdrom drive.

A little quiet contemplation and gnome number 387 suggests trying the following
(and providing more detailed information such as the last message printed before
the DMA message). Stuff a BUG() before the panic in BAD_DMA (aha1542.c) if needed
to get a good trace.

Please report success/failure/change.

--- drivers/scsi/sr_ioctl.c~	2007-04-27 22:53:33.885035256 +0100
+++ drivers/scsi/sr_ioctl.c	2007-04-27 22:53:33.885035256 +0100
@@ -187,9 +187,10 @@
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
 	struct request_sense *sense = cgc->sense;
-
+	void *zebedee = cgc->buffer;
+	
 	SDev = cd->device;
-
+	
 	if (!sense) {
 		sense = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
 		if (!sense) {
@@ -197,7 +198,22 @@
 			goto out;
 		}
 	}
-
+	
+	if (cgc->buflen && cd->device->host->unchecked_isa_dma) {
+		switch(cgc->data_direction) {
+			case DMA_NONE:
+				break;
+			case DMA_FROM_DEVICE:
+			case DMA_TO_DEVICE: /* Boing!!!! said Zebedee */
+				zebedee = kmalloc(cgc->buflen, GFP_KERNEL|GFP_DMA);
+				if (zebedee ==NULL) {
+					err = -ENOMEM;
+					goto out;
+				}
+		}
+		if (cgc->data_direction == DMA_TO_DEVICE)
+			memcpy(zebedee, cgc->buffer, cgc->buflen);
+	}
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
 		err = -ENODEV;
@@ -206,10 +222,13 @@
 
 	memset(sense, 0, sizeof(*sense));
 	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, (char *)sense,
+			      zebedee, cgc->buflen, (char *)sense,
 			      cgc->timeout, IOCTL_RETRIES, 0);
 
 	scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
+	
+	if (zebedeee != cgc->buffer && cgc->data_direction == DMA_FROM_DEVICE)
+		memcpy(cgc->buffer, zebedee, cgc->buflen);
 
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (driver_byte(result) != 0) {
