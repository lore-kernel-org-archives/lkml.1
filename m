Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbXLULHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbXLULHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXLULHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:07:05 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:11467 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754310AbXLULHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:07:02 -0500
To: LKML <linux-kernel@vger.kernel.org>
From: Maxim Uvarov <muvarov@ru.mvista.com>
Subject: [PATCH] SMbus i2c-i801 ioports request.
Date: Fri, 21 Dec 2007 14:06:56 +0000
Message-ID: <20071221140656.12179.42116.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems it was not on lkml mail list.

MPCBL0040 target has buggy DC752HRA bios with wrong length of SMBus region
(SMBL field).  That makes acpi pnp code reserve incorrect region.  i2c-801 
driver fails on requesting ioport region because half of this region is 
alredy held by acpi pnp and regions lengths are not match. This patch 
requests each ioport separately so it doesn't matter now if ioport is 
reserved by acpi pnp or not.

This patch makes extra records in /proc/ioport. One record per ioport = 20
lines. In case with DC752HRA bios we can request ioports on 2 commands and 
we will have only 2 lines in /proc/ioport. But this solution is more 
universal.
Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>

Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>                                                                                  
---

 drivers/i2c/busses/i2c-i801.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ac27e5f..6bb9a70 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -554,6 +554,7 @@ static int __devinit i801_probe(struct pci_dev *dev, const struct pci_device_id
 {
 	unsigned char temp;
 	int err;
+	int idx;
 
 	I801_dev = dev;
 	switch (dev->device) {
@@ -588,12 +589,15 @@ static int __devinit i801_probe(struct pci_dev *dev, const struct pci_device_id
 		goto exit;
 	}
 
-	err = pci_request_region(dev, SMBBAR, i801_driver.name);
-	if (err) {
-		dev_err(&dev->dev, "Failed to request SMBus region "
-			"0x%lx-0x%Lx\n", i801_smba,
-			(unsigned long long)pci_resource_end(dev, SMBBAR));
-		goto exit;
+	for (idx = 0; idx < pci_resource_len(dev, SMBBAR); idx++) {
+		if (!request_region(i801_smba + idx, 1, i801_driver.name)) {
+				while (idx--)
+					release_region(i801_smba + idx, 1);
+				dev_err(&dev->dev, "Failed to request SMBus region "
+					"0x%lx-0x%Lx\n", i801_smba,
+					(unsigned long long)pci_resource_end(dev, SMBBAR));
+				goto exit;
+		}
 	}
 
 	pci_read_config_byte(I801_dev, SMBHSTCFG, &temp);
@@ -623,7 +627,8 @@ static int __devinit i801_probe(struct pci_dev *dev, const struct pci_device_id
 	return 0;
 
 exit_release:
-	pci_release_region(dev, SMBBAR);
+	for (idx = 0; idx < pci_resource_len(dev, SMBBAR); idx++) 
+		release_region(i801_smba + idx, 1);
 exit:
 	return err;
 }

