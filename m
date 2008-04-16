Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYDPW2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYDPW2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbYDPW2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:28:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:16348 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbYDPW16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=fypTELq+gRKauINkO1SvoyHntKZTbX7vsOvxcFFQ4TktfMMJsqgfBUXQhobRunUbtMo8NVD3cjX362HMbeiFrrs7GAVr0LiqAgATqD6owrQFKlIATo4MtNTYQm3kxoeaK+b4aPyTOu06pAPXnvm5wyaGLZz1n2qSiPkZP2mFt1g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] scc_pata: add ->{in,out}put_data methods (take 2)
Date: Thu, 17 Apr 2008 00:09:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Kou Ishizaki <kou.ishizaki@toshiba.co.jp>,
       Akira Iguchi <akira2.iguchi@toshiba.co.jp>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804170009.39454.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2:

* Update ->{in,out}_data methods to take 'struct request *rq' argument
  (thanks to Stephen Rothwell for catching it).

There should be no functional changes caused by this patch.

Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Cc: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch for the one in the IDE tree

 drivers/ide/pci/scc_pata.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -612,6 +612,38 @@ static int __devinit init_setup_scc(stru
 	return rc;
 }
 
+static void scc_input_data(ide_drive_t *drive, struct request *rq,
+			   void *buf, unsigned int len)
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
+static void scc_output_data(ide_drive_t *drive,  struct request *rq,
+			    void *buf, unsigned int len)
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
@@ -626,6 +658,9 @@ static void __devinit init_mmio_iops_scc
 
 	ide_set_hwifdata(hwif, ports);
 
+	hwif->input_data  = scc_input_data;
+	hwif->output_data = scc_output_data;
+
 	hwif->INB = scc_ide_inb;
 	hwif->INW = scc_ide_inw;
 	hwif->INSW = scc_ide_insw;
