Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZD3Gs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZD3Gs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZD3GsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:48:06 -0400
Received: from mga12.intel.com ([143.182.124.36]:30384 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbZD3GsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:48:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,270,1239001200"; 
   d="scan'208";a="137609237"
Subject: [PATCH] Fix pci-e port driver slot_reset bad default return value
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Thu, 30 Apr 2009 14:48:29 +0800
Message-Id: <1241074109.2567.901.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an upstream port reports an AER error to root port, kernel
starts error recovery procedures. The default return value of
function pcie_portdrv_slot_reset is PCI_ERS_RESULT_NONE. If all
port service drivers of the downstream port under the upstream
port have no slot_reset method in pci_error_handlers, aer recovery
would stop without resume. Below patch against 2.6.30-rc3 fixes it.

﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

diff -Nraup linux-2.6.30-rc3/drivers/pci/pcie/aer/aerdrv.h linux-2.6.30-rc3_aerport/drivers/pci/pcie/aer/aerdrv.h
--- linux-2.6.30-rc3/drivers/pci/pcie/aer/aerdrv.h	2009-04-29 15:51:28.000000000 +0800
+++ linux-2.6.30-rc3_aerport/drivers/pci/pcie/aer/aerdrv.h	2009-04-30 14:06:58.000000000 +0800
@@ -95,6 +95,9 @@ struct aer_broadcast_data {
 static inline pci_ers_result_t merge_result(enum pci_ers_result orig,
 		enum pci_ers_result new)
 {
+	if (new == PCI_ERS_RESULT_NONE)
+		return orig;
+
 	switch (orig) {
 	case PCI_ERS_RESULT_CAN_RECOVER:
 	case PCI_ERS_RESULT_RECOVERED:
diff -Nraup linux-2.6.30-rc3/drivers/pci/pcie/portdrv_pci.c linux-2.6.30-rc3_aerport/drivers/pci/pcie/portdrv_pci.c
--- linux-2.6.30-rc3/drivers/pci/pcie/portdrv_pci.c	2009-04-29 15:52:23.000000000 +0800
+++ linux-2.6.30-rc3_aerport/drivers/pci/pcie/portdrv_pci.c	2009-04-30 14:02:25.000000000 +0800
@@ -200,7 +200,7 @@ static int slot_reset_iter(struct device
 
 static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
 {
-	pci_ers_result_t status = PCI_ERS_RESULT_NONE;
+	pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
 	int retval;
 
 	/* If fatal, restore cfg space for possible link reset at upstream */


