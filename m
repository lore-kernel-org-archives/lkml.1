Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbXEVIL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbXEVIL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758681AbXEVIGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:33 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:6107 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbXEVIGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:17 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 3/15] x86-64: Calgary - introduce handle_quirks() for various chipset quirks
Date: Tue, 22 May 2007 04:05:52 -0400
Message-Id: <11798211663773-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211643144-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Move the aic94xx split completion timeout handling there.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index b1ab0d5..9f6dd44 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -807,6 +807,20 @@ static void __init calgary_set_split_com
 	readq(target); /* flush */
 }
 
+static void __init calgary_handle_quirks(struct pci_dev* dev)
+{
+	unsigned char busnum = dev->bus->number;
+	struct iommu_table *tbl = dev->sysdata;
+
+	/*
+	 * Give split completion a longer timeout on bus 1 for aic94xx
+	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
+	 */
+	if (busnum == 1)
+		calgary_set_split_completion_timeout(tbl->bbar, busnum,
+						     CCR_2SEC_TIMEOUT);
+}
+
 static void __init calgary_enable_translation(struct pci_dev *dev)
 {
 	u32 val32;
@@ -831,14 +845,6 @@ static void __init calgary_enable_transl
 	writel(cpu_to_be32(val32), target);
 	readl(target); /* flush */
 
-	/*
-	 * Give split completion a longer timeout on bus 1 for aic94xx
-	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
-	 */
-	if (busnum == 1)
-		calgary_set_split_completion_timeout(bbar, busnum,
-						     CCR_2SEC_TIMEOUT);
-
 	init_timer(&tbl->watchdog_timer);
 	tbl->watchdog_timer.function = &calgary_watchdog;
 	tbl->watchdog_timer.data = (unsigned long)dev;
@@ -890,6 +896,9 @@ static int __init calgary_init_one(struc
 
 	pci_dev_get(dev);
 	dev->bus->self = dev;
+
+	calgary_handle_quirks(dev);
+
 	calgary_enable_translation(dev);
 
 	return 0;
-- 
1.4.4

