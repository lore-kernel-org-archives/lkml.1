Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYFPOgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYFPOgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYFPOfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:20 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50202 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753913AbYFPOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:14 -0400
Message-Id: <20080616143513.025791459@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:51 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 06/16] MMC: Fix S3C24XX IRQ enable during PIO transfers
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-unfinished-write-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Moracik <roman.moravcik@gmail.com> 

Fix Bug #677 - I/O errors on heavy microSD writes for 2.6.22.x.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-08 13:57:35.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-08 13:57:37.000000000 +0100
@@ -327,6 +327,7 @@ static void pio_tasklet(unsigned long da
 {
 	struct s3cmci_host *host = (struct s3cmci_host *) data;
 
+	disable_irq(host->irq);
 
 	if (host->pio_active == XFER_WRITE)
 		do_pio_write(host);
@@ -345,9 +346,9 @@ static void pio_tasklet(unsigned long da
 			host->mrq->data->error = MMC_ERR_DMA;
 		}
 
-		disable_irq(host->irq);
 		finalize_request(host);
-	}
+	} else
+		enable_irq(host->irq);
 }
 
 /*

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
