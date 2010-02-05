Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab0BEGm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 01:42:57 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:45076 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0BEGm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 01:42:56 -0500
Date: Fri, 5 Feb 2010 01:42:43 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: torvalds@linux-foundation.org
Cc: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>,
       Leigh Porter <leigh@leighporter.org>, linux-geode@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christopher Camden <ccamden@cbnco.com>
Subject: [PATCH] CS5536: apply pci quirk for BIOS SMBUS bug
Message-ID: <20100205014243.5264e8a0@mycelium.queued.net>
In-Reply-To: <4B605410.3030409@LiPPERTEmbedded.de>
References: <4B5DC7EF.5060609@leighporter.org>
 <4B5EE78F.8030705@LiPPERTEmbedded.de>
 <4B5F01E3.2090006@leighporter.org>
 <4B603383.1090807@LiPPERTEmbedded.de>
 <4B604324.6030806@leighporter.org>
 <4B605410.3030409@LiPPERTEmbedded.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; i486-pc-linux-gnu)
Importance: high
X-Priority: 1 (Highest)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 15:56:16 +0100
Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:

> A bit of background: The _real_ base address for the MFGPT hardware
> is set with the MSR, but this is very Geode-proprietary. So the BIOS
> contains VSA (Virtual System Architecture) code to implement a
> _virtual_ PCI device. This means the BIOS simulates a standard PCI
> device solely in software as a front-end for the MFGPT hardware to
> make it look like a 'normal' device which can be accessed with normal
> PCI drivers.
> 
> Well, this PCI device's configuration should of course always mirror
> the real state of the hardware, i.e. if someone changes the MSR, the
> PCI header should reflect that change, and vice versa.
> 
> > [    0.090015] pci 0000:00:14.0: address space collision: [io
> > 0x6200-0x63ff] already in use
> ....
> > [    0.202033] pci 0000:00:14.0: BAR 2: set to [io  0x1000-0x11ff]
> > (PCI address [0x1000-0x11ff]
> ....
> > root@doulos:/home/leigh# ./mfgpt
> > 6200
> 
> Now it looks like originally both MSR and PCI say the adress is 6200.
> But Linux detects a conflict on boot and moves it to 1000 by changing
> the PCI config. At this point the BIOS should copy the new address to
> the backing MSR i.e. to the real hardware. But this it fails to do.
> And later the cs5535-mfgpt uses the address from PCI (=1000) to look
> for the MFGPTs, but they're not there - they're are still at 6200.
> 
> >>> Copyright (C) 2000-2007 Soekris Engineering."
> > Yup, I am about to call them. ...
> 
> Hope they fix it. But this will not be the only BIOS with this bug,
> that's why we have to revert the cs5535-mfgpt driver to read the MSR
> directly again.
> 
> Best regards,
> Jens Rottmann
> 


Hi Linus,

This fixes a regression w/ the new cs5535-* drivers on some Soekris
boards.  Can you please add it for -rc7?




From: Andres Salomon <dilinger@collabora.co.uk>
Subject: [PATCH] CS5536: apply pci quirk for BIOS SMBUS bug

The new cs5535-* drivers use PCI header config info rather than MSRs to
determine the memory region to use for things like GPIOs and MFGPTs.  As
anticipated, we've run into a buggy BIOS:

[    0.081818] pci 0000:00:14.0: reg 10: [io  0x6000-0x7fff]
[    0.081906] pci 0000:00:14.0: reg 14: [io  0x6100-0x61ff]
[    0.082015] pci 0000:00:14.0: reg 18: [io  0x6200-0x63ff]
[    0.082917] pci 0000:00:14.2: reg 20: [io  0xe000-0xe00f]
[    0.083551] pci 0000:00:15.0: reg 10: [mem 0xa0010000-0xa0010fff]
[    0.084436] pci 0000:00:15.1: reg 10: [mem 0xa0011000-0xa0011fff]
[    0.088816] PCI: pci_cache_line_size set to 32 bytes
[    0.088938] pci 0000:00:14.0: address space collision: [io 0x6100-0x61ff] already in use
[    0.089052] pci 0000:00:14.0: can't reserve [io  0x6100-0x61ff]

This is a Soekris board, and its BIOS sets the size of the PCI ISA bridge
device's BAR0 to 8k.  In reality, it should be 8 bytes (BAR0 is used for
SMBus stuff).  This quirk checks for an incorrect size, and resets it
accordingly.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Tested-by: Leigh Porter <leigh@leighporter.org>
Tested-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---
 drivers/pci/quirks.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c746943..d58b940 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -338,6 +338,23 @@ static void __devinit quirk_s3_64M(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S3,	PCI_DEVICE_ID_S3_868,		quirk_s3_64M);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S3,	PCI_DEVICE_ID_S3_968,		quirk_s3_64M);
 
+/*
+ * Some CS5536 BIOSes (for example, the Soekris NET5501 board w/ comBIOS
+ * ver. 1.33  20070103) don't set the correct ISA PCI region header info.
+ * BAR0 should be 8 bytes; instead, it may be set to something like 8k
+ * (which conflicts w/ BAR1's memory range).
+ */
+static void __devinit quirk_cs5536_vsa(struct pci_dev *dev)
+{
+	if (pci_resource_len(dev, 0) != 8) {
+		struct resource *res = &dev->resource[0];
+		res->end = res->start + 8 - 1;
+		dev_info(&dev->dev, "CS5536 ISA bridge bug detected "
+				"(incorrect header); workaround applied.\n");
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, quirk_cs5536_vsa);
+
 static void __devinit quirk_io_region(struct pci_dev *dev, unsigned region,
 	unsigned size, int nr, const char *name)
 {
-- 
1.5.6.5

