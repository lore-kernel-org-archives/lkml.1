Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbXHMEFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbXHMEFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 00:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXHMEFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 00:05:32 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:64525 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXHMEFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 00:05:31 -0400
Date: Mon, 13 Aug 2007 00:05:30 -0400
To: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       <dri-devel@lists.sourceforge.net>
Subject: [PATCH 4 of 5 ] /drivers/char/rio ioremap balancing/ returncode check
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070813040530.9E0E9DA82E@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc2 and this set is an audit of 
/drivers/char/a* 
through drivers/char .   

this corrects missing ioremap return checks and balancing on 
iounmap calls..

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/char/rio/rio_linux.c 
b/drivers/char/rio/rio_linux.c
index 0ce9667..fdaf44f 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -924,6 +924,11 @@ static void fix_rio_pci(struct pci_dev *pdev)
 
 	hwbase = pci_resource_start(pdev, 0);
 	rebase = ioremap(hwbase, 0x80);
+	if (!rebase) {
+		printk(KERN_DEBUG "rio: unable to perform cntrl reg fix as 
ioremap call failed\n");
+		return;
+	}
+		
 	t = readl(rebase + CNTRL_REG_OFFSET);
 	if (t != CNTRL_REG_GOODVALUE) {
 		printk(KERN_DEBUG "rio: performing cntrl reg fix: %08x -> 
%08x\n", t, CNTRL_REG_GOODVALUE);
@@ -996,6 +1001,11 @@ static int __init rio_init(void)
 		if (((1 << hp->Ivec) & rio_irqmask) == 0)
 			hp->Ivec = 0;
 		hp->Caddr = ioremap(p->RIOHosts[p->RIONumHosts].PaddrP, 
RIO_WINDOW_LEN);
+		if (!hp->Caddr) {
+			printk(KERN_ERR "RIO: Unable to ioremap.\n");
+			return -ENOMEM;
+		}
+
 		hp->CardP = (struct DpRam __iomem *) hp->Caddr;
 		hp->Type = RIO_PCI;
 		hp->Copy = rio_copy_to_card;
@@ -1049,6 +1059,10 @@ static int __init rio_init(void)
 			hp->Ivec = 0;
 		hp->Ivec |= 0x8000;	/* Mark as non-sharable */
 		hp->Caddr = ioremap(p->RIOHosts[p->RIONumHosts].PaddrP, 
RIO_WINDOW_LEN);
+		if (!hp->Caddr) {
+			printk(KERN_ERR "RIO: Unable to ioremap.\n");
+			return -ENOMEM;
+		}
 		hp->CardP = (struct DpRam __iomem *) hp->Caddr;
 		hp->Type = RIO_PCI;
 		hp->Copy = rio_copy_to_card;


