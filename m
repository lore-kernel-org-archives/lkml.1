Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbXAZKyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbXAZKyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXAZKyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:54:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:64918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbXAZKyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:54:08 -0500
Date: Fri, 26 Jan 2007 11:50:50 +0100
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Bugfixes: PCI devices get assigned redundant IRQs
From: "Andreas Block" <andreas.block@esd-electronics.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Message-ID: <op.tmrce0km8n9ctc@pc-block.esd>
User-Agent: Opera Mail/9.10 (Win32)
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:7ee1d245d6d47e4a96dce2c88f0dd45f
X-Provags-ID2: V01U2FsdGVkX1/xCOtkB747I9zoStO9cyYDhdW+Iz3SlhSzvNznMF2VxU9GePRbgLNkKup4z3+FNidFPDytBdBzCAtkd9gVOEI9TFFTYFwC2Uwo1kvZOARsag==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently working on a port to a CPCI board with a MPC5200.
When testing the PCI interrupt routing, I discovered the following:
Even devices which don't use interrupts (-> PCI Spec.: Interrupt Pin  
Register is zero),
get an interrupt assigned (this is at least true for most of the  
PPC-targets I looked at).
The cause is pretty obvious in drivers/pci/setup-irq.c.
I guess at least in an ideal world with correctly designed hardware, the  
code should
rather look as in the patch below.
Of course it doesn't hurt anybody to have an unuseable IRQ assigned to a
PCI-to-PCI-bridge (or something alike), but to me it seems a bit strange.
Please correct me, if I'm mislead.

The patch below is tested on the above mentioned CPCI-MPC5200 board and is  
compiler
tested with the latest git-repository kernel on x86.

Best regards,
Andreas

---

Don't assign IRQs to devices, which don't need any

---
commit 2133d61f0bc119d4a06d453b8e79980912a151f0
tree 59ff1b5f7c1ec41780907edd90a35c10a64e3996
parent 99abfeafb5f2eea1bb481330ff37343e1133c924
author Andreas Block <andreas.block@esd-electronics.com> Thu, 25 Jan 2007  
17:12:48 +0100
committer Andreas Block <andreas.block@esd-electronics.com> Thu, 25 Jan  
2007 17:12:48 +0100

  drivers/pci/setup-irq.c |   18 ++++++++++--------
  1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index a251289..568f187 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -24,7 +24,7 @@ pdev_fixup_irq(struct pci_dev *dev,
  	       int (*map_irq)(struct pci_dev *, u8, u8))
  {
  	u8 pin, slot;
-	int irq;
+	int irq = 0;

  	/* If this device is not on the primary bus, we need to figure out
  	   which interrupt pin it will come in on.   We know which slot it
@@ -33,16 +33,18 @@ pdev_fixup_irq(struct pci_dev *dev,
  	   apply the swizzle function.  */

  	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
-	/* Cope with 0 and illegal. */
-	if (pin == 0 || pin > 4)
+	/* Cope with illegal. */
+	if (pin > 4)
  		pin = 1;

-	/* Follow the chain of bridges, swizzling as we go.  */
-	slot = (*swizzle)(dev, &pin);
+	if (pin != 0) {
+		/* Follow the chain of bridges, swizzling as we go.  */
+		slot = (*swizzle)(dev, &pin);

-	irq = (*map_irq)(dev, slot, pin);
-	if (irq == -1)
-		irq = 0;
+		irq = (*map_irq)(dev, slot, pin);
+		if (irq == -1)
+			irq = 0;
+	}
  	dev->irq = irq;

  	pr_debug("PCI: fixup irq: (%s) got %d\n",
 
