Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYAKI5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYAKI5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbYAKI5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:57:12 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31391
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758060AbYAKI5K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:57:10 -0500
Message-Id: <47873D87.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 08:57:27 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Greg Kroah-Hartman" <GregKH@novell.com>
Subject: [PATCH 3/4] introduce __devinitconst
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers picked just serve as examples (which I routinely build and
hence am able to easily verify), i.e. as before he patch doesn't change
all instances where 'const' could have been added as a result of the
base change, only where the change has a real effect (the module loader
doesn't enforce read-only section attributes at present, so only
built-in files make a real difference).

For the PCI ID tables a change like this could probably be done almost
globally in drivers/.

The cleaning up of all the invalid uses of 'const' and '__devinitdata'
on the same object could likewise be done in an almost global fashion,
although drivers/ide/pci/ seems to be the most significant violator.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-piix4.c |    4 ++--
 drivers/ide/pci/piix.c         |    2 +-
 drivers/video/aty/aty128fb.c   |    2 +-
 include/linux/init.h           |    2 ++
 4 files changed, 6 insertions(+), 4 deletions(-)

--- 2.6.24-rc7-initconst.orig/drivers/i2c/busses/i2c-piix4.c
+++ 2.6.24-rc7-initconst/drivers/i2c/busses/i2c-piix4.c
@@ -108,7 +108,7 @@ static unsigned short piix4_smba;
 static struct pci_driver piix4_driver;
 static struct i2c_adapter piix4_adapter;
 
-static struct dmi_system_id __devinitdata piix4_dmi_table[] = {
+static struct dmi_system_id __devinitconst piix4_dmi_table[] = {
 	{
 		.ident = "IBM",
 		.matches = { DMI_MATCH(DMI_SYS_VENDOR, "IBM"), },
@@ -388,7 +388,7 @@ static struct i2c_adapter piix4_adapter 
 	.algo		= &smbus_algorithm,
 };
 
-static struct pci_device_id piix4_ids[] = {
+static struct pci_device_id __devinitconst piix4_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3),
 	  .driver_data = 3 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP200_SMBUS),
--- 2.6.24-rc7-initconst.orig/drivers/ide/pci/piix.c
+++ 2.6.24-rc7-initconst/drivers/ide/pci/piix.c
@@ -398,7 +398,7 @@ static void __devinit init_hwif_ich(ide_
 		.udma_mask	= udma, \
 	}
 
-static const struct ide_port_info piix_pci_info[] __devinitdata = {
+static struct ide_port_info __devinitconst piix_pci_info[] = {
 	/*  0 */ DECLARE_PIIX_DEV("PIIXa",	0x00),	/* no udma */
 	/*  1 */ DECLARE_PIIX_DEV("PIIXb",	0x00),	/* no udma */
 
--- 2.6.24-rc7-initconst.orig/drivers/video/aty/aty128fb.c
+++ 2.6.24-rc7-initconst/drivers/video/aty/aty128fb.c
@@ -149,7 +149,7 @@ enum {
 };
 
 /* Must match above enum */
-static const char *r128_family[] __devinitdata = {
+static const char *__devinitconst r128_family[] = {
 	"AGP",
 	"PCI",
 	"PRO AGP",
--- 2.6.24-rc7-initconst.orig/include/linux/init.h
+++ 2.6.24-rc7-initconst/include/linux/init.h
@@ -257,11 +257,13 @@ void __init parse_early_param(void);
 #ifdef CONFIG_HOTPLUG
 #define __devinit
 #define __devinitdata
+#define __devinitconst const
 #define __devexit
 #define __devexitdata
 #else
 #define __devinit __init
 #define __devinitdata __initdata
+#define __devinitconst __initdata
 #define __devexit __exit
 #define __devexitdata __exitdata
 #endif



