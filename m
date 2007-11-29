Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbXK2IPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbXK2IPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXK2IO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:14:58 -0500
Received: from imx9.toshiba.co.jp ([202.33.96.51]:53909 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbXK2IO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:14:57 -0500
Date: Thu, 29 Nov 2007 16:44:18 +0900 (JST)
Message-Id: <20071129.164418.-1300542154.kouish@swc.toshiba.co.jp>
To: paulus@samba.org
Cc: gorcunov@gmail.com, olof@lixom.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH] PPC: CELLEB - fix possible NULL pointer dereference
In-Reply-To: <aa79d98a0711282141l6b07569fmb925b198730a554e@mail.gmail.com>
From: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch adds checking for NULL returned value to
prevent possible NULL pointer dereference.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Paul,
This is a resend of a patch from Cyrill. I changed it to inline style.

Cyrill,
This works good on Celleb. Thanks.

Best regards,
Kou Ishizaki


 arch/powerpc/platforms/celleb/pci.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/celleb/pci.c b/arch/powerpc/platforms/celleb/pci.c
index 6bc32fd..13ec4a6 100644
--- a/arch/powerpc/platforms/celleb/pci.c
+++ b/arch/powerpc/platforms/celleb/pci.c
@@ -138,8 +138,6 @@ static void celleb_config_read_fake(unsigned char *config, int where,
 		*val = celleb_fake_config_readl(p);
 		break;
 	}
-
-	return;
 }
 
 static void celleb_config_write_fake(unsigned char *config, int where,
@@ -158,7 +156,6 @@ static void celleb_config_write_fake(unsigned char *config, int where,
 		celleb_fake_config_writel(val, p);
 		break;
 	}
-	return;
 }
 
 static int celleb_fake_pci_read_config(struct pci_bus *bus,
@@ -351,6 +348,10 @@ static int __init celleb_setup_fake_pci_device(struct device_node *node,
 	wi1 = of_get_property(node, "vendor-id", NULL);
 	wi2 = of_get_property(node, "class-code", NULL);
 	wi3 = of_get_property(node, "revision-id", NULL);
+	if (!wi0 || !wi1 || !wi2 || !wi3) {
+		printk(KERN_ERR "PCI: Missing device tree properties.\n");
+		goto error;
+	}
 
 	celleb_config_write_fake(*config, PCI_DEVICE_ID, 2, wi0[0] & 0xffff);
 	celleb_config_write_fake(*config, PCI_VENDOR_ID, 2, wi1[0] & 0xffff);
@@ -372,6 +373,10 @@ static int __init celleb_setup_fake_pci_device(struct device_node *node,
 	celleb_setup_pci_base_addrs(hose, devno, fn, num_base_addr);
 
 	li = of_get_property(node, "interrupts", &rlen);
+	if (!li) {
+		printk(KERN_ERR "PCI: interrupts not found.\n");
+		goto error;
+	}
 	val = li[0];
 	celleb_config_write_fake(*config, PCI_INTERRUPT_PIN, 1, 1);
 	celleb_config_write_fake(*config, PCI_INTERRUPT_LINE, 1, val);
