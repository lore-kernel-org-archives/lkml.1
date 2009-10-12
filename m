Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZJLKTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZJLKTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZJLKTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:19:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:24590 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbZJLKTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:19:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,545,1249282800"; 
   d="scan'208";a="197861495"
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
From: David Woodhouse <david.woodhouse@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <alpine.LFD.2.01.0910111554400.3438@localhost.localdomain>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	 <alpine.LFD.2.01.0910111554400.3438@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Mon, 12 Oct 2009 11:18:58 +0100
Message-Id: <1255342738.24732.265.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 00:07 +0100, Linus Torvalds wrote:
> The IOMMU should not be reprogrammed until _after_ we have handled and 
> re-initialized all the devices, so I really think the problem is the IOMMU 
> code, not the USB code.

The IOMMU init is happening in the right place, I think. It has to be
before device_initcall(), because it has to be set up before we actually
start initialising devices -- we have to have the IOMMU in place before
any real drivers try to set up DMA mappings.

It's currently fs_initcall(), with an explicit comment saying that it
has to be after PCI initialisation. The only way it could be later is if
we move it to rootfs_initcall().

> (Of course, the underlying problem is that USB legacy mode handling by 
> BIOS with SMM is some seriously insane crap, no question about that. At 
> the same time, the IOMMU code is just clearly wrong in removing the legacy 
> mappings before we have initialized all devices, so the revert is simply 
> the right thing to do)

Well, according to the design, the IOMMU code is doing the right thing¹.

The theory is that the BIOS _tells_ us about the legacy mappings it
needs by putting them in an ACPI table (the RMRR table). Of course, the
reality is that BIOSes are universally shit and often fail to do this.

If the BIOSes were only _slightly_ shit, there'd be a few harmless DMA
faults and the legacy USB would stop of its own accord. But no, a bunch
of them also manage to lock up in SMM mode when their DMA goes AWOL.

The only viable solution (short of an open source BIOS written by sober
people) was to quiesce the USB controllers before enabling the IOMMU.

The final PCI quirks are currently run from pci_init() which is a
device_initcall(), which is too late -- in fact, it could actually be
_after_ some of the real device drivers have taken control of the same
hardware.

So the better fix is probably just to fix that problem -- move the final
PCI quirks so they happen a little earlier. If we move them to
fs_initcall_sync() and then move the IOMMU init to rootfs_initcall(),
then everything ought to work, I think...

(Let's rename 'pci_init()' and move it to quirks.c while we're at it,
since it only actually does that one thing. If/when I submit this
properly, I'll do that in a separate commit.)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 64b838e..e0d9199 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -311,7 +311,7 @@ void pci_iommu_shutdown(void)
 	amd_iommu_shutdown();
 }
 /* Must execute after PCI subsystem */
-fs_initcall(pci_iommu_init);
+rootfs_initcall(pci_iommu_init);
 
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6edecff..2b575cf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2719,17 +2719,6 @@ int __attribute__ ((weak)) pci_ext_cfg_avail(struct pci_dev *dev)
 	return 1;
 }
 
-static int __devinit pci_init(void)
-{
-	struct pci_dev *dev = NULL;
-
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		pci_fixup_device(pci_fixup_final, dev);
-	}
-
-	return 0;
-}
-
 static int __init pci_setup(char *str)
 {
 	while (str) {
@@ -2767,8 +2756,6 @@ static int __init pci_setup(char *str)
 }
 early_param("pci", pci_setup);
 
-device_initcall(pci_init);
-
 EXPORT_SYMBOL(pci_reenable_device);
 EXPORT_SYMBOL(pci_enable_device_io);
 EXPORT_SYMBOL(pci_enable_device_mem);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6099fac..d99c9b4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2572,6 +2572,19 @@ void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 	}
 	pci_do_fixups(dev, start, end);
 }
+
+static int __devinit pci_apply_final_quirks(void)
+{
+	struct pci_dev *dev = NULL;
+
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		pci_fixup_device(pci_fixup_final, dev);
+	}
+
+	return 0;
+}
+
+fs_initcall_sync(pci_apply_final_quirks);
 #else
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev) {}
 #endif


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

¹ Yes, the design is completely broken. Anyone with any real-world
  experience would have known that the BIOS would never get this right.
  Personally, I find that it's useful to assume malice on the part of
  BIOS authors. I'm not suggesting that it's actually _true_, but it
  does tend to give a useful predictor of _just_ how badly they're going
  to screw things up.



