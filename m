Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYIEQeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYIEQeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYIEQeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:34:06 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:29800 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYIEQeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:34:04 -0400
X-BigFish: VPS2(zzzz10d3izzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0K6QE0B-01-JDG-01
Date: Fri, 5 Sep 2008 18:33:26 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: hpet: modify IXP400 quirk to enable interrupts
Message-ID: <20080905163326.GE6743@alberich.amd.com>
References: <20080904144657.GC15987@alberich.amd.com> <20080904153206.GB7120@elte.hu> <alpine.LFD.1.10.0809041812450.3243@apollo.tec.linutronix.de> <20080905124203.GD6743@alberich.amd.com> <alpine.LFD.1.10.0809051600370.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809051600370.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Sep 2008 16:33:34.0786 (UTC) FILETIME=[24173220:01C90F75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current quirk is incomplete. Some more chipset fiddling has to be
done to enable HPET interrupts. This patch aims to do this. From my
tests it seems to work faultlessly.

But the official statement is that HPET is not supported on SB4X0.

Users will still have to use hpet=force to enable it.

Use it at your own risk.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/quirks.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index d138588..f6a11b9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -354,9 +354,27 @@ static void ati_force_hpet_resume(void)
 	printk(KERN_DEBUG "Force enabled HPET at resume\n");
 }
 
+static u32 ati_ixp4x0_rev(struct pci_dev *dev)
+{
+	u32 d;
+	u8  b;
+
+	pci_read_config_byte(dev, 0xac, &b);
+	b &= ~(1<<5);
+	pci_write_config_byte(dev, 0xac, b);
+	pci_read_config_dword(dev, 0x70, &d);
+	d |= 1<<8;
+	pci_write_config_dword(dev, 0x70, d);
+	pci_read_config_dword(dev, 0x8, &d);
+	d &= 0xff;
+	dev_printk(KERN_DEBUG, &dev->dev, "SB4X0 revision 0x%x\n", d);
+	return d;
+}
+
 static void ati_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 uninitialized_var(val);
+	u32 d, val;
+	u8  b;
 
 	if (hpet_address || force_hpet_address)
 		return;
@@ -366,14 +384,33 @@ static void ati_force_enable_hpet(struct pci_dev *dev)
 		return;
 	}
 
+	d = ati_ixp4x0_rev(dev);
+	if (d  < 0x82)
+		return;
+
+	/* base address */
 	pci_write_config_dword(dev, 0x14, 0xfed00000);
 	pci_read_config_dword(dev, 0x14, &val);
+
+	/* enable interrupt */
+	outb(0x72, 0xcd6); b = inb(0xcd7);
+	b |= 0x1;
+	outb(0x72, 0xcd6); outb(b, 0xcd7);
+	outb(0x72, 0xcd6); b = inb(0xcd7);
+	if (!(b & 0x1))
+		return;
+	pci_read_config_dword(dev, 0x64, &d);
+	d |= (1<<10);
+	pci_write_config_dword(dev, 0x64, d);
+	pci_read_config_dword(dev, 0x64, &d);
+	if (!(d & (1<<10)))
+		return;
+
 	force_hpet_address = val;
 	force_hpet_resume_type = ATI_FORCE_HPET_RESUME;
 	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
 		   force_hpet_address);
 	cached_dev = dev;
-	return;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
 			 ati_force_enable_hpet);
-- 
1.6.0.1



