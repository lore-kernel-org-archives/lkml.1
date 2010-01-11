Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459Ab0AKBNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0AKBNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079Ab0AKBNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:13:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:45368 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0AKBNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:13:54 -0500
Message-ID: <4B4A7BC7.6060106@kernel.org>
Date: Mon, 11 Jan 2010 10:15:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: MSI broken in libata?
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>	 <4B484829.6060405@kernel.org> <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>
In-Reply-To: <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080004010404040205070605"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Jan 2010 01:13:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080004010404040205070605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 01/10/2010 01:33 PM, Torsten Kaiser wrote:
> I did try the patch from Robert Hancock in
> http://lkml.org/lkml/2010/1/6/417 ,but without success.
> 
> if you need any more information, or have something for me to try,
> please just ask. I did look at the code and the documentation about
> enabling MSI, but did not see anything (obvious) wrong, so I don't
> know what to try next.

Can you please try the attached patch?

Thanks.

-- 
tejun

--------------080004010404040205070605
Content-Type: text/x-patch;
 name="sil24-msi-possible-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sil24-msi-possible-fix.patch"

diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 1370df6..b03bc5b 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -102,6 +102,7 @@ enum {
 	HOST_CTRL_STOP		= (1 << 18), /* latched PCI STOP */
 	HOST_CTRL_DEVSEL	= (1 << 19), /* latched PCI DEVSEL */
 	HOST_CTRL_REQ64		= (1 << 20), /* latched PCI REQ64 */
+	HOST_CTRL_MSIACK        = (1 << 30), /* MSI acknowledge */
 	HOST_CTRL_GLOBAL_RST	= (1 << 31), /* global reset */
 
 	/*
@@ -248,6 +249,7 @@ enum {
 				  ATA_FLAG_NCQ | ATA_FLAG_ACPI_SATA |
 				  ATA_FLAG_AN | ATA_FLAG_PMP,
 	SIL24_FLAG_PCIX_IRQ_WOC	= (1 << 24), /* IRQ loss errata on PCI-X */
+	SIL24_FLAG_MSI		= (1 << 25), /* MSI enabled */
 
 	IRQ_STAT_4PORTS		= 0xf,
 };
@@ -1144,18 +1146,22 @@ static irqreturn_t sil24_interrupt(int irq, void *dev_instance)
 	u32 status;
 	int i;
 
+	spin_lock(&host->lock);
+
+	if (host->ports[0]->flags & SIL24_FLAG_MSI)
+		writel(IRQ_STAT_4PORTS | HOST_CTRL_MSIACK,
+		       host_base + HOST_CTRL);
+
 	status = readl(host_base + HOST_IRQ_STAT);
 
 	if (status == 0xffffffff) {
 		printk(KERN_ERR DRV_NAME ": IRQ status == 0xffffffff, "
 		       "PCI fault or device removal?\n");
-		goto out;
+		goto out_unlock;
 	}
 
 	if (!(status & IRQ_STAT_4PORTS))
-		goto out;
-
-	spin_lock(&host->lock);
+		goto out_unlock;
 
 	for (i = 0; i < host->n_ports; i++)
 		if (status & (1 << i)) {
@@ -1168,8 +1174,8 @@ static irqreturn_t sil24_interrupt(int irq, void *dev_instance)
 				       ": interrupt from disabled port %d\n", i);
 		}
 
+ out_unlock:
 	spin_unlock(&host->lock);
- out:
 	return IRQ_RETVAL(handled);
 }
 
@@ -1347,6 +1353,7 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (sata_sil24_msi && !pci_enable_msi(pdev)) {
 		dev_printk(KERN_INFO, &pdev->dev, "Using MSI\n");
 		pci_intx(pdev, 0);
+		host->ports[0]->flags |= SIL24_FLAG_MSI;
 	}
 
 	pci_set_master(pdev);

--------------080004010404040205070605--
