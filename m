Return-Path: <linux-kernel-owner+w=401wt.eu-S1765021AbYBMHM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765021AbYBMHM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYBMHMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:12:18 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:37162 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYBMHMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:12:17 -0500
To: Gregor Radtke <mail@g-radtke.name>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, Tim Kunschke <beatmeistah@web.de>
Subject: Re: [PATCH] pata_cs5536 Fix secondary port configuration
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1202158828.6229.22.camel@desktop.ein-elch.local>
	<yq163x47wsy.fsf@sermon.lab.mkp.net>
	<1202662829.6418.8.camel@desktop.ein-elch.local>
	<yq1myq6p7fe.fsf_-_@sermon.lab.mkp.net>
	<1202858221.6419.33.camel@desktop.ein-elch.local>
Date: Wed, 13 Feb 2008 02:12:06 -0500
In-Reply-To: <1202858221.6419.33.camel@desktop.ein-elch.local> (Gregor Radtke's message of "Wed\, 13 Feb 2008 00\:17\:01 +0100")
Message-ID: <yq163wtpby1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gregor" == Gregor Radtke <mail@g-radtke.name> writes:

Gregor> boots! 

Excellent.  Thanks for testing this!  I have sent the patch upstream.


Gregor> Anyway, the patch fits perfectly and now UDMA/33 (due to
Gregor> 40wire-cable, vendor says UDMA/100 should work either) on a
Gregor> HDD using pata_cs5536 just works =)

pata_amd.c happens to ignore the 40/80 wire configuration bit on
CS5536 and a couple of other chips.  That's why it negotiates
UDMA/100 regardless of cable type.

pata_cs5536.c relies on the BIOS telling it whether an 80-wire cable
is connected or not.

I have attached a patch that dumps the 5536 IDE configuration
registers during boot. If you like you can apply that and mail me the
resulting register dump.  That'll tell us how your BIOS initialized
the chip.

-- 
Martin K. Petersen	Oracle Linux Engineering


diff -r b0dc16d276be drivers/ata/pata_cs5536.c
--- a/drivers/ata/pata_cs5536.c	Tue Feb 12 08:52:44 2008 -0500
+++ b/drivers/ata/pata_cs5536.c	Wed Feb 13 01:51:00 2008 -0500
@@ -73,6 +73,11 @@ enum {
 	IDE_CAST_CMD_SHIFT	= 24,
 
 	IDE_ETC_NODMA		= 0x03,
+
+	CFG_REG_MASK		= 0x34002,
+	DTC_REG_MASK		= 0xffff0000,
+	CAST_REG_MASK		= 0xff0000f0,
+	ETC_REG_MASK		= 0xc7c70000,
 };
 
 static int use_msr;
@@ -84,6 +89,23 @@ static const u8 pci_reg[4] = {
 static const u8 pci_reg[4] = {
 	PCI_IDE_CFG, PCI_IDE_DTC, PCI_IDE_CAST, PCI_IDE_ETC,
 };
+
+static void cs5536_regs(void)
+{
+        u32 reg, dummy;
+
+        rdmsr(MSR_IDE_CFG, reg, dummy);
+        printk(KERN_ERR " CFG  = 0x%08x\n", reg & CFG_REG_MASK);
+
+        rdmsr(MSR_IDE_DTC, reg, dummy);
+        printk(KERN_ERR " DTC  = 0x%08x\n", reg & DTC_REG_MASK);
+
+        rdmsr(MSR_IDE_CAST, reg, dummy);
+        printk(KERN_ERR " CAST = 0x%08x\n", reg & CAST_REG_MASK);
+
+        rdmsr(MSR_IDE_ETC, reg, dummy);
+        printk(KERN_ERR " ETC  = 0x%08x\n", reg & ETC_REG_MASK);
+}
 
 static inline int cs5536_read(struct pci_dev *pdev, int reg, int *val)
 {
@@ -303,6 +325,8 @@ static int cs5536_init_one(struct pci_de
 		return -ENODEV;
 	}
 
+	cs5536_regs();
+
 	return ata_pci_init_one(dev, ppi);
 }
 
