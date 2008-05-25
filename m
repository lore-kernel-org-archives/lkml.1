Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbYEYVJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbYEYVJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 17:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYEYVJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 17:09:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37797 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbYEYVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 17:09:42 -0400
Date: Sun, 25 May 2008 23:10:16 +0200
From: Pavel Machek <pavel@suse.cz>
To: Patrick <ragamuffin@datacomm.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
Message-ID: <20080525211016.GA32478@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain> <20080525173825.GA4132@ucw.cz> <1211746106.6188.57.camel@localhost.localdomain> <20080525203921.GB18781@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525203921.GB18781@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > iommu problem? Try it with mem=3G.
> > 
> > YES! :-) How did you know?
> 
> Guess how... I hit it myself.
> 
> > So how are we going to get this fixed???
> 
> Write a patch, submit it? ;-).

Can you try this one? It should prevent suspend in the broken cases,
but allow it in mem=4G config.

								Pavel

iommu/gart support misses suspend/resume code, which can do bad stuff,
including memory corruption on resume. Prevent system suspend in case
we would be unable to resume.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 7724af033ea084f0b037ae8a2032da5e40255088
tree 06de661a106ba83a96cab2ee0e76e3f3c44823ab
parent e9f4353b46ec2b05f73e1a84085c305de211bd3e
author Pavel <pavel@amd.ucw.cz> Sun, 25 May 2008 23:08:17 +0200
committer Pavel <pavel@amd.ucw.cz> Sun, 25 May 2008 23:08:17 +0200

 arch/x86/kernel/pci-gart_64.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 620ec3a..926af9c 100644
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
@@ -595,6 +618,12 @@ static __init int init_k8_gatt(struct ag
 		dev = k8_northbridges[i];
 		enable_gart_translation(dev, __pa(gatt));
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
