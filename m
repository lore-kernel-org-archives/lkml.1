Return-Path: <linux-kernel-owner+w=401wt.eu-S1764661AbYF3VrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764661AbYF3VrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933324AbYF3VlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:18 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50412 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933388AbYF3VlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:10 -0400
Message-Id: <20080630214109.617644797@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:28 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 05/16] MMC: Fix S3C24XX IRQ enable during PIO transfers
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-unfinished-write-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Moracik <roman.moravcik@gmail.com> 

Fix Bug #677 - I/O errors on heavy microSD writes for 2.6.22.x.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:19:15.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:19:16.000000000 +0100
@@ -335,6 +335,8 @@ static void pio_tasklet(unsigned long da
 	struct s3cmci_host *host = (struct s3cmci_host *) data;
 
 
+	disable_irq(host->irq);
+
 	if (host->pio_active == XFER_WRITE)
 		do_pio_write(host);
 
@@ -352,9 +354,9 @@ static void pio_tasklet(unsigned long da
 			host->mrq->data->error = -EINVAL;
 		}
 
-		disable_irq(host->irq);
 		finalize_request(host);
-	}
+	} else
+		enable_irq(host->irq);
 }
 
 /*
@@ -630,7 +632,6 @@ out:
 	spin_unlock_irqrestore(&host->complete_lock, iflags);
 	return;
 
-
 fail_request:
 	host->mrq->data->error = -EINVAL;
 	host->complete_what = COMPLETION_FINALIZE;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
