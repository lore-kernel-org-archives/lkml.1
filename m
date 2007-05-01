Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXEAPAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXEAPAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXEAPAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:00:24 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:44012 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXEAO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:59:49 -0400
Date: Tue, 1 May 2007 16:59:47 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, davej@codemonkey.org.uk,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       kernel list <linux-kernel@vger.kernel.org>, andi@lisas.de
Subject: [PATCH -mm] working 3D/DRI intel-agp.ko resume for i815 chip; Intel chipset testers wanted! (was: Re: intel-agp PM experiences ...)
Message-ID: <20070501145947.GA19953@rhlx01.hs-esslingen.de>
References: <20070116135727.GA2831@elf.ucw.cz> <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070118231650.GA5352@ucw.cz>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 18, 2007 at 11:16:51PM +0000, Pavel Machek wrote:
> Hi!
> 
> > > > Especially the PCI video_state trick finally got me a working resume on
> > > > 2.6.19-ck2 r128 Rage Mobility M4 AGP *WITH*(!) fully enabled and working
> > > > (and keeping working!) DRI (3D).
> > > 
> > > Can we get whitelist entry for suspend.sf.net? s2ram from there can do
> > > all the tricks you described, one letter per trick :-). We even got
> > > PCI saving lately.
> > 
> > Whitelist? Let me blacklist it all the way to Timbuktu instead!
> 
> > I've been doing more testing, and X never managed to come back to working
> > state without some of my couple intel-agp changes:
> > - a proper suspend method, doing a proper pci_save_state()
> >   or improved equivalent
> > - a missing resume check for my i815 chipset
> > - global cache flush in _configure
> > - restoring AGP bridge PCI config space
> 
> Can you post a patch?

Took way longer than I'd have wanted it to (nice daughter and stuff ;),
but here it is.

- add .suspend handler and pci_set_power_state() calls
- add i815-specific function agp_i815_remember_state() to remember important
  i815 register values
- add generic DEBUG_AGP_PM framework which will allow people to resume properly
  and help identify which registers need attention
- add obvious and detailed log message to make people sit up and take notice
  about long-standing AGP resume issues
- spelling fixes

Patch against 2.6.21-rc7-mm2, my Inspiron 8000 (i815 with Radeon AGP card,
internal Intel VGA unit NOT active) resumes fine with both
either i815-specific register saving or generic DEBUG_AGP_PM mechanism enabled.
(of course my notebook needs vbetool post and manual saving of video card
PCI space, too, but even when doing all this I still had X.org lockups before
whenever DRI/3D was enabled)

After resume I'm now still able to run both glxgears and glxinfo without
anomalies.

Right now all I care about is that this gets into mainline relatively soon,
since I'm rather certain that many other machines suffer from similar
AGP resume lockup issues that could be debugged this way (e.g. some Thinkpads,
as witnessed accidentally via IRC chats, and from the well-known "don't enable
DRI, that will lock up on resume!" chants).
Yes, this code is a cludge and somewhat far from a nicely generic
extended PCI space resume framework, but we've spent almost 10 (TEN!) years
without anything even remotely resembling a working cludge for
AGP suspend/resume in combination with DRI, so...

Feel free to offer thoughts on how this missing generic extended PCI space
restore functionality could be implemented, to be used by intel-agp and
various other drivers. No promise that it will be me who implements that,
though ;)

> Whitelist entry would still be welcome.

OK, I'll work on this next.


Thanks!

Signed-off-by: Andreas Mohr <andi@lisas.de>


--- linux-2.6.21-rc7-mm2.orig/drivers/char/agp/intel-agp.c	2007-05-10 14:52:26.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/char/agp/intel-agp.c	2007-05-10 14:31:48.000000000 +0200
@@ -31,9 +31,16 @@
 extern int agp_memory_reserved;
 
 
