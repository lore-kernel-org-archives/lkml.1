Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZGPFI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZGPFI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 01:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZGPFIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 01:08:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:39234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420AbZGPFIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 01:08:55 -0400
Subject: Memory leak issues in drm
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Dave Airlie <airlied@redhat.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>, airlied@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 10:37:57 +0530
Message-Id: <1247720877.2532.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On linus tree, while investigating kmemleak issues in drm :

unreferenced object 0xf571dea0 (size 32):
  comm "Xorg", pid 1992, jiffies 4294703188
  backtrace:
    [<c1096655>] create_object+0x140/0x210
    [<c10967f2>] kmemleak_alloc+0x25/0x4b
    [<c1093b63>] __kmalloc+0xcb/0x153
    [<c11ae939>] drm_setversion+0x154/0x1f6
    [<c11ad0b1>] drm_ioctl+0x211/0x296
    [<c10a2dc9>] vfs_ioctl+0x50/0x69
    [<c10a3321>] do_vfs_ioctl+0x49b/0x4d5
    [<c10a3387>] sys_ioctl+0x2c/0x45
    [<c1002988>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff

I found some other issues in drm, I hope it will be helpful :

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 9b9ff46..ab0344b 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -96,25 +96,31 @@ int drm_setunique(struct drm_device *dev, void *data,
 	master->unique = kmalloc(master->unique_size, GFP_KERNEL);
 	if (!master->unique)
 		return -ENOMEM;
-	if (copy_from_user(master->unique, u->unique, master->unique_len))
+	if (copy_from_user(master->unique, u->unique, master->unique_len)) {
+		kfree(master->unique);
 		return -EFAULT;
+	}
 
 	master->unique[master->unique_len] = '\0';
 
 	dev->devname = kmalloc(strlen(dev->driver->pci_driver.name) +
 			       strlen(master->unique) + 2, GFP_KERNEL);
-	if (!dev->devname)
+	if (!dev->devname) {
+		kfree(master->unique);
 		return -ENOMEM;
+	}
 
 	sprintf(dev->devname, "%s@%s", dev->driver->pci_driver.name,
 		master->unique);
 
-	/* Return error if the busid submitted doesn't match the device's actual
+	/*
+	 * Return error if the busid submitted doesn't match the device's actual
 	 * busid.
 	 */
 	ret = sscanf(master->unique, "PCI:%d:%d:%d", &bus, &slot, &func);
 	if (ret != 3)
-		return -EINVAL;
+		goto error;
+
 	domain = bus >> 8;
 	bus &= 0xff;
 
@@ -122,9 +128,15 @@ int drm_setunique(struct drm_device *dev, void *data,
 	    (bus != dev->pdev->bus->number) ||
 	    (slot != PCI_SLOT(dev->pdev->devfn)) ||
 	    (func != PCI_FUNC(dev->pdev->devfn)))
-		return -EINVAL;
+		goto error;
 
 	return 0;
+
+error:
+	kfree(dev->devname);
+	kfree(master->unique);
+
+	return -EINVAL;
 }
 
 static int drm_set_busid(struct drm_device *dev, struct drm_file *file_priv)
@@ -136,25 +148,31 @@ static int drm_set_busid(struct drm_device *dev, struct drm_file *file_priv)
 		return -EBUSY;
 
 	master->unique_len = 40;
-	master->unique_size = master->unique_len;
+	master->unique_size = master->unique_len + 1;
 	master->unique = kmalloc(master->unique_size, GFP_KERNEL);
 	if (master->unique == NULL)
 		return -ENOMEM;
 
-	len = snprintf(master->unique, master->unique_len, "pci:%04x:%02x:%02x.%d",
+	/*
+	 * Using sprintf as it will return number of characters
+	 * (not including the trailing '\0')
+	 */
+	len = sprintf(master->unique, "pci:%04x:%02x:%02x.%d",
 		       drm_get_pci_domain(dev),
 		       dev->pdev->bus->number,
 		       PCI_SLOT(dev->pdev->devfn),
 		       PCI_FUNC(dev->pdev->devfn));
-	if (len >= master->unique_len)
+	if (len > master->unique_len)
 		DRM_ERROR("buffer overflow");
 	else
 		master->unique_len = len;
 
 	dev->devname = kmalloc(strlen(dev->driver->pci_driver.name) +
 			       master->unique_len + 2, GFP_KERNEL);
-	if (dev->devname == NULL)
+	if (dev->devname == NULL) {
+		kfree(master->unique);
 		return -ENOMEM;
+	}
 
 	sprintf(dev->devname, "%s@%s", dev->driver->pci_driver.name,
 		master->unique);


