Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYDWXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYDWXDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYDWXDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:03:09 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:52800 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYDWXDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:03:08 -0400
Message-ID: <480FC026.9060009@tiscali.nl>
Date: Thu, 24 Apr 2008 01:03:02 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: paulus@samba.org, linuxppc-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] mpic_u3msi: mpic_u3msi: failed allocation unnoticed
References: <480F6905.3070808@tiscali.nl> <480F8754.7000200@tiscali.nl> <df21920e067e73985f73047e2d8bcbda@kernel.crashing.org> <480FB766.1040405@tiscali.nl>
In-Reply-To: <480FB766.1040405@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again thanks to Segher and Joe Perches
---
bitmap_find_free_region(), called by mpic_msi_alloc_hwirqs() may return
signed, but hwirq is unsigned. A failed allocation remains unnoticed.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_u3msi.c
index 1d5a408..6e2f868 100644
--- a/arch/powerpc/sysdev/mpic_u3msi.c
+++ b/arch/powerpc/sysdev/mpic_u3msi.c
@@ -115,17 +115,19 @@ static int u3msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	struct msi_desc *entry;
 	struct msi_msg msg;
 	u64 addr;
+	int ret;
 
 	addr = find_ht_magic_addr(pdev);
 	msg.address_lo = addr & 0xFFFFFFFF;
 	msg.address_hi = addr >> 32;
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
-		hwirq = mpic_msi_alloc_hwirqs(msi_mpic, 1);
-		if (hwirq < 0) {
+		ret = mpic_msi_alloc_hwirqs(msi_mpic, 1);
+		if (ret < 0) {
 			pr_debug("u3msi: failed allocating hwirq\n");
-			return hwirq;
+			return ret;
 		}
+		hwirq = ret;
 
 		virq = irq_create_mapping(msi_mpic->irqhost, hwirq);
 		if (virq == NO_IRQ) {

