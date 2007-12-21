Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXLUWlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXLUWlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbXLUWlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:41:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47134 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbXLUWli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:41:38 -0500
Date: Fri, 21 Dec 2007 23:40:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, bjorn.helgaas@hp.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch 3/3] PCI: use dev_printk in x86 quirk messages
Message-ID: <20071221224053.GA23289@elte.hu>
References: <20071217210937.103111394@ldl.fc.hp.com> <20071217211337.545932066@ldl.fc.hp.com> <20071218135801.GB17470@elte.hu> <20071221134735.1e0066c9.akpm@linux-foundation.org> <20071221222956.GB24478@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221222956.GB24478@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> > > arch/x86/kernel/quirks.c |   42 ++++++++++++++++++++++--------------------
> > > arch/x86/pci/fixup.c     |   22 +++++++++++-----------
> > 
> > That made it hard.  Arguably one file is PCI tree and the other is 
> > x86 tree.
> 
> Hm, as traditionally we haven't had such an active x86 maintainer, 
> I've handled most of the pci quirk type stuff that people have sent to 
> me in the past :)
> 
> But, now that we have more enthusiastic developers, I can change this. 
> If you want me to cut portions of the patch up, I'll be glad to do so, 
> just let me know.
> 
> It's easy for me when merging, as our tools can handle it just fine, 
> but Andrew is the one with the big problems, so we should probably 
> shake it out on our end first...
> 
> Ingo, what is easiest for you to do?  As I use quilt, I can very 
> simply cut a portion of the patch up, or drop it entirely.

There's one patch right now in x86.git that affects 
arch/x86/kernel/quirks.c and arch/x86/pci/fixup.c - the one from Bjorn. 
(find below)

Are your quirks (and other arch/x86) patches nicely standalone? If yes 
then we could pick them up just fine - patch-bomb me or send a tarball 
or mbox of the patches - whichever is the most convenient for you. (we 
too use quilt as the main repository)

but if there's some dependency on continuing pci/driver infrastructure 
you might be working on then it would be better for you to carry them. 
Or if you'd just like to have Bjorn's patch in one piece. Tell me and 
i'll drop the changes below from x86.git.

In any case, both variants would be fine for us - the important thing is 
to not drop any of the patches on the floor :)

	Ingo

-------------------->
Subject: PCI: use dev_printk in x86 quirk messages
From: bjorn.helgaas@hp.com

Convert quirk printks to dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/quirks.c |   43 +++++++++++++++++++++++--------------------
 arch/x86/pci/fixup.c     |   22 +++++++++++-----------
 2 files changed, 34 insertions(+), 31 deletions(-)

Index: linux-x86.q/arch/x86/kernel/quirks.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/quirks.c
+++ linux-x86.q/arch/x86/kernel/quirks.c
@@ -30,8 +30,8 @@ static void __devinit quirk_intel_irqbal
 	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
-		printk(KERN_INFO "Intel E7520/7320/7525 detected. "
-			"Disabling irq balancing and affinity\n");
+		dev_info(&dev->dev, "Intel E7520/7320/7525 detected; "
+			"disabling irq balancing and affinity\n");
 #ifdef CONFIG_IRQBALANCE
 		irqbalance_disable("");
 #endif
@@ -104,14 +104,16 @@ static void ich_force_enable_hpet(struct
 	pci_read_config_dword(dev, 0xF0, &rcba);
 	rcba &= 0xFFFFC000;
 	if (rcba == 0) {
-		printk(KERN_DEBUG "RCBA disabled. Cannot force enable HPET\n");
+		dev_printk(KERN_DEBUG, &dev->dev, "RCBA disabled; "
+			"cannot force enable HPET\n");
 		return;
 	}
 
 	/* use bits 31:14, 16 kB aligned */
 	rcba_base = ioremap_nocache(rcba, 0x4000);
 	if (rcba_base == NULL) {
-		printk(KERN_DEBUG "ioremap failed. Cannot force enable HPET\n");
+		dev_printk(KERN_DEBUG, &dev->dev, "ioremap failed; "
+			"cannot force enable HPET\n");
 		return;
 	}
 
@@ -122,8 +124,8 @@ static void ich_force_enable_hpet(struct
 		/* HPET is enabled in HPTC. Just not reported by BIOS */
 		val = val & 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+			"0x%lx\n", force_hpet_address);
 		iounmap(rcba_base);
 		return;
 	}
