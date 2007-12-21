Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbXLUEsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbXLUEsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 23:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXLUEsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 23:48:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:48876 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXLUEsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 23:48:15 -0500
Subject: Re: [PATCH 3/3] pci: Remove pci_enable_device_bars()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, Alan Cox <alan@redhat.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071221042855.GF25341@kroah.com>
References: <20071220042812.706D0DDEE7@ozlabs.org>
	 <20071221042855.GF25341@kroah.com>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 15:47:28 +1100
Message-Id: <1198212448.6779.45.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci: Remove pci_enable_device_bars() fix for qla

The previous patch missed one occurence of pci_enable_device_bars()
in the qla2xxx driver. This fixes it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-merge/drivers/scsi/qla2xxx/qla_def.h
===================================================================
--- linux-merge.orig/drivers/scsi/qla2xxx/qla_def.h	2007-12-21 15:45:41.000000000 +1100
+++ linux-merge/drivers/scsi/qla2xxx/qla_def.h	2007-12-21 15:46:12.000000000 +1100
@@ -2272,6 +2272,7 @@ typedef struct scsi_qla_host {
 	spinlock_t		hardware_lock ____cacheline_aligned;
 
 	int		bars;
+	int		mem_only;
 	device_reg_t __iomem *iobase;		/* Base I/O address */
 	unsigned long	pio_address;
 	unsigned long	pio_length;
Index: linux-merge/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- linux-merge.orig/drivers/scsi/qla2xxx/qla_os.c	2007-12-21 15:46:10.000000000 +1100
+++ linux-merge/drivers/scsi/qla2xxx/qla_os.c	2007-12-21 15:46:12.000000000 +1100
@@ -1626,6 +1626,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	sprintf(ha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, ha->host_no);
 	ha->parent = NULL;
 	ha->bars = bars;
+	ha->mem_only = mem_only;
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
@@ -2905,8 +2906,14 @@ qla2xxx_pci_slot_reset(struct pci_dev *p
 {
 	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
 	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	int rc;
 
-	if (pci_enable_device_bars(pdev, ha->bars)) {
+	if (ha->mem_only)
+		rc = pci_enable_device_mem(pdev);
+	else
+		rc = pci_enable_device(pdev);
+
+	if (rc) {
 		qla_printk(KERN_WARNING, ha,
 		    "Can't re-enable PCI device after reset.\n");
 


