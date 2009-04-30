Return-Path: <linux-kernel-owner+w=401wt.eu-S1764742AbZD3RZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764742AbZD3RZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764629AbZD3RH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:56 -0400
Received: from kroah.org ([198.145.64.141]:56378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764614AbZD3RHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:44 2009
Message-Id: <20090430165744.294049024@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:29 -0700
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
       alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jeff Garzik <jgarzik@redhat.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 40/88] pata_hpt37x: fix HPT370 DMA timeouts
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0070-pata_hpt37x-fix-HPT370-DMA-timeouts.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

upstream commit: 265b7215aed36941620b65ecfff516200fb190c1

The libata driver has copied the code from the IDE driver which caused a post
2.4.18 regression on many HPT370[A] chips -- DMA stopped to work completely,
only causing timeouts.  Now remove hpt370_bmdma_start() for good...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ata/pata_hpt37x.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -8,7 +8,7 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
  *
  * TODO
  *	Look into engine reset on timeout errors. Should not be	required.
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.11"
+#define DRV_VERSION	"0.6.12"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -445,23 +445,6 @@ static void hpt370_set_dmamode(struct at
 }
 
 /**
- *	hpt370_bmdma_start		-	DMA engine begin
- *	@qc: ATA command
- *
- *	The 370 and 370A want us to reset the DMA engine each time we
- *	use it. The 372 and later are fine.
- */
-
-static void hpt370_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
-	udelay(10);
-	ata_bmdma_start(qc);
-}
-
-/**
  *	hpt370_bmdma_end		-	DMA engine stop
  *	@qc: ATA command
  *
@@ -598,7 +581,6 @@ static struct scsi_host_template hpt37x_
 static struct ata_port_operations hpt370_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
-	.bmdma_start 	= hpt370_bmdma_start,
 	.bmdma_stop	= hpt370_bmdma_stop,
 
 	.mode_filter	= hpt370_filter,


