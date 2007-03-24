Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbXCXSKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbXCXSKS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 14:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXCXSKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 14:10:18 -0400
Received: from outbound-mail-30.bluehost.com ([69.89.17.212]:38098 "HELO
	outbound-mail-30.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753460AbXCXSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 14:10:16 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Mar 2007 14:10:16 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] fix sysfs rom file creation for BIOS ROM shadows
Date: Sat, 24 Mar 2007 11:03:32 -0700
User-Agent: KMail/1.9.6
Cc: Eric Anholt <eric@anholt.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703241103.33208.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At one time, if a BIOS ROM shadow was detected for the boot video
device (stored at offset 0xc0000), we'd set a special resource flag,
IORESOURCE_ROM_SHADOW, so that the sysfs ROM file code could handle
it properly.  That broke along the way somewhere though, so current
kernels will be missing 'rom' files in sysfs if the video device
doesn't have an explicit ROM BAR.

This patch fixes the regression by moving the video fixup quirk to a
little later in the boot cycle (to avoid having its work undone by
PCI resource allocation) and checking in the PCI sysfs code whether
a rom file should be created due to a shadow resource, which is also
moved to a little later in the boot cycle so it will occur after the
video fixup.  Tested and works on my i386 test box.

Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>

diff -Napur -X /home/jbarnes/dontdiff linux-2.6.21-rc4/arch/i386/pci/fixup.c linux-2.6.21-rc4-modesetting/arch/i386/pci/fixup.c
--- linux-2.6.21-rc4/arch/i386/pci/fixup.c	2007-03-15 17:20:01.000000000 -0700
+++ linux-2.6.21-rc4-modesetting/arch/i386/pci/fixup.c	2007-03-24 10:46:57.000000000 -0700
@@ -354,7 +354,7 @@ static void __devinit pci_fixup_video(st
 		printk(KERN_DEBUG "Boot video device is %s\n", pci_name(pdev));
 	}
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
+DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
 
 /*
  * Some Toshiba laptops need extra code to enable their TI TSB43AB22/A.
diff -Napur -X /home/jbarnes/dontdiff linux-2.6.21-rc4/drivers/pci/pci-sysfs.c linux-2.6.21-rc4-modesetting/drivers/pci/pci-sysfs.c
--- linux-2.6.21-rc4/drivers/pci/pci-sysfs.c	2007-03-15 17:20:01.000000000 -0700
+++ linux-2.6.21-rc4-modesetting/drivers/pci/pci-sysfs.c	2007-03-24 10:46:42.000000000 -0700
@@ -620,7 +620,8 @@ int __must_check pci_create_sysfs_dev_fi
 		goto err_bin_file;
 
 	/* If the device has a ROM, try to expose it in sysfs. */
-	if (pci_resource_len(pdev, PCI_ROM_RESOURCE)) {
+	if (pci_resource_len(pdev, PCI_ROM_RESOURCE) ||
+	    (pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW)) {
 		rom_attr = kzalloc(sizeof(*rom_attr), GFP_ATOMIC);
 		if (rom_attr) {
 			pdev->rom_attr = rom_attr;
@@ -695,4 +696,4 @@ static int __init pci_sysfs_init(void)
 	return 0;
 }
 
-__initcall(pci_sysfs_init);
+late_initcall(pci_sysfs_init);