@@ -142,11 +144,12 @@ static void ich_force_enable_hpet(struct
 	if (err) {
 		force_hpet_address = 0;
 		iounmap(rcba_base);
-		printk(KERN_DEBUG "Failed to force enable HPET\n");
+		dev_printk(KERN_DEBUG, &dev->dev,
+			"Failed to force enable HPET\n");
 	} else {
 		force_hpet_resume_type = ICH_FORCE_HPET_RESUME;
-		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+			"0x%lx\n", force_hpet_address);
 	}
 }
 
@@ -206,8 +209,8 @@ static void old_ich_force_enable_hpet(st
 	if (val & 0x4) {
 		val &= 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "HPET at 0x%lx\n",
+			force_hpet_address);
 		return;
 	}
 
@@ -227,14 +230,14 @@ static void old_ich_force_enable_hpet(st
 		/* HPET is enabled in HPTC. Just not reported by BIOS */
 		val &= 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+			"0x%lx\n", force_hpet_address);
 		cached_dev = dev;
 		force_hpet_resume_type = OLD_ICH_FORCE_HPET_RESUME;
 		return;
 	}
 
-	printk(KERN_DEBUG "Failed to force enable HPET\n");
+	dev_printk(KERN_DEBUG, &dev->dev, "Failed to force enable HPET\n");
 }
 
 /*
@@ -292,8 +295,8 @@ static void vt8237_force_enable_hpet(str
 	 */
 	if (val & 0x80) {
 		force_hpet_address = (val & ~0x3ff);
-		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "HPET at 0x%lx\n",
+			force_hpet_address);
 		return;
 	}
 
@@ -307,14 +310,14 @@ static void vt8237_force_enable_hpet(str
 	pci_read_config_dword(dev, 0x68, &val);
 	if (val & 0x80) {
 		force_hpet_address = (val & ~0x3ff);
-		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+			"0x%lx\n", force_hpet_address);
 		cached_dev = dev;
 		force_hpet_resume_type = VT8237_FORCE_HPET_RESUME;
 		return;
 	}
 
-	printk(KERN_DEBUG "Failed to force enable HPET\n");
+	dev_printk(KERN_DEBUG, &dev->dev, "Failed to force enable HPET\n");
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
@@ -342,7 +345,7 @@ static void nvidia_force_enable_hpet(str
 	pci_read_config_dword(dev, 0x44, &val);
 	force_hpet_address = val & 0xfffffffe;
 	force_hpet_resume_type = NVIDIA_FORCE_HPET_RESUME;
-	printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
 		force_hpet_address);
 	cached_dev = dev;
 	return;
