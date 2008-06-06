Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbYFFPzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbYFFPzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbYFFPz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:29 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51776 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756127AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155525.495951151@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:22 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 05/15] MMC: Fix S3C24XX IRQ enable during PIO transfers From: Roman Moracik <roman.moravcik@gmail.com>
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-unfinished-write-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix Bug #677 - I/O errors on heavy microSD writes for 2.6.22.x.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:01.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:03.000000000 +0100
@@ -313,6 +313,7 @@ static void pio_tasklet(unsigned long da
 {
 	struct s3cmci_host *host = (struct s3cmci_host *) data;
 
+	disable_irq(host->irq);
 
 	if (host->pio_active == XFER_WRITE)
 		do_pio_write(host);
@@ -331,9 +332,9 @@ static void pio_tasklet(unsigned long da
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
