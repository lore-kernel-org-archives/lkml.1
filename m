Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbXFCX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbXFCX3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXFCX3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 19:29:10 -0400
Received: from lixom.net ([66.141.50.11]:35244 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXFCX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 19:29:10 -0400
Date: Sun, 3 Jun 2007 18:35:10 -0500
To: jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] [2.6.22] libata: fix probe time irq printouts
Message-ID: <20070603233510.GA25750@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most drivers don't seem to fill out the host->irq field, resulting in the
wrong (no) irq being reported at probe time. For example, sil24 on my system:

ata1: SATA max UDMA/100 cmd 0xd00008009001f000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata2: SATA max UDMA/100 cmd 0xd000080090021000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0

Since they're allocated and set up in ata_host_activate(), just save
them away there.


Signed-off-by: Olof Johansson <olof@lixom.net>


diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index af62514..7491b11 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6438,6 +6438,9 @@ int ata_host_activate(struct ata_host *host, int irq,
 	if (rc)
 		devm_free_irq(host->dev, irq, host);
 
+	/* Used to print device info at probe */
+	host->irq = irq;
+
 	return rc;
 }
 
