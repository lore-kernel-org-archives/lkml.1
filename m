Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbXHWDba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbXHWDba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbXHWDbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:31:23 -0400
Received: from n6a.bullet.mail.re3.yahoo.com ([68.142.236.44]:33002 "HELO
	n6a.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756179AbXHWDbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:31:22 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 958066.46453.bm@rrr2.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fd1tesO/oMfXZdJb2fpf122N5fnP9Frh7bYNcbTj63qO0Q5NjYdJ+wBXDvsy3PTAe1KvKL+UJPjovUjLWpUDCf4RDzyLxmHqI0WhzsJDGNigmTGeotlv1HHhpxWuVtxlyH4hfqz0GxHGOEhqX0xWr8TS4rcOz8MoqU1RCDFoSWA=;
Date: Wed, 22 Aug 2007 20:31:00 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH 4 of 5 resend] /drivers/char/rio ioremap balancing/ returncode check
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <830283.28023.qm@web44902.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc3.  
corrects missing ioremap return checks and balancing on iounmap calls, integrated changes per list
recommendations on the original set of patches..

patch 4 --> rio_linux.c adds an int rc to the void fix_rio_pci which is then checked.  early
returns for ioremap fails also required a misc_deregister call.

Note -- this mail client will probably wrap first couple lines of (1013,7 +1026,12 @@ static int
__init rio_init(void) ) patch which, by my counts, runs to 221 columns.  Not sure what to do about
that, will post something seperate to lists for ideas...  

Warning -- cleanup handler here may miss additional required cleanup as has occurred on other
portions of ioremap audit.

This patch had been submitted previously but hushmail client caused wordwrap issues, resending
with different mail client.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------

diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 0ce9667..242e5fb 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -913,7 +913,7 @@ static void __exit rio_release_drivers(void)
    EEprom.  As the bit is read/write for the CPU, we can fix it here,
    if we detect that it isn't set correctly. -- REW */
 
-static void fix_rio_pci(struct pci_dev *pdev)
+static int fix_rio_pci(struct pci_dev *pdev)
 {
 	unsigned long hwbase;
 	unsigned char __iomem *rebase;
@@ -924,12 +924,19 @@ static void fix_rio_pci(struct pci_dev *pdev)
 
 	hwbase = pci_resource_start(pdev, 0);
 	rebase = ioremap(hwbase, 0x80);
+	if (!rebase) {
+		printk(KERN_ERR "rio: unable to perform cntrl reg fix"
+				  " as ioremap call failed\n");
+		return -ENOMEM;
+	}
+		
 	t = readl(rebase + CNTRL_REG_OFFSET);
 	if (t != CNTRL_REG_GOODVALUE) {
 		printk(KERN_DEBUG "rio: performing cntrl reg fix: %08x -> %08x\n", t, CNTRL_REG_GOODVALUE);
 		writel(CNTRL_REG_GOODVALUE, rebase + CNTRL_REG_OFFSET);
 	}
 	iounmap(rebase);
+ 	return 0;
 }
 #endif
 
@@ -996,6 +1003,12 @@ static int __init rio_init(void)
 		if (((1 << hp->Ivec) & rio_irqmask) == 0)
 			hp->Ivec = 0;
 		hp->Caddr = ioremap(p->RIOHosts[p->RIONumHosts].PaddrP, RIO_WINDOW_LEN);
+		if (!hp->Caddr) {
+			printk(KERN_ERR "RIO: Unable to ioremap.\n");
+			misc_deregister(&rio_fw_device);
+			return -ENOMEM;
+		}
+
 		hp->CardP = (struct DpRam __iomem *) hp->Caddr;
 		hp->Type = RIO_PCI;
 		hp->Copy = rio_copy_to_card;
@@ -1013,7 +1026,12 @@ static int __init rio_init(void)
 			    ((readb(&p->RIOHosts[p->RIONumHosts].Unique[1]) & 0xFF) << 8) |
((readb(&p->RIOHosts[p->RIONumHosts].Unique[2]) & 0xFF) << 16) |
((readb(&p->RIOHosts[p->RIONumHosts].Unique[3]) & 0xFF) << 24);
 			rio_dprintk(RIO_DEBUG_PROBE, "Hmm Tested ok, uniqid = %x.\n",
p->RIOHosts[p->RIONumHosts].UniqueNum);
 
-			fix_rio_pci(pdev);
+			if (fix_rio_pci(pdev)){
+				misc_deregister(&rio_fw_device);
+				iounmap(hp->Caddr);
+				return -ENOMEM;
+
+			}
 
 			p->RIOHosts[p->RIONumHosts].pdev = pdev;
 			pci_dev_get(pdev);
@@ -1049,6 +1067,11 @@ static int __init rio_init(void)
 			hp->Ivec = 0;
 		hp->Ivec |= 0x8000;	/* Mark as non-sharable */
 		hp->Caddr = ioremap(p->RIOHosts[p->RIONumHosts].PaddrP, RIO_WINDOW_LEN);
+		if (!hp->Caddr) {
+			printk(KERN_ERR "RIO: Unable to ioremap.\n");
+			misc_deregister(&rio_fw_device);
+			return -ENOMEM;
+		}
 		hp->CardP = (struct DpRam __iomem *) hp->Caddr;
 		hp->Type = RIO_PCI;
 		hp->Copy = rio_copy_to_card;


       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers -
Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433


       
____________________________________________________________________________________
Boardwalk for $500? In 2007? Ha! Play Monopoly Here and Now (it's updated for today's economy) at Yahoo! Games.
http://get.games.yahoo.com/proddesc?gamekey=monopolyherenow  

