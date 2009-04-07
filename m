Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZDGXXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZDGXXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbZDGXWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:22:49 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45857 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbZDGXWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:22:48 -0400
Date: Tue, 7 Apr 2009 19:22:47 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, d.harrison@sutus.com,
       sagar.borikar@gmail.com
Subject: [PATCH 1/2] libata EH: freeze port before aborting commands
Message-ID: <20090407232247.GA16086@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 9c2fd3d1955572d3d1ee596b5f81c9768dde896e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Apr 7 19:13:15 2009 -0400

    [libata] EH: freeze port before aborting commands
    
    Call the ->freeze() hook before aborting qc's, because some hardware
    requires special handling prior to accessing the taskfile registers
    (for diagnosis/analysis/reset).  Most notably, hardware may wish to
    disable the DMA engine or interrupts in the ->freeze() hook.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

---
Alan, we should create ata_sff_bmdma_freeze() and use that to turn off
the PCI IDE BMDMA engine in ->freeze(), too, I think...


diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0183131..b79cbd6 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -999,7 +999,9 @@ static void __ata_port_freeze(struct ata_port *ap)
  *	ata_port_freeze - abort & freeze port
  *	@ap: ATA port to freeze
  *
- *	Abort and freeze @ap.
+ *	Abort and freeze @ap.  The freeze operation must be called
+ *	first, because some hardware requires special operations
+ *	before the taskfile registers are accessible.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -1013,8 +1015,8 @@ int ata_port_freeze(struct ata_port *ap)
 
 	WARN_ON(!ap->ops->error_handler);
 
-	nr_aborted = ata_port_abort(ap);
 	__ata_port_freeze(ap);
+	nr_aborted = ata_port_abort(ap);
 
 	return nr_aborted;
 }
