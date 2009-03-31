Return-Path: <linux-kernel-owner+w=401wt.eu-S1763403AbZCaWX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763403AbZCaWX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZCaWXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:23:45 -0400
Received: from [213.79.90.228] ([213.79.90.228]:3198 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757680AbZCaWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:23:44 -0400
Date: Wed, 1 Apr 2009 02:23:41 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Fix oops in pci_vpd_truncate
Message-ID: <20090331222341.GA16479@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_vpd_truncate() should check for dev->vpd->attr, otherwise
this might happen:

sky2 driver version 1.22
Unable to handle kernel paging request for data at address 0x0000000c
Faulting instruction address: 0xc01836fc
Oops: Kernel access of bad area, sig: 11 [#1]
[...]
NIP [c01836fc] pci_vpd_truncate+0x38/0x40
LR [c029be18] sky2_probe+0x14c/0x518
Call Trace:
[ef82bde0] [c029bda4] sky2_probe+0xd8/0x518 (unreliable)
[ef82be20] [c018a11c] local_pci_probe+0x24/0x34
[ef82be30] [c018a14c] pci_call_probe+0x20/0x30
[ef82be50] [c018a330] __pci_device_probe+0x64/0x78
[ef82be60] [c018a44c] pci_device_probe+0x30/0x58
[ef82be80] [c01aa270] really_probe+0x78/0x1a0
[ef82bea0] [c01aa460] __driver_attach+0xa4/0xa8
[ef82bec0] [c01a96ac] bus_for_each_dev+0x60/0x9c
[ef82bef0] [c01aa0b4] driver_attach+0x24/0x34
[ef82bf00] [c01a9e08] bus_add_driver+0x12c/0x1cc
[ef82bf20] [c01aa87c] driver_register+0x6c/0x110
[ef82bf30] [c018a770] __pci_register_driver+0x4c/0x9c
[ef82bf50] [c03782c8] sky2_init_module+0x30/0x40
[ef82bf60] [c0001dbc] do_one_initcall+0x34/0x1a0
[ef82bfd0] [c0362240] do_initcalls+0x38/0x58

This happens with CONFIG_SKY2=y, and "ip=on" kernel command line, so
pci_vpd_truncate() is called before late_initcall(pci_sysfs_init),
therefore ->attr isn't yet initialized.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/pci/access.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 3814447..64dd7df 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -356,7 +356,8 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size)
 		return -EINVAL;
 
 	dev->vpd->len = size;
-	dev->vpd->attr->size = size;
+	if (dev->vpd->attr)
+		dev->vpd->attr->size = size;
 
 	return 0;
 }
-- 
1.5.6.5
