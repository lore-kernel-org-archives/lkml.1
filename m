Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYC3TbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYC3TbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYC3Taw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:30:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:29383 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYC3Tau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=gCt0yeN3ZENNhzv8Ektw0wKfSFFH1entajnh5RTJw2HaHNg3ECFVzSMciuMvr+Ev/GqNlEQHyWRAxnKLe+wXkTt6NUAS2fuYI707YjDxr6nGwi532Shq9gX3DC7LWCyjh47OQ74T7RFv+FsJbvb/uZiroTb+lL0lzFNFflFj/HQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/6] scc_pata: add ->{in,out}put_data methods
Date: Sun, 30 Mar 2008 21:41:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803302141.06106.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/scc_pata.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -574,6 +574,36 @@ static int __devinit init_setup_scc(stru
 	return ide_setup_pci_device(dev, d);
 }
 
+static void scc_input_data(ide_drive_t *drive, void *buf, unsigned int len)
+{
+	unsigned long data_addr = drive->hwif->io_ports.data_addr;
+
+	len++;
+
+	if (drive->io_32bit) {
+		scc_ide_insl(data_addr, buf, len / 4);
+
+		if ((len & 3) >= 2)
+			scc_ide_insw(data_addr, (u8 *)buf + (len & ~3), 1);
+	} else
+		scc_ide_insw(data_addr, buf, len / 2);
+}
+
+static void scc_output_data(ide_drive_t *drive, void *buf, unsigned int len)
+{
+	unsigned long data_addr = drive->hwif->io_ports.data_addr;
+
+	len++;
+
+	if (drive->io_32bit) {
+		scc_ide_outsl(data_addr, buf, len / 4);
+
+		if ((len & 3) >= 2)
+			scc_ide_outsw(data_addr, (u8 *)buf + (len & ~3), 1);
+	} else
+		scc_ide_outsw(data_addr, buf, len / 2);
+}
+
 /**
  *	init_mmio_iops_scc	-	set up the iops for MMIO
  *	@hwif: interface to set up
@@ -589,6 +619,9 @@ static void __devinit init_mmio_iops_scc
 
 	ide_set_hwifdata(hwif, ports);
 
+	hwif->input_data  = scc_input_data;
+	hwif->output_data = scc_output_data;
+
 	hwif->INB = scc_ide_inb;
 	hwif->INW = scc_ide_inw;
 	hwif->INSW = scc_ide_insw;
