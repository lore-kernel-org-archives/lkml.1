Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbZE3STe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbZE3STe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 14:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760986AbZE3STZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 14:19:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33612 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbZE3STY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 14:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=jsgWuny3w2cAW9mnKFvUuKpLNMK3BA6sQqYahDxPgRNlQz+A2hhgt6d2I6lA4avoHZ
         YjKB39+Y1z+s705dyhZyrSAwY3u5/c8kou8MZPDALypD7/6Lq2aqfvUzqKdxOYYEqGTb
         e4WHEVB+ZaoPy1FdwHj0GZEGu2dMYpPQ47mbI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fix
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 30 May 2009 20:24:05 +0200
Message-Id: <200905302024.05719.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix LBA48 and CACHE FLUSH commands support on Netcell ATA RAID
(2.6.28 regression).

[ pata_netcell needs a similar change if anyone is interested ]


Linus, please pull from 'for-linus' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus

to receive the following updates:

 drivers/ide/ide-pci-generic.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)


Bartlomiej Zolnierkiewicz (1):
      ide_pci_generic: add quirk for Netcell ATA RAID


diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
index 61111fd..39d4e01 100644
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -33,6 +33,16 @@ static int ide_generic_all;		/* Set to claim all devices */
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
 MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE storage controllers.");
 
+static void netcell_quirkproc(ide_drive_t *drive)
+{
+	/* mark words 85-87 as valid */
+	drive->id[ATA_ID_CSF_DEFAULT] |= 0x4000;
+}
+
+static const struct ide_port_ops netcell_port_ops = {
+	.quirkproc		= netcell_quirkproc,
+};
+
 #define DECLARE_GENERIC_PCI_DEV(extra_flags) \
 	{ \
 		.name		= DRV_NAME, \
@@ -74,6 +84,7 @@ static const struct ide_port_info generic_chipsets[] __devinitdata = {
 
 	{	/* 6: Revolution */
 		.name		= DRV_NAME,
+		.port_ops	= &netcell_port_ops,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
 				  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,
