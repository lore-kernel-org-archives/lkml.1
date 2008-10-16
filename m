Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbYJPTxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbYJPTxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757817AbYJPTwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:52:38 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:13864 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbYJPTwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=MfS6H7w+KMFJuDySORATkFlx2wBZBAII+xRbKaPSn4ZAL8+2YCOvTmc/DIOWqV3T8A
         ChJng91Y2zXcAqSrVmTFIC63+27T4ua3WfDcopnNl2UFGlOhdD1Iw8hi2XPUMKZnb/DY
         tnwj5TW4QkhjZDCoL6XY0kcWpwPV8pcCPefqQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] delkin_cb: add PM support
Date: Thu, 16 Oct 2008 21:27:39 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, bumble.bee@xs4all.nl,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810162127.40790.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out chipset initialization code from delkin_cb_probe()
  to delkin_cb_init_chipset().

* Assign ->init_chipset in struct delkin_cb_port_info.

* Add delkin_cb_{suspend,resume}() (->suspend/->resume methods).

Fixes kernel bugzilla bug #11735:

http://bugzilla.kernel.org/show_bug.cgi?id=11735

Tested-by: bumble.bee@xs4all.nl
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/delkin_cb.c |   63 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 7 deletions(-)

Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -46,10 +46,27 @@ static const struct ide_port_ops delkin_
 	.quirkproc		= ide_undecoded_slave,
 };
 
+static unsigned int delkin_cb_init_chipset(struct pci_dev *dev)
+{
+	unsigned long base = pci_resource_start(dev, 0);
+	int i;
+
+	outb(0x02, base + 0x1e);	/* set nIEN to block interrupts */
+	inb(base + 0x17);		/* read status to clear interrupts */
+
+	for (i = 0; i < sizeof(setup); ++i) {
+		if (setup[i])
+			outb(setup[i], base + i);
+	}
+
+	return 0;
+}
+
 static const struct ide_port_info delkin_cb_port_info = {
 	.port_ops		= &delkin_cb_port_ops,
 	.host_flags		= IDE_HFLAG_IO_32BIT | IDE_HFLAG_UNMASK_IRQS |
 				  IDE_HFLAG_NO_DMA,
+	.init_chipset		= delkin_cb_init_chipset,
 };
 
 static int __devinit
@@ -57,7 +74,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 {
 	struct ide_host *host;
 	unsigned long base;
-	int i, rc;
+	int rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	rc = pci_enable_device(dev);
@@ -72,12 +89,8 @@ delkin_cb_probe (struct pci_dev *dev, co
 		return rc;
 	}
 	base = pci_resource_start(dev, 0);
-	outb(0x02, base + 0x1e);	/* set nIEN to block interrupts */
-	inb(base + 0x17);		/* read status to clear interrupts */
-	for (i = 0; i < sizeof(setup); ++i) {
-		if (setup[i])
-			outb(setup[i], base + i);
-	}
+
+	delkin_cb_init_chipset(dev);
 
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base + 0x10, base + 0x1e);
@@ -110,6 +123,40 @@ delkin_cb_remove (struct pci_dev *dev)
 	pci_disable_device(dev);
 }
 
+#ifdef CONFIG_PM
+static int delkin_cb_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	pci_save_state(dev);
+	pci_disable_device(dev);
+	pci_set_power_state(dev, pci_choose_state(dev, state));
+
+	return 0;
+}
+
+static int delkin_cb_resume(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	int rc;
+
+	pci_set_power_state(dev, PCI_D0);
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
+
+	pci_restore_state(dev);
+	pci_set_master(dev);
+
+	if (host->init_chipset)
+		host->init_chipset(dev);
+
+	return 0;
+}
+#else
+#define delkin_cb_suspend NULL
+#define delkin_cb_resume NULL
+#endif
+
 static struct pci_device_id delkin_cb_pci_tbl[] __devinitdata = {
 	{ 0x1145, 0xf021, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ 0x1145, 0xf024, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
@@ -122,6 +169,8 @@ static struct pci_driver delkin_cb_pci_d
 	.id_table	= delkin_cb_pci_tbl,
 	.probe		= delkin_cb_probe,
 	.remove		= delkin_cb_remove,
+	.suspend	= delkin_cb_suspend,
+	.resume		= delkin_cb_resume,
 };
 
 static int __init delkin_cb_init(void)
