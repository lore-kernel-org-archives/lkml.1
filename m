Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbXLDTgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbXLDTgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXLDTgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:36:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbXLDTgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:36:03 -0500
Message-ID: <4755AC14.20605@ce.jp.nec.com>
Date: Tue, 04 Dec 2007 14:35:48 -0500
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <gregkh@suse.de>
Subject: [PATCH] pci: Omit error message for benign allocation failure
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On a system with PCI-to-PCI bridges, following errors are observed:

PCI: Failed to allocate mem resource #8:100000@d8200000 for 0000:02:00.0
PCI: Failed to allocate mem resource #6:10000@0 for 0000:03:01.0

'#6' is for expansion ROM and '#8' for the bridge where the device
with the expansion ROM is connected.
But I think the failure is benign because the allocation is
not necessary for these resources.

The allocation failure message is informative when the failure
is really a problem and needs a diagnosis.
However, if the resource is expansion ROMs, the message is just
confusing.

This patch omits the error message if the resource is an expansion
ROM or a bridge.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America


Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

--- linux-2.6.24-rc3/drivers/pci/setup-res.c.orig	2007-12-04 00:24:11.000000000 -0500
+++ linux-2.6.24-rc3/drivers/pci/setup-res.c	2007-12-04 00:42:14.000000000 -0500
@@ -158,11 +158,12 @@ int pci_assign_resource(struct pci_dev *
 	}
 
 	if (ret) {
-		printk(KERN_ERR "PCI: Failed to allocate %s resource "
-			"#%d:%llx@%llx for %s\n",
-			res->flags & IORESOURCE_IO ? "I/O" : "mem",
-			resno, (unsigned long long)size,
-			(unsigned long long)res->start, pci_name(dev));
+		if (resno < PCI_ROM_RESOURCE)
+			printk(KERN_ERR "PCI: Failed to allocate %s resource "
+				"#%d:%llx@%llx for %s\n",
+				res->flags & IORESOURCE_IO ? "I/O" : "mem",
+				resno, (unsigned long long)size,
+				(unsigned long long)res->start, pci_name(dev));
 	} else if (resno < PCI_BRIDGE_RESOURCES) {
 		pci_update_resource(dev, res, resno);
 	}
