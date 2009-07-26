Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbZGYOKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbZGYOKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZGYOKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:10:36 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60599 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZGYOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=cCWo6YhBGnxZF8E7ePN74OvFbh8iVrkjhW3lKkhmxyjsg9YbKi46I15KW0jYP5UqNS
         52lQDTG7dTsHgq2sNnYzaJyxTySe50Sc0RbQU4NzQCAjdqTTc5UuInrADTTzi34FdFfF
         nuwvVzrXV6SxBiYkKdlYpBUSkNdU9PUjIpUYE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: jgarzik@pobox.com
Subject: [PATCH] libata: remove superfluous NULL pointer checks
Date: Sun, 26 Jul 2009 16:05:13 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090723-04314-g011b7b2-dirty; KDE/4.2.4; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907261605.14619.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: remove superfluous NULL pointer checks

host->ports[] always contain pointers to valid port structures since
a "dummy port" structure is used in case if there is no physical port.

This patch takes care of two entries from Dan's list:

drivers/ata/sata_sil.c +535 sil_interrupt(13) warning: variable derefenced before check 'ap'
drivers/ata/sata_mv.c +2517 mv_unexpected_intr(6) warning: variable derefenced before check 'ap'

and of another needless NULL pointer check in pata_octeon_cf.c.

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_octeon_cf.c |    3 ++-
 drivers/ata/sata_mv.c        |    2 +-
 drivers/ata/sata_sil.c       |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/ata/pata_octeon_cf.c
===================================================================
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -653,7 +653,8 @@ static irqreturn_t octeon_cf_interrupt(i
 
 		ap = host->ports[i];
 		ocd = ap->dev->platform_data;
-		if (!ap || (ap->flags & ATA_FLAG_DISABLED))
+
+		if (ap->flags & ATA_FLAG_DISABLED)
 			continue;
 
 		ocd = ap->dev->platform_data;
Index: b/drivers/ata/sata_mv.c
===================================================================
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2514,7 +2514,7 @@ static void mv_unexpected_intr(struct at
 	char *when = "idle";
 
 	ata_ehi_clear_desc(ehi);
-	if (!ap || (ap->flags & ATA_FLAG_DISABLED)) {
+	if (ap->flags & ATA_FLAG_DISABLED) {
 		when = "disabled";
 	} else if (edma_was_enabled) {
 		when = "EDMA enabled";
Index: b/drivers/ata/sata_sil.c
===================================================================
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -532,7 +532,7 @@ static irqreturn_t sil_interrupt(int irq
 		struct ata_port *ap = host->ports[i];
 		u32 bmdma2 = readl(mmio_base + sil_port[ap->port_no].bmdma2);
 
-		if (unlikely(!ap || ap->flags & ATA_FLAG_DISABLED))
+		if (unlikely(ap->flags & ATA_FLAG_DISABLED))
 			continue;
 
 		/* turn off SATA_IRQ if not supported */
