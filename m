Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbXC3WqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbXC3WqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXC3WqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:46:04 -0400
Received: from smtp-3.hut.fi ([130.233.228.93]:50011 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbXC3WqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:46:01 -0400
X-Greylist: delayed 2204 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 18:46:00 EDT
Date: Sat, 31 Mar 2007 01:09:00 +0300 (EEST)
From: Mikko Tiihonen <mikko.tiihonen@iki.fi>
To: nicolas.mailhot@laposte.net
cc: linux-kernel@vger.kernel.org
Subject: RE: [PATCH 1/5] RT kernel: force detect HPET from PCI space
Message-ID: <Pine.OSF.4.64.0703310049090.412261@kosh.hut.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at putosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Anyone got the same thing for CK804? I had my hopes high, and then I saw
> the DECLARE_PCI_FIXUP_HEADER values [and the thread title was misleading]

I have an A8N-E motherboard with AthlonX2 and the ACPI definitions are 
missing the HPET (standard feature of Asus motherboards).

I too got interested to get my motherboard working. Luckily I found this 
http://lkml.org/lkml/2006/12/17/69 from which I generated the following patch:

--- arch/i386/kernel/quirks.c.orig	2007-03-30 23:43:06.000000000 +0300
+++ arch/i386/kernel/quirks.c	2007-03-30 23:26:47.000000000 +0300
@@ -101,5 +101,39 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH7_1,     force_enable_hpet);
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH7_31,     force_enable_hpet);
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH8_1,     force_enable_hpet);
+
+static void __init force_enable_nvidia_hpet(struct pci_dev *dev)
+{
+        u8 enabled;
+	u32 addr;
+
+	if (hpet_address)
+		return;
+
+	pci_read_config_dword(dev, 0x44, &addr);
+	if (addr != 0xfefff000L) {
+		printk(KERN_INFO "Unsafe HPET address 0x%08x. Cannot force enable HPET\n", addr);
+		return;
+	}
+
+	pci_read_config_byte(dev, 0xA3, &enabled);
+	if ((enabled & 4) == 0) {
+	        if (enabled != 0xc1) {
+		  printk(KERN_INFO "Unsafe HPET enable 0x%02x. Cannot force enable HPET\n", enabled);
+		  return;
+		}
+		pci_write_config_byte(dev, 0xA3, enabled | 4);
+		pci_read_config_byte(dev, 0xA3, &enabled);
+		if ((enabled & 4) == 0) {
+			printk(KERN_INFO "Failed to force enable HPET\n");
+			return;
+		}
+	}
+
+	force_hpet_address = addr;
+	printk(KERN_INFO "Force enabled HPET. Base address 0x%08lx\n", force_hpet_address);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA,	0x0050,     force_enable_nvidia_hpet); // NForce4
  #endif

Now Linux seems to detect HPET and it passes at least the basic sanity checks:

Force enabled HPET. Base address 0xfefff000
HPET: hpet_period 40000000, hpet_tick 83333
Successfully registered HPET clocksource

Unfortunately the 2.6.20-mm2 kernel to which I tried to patch the patch series 
seems to hang few seconds later after half way in udev startup event 
processing.

It could either be something totally different in 2.6.20-mm2 that just happens 
to fail or more likely some interrupt setup that still needs to be done.

I have no idea how to continue from here.

-Mikko
