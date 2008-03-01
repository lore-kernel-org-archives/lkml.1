Return-Path: <linux-kernel-owner+w=401wt.eu-S1762366AbYCAUoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762366AbYCAUoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759974AbYCAUni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:28247 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691AbYCAUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=B6Gd/EREkrdrgezh83dST/tQXLBtb7ljmn+Xp7oDRzxgKExGD0Je9EOX33XSJmu2QgnrJKndAr8Bk4MSgN/OCEdjjyug50wEqdxq3e99WLkFvo7CBqaR31vi1OarwWDdmsaFNjIJHylYuWLShDrsqDSR90Sx9uDZbj80AVwGvJ0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/9] ide-generic: manage I/O resources in driver
Date: Sat, 1 Mar 2008 19:47:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803011947.34906.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tell IDE layer to not manage resources by setting hwif->mmio flag.

* Use {request,release}_region() for resources management.

* Use driver name for resources management.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -94,7 +94,24 @@ static int __init ide_generic_init(void)
 		unsigned long io_addr = ide_default_io_base(i);
 		hw_regs_t hw;
 
+		idx[i] = 0xff;
+
 		if (io_addr) {
+			if (!request_region(io_addr, 8, DRV_NAME)) {
+				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
+						"not free.\n",
+						DRV_NAME, io_addr, io_addr + 7);
+				continue;
+			}
+
+			if (!request_region(io_addr + 0x206, 1, DRV_NAME)) {
+				printk(KERN_ERR "%s: I/O resource 0x%lX "
+						"not free.\n",
+						DRV_NAME, io_addr + 0x206);
+				release_region(io_addr, 8);
+				continue;
+			}
+
 			/*
 			 * Skip probing if the corresponding
 			 * slot is already occupied.
@@ -109,10 +126,10 @@ static int __init ide_generic_init(void)
 			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
 			hw.irq = ide_default_irq(io_addr);
 			ide_init_port_hw(hwif, &hw);
+			hwif->mmio = 1;
 
 			idx[i] = i;
-		} else
-			idx[i] = 0xff;
+		}
 	}
 
 	ide_device_add_all(idx, NULL);
