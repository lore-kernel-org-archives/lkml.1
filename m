Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZCFC2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZCFC2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 21:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZCFC2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 21:28:43 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22437 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZCFC2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 21:28:42 -0500
Date: Thu, 5 Mar 2009 19:28:40 -0700
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org, matthew@wil.cx
Cc: andrew.patterson@hp.com, linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCIe: AER: during disable, check subordinate before walking
Message-ID: <20090306022840.GC30103@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	matthew@wil.cx, andrew.patterson@hp.com,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 47a8b0cc (Enable PCIe AER only after checking firmware
support) wants to walk the PCI bus in the remove path to disable
AER, and calls pci_walk_bus for downstream bridges.

Unfortunately, in the remove path, we remove devices and bridges
in a depth-first manner, starting with the furthest downstream
bridge and working our way backwards.

The furthest downstream bridges will not have a dev->subordinate,
and we hit a NULL deref in pci_walk_bus.

Check for dev->subordinate first before attempting to walk the
PCI hierarchy below us.

Cc: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
Willy, this is .29 material, please push to Linus, thanks.

---
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index aebb5f6..677d680 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -133,6 +133,9 @@ static void set_downstream_devices_error_reporting(struct pci_dev *dev,
 						   bool enable)
 {
 	set_device_error_reporting(dev, &enable);
+
+	if (!dev->subordinate)
+		return;
 	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
 }
 
