Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYBDAY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYBDAY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYBDAYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:24:15 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:1608 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753773AbYBDAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Qkmacu1prxjD/gWtSk8ol6u58oxS0vME5M8ll5RjAJfeN+pVRvGQ+SZlCvN0r6WxAPeCtUi21Dn67VGnV8D5vwguaMRzFvyjq1Xd/qYAwHxvA78DVWmO3n/Ghi776ONUChsVLjD+QcquXDlB81kehMafAiHVqB14KPzm2nFpUdU=
Message-ID: <804dabb00802031624o1c0c5f4x378f80fe4e7fa242@mail.gmail.com>
Date: Mon, 4 Feb 2008 08:24:12 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: sis190_pci_tbl causes a section type conflict
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While compiling the latest linus tree I got the following error:

rivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type conflict
make[2]: *** [drivers/net/sis190.o] Error 1

And after some modification and successful compilation, the following
warnings appeared:

WARNING: drivers/net/sis190.o(.text+0xdc): Section mismatch in
reference from the function sis190_get_mac_addr() to the function
.devinit.text:sis190_get_mac_addr_from_apc()
The function  sis190_get_mac_addr() references
the function __devinit sis190_get_mac_addr_from_apc().
This is often because sis190_get_mac_addr lacks a __devinit
annotation or the annotation of sis190_get_mac_addr_from_apc is wrong.

WARNING: drivers/net/sis190.o(.text+0xe7): Section mismatch in
reference from the function sis190_get_mac_addr() to the function
.devinit.text:sis190_get_mac_addr_from_eeprom()
The function  sis190_get_mac_addr() references
the function __devinit sis190_get_mac_addr_from_eeprom().
This is often because sis190_get_mac_addr lacks a __devinit
annotation or the annotation of sis190_get_mac_addr_from_eeprom is wrong.

The following patch is to fix the above problems - please comment:

Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

--- sis190.c.orig       2008-02-04 08:17:28.000000000 +0800
+++ drivers/net/sis190.c        2008-02-04 08:20:29.000000000 +0800
@@ -326,7 +326,7 @@ static const struct {
        { "SiS 191 PCI Gigabit Ethernet adapter" },
 };

-static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
+static struct pci_device_id sis190_pci_tbl[] = {
        { PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
        { PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
        { 0, },
@@ -1630,7 +1630,7 @@ static inline void sis190_init_rxfilter(
        SIS_PCI_COMMIT();
 }

-static int sis190_get_mac_addr(struct pci_dev *pdev, struct net_device *dev)
+static int __devinit sis190_get_mac_addr(struct pci_dev *pdev, struct
net_device *dev)
 {
        u8 from;
