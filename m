Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZCDBWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZCDBWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZCDBWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:22:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbZCDBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:22:31 -0500
Date: Tue, 3 Mar 2009 20:22:29 -0500
From: Kyle McMartin <kyle@infradead.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ppc: detect sbc610 boards and only fixup nec usb on them
Message-ID: <20090304012229.GN28503@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Bug #486511 in Fedora, this is getting applied to any machine with a NEC
USB pci device if this CONFIG_GEF_SBC610 is on (as it was in Fedora.)
Obviously this isn't appropriate to do in any more than the SBC610
case..., so flag that we're a sbc610 board, and skip the fixup if we're
not.

(Fedora: Should fix USB on Mac G4/G5...)

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/arch/powerpc/platforms/86xx/gef_sbc610.c b/arch/powerpc/platforms/86xx/gef_sbc610.c
index fb371f5..54afda2 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc610.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc610.c
@@ -51,6 +51,8 @@
 
 void __iomem *sbc610_regs;
 
+static int is_sbc610;
+
 static void __init gef_sbc610_init_irq(void)
 {
 	struct device_node *cascade_node = NULL;
@@ -142,6 +144,9 @@ static void __init gef_sbc610_nec_fixup(struct pci_dev *pdev)
 {
 	unsigned int val;
 
+	if (!is_sbc610)
+		return;
+
 	printk(KERN_INFO "Running NEC uPD720101 Fixup\n");
 
 	/* Ensure ports 1, 2, 3, 4 & 5 are enabled */
@@ -166,8 +171,10 @@ static int __init gef_sbc610_probe(void)
 {
 	unsigned long root = of_get_flat_dt_root();
 
-	if (of_flat_dt_is_compatible(root, "gef,sbc610"))
+	if (of_flat_dt_is_compatible(root, "gef,sbc610")) {
+		is_sbc610 = 1;
 		return 1;
+	}
 
 	return 0;
 }
