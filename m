Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYJ2WOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYJ2WOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYJ2WOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:14:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58850 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYJ2WOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:14:09 -0400
Date: Wed, 29 Oct 2008 23:15:41 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, linux-stable@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 2.6.25] prevent suspend when iommu is used
Message-ID: <20081029221541.GA6670@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit cd76374e9de4501acc74f833dc6cb5e7a5dca115
Author: Pavel Machek <pavel@suse.cz>
Date:   Thu May 29 00:30:21 2008 -0700

    suspend-vs-iommu: prevent suspend if we could not resume
    
    iommu/gart support misses suspend/resume code, which can do bad stuff,
    including memory corruption on resume.  Prevent system suspend in case we
    would be unable to resume.
    
Signed-off-by: Pavel Machek <pavel@suse.cz>
Tested-by: Patrick <ragamuffin@datacomm.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c07455d..aa8ec92 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -26,6 +26,7 @@ #include <linux/bitops.h>
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <linux/sysdev.h>
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
@@ -548,6 +549,28 @@ static __init unsigned read_aperture(str
 	return aper_base;
 }
 
+static int gart_resume(struct sys_device *dev)
+{
+	return 0;
+}
+
+static int gart_suspend(struct sys_device *dev, pm_message_t state)
+{
+	return -EINVAL;
+}
+
+static struct sysdev_class gart_sysdev_class = {
+	.name = "gart",
+	.suspend = gart_suspend,
+	.resume = gart_resume,
+
+};
+
+static struct sys_device device_gart = {
+	.id	= 0,
+	.cls	= &gart_sysdev_class,
+};
+
 /*
  * Private Northbridge GATT initialization in case we cannot use the
  * AGP driver for some reason.
@@ -558,7 +581,7 @@ static __init int init_k8_gatt(struct ag
 	unsigned aper_base, new_aper_base;
 	struct pci_dev *dev;
 	void *gatt;
-	int i;
+	int i, error;
 
 	printk(KERN_INFO "PCI-DMA: Disabling AGP.\n");
 	aper_size = aper_base = info->aper_size = 0;
@@ -606,6 +629,12 @@ static __init int init_k8_gatt(struct ag
 
 		pci_write_config_dword(dev, 0x90, ctl);
 	}
+
+	error = sysdev_class_register(&gart_sysdev_class);
+	if (!error)
+		error = sysdev_register(&device_gart);
+	if (error)
+		panic("Could not register gart_sysdev -- would corrupt data on next suspend");
 	flush_gart();
 
 	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