-/* Intel 815 register */
-#define INTEL_815_APCONT	0x51
-#define INTEL_815_ATTBASE_MASK	~0x1FFFFFFF
+/* Intel i815 registers, see Intel spec #29068801 */
+#define I815_GMCHCFG		0x50
+#define I815_APCONT		0x51
+#define I815_UNKNOWN_80		0x80
+#define I815_ATTBASE_MASK	~0x1FFFFFFF
+#define I815_SM_RCOMP		0x98 /* Sys Mem R Compensation Ctrl */
+#define I815_SM			0x9c /* System Memory Control Reg */
+#define I815_AGPCMD		0xa8 /* AGP Command Register */
+#define I815_ERRSTS		0xc8 /* undocumented in i815 spec; since this one is modified on resume and many other related chipsets have it, I assume it *is* ERRSTS */
+#define I815_UNKNOWN_E8		0xe8
 
 /* Intel i820 registers */
 #define INTEL_I820_RDCR		0x51
@@ -664,7 +671,7 @@
 	if ((pg_start + mem->page_count) > num_entries)
 		goto out_err;
 
-	/* The i830 can't check the GTT for entries since its read only,
+	/* The i830 can't check the GTT for entries since it's read-only,
 	 * depend on the caller to make the correct offset decisions.
 	 */
 
@@ -787,7 +794,7 @@
 	if ((pg_start + mem->page_count) > num_entries)
 		goto out_err;
 
-	/* The i915 can't check the GTT for entries since its read only,
+	/* The i915 can't check the GTT for entries since it's read-only,
 	 * depend on the caller to make the correct offset decisions.
 	 */
 
@@ -1103,8 +1110,8 @@
 	/* attbase - aperture base */
 	/* the Intel 815 chipset spec. says that bits 29-31 in the
 	* ATTBASE register are reserved -> try not to write them */
-	if (agp_bridge->gatt_bus_addr & INTEL_815_ATTBASE_MASK) {
-		printk (KERN_EMERG PFX "gatt bus addr too high");
+	if (agp_bridge->gatt_bus_addr & I815_ATTBASE_MASK) {
+		printk (KERN_EMERG PFX "gatt bus addr too high\n");
 		return -EINVAL;
 	}
 
@@ -1119,7 +1126,7 @@
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 
 	pci_read_config_dword(agp_bridge->dev, INTEL_ATTBASE, &addr);
-	addr &= INTEL_815_ATTBASE_MASK;
+	addr &= I815_ATTBASE_MASK;
 	addr |= agp_bridge->gatt_bus_addr;
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, addr);
 
@@ -1127,8 +1134,8 @@
 	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
 
 	/* apcont */
-	pci_read_config_byte(agp_bridge->dev, INTEL_815_APCONT, &temp2);
-	pci_write_config_byte(agp_bridge->dev, INTEL_815_APCONT, temp2 | (1 << 1));
+	pci_read_config_byte(agp_bridge->dev, I815_APCONT, &temp2);
+	pci_write_config_byte(agp_bridge->dev, I815_APCONT, temp2 | (1 << 1));
 
 	/* clear any possible error conditions */
 	/* Oddness : this chipset seems to have no ERRSTS register ! */
@@ -1355,7 +1362,7 @@
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
 
 	/* agpctrl */
-	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
+	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x00000000);
 
 	/* mchcfg */
 	pci_read_config_word(agp_bridge->dev, INTEL_I7505_MCHCFG, &temp2);
@@ -2011,12 +2018,178 @@
 }
 
 #ifdef CONFIG_PM
