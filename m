Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbXEJGoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbXEJGoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXEJGof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:44:35 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57430 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbXEJGod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:44:33 -0400
Date: Thu, 10 May 2007 08:44:32 +0200
From: Andreas Mohr <andim2@users.sourceforge.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, Andrew Morton <akpm@osdl.org>,
       davej@codemonkey.org.uk, dri-devel <dri-devel@lists.sourceforge.net>,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] working 3D/DRI intel-agp.ko resume for i815 chip; Intel chipset testers wanted! (was: Re: intel-agp PM experiences ...)
Message-ID: <20070510064432.GA26461@rhlx01.hs-esslingen.de>
Reply-To: andi@lisas.de
References: <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070501145947.GA19953@rhlx01.hs-esslingen.de> <20070502101718.GC10245@elf.ucw.cz> <20070505175605.GA24615@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505175605.GA24615@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 05, 2007 at 07:56:05PM +0200, Andreas Mohr wrote:
> Due to the "scathing" (well, thorough ;) code review I'll send a patch
> with those cleanups against 2.6.21-mm1 very soon.

working 3D/DRI intel-agp.ko resume for i815 chip cleanup patch:

- revert register define name change to ease backporting etc.
- shorten resume issues warning message to two lines while still preserving
  all required information (use many shorter words)


I'm not ultimately sure about the register define names, since there's
a general inconsistency in naming here which perhaps would be a good idea
to resolve (my original renaming happened to decrease inconsistency but didn't
quite get rid of it, so it was kind of useless to do it...).

The warning message, while definitely ugly (and that's its job ;), IMHO is
very important to make knowledgeable people see where the problem is.
Those people, if they experience issues, WILL look at kernel logs...

Splitting the remember_state function in two parts isn't very useful given
that it's supposed to be a temporary, "make it work at all" measure only
until there's generic save/restore support (I want to keep this "debug"
code at a minimum). Once there's further chipset data and/or information
how to implement this cleanly, I'm definitely interested in continuing that.

Run-tested on 2.6.21-mm2, resumes fine.

Signed-off-by: Andreas Mohr <andi@lisas.de>


--- linux-2.6.21-mm2/drivers/char/agp/intel-agp.c	2007-05-19 06:25:00.000000000 +0200
+++ linux-2.6.21-mm2.agp/drivers/char/agp/intel-agp.c	2007-05-19 06:23:51.000000000 +0200
@@ -32,15 +32,15 @@
 
 
 /* Intel i815 registers, see Intel spec #29068801 */
-#define I815_GMCHCFG		0x50
-#define I815_APCONT		0x51
-#define I815_UNKNOWN_80		0x80
-#define I815_ATTBASE_MASK	~0x1FFFFFFF
-#define I815_SM_RCOMP		0x98 /* Sys Mem R Compensation Ctrl */
-#define I815_SM			0x9c /* System Memory Control Reg */
-#define I815_AGPCMD		0xa8 /* AGP Command Register */
-#define I815_ERRSTS		0xc8 /* undocumented in i815 spec; since this one is modified on resume and many other related chipsets have it, I assume it *is* ERRSTS */
-#define I815_UNKNOWN_E8		0xe8
+#define INTEL_I815_GMCHCFG	0x50
+#define INTEL_I815_APCONT	0x51
+#define INTEL_I815_UNKNOWN_80	0x80
+#define INTEL_I815_ATTBASE_MASK	~0x1FFFFFFF
+#define INTEL_I815_SM_RCOMP	0x98 /* Sys Mem R Compensation Ctrl */
+#define INTEL_I815_SM		0x9c /* System Memory Control Reg */
+#define INTEL_I815_AGPCMD	0xa8 /* AGP Command Register */
+#define INTEL_I815_ERRSTS	0xc8 /* undocumented in i815 spec; since this one is modified on resume and many other related chipsets have it, I assume it *is* ERRSTS */
+#define INTEL_I815_UNKNOWN_E8	0xe8
 
 /* Intel i820 registers */
 #define INTEL_I820_RDCR		0x51
@@ -1110,7 +1110,7 @@
 	/* attbase - aperture base */
 	/* the Intel 815 chipset spec. says that bits 29-31 in the
 	* ATTBASE register are reserved -> try not to write them */
-	if (agp_bridge->gatt_bus_addr & I815_ATTBASE_MASK) {
+	if (agp_bridge->gatt_bus_addr & INTEL_I815_ATTBASE_MASK) {
 		printk (KERN_EMERG PFX "gatt bus addr too high\n");
 		return -EINVAL;
 	}
@@ -1126,7 +1126,7 @@
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 
 	pci_read_config_dword(agp_bridge->dev, INTEL_ATTBASE, &addr);
-	addr &= I815_ATTBASE_MASK;
+	addr &= INTEL_I815_ATTBASE_MASK;
 	addr |= agp_bridge->gatt_bus_addr;
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, addr);
 
@@ -1134,8 +1134,8 @@
 	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
 
 	/* apcont */