Index: linux-x86.q/arch/x86/pci/fixup.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/fixup.c
+++ linux-x86.q/arch/x86/pci/fixup.c
@@ -17,7 +17,7 @@ static void __devinit pci_fixup_i450nx(s
 	int pxb, reg;
 	u8 busno, suba, subb;
 
-	printk(KERN_WARNING "PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
+	dev_warn(&d->dev, "Searching for i450NX host bridges\n");
 	reg = 0xd0;
 	for(pxb=0; pxb<2; pxb++) {
 		pci_read_config_byte(d, reg++, &busno);
@@ -41,7 +41,7 @@ static void __devinit pci_fixup_i450gx(s
 	 */
 	u8 busno;
 	pci_read_config_byte(d, 0x4a, &busno);
-	printk(KERN_INFO "PCI: i440KX/GX host bridge %s: secondary bus %02x\n", pci_name(d), busno);
+	dev_info(&d->dev, "i440KX/GX host bridge; secondary bus %02x\n", busno);
 	pci_scan_bus_with_sysdata(busno);
 	pcibios_last_bus = -1;
 }
@@ -55,7 +55,7 @@ static void __devinit  pci_fixup_umc_ide
 	 */
 	int i;
 
-	printk(KERN_WARNING "PCI: Fixing base address flags for device %s\n", pci_name(d));
+	dev_warn(&d->dev, "Fixing base address flags\n");
 	for(i=0; i<4; i++)
 		d->resource[i].flags |= PCI_BASE_ADDRESS_SPACE_IO;
 }
@@ -68,7 +68,7 @@ static void __devinit  pci_fixup_ncr53c8
 	 * Fix class to be PCI_CLASS_STORAGE_SCSI
 	 */
 	if (!d->class) {
-		printk(KERN_WARNING "PCI: fixing NCR 53C810 class code for %s\n", pci_name(d));
+		dev_warn(&d->dev, "Fixing NCR 53C810 class code\n");
 		d->class = PCI_CLASS_STORAGE_SCSI << 8;
 	}
 }
@@ -80,7 +80,7 @@ static void __devinit  pci_fixup_latency
 	 *  SiS 5597 and 5598 chipsets require latency timer set to
 	 *  at most 32 to avoid lockups.
 	 */
-	DBG("PCI: Setting max latency to 32\n");
+	dev_dbg(&d->dev, "Setting max latency to 32\n");
 	pcibios_max_latency = 32;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_5597, pci_fixup_latency);
@@ -138,7 +138,7 @@ static void pci_fixup_via_northbridge_bu
 
 	pci_read_config_byte(d, where, &v);
 	if (v & ~mask) {
-		printk(KERN_WARNING "Disabling VIA memory write queue (PCI ID %04x, rev %02x): [%02x] %02x & %02x -> %02x\n", \
+		dev_warn(&d->dev, "Disabling VIA memory write queue (PCI ID %04x, rev %02x): [%02x] %02x & %02x -> %02x\n", \
 			d->device, d->revision, where, v, mask, v & mask);
 		v &= mask;
 		pci_write_config_byte(d, where, v);
@@ -200,7 +200,7 @@ static void pci_fixup_nforce2(struct pci
 	 * Apply fixup if needed, but don't touch disconnect state
 	 */
 	if ((val & 0x00FF0000) != 0x00010000) {
-		printk(KERN_WARNING "PCI: nForce2 C1 Halt Disconnect fixup\n");
+		dev_warn(&dev->dev, "nForce2 C1 Halt Disconnect fixup\n");
 		pci_write_config_dword(dev, 0x6c, (val & 0xFF00FFFF) | 0x00010000);
 	}
 }
@@ -348,7 +348,7 @@ static void __devinit pci_fixup_video(st
 	pci_read_config_word(pdev, PCI_COMMAND, &config);
 	if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 		pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
-		printk(KERN_DEBUG "Boot video device is %s\n", pci_name(pdev));
+		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
@@ -388,11 +388,11 @@ static void __devinit pci_fixup_msi_k8t_
 		/* verify the change for status output */
 		pci_read_config_byte(dev, 0x50, &val);
 		if (val & 0x40)
-			printk(KERN_INFO "PCI: Detected MSI K8T Neo2-FIR, "
+			dev_info(&dev->dev, "Detected MSI K8T Neo2-FIR; "
 					"can't enable onboard soundcard!\n");
 		else
-			printk(KERN_INFO "PCI: Detected MSI K8T Neo2-FIR, "
-					"enabled onboard soundcard.\n");
+			dev_info(&dev->dev, "Detected MSI K8T Neo2-FIR; "
+					"enabled onboard soundcard\n");
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