+
+static int agp_i815_remember_state(struct pci_dev *pdev, int restore)
+{
+	typedef struct {
+		int reg;
+		u32 value;
+	} saved_regs;
+
+	/* Dell Inspiron 8000 BIOS rev. A23 needs the following registers saved
+	 * to be able to successfully restore X11 when AGP 3D is enabled
+	 * (register values given are after resume vs. before suspend):
+	 *
+	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global Enable) of I815_APCONT (0x51),
+	 *              thus use I815_GMCHCFG (0x50) as 32bit base register); 0x4fdd0040 instead of 0x4fdd0240
+	 * ??? (0x80); 0x07ce1cde instead of 0x07cb94de
+	 * I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
+	 * I815_SM (0x9c); 0x00c48405 instead of 0x04848405
+	 * I815_AGPCMD (0xa8); 0x00000000 instead of 0x00000304
+	 * INTEL_AGPCTRL (0xb0); 0x00000000 instead of 0x00000080
+	 * INTEL_APSIZE (0xb4);
+	 * INTEL_ATTBASE (0xb8); 0x00000000 instead of 0x024b0000
+	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above); 0x00000000 instead of 0x00000800
+	 * ??? (0xe8); 0x1c700000 instead of 0x18500000
+	 *
+	 * Other machines/chipsets/BIOS versions may require
+	 * a different set of registers to be properly saved.
+	 */
+	static saved_regs i815_saved_regs[] = {
+		{ I815_UNKNOWN_80, 0 },
+		{ I815_GMCHCFG, 0 },
+		{ I815_SM_RCOMP, 0 },
+		{ I815_SM, 0 },
+		{ I815_AGPCMD, 0 },
+		{ INTEL_AGPCTRL, 0 },
+		{ INTEL_APSIZE, 0 },
+		{ INTEL_ATTBASE, 0 },
+		{ I815_ERRSTS, 0 },
+		{ I815_UNKNOWN_E8, 0 },
+		{ 0, 0 }, /* DELIMITER */
+	};
+	saved_regs *p;
+
+	if (restore) {
+		u32 val;
+		for (p = i815_saved_regs; (p->reg != 0); p++)
+		{
+			pci_read_config_dword(pdev, p->reg, &val);
+			if (val != p->value) {
+				printk(KERN_DEBUG "AGP: Writing back config space on "
+					"device %s at offset %x (was %x, writing %x)\n",
+					pci_name(pdev), p->reg,
+					val, p->value);
+				pci_write_config_dword(pdev, p->reg,
+					p->value);
+			}
+		}	
+	} else {
+		for (p = i815_saved_regs; (p->reg != 0); p++)
+			pci_read_config_dword(pdev, p->reg, &p->value);
+	}
+	return 1;
+}
+
+/*
+ * set DEBUG_AGP_PM to 1 if your AGP chipset has issues resuming
+ * (machine lockups due to non-restored hardware registered values),
+ * then figure out from the log which registers have to be restored manually,
+ * then add specific support for your chipset, similar to what already exists
+ * for i815 (Dell Inspiron) above.
+ * E.g. IBM X31 (i855PM) seems to still have intel-agp suspend issues, too.
+ *
+ * Once it's obvious which chipsets need which treatment
+ * (this is an important step to gain knowledge about all chipsets!)
+ * this stop-gap code handling (we need something that works NOW,
+ * since we could have had it almost a decade ago already!)
+ * should be cleaned up, probably by implementing a generic Linux
+ * PCI function to save/restore extended PCI config space
+ * by supplying a register array or so...
+ * At this point, it would also be nice to clean up the _suspend()/_resume() functions
+ * to use some non-ugly and nicely generic restore mechanism.
+ */
+#define DEBUG_AGP_PM 0
+
+#if DEBUG_AGP_PM
+static u32 pci_cfg_space[64];
+
+static void agp_intel_suspend_debug(struct pci_dev *pdev, pm_message_t state)
+{
+	int i;
+	for (i = 63; i >= 0; i--)
+		pci_read_config_dword(pdev, i * 4, &pci_cfg_space[i]);
+}
+
+static void agp_intel_resume_debug(struct pci_dev *pdev)
+{
+	int i;
+	int val;
+
+	/* Try first reading main PCI config space, then extended space;
+	 * this order should hopefully prevent any lockups that may easily
+	 * occur otherwise.
+	 */
+	for (i = 15; i >= 0; i--) {
+		pci_read_config_dword(pdev, i * 4, &val);
+		if (val != pci_cfg_space[i]) {
+			/* Who the *** decided (in PM code) that logging
+			 * register offsets in very weird offset notation
+			 * (extremely uncommon in PCI datasheet spheres) was a good idea?
+			 * Fixing this in this AGP-specific log message by multiplying offsets
+			 */
+			int reg = i * sizeof(u32);
+			printk(KERN_DEBUG "AGP: Writing back config space on "
+				"device %s at offset %x (was %x, writing %x)\n",
+				pci_name(pdev), reg,
+				val, pci_cfg_space[i]);
+			pci_write_config_dword(pdev, reg,
+				pci_cfg_space[i]);
+		}
+	}
+	for (i = 63; i >= 16; i--) {
+		pci_read_config_dword(pdev, i * 4, &val);
+		if (val != pci_cfg_space[i]) {
+			int reg = i * sizeof(u32);
+			printk(KERN_DEBUG "AGP: Writing back config space on "
+				"device %s at offset %x (was %x, writing %x)\n",
+				pci_name(pdev), reg,
+				val, pci_cfg_space[i]);
+			pci_write_config_dword(pdev, reg,
+				pci_cfg_space[i]);
+		}
+	}
+}
+#else
+static inline void agp_intel_suspend_debug(struct pci_dev *pdev, pm_message_t state) { }
+static inline void agp_intel_resume_debug(struct pci_dev *pdev) { }
+#endif /* DEBUG_AGP_PM */
+
+
+static int agp_intel_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
+
+	if (bridge->driver == &intel_815_driver)
+		agp_i815_remember_state(pdev, 0);
+
+	agp_intel_suspend_debug(pdev, state);
+
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
 static int agp_intel_resume(struct pci_dev *pdev)
 {
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
 
+	/* This ought to be enough meat in here to let us
+	 * resume successfully, at least when also being helped
+	 * by additional manual /sys/bus/pci/DEVICE recovering
+	 * of the graphics card and "vbetool post"
+	 * (the s2ram tool should do this nicely already)
+	 */
+
+	pci_set_power_state (pdev, PCI_D0);
 	pci_restore_state(pdev);
 
+	agp_intel_resume_debug(pdev);
+
+	if (bridge->driver == &intel_815_driver)
+		agp_i815_remember_state(pdev, 1);
+
 	/* We should restore our graphics device's config space,
 	 * as host bridge (00:00) resumes before graphics device (02:00),
 	 * then our access to its pci space can work right.
@@ -2038,6 +2211,8 @@
 		intel_i915_configure();
 	else if (bridge->driver == &intel_830_driver)
 		intel_i830_configure();
+	/* Please no entry for i815 here since it already has
+	 * specific resume support above */
 	else if (bridge->driver == &intel_810_driver)
 		intel_i810_configure();
 	else if (bridge->driver == &intel_i965_driver)
@@ -2045,7 +2220,7 @@
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_PM */
 
 static struct pci_device_id agp_intel_pci_table[] = {
 #define ID(x)						\
@@ -2098,6 +2273,7 @@
 	.probe		= agp_intel_probe,
 	.remove		= __devexit_p(agp_intel_remove),
 #ifdef CONFIG_PM
+	.suspend	= agp_intel_suspend,
 	.resume		= agp_intel_resume,
 #endif
 };
@@ -2106,6 +2282,12 @@
 {
 	if (agp_off)
 		return -EINVAL;
+	/* let people know that this is an important place to investigate at in case of resume lockups */
+	printk(KERN_INFO PFX
+		"suspend/resume of intel-agp.ko is NOT always stable for all Intel AGP\n"
+		"chipset/BIOS combos, may cause resume lockups when DRI (3D accel) active,\n"
+		"in AGP (non-PCI) mode! (see DEBUG_AGP_PM in intel-agp.c source to investigate)\n"
+	);
 	return pci_register_driver(&agp_intel_pci_driver);
 }
 
