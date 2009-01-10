Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbZAJANG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbZAJANG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZAJAMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:12:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:35570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZAJAMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:12:52 -0500
Date: Fri, 9 Jan 2009 16:14:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jgarzik@pobox.net
Subject: libata: make parallel port scan a per-host opt-in feature
Message-ID: <20090109161455.08d5a54c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 17f458c7d9d7a25a04d448aef22b134135857018 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 9 Jan 2009 15:54:07 -0800
Subject: [PATCH] libata: Add a per-host flag to opt-in into parallel port probes

This patch adds a per host flag that allows drivers to opt in into
having its busses scanned in parallel.

Drivers that do not set this flag get their ports scanned in
the "original" sequence.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/ata/ahci.c        |    3 +++
 drivers/ata/libata-core.c |    9 +++++++++
 include/linux/libata.h    |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7f701cb..1fc2d4b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2660,6 +2660,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	host->iomap = pcim_iomap_table(pdev);
 	host->private_data = hpriv;
 
+	if (!hpriv->cap & HOST_CAP_SSS)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+
 	if (pi.flags & ATA_FLAG_EM)
 		ahci_reset_em(host);
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c507a9a..31c0f22 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5920,6 +5920,15 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 {
 	int rc;
 	struct ata_port *ap = data;
+
+	/*
+	 * If we're not allowed to scan this host in parallel,
+	 * we need to wait until all previous scans have completed
+	 * before going further.
+	 */
+	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN))
+		async_synchronize_cookie(cookie);
+	
 	/* probe */
 	if (ap->ops->error_handler) {
 		struct ata_eh_info *ehi = &ap->link.eh_info;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4f7c8fb..b6b8a7f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -239,6 +239,7 @@ enum {
 	/* host set flags */
 	ATA_HOST_SIMPLEX	= (1 << 0),	/* Host is simplex, one DMA channel per host only */
 	ATA_HOST_STARTED	= (1 << 1),	/* Host started */
+	ATA_HOST_PARALLEL_SCAN	= (1 << 2),	/* Ports on this host can be scanned in parallel */
 
 	/* bits 24:31 of host->flags are reserved for LLD specific flags */
 
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
