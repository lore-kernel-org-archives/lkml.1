Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbXGFS76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbXGFS76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761966AbXGFS7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:59:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761918AbXGFS7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:59:48 -0400
Date: Fri, 6 Jul 2007 14:59:43 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Clean up E7520/7320/7525 quirk printk.
Message-ID: <20070706185943.GA18853@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The printk level in this printk is bogus, as the previous printk
didn't have a terminating \n resulting in ..

Intel E7520/7320/7525 detected.<6>Disabling irq balancing and affinity

It also never printed a \n at all in the case where we didn't do
the quirk.

Change it to only make noise if it actually does something useful.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/i386/kernel/quirks.c b/arch/i386/kernel/quirks.c
index 9f6ab17..6722469 100644
--- a/arch/i386/kernel/quirks.c
+++ b/arch/i386/kernel/quirks.c
@@ -20,8 +20,6 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 	if (rev > 0x9)
 		return;
 
-	printk(KERN_INFO "Intel E7520/7320/7525 detected.");
-
 	/* enable access to config space*/
 	pci_read_config_byte(dev, 0xf4, &config);
 	pci_write_config_byte(dev, 0xf4, config|0x2);
@@ -30,7 +28,8 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
-		printk(KERN_INFO "Disabling irq balancing and affinity\n");
+		printk(KERN_INFO "Intel E7520/7320/7525 detected. "
+			"Disabling irq balancing and affinity\n");
 #ifdef CONFIG_IRQBALANCE
 		irqbalance_disable("");
 #endif
-- 
http://www.codemonkey.org.uk
