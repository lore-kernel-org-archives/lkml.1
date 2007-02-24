Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbXBXGZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbXBXGZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 01:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXBXGZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 01:25:12 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:31087 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXBXGZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 01:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=eFj7aYbsfDh6r4bQY3cnjP2gsV9CUDvw26gZEL5EfhzCz/XiTIPrMxlBECEu01iGER23ep0dv9yQNCSb55wYqGuRtOCyBgRhnagtlsIAcUT1rbC84JOKAmQPy4vg6JPl8EiiwDJeGETrVHdLqI9dEYN40rBOBr0v1KCUQPG/mZM=
Message-ID: <45DFDA3E.80402@gmail.com>
Date: Sat, 24 Feb 2007 15:25:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Manuel Metz <mmetz@astro.uni-bonn.de>, studium@profihost.com
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA ahci Bug in 2.6.19.x
References: <7G2pJ-2iX-23@gated-at.bofh.it> <7G828-3zn-3@gated-at.bofh.it>	<7HpWX-3D2-5@gated-at.bofh.it> <7Hrci-5ou-5@gated-at.bofh.it>	<7HrP4-6t8-1@gated-at.bofh.it> <7Hvzs-3Tj-23@gated-at.bofh.it>	<7IYJ1-281-27@gated-at.bofh.it>	<45D2CEFC.4010900@astro.uni-bonn.de> <45DC3345.5000804@gmail.com> <45DC7769.7030206@astro.uni-bonn.de>
In-Reply-To: <45DC7769.7030206@astro.uni-bonn.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: multipart/mixed;
 boundary="------------010800060107090809090409"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010800060107090809090409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Manuel Metz wrote:
> Tejun Heo wrote:
>> Does it work if you give 'irqpoll' kernel parameter?
>>
> 
> Yes this works with "irqpoll". But as you can see in the attached dmesg
> output, now I get a bunch of APIC errors ... ?

Manuel, Stefan, please try the attached patch over 2.6.20 and report the
result.

-- 
tejun

--------------010800060107090809090409
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 48616c6..882b205 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -209,6 +209,10 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 };
 
+static int msi;
+module_param(msi, int, 0444);
+MODULE_PARM_DESC(msi, "Enable use of PCI MSI (0=off, 1=on)");
+
 static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg);
 static void ahci_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int ahci_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
@@ -1706,11 +1710,13 @@ static int ahci_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out;
 	}
 
-	if (pci_enable_msi(pdev) == 0)
-		have_msi = 1;
-	else {
-		pci_intx(pdev, 1);
-		have_msi = 0;
+	if (msi) {
+		if (pci_enable_msi(pdev) == 0)
+			have_msi = 1;
+		else {
+			pci_intx(pdev, 1);
+			have_msi = 0;
+		}
 	}
 
 	probe_ent = kmalloc(sizeof(*probe_ent), GFP_KERNEL);

--------------010800060107090809090409--
