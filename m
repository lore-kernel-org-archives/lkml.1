Return-Path: <linux-kernel-owner+w=401wt.eu-S1761587AbXKICC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587AbXKICC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 21:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbXKICCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 21:02:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:50773 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbXKICCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 21:02:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=hmKnIr5y1QOVxnWx/YXgfyFcBLtwnbQSqzN70d5DTiUSm8UyHIiFcXyXiG6T2hNjvXcoJDkkG0PFROjebHzVaREYKOo4qz7ohBEuMAmNZTLA11YRwbhMuroc5hJWmQZzrNYKaQbgyqiawMW95C94NqVQmmK7jFXjoX8k0Dp3z/w=
Date: Fri, 9 Nov 2007 09:02:35 +0700
From: Riki Oktarianto <rkoktarianto@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071109020235.GA2031@ceren>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSen map AHCI ABAR but lock the SATA controller to IDE mode.
This patch add quirk to set AHCI mode on ICH board with such case.

Tested on Macbook2,1 (ICH7M)

-- 
Riki Oktarianto

--- linux-2.6.24-rc2.orig/drivers/pci/quirks.c
+++ linux-2.6.24-rc2/drivers/pci/quirks.c
@@ -466,6 +466,38 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_2, quirk_ich6_lpc_acpi );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_3, quirk_ich6_lpc_acpi );
 
+static void __devinit quirk_ich_sata(struct pci_dev *dev)
+{
+	u32 ahci_bar;
+
+	pci_read_config_dword(dev, 0x24, &ahci_bar);
+	if (!ahci_bar) {
+		return;
+	}
+
+	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
+		pci_write_config_byte(dev, PCI_CLASS_PROG, 0x01);
+		pci_write_config_byte(dev, PCI_CLASS_DEVICE, 0x06);
+	}
+	dev->class = PCI_CLASS_STORAGE_SATA_AHCI;
+	printk (KERN_INFO "PCI_CLASS_STORAGE_SATA_AHCI set for %s\n",
+		pci_name(dev));
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2652, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2653, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27c0, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27c4, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2680, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2820, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2825, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2828, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2920, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2921, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2926, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2928, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x292d, quirk_ich_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x292e, quirk_ich_sata);
+
 /*
  * VIA ACPI: One IO region pointed to by longword at
  *	0x48 or 0x20 (256 bytes of ACPI registers)
