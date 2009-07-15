Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbZGOXoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbZGOXoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 19:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756511AbZGOXoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 19:44:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46555 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbZGOXoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 19:44:13 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/4] libata: Make it possible for host drivers to flag hotplug ports
Date: Thu, 16 Jul 2009 00:43:57 +0100
Message-Id: <1247701438-18266-3-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1247701438-18266-2-git-send-email-mjg@redhat.com>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
 <1247701438-18266-2-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some libata host drivers may be able to provide hotplug information
on a port by port basis. Add a port operation to allow this to be
done, and ensure that it's called during registration.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/ata/libata-core.c |    4 ++++
 include/linux/libata.h    |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 045a486..e4efd68 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6120,6 +6120,10 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		xfer_mask = ata_pack_xfermask(ap->pio_mask, ap->mwdma_mask,
 					      ap->udma_mask);
 
+		if (ap->ops->is_hotpluggable)
+			ap->scsi_host->hotpluggable =
+				ap->ops->is_hotpluggable(ap);
+
 		if (!ata_port_is_dummy(ap)) {
 			ata_port_printk(ap, KERN_INFO,
 					"%cATA max %s %s\n",
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3d501db..7b1da91 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -814,6 +814,7 @@ struct ata_port_operations {
 	void (*pmp_detach)(struct ata_port *ap);
 	int  (*enable_pm)(struct ata_port *ap, enum link_pm policy);
 	void (*disable_pm)(struct ata_port *ap);
+	int  (*is_hotpluggable)(struct ata_port *ap);
 
 	/*
 	 * Start, stop, suspend and resume
-- 
1.6.2.5

