Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZAEXHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZAEXHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZAEXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:07:20 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:42541 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZAEXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:07:18 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH v2] ASPM: Use msleep instead of cpu_relax during link
	retraining
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: andrew.patterson@hp.com, matthew@wil.cx, akpm@linux-foundation.org,
       shaohua.li@intel.com
Date: Mon, 05 Jan 2009 16:07:16 -0700
Message-ID: <20090105230716.15081.29984.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASPM: Use msleep instead of cpu_relax during link retraining

The cpu_relax() function can be a noop on certain architectures
like IA-64 when CPU threads are disabled, so use msleep instead
during link retraining busy/wait loop.

Introduce define LINK_RETRAIN_TIMEOUT instead of hard-coding
timeout in pcie_aspm_configure_common_clock.

Use time_after() to avoid jiffy wraparound when checking for expired
timeout.

After timeout expires, recheck link status register link training bit
instead of checking for expired timeout to avoid possible false positive.

Note that Matthew Wilcox came up with the first rough version of
this patch.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 4d8e2c7..e67eaa2 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
+#include <linux/delay.h>
 #include <linux/pci-aspm.h>
 #include "../pci.h"
 
@@ -75,6 +76,8 @@ static const char *policy_str[] = {
 	[POLICY_POWERSAVE] = "powersave"
 };
 
+#define LINK_RETRAIN_TIMEOUT HZ
+
 static int policy_to_aspm_state(struct pci_dev *pdev)
 {
 	struct pcie_link_state *link_state = pdev->link_state;
@@ -238,16 +241,19 @@ static void pcie_aspm_configure_common_clock(struct pci_dev *pdev)
 	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
 
 	/* Wait for link training end */
-	/* break out after waiting for 1 second */
+	/* break out after waiting for timeout */
 	start_jiffies = jiffies;
-	while ((jiffies - start_jiffies) < HZ) {
+	for (;;) {
 		pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
 		if (!(reg16 & PCI_EXP_LNKSTA_LT))
 			break;
-		cpu_relax();
+		if (time_after(start_jiffies,
+			       start_jiffies + LINK_RETRAIN_TIMEOUT))
+			break;
+		msleep(1);
 	}
 	/* training failed -> recover */
-	if ((jiffies - start_jiffies) >= HZ) {
+	if (reg16 & PCI_EXP_LNKSTA_LT) {
 		dev_printk (KERN_ERR, &pdev->dev, "ASPM: Could not configure"
 			    " common clock\n");
 		i = 0;

