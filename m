Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZK0S6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZK0S6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZK0S6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:58:17 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62522 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZK0S6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:58:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=KLWc3V27gAWj7GbqOZCUAw6fkFtsl01vVVMIsXcvOd09kYJCdUS3ZAADdFMrXG9Ca4
         Hze77oMJ2U5d2if3mLoBx8g5uBH+FDQ8Kh+CzRo+3x2cbfcsFcrjLjGf3QD41isAld8H
         OOtUkmmYAGvQGArA4Lm0h8/kcLtLIJ1TmGrvg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] pata_hpt3x2n: add enablebits checking
Date: Fri, 27 Nov 2009 19:55:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911271955.52643.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There shouldn't be any problems with it as IDE hpt366 host driver
has been supporting enablebits checking for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_hpt3x2n.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: b/drivers/ata/pata_hpt3x2n.c
===================================================================
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -153,8 +153,17 @@ static int hpt3x2n_cable_detect(struct a
 
 static int hpt3x2n_pre_reset(struct ata_link *link, unsigned long deadline)
 {
+	static const struct pci_bits hpt37x_enable_bits[] = {
+		{ 0x50, 1, 0x04, 0x04 },
+		{ 0x54, 1, 0x04, 0x04 }
+	};
+
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
+		return -ENOENT;
+
 	/* Reset the state machine */
 	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 	udelay(100);
