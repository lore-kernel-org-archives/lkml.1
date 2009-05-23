Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbZEWAat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbZEWAat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 20:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZEWAam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 20:30:42 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:41404 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZEWAam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 20:30:42 -0400
Message-ID: <4A1743AF.5010904@linux.vnet.ibm.com>
Date: Fri, 22 May 2009 21:30:39 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] icom: fix rmmod crash
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually the icom driver is crashing when is being removed because
the driver is kfreeing the adapter structure before calling 
pci_release_regions(), which result in the following error:

Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6b6d33
Faulting instruction address: 0xc000000000246b80
Oops: Kernel access of bad area, sig: 11 [#1]
....
[c000000012d436a0] [c0000000001002d0] .kfree+0x120/0x34c (unreliable)
[c000000012d43730] [c000000000246d60] .pci_release_selected_regions+0x3c/0x68
[c000000012d437c0] [d000000002d54700] .icom_kref_release+0xf4/0x118 [icom]
[c000000012d43850] [c000000000232e50] .kref_put+0x74/0x94
[c000000012d438d0] [d000000002d56c58] .icom_remove+0x40/0xa4 [icom]
[c000000012d43960] [c000000000249e48] .pci_device_remove+0x50/0x90
[c000000012d439e0] [c0000000002d68d8] .__device_release_driver+0x94/0xd4
[c000000012d43a70] [c0000000002d7104] .driver_detach+0xf8/0x12c
[c000000012d43b00] [c0000000002d549c] .bus_remove_driver+0xbc/0x11c
[c000000012d43b90] [c0000000002d71dc] .driver_unregister+0x60/0x80
[c000000012d43c20] [c00000000024a07c] .pci_unregister_driver+0x44/0xe8
[c000000012d43cb0] [d000000002d56bf4] .icom_exit+0x1c/0x40 [icom]
[c000000012d43d30] [c000000000095fa8] .SyS_delete_module+0x214/0x2a8
[c000000012d43e30] [c00000000000852c] syscall_exit+0x0/0x40

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/icom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 6579e2b..a461b3b 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -1472,8 +1472,8 @@ static void icom_remove_adapter(struct icom_adapter *icom_adapter)
 
 	free_irq(icom_adapter->pci_dev->irq, (void *) icom_adapter);
 	iounmap(icom_adapter->base_addr);
-	icom_free_adapter(icom_adapter);
 	pci_release_regions(icom_adapter->pci_dev);
+	icom_free_adapter(icom_adapter);
 }
 
 static void icom_kref_release(struct kref *kref)
-- 
1.6.0.4

