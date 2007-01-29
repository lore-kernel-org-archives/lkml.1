Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbXA2Va4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbXA2Va4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXA2Vaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:30:55 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49329 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbXA2Vay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:30:54 -0500
Date: Mon, 29 Jan 2007 22:30:53 +0100
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Pavel Machek <pavel@ucw.cz>, andi@lisas.de, davej@codemonkey.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: intel-agp PM experiences (was: 2.6.20-rc5: usb mouse breaks suspend to ram)
Message-ID: <20070129213053.GA14881@rhlx01.hs-esslingen.de>
References: <20070116135727.GA2831@elf.ucw.cz> <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070122044519.GA24398@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070122044519.GA24398@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 22, 2007 at 12:45:19PM +0800, Wang Zhenyu wrote:
> I've post a patch which trys to resolve pci config restore issue, see
> http://lkml.org/lkml/2007/1/16/297. It resolves s3 issue with my 965G machine,
> that my X can come back to live after s3, but I wasn't aware of the issues Andreas
> has noted. It'll be good if more people could try this out. 

[sorry, somewhat late, had complete and utter heating failure at home]

I employed a variant of your patch (added a static i815_dev
to support my i815 chipset). It didn't help, X hung on resume.
PCI IDs of i815 are 0x1130, 0x1131, 0x1132.
I'm having 0x1130 and 0x1131, IOW an i815 system in
"external AGP graphics" mode:
00:00.0 Host bridge: Intel Corporation 82815 815 Chipset Host Bridge and Memory Controller Hub (rev 02)
00:01.0 PCI bridge: Intel Corporation 82815 815 Chipset AGP Bridge (rev 02)

so I need to query 0x1131 instead of PCI_DEVICE_ID_INTEL_82815_CGC
(0x1132) for resume of the proper device, right??
Or am I supposed to restore the PCI space of my *non-builtin*
01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility M4 AGP
card instead?

The diff below (against 2.6.19-ck2 or in fact plain 2.6.19)
shows what I changed from my (working!) version to what I think I
had to do to be compatible with your intentions. OK, not quite,
I now merely disabled the suspend/restore of the full PCI space,
several other parts remained the same.

IOW, suspending/restoring the *full* PCI space of my Host Bridge
helped, whereas restoring the standard PCI space of my Host Bridge
plus restoring the PCI space of the AGP bridge as you suggested
did NOT.

Can we conclude from that that I'm having rather different issues
than you?

I think this means that we are required/supposed to backup
the entire PCI space of host bridges, right? How to actually implement
this cleanly? Oh, and of course my patch manages to fix the X11
lockup only, actual video is still garbled and requires
vbetool magic to get it fixed, too...

Thanks,

Andreas Mohr

--- intel-agp.c	2007-02-07 21:50:49.000000000 +0100
+++ intel-agp.c.2619ck2.patched	2007-02-07 21:50:04.000000000 +0100
@@ -1666,6 +1666,9 @@
 	return 1;
 }
 
+static struct pci_dev *i815_dev;
+
+
 static int __devinit agp_intel_probe(struct pci_dev *pdev,
 				     const struct pci_device_id *ent)
 {
@@ -1719,7 +1722,10 @@
 		if (find_i810(PCI_DEVICE_ID_INTEL_82815_CGC))
 			bridge->driver = &intel_810_driver;
 		else
+		{
+			i815_dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x1131, NULL);
 			bridge->driver = &intel_815_driver;
+		}
 		name = "i815";
 		break;
 	case PCI_DEVICE_ID_INTEL_82820_HB:
@@ -1921,12 +1927,62 @@
 }
 
 #ifdef CONFIG_PM
+
+#if 0
+static u32 pci_cfg_space[64];
+
+static int agp_intel_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int i;
+	for (i = 0; i <= 63; i++)
+		pci_read_config_dword(pdev, i * 4, &pci_cfg_space[i]);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	printk(KERN_INFO "agp_intel_suspend\n");
+
+	return 0;
+}
+#endif
+
 static int agp_intel_resume(struct pci_dev *pdev)
 {
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
+	int i;
+	int val;
 
+	pci_set_power_state (pdev, PCI_D0);
 	pci_restore_state(pdev);
 
+	if (i815_dev)
+		pci_restore_state(i815_dev);
+
+#if 0
+	for (i = 15; i >= 0; i--) {
+		pci_read_config_dword(pdev, i * 4, &val);
+		if (val != pci_cfg_space[i]) {
+			printk(KERN_DEBUG "AGP: Writing back config space on "
+				"device %s at offset %x (was %x, writing %x)\n",
+				pci_name(pdev), i,
+				val, pci_cfg_space[i]);
+			pci_write_config_dword(pdev, i * 4,
+				pci_cfg_space[i]);
+		}
+	}
+	for (i = 63; i >= 16; i--) {
+		pci_read_config_dword(pdev, i * 4, &val);
+		if (val != pci_cfg_space[i]) {
+			printk(KERN_DEBUG "AGP: Writing back config space on "
+				"device %s at offset %x (was %x, writing %x)\n",
+				pci_name(pdev), i,
+				val, pci_cfg_space[i]);
+			pci_write_config_dword(pdev, i * 4,
+				pci_cfg_space[i]);
+		}
+	}
+#endif
+
+	printk(KERN_INFO "agp bridge is %04x\n", agp_bridge->dev->device);
+
 	if (bridge->driver == &intel_generic_driver)
 		intel_configure();
 	else if (bridge->driver == &intel_850_driver)
@@ -1939,6 +1995,8 @@
 		intel_i915_configure();
 	else if (bridge->driver == &intel_830_driver)
 		intel_i830_configure();
+	else if (bridge->driver == &intel_815_driver)
+		intel_815_configure();
 	else if (bridge->driver == &intel_810_driver)
 		intel_i810_configure();
 	else if (bridge->driver == &intel_i965_driver)
@@ -1998,6 +2056,7 @@
 	.probe		= agp_intel_probe,
 	.remove		= __devexit_p(agp_intel_remove),
 #ifdef CONFIG_PM
+	//.suspend	= agp_intel_suspend,
 	.resume		= agp_intel_resume,
 #endif
 };

Andreas Mohr
