Return-Path: <linux-kernel-owner+w=401wt.eu-S1764690AbYDQPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764690AbYDQPCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbYDQPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:02:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758735AbYDQPCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:02:11 -0400
Message-ID: <4807666E.7070803@redhat.com>
Date: Thu, 17 Apr 2008 17:02:06 +0200
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: romieu@fr.zoreil.com
Subject: [PATCH] NET: r8169: fix oops in r8169_get_mac_version
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When does r8169_get_mac_version find unknown MAC then kernel crash occurs
because tp->pci_dev is NULL and is dereferenced. Problem is that the function
r8169_get_mac_version is called from rtl8169_init_one at line 1704 but
tp->pci_dev is filled at line 1780.

Ivan

---
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 3acfeea..a45c8e8 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1700,6 +1700,9 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		msleep_interruptible(1);
 	}
 
+	/* rtl8169_get_mac_version uses tp->pci_dev when unknown MAC found */
+	tp->pci_dev = pdev;
+
 	/* Identify chip attached to board */
 	rtl8169_get_mac_version(tp, ioaddr);
 
@@ -1777,7 +1780,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 	tp->intr_mask = 0xffff;
-	tp->pci_dev = pdev;
 	tp->mmio_addr = ioaddr;
 	tp->align = cfg->align;
 	tp->hw_start = cfg->hw_start;