-	pci_read_config_byte(agp_bridge->dev, I815_APCONT, &temp2);
-	pci_write_config_byte(agp_bridge->dev, I815_APCONT, temp2 | (1 << 1));
+	pci_read_config_byte(agp_bridge->dev, INTEL_I815_APCONT, &temp2);
+	pci_write_config_byte(agp_bridge->dev, INTEL_I815_APCONT, temp2 | (1 << 1));
 
 	/* clear any possible error conditions */
 	/* Oddness : this chipset seems to have no ERRSTS register ! */
@@ -2018,7 +2018,6 @@
 }
 
 #ifdef CONFIG_PM
-
 static int agp_i815_remember_state(struct pci_dev *pdev, int restore)
 {
 	typedef struct {
@@ -2030,18 +2029,18 @@
 	 * to be able to successfully restore X11 when AGP 3D is enabled
 	 * (register values given are after resume vs. before suspend):
 	 *
-	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global
-	 *              Enable) of I815_APCONT (0x51),
-	 *              thus use I815_GMCHCFG (0x50) as 32bit base register);
+	 * INTEL_I815_GMCHCFG (0x50; we need to set bit 1
+	 * (Aperture Access Global Enable) of INTEL_I815_APCONT (0x51),
+	 *  thus use INTEL_I815_GMCHCFG (0x50) as 32bit base register);
 	 *              0x4fdd0040 instead of 0x4fdd0240
 	 * ??? (0x80); 0x07ce1cde instead of 0x07cb94de
-	 * I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
-	 * I815_SM (0x9c); 0x00c48405 instead of 0x04848405
-	 * I815_AGPCMD (0xa8); 0x00000000 instead of 0x00000304
+	 * INTEL_I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
+	 * INTEL_I815_SM (0x9c); 0x00c48405 instead of 0x04848405
+	 * INTEL_I815_AGPCMD (0xa8); 0x00000000 instead of 0x00000304
 	 * INTEL_AGPCTRL (0xb0); 0x00000000 instead of 0x00000080
 	 * INTEL_APSIZE (0xb4);
 	 * INTEL_ATTBASE (0xb8); 0x00000000 instead of 0x024b0000
-	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above);
+	 * INTEL_I815_ERRSTS?? (0xc8; undocumented for i815, see above);
 	 *              0x00000000 instead of 0x00000800
 	 * ??? (0xe8); 0x1c700000 instead of 0x18500000
 	 *
@@ -2049,23 +2048,23 @@
 	 * a different set of registers to be properly saved.
 	 */
 	static saved_regs i815_saved_regs[] = {
-		{ I815_UNKNOWN_80, 0 },
-		{ I815_GMCHCFG, 0 },
-		{ I815_SM_RCOMP, 0 },
-		{ I815_SM, 0 },
-		{ I815_AGPCMD, 0 },
+		{ INTEL_I815_UNKNOWN_80, 0 },
+		{ INTEL_I815_GMCHCFG, 0 },
+		{ INTEL_I815_SM_RCOMP, 0 },
+		{ INTEL_I815_SM, 0 },
+		{ INTEL_I815_AGPCMD, 0 },
 		{ INTEL_AGPCTRL, 0 },
 		{ INTEL_APSIZE, 0 },
 		{ INTEL_ATTBASE, 0 },
-		{ I815_ERRSTS, 0 },
-		{ I815_UNKNOWN_E8, 0 },
+		{ INTEL_I815_ERRSTS, 0 },
+		{ INTEL_I815_UNKNOWN_E8, 0 },
 		{ 0, 0 }, /* DELIMITER */
 	};
 	saved_regs *p;
 
 	if (restore) {
 		u32 val;
-		for (p = i815_saved_regs; (p->reg != 0); p++) {
+		for (p = i815_saved_regs; p->reg; p++) {
 			pci_read_config_dword(pdev, p->reg, &val);
 			if (val != p->value) {
 				printk(KERN_DEBUG "AGP: Writing back config "
@@ -2078,7 +2077,7 @@
 			}
 		}
 	} else {
-		for (p = i815_saved_regs; (p->reg != 0); p++)
+		for (p = i815_saved_regs; p->reg; p++)
 			pci_read_config_dword(pdev, p->reg, &p->value);
 	}
 	return 1;
@@ -2285,11 +2284,16 @@
 {
 	if (agp_off)
 		return -EINVAL;
-	/* let people know that this is an important place to investigate at in case of resume lockups */
+
+	/* let people know that this is an important place to investigate at
+	 * in case of resume lockups.
+	 * Let's hope we'll be able to kill this message in mid-2008 or so
+	 * once all/most problematic Intel chipset cases have proper 3D resume
+	 * after users reported details.
+	 */
 	printk(KERN_INFO PFX
-		"suspend/resume of intel-agp.ko is NOT always stable for all Intel AGP\n"
-		"chipset/BIOS combos, may cause resume lockups when DRI (3D accel) active,\n"
-		"in AGP (non-PCI) mode! (see DEBUG_AGP_PM in intel-agp.c source to investigate)\n"
+		"suspend/resume problematic: resume with 3D/DRI active may lockup X.Org\n"
+		"on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)\n"
 	);
 	return pci_register_driver(&agp_intel_pci_driver);
 }
