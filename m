Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbXLOX76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbXLOX76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbXLOX7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:59:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:21242 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbXLOX7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:59:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ToVVVUEmUqwK8dlNoRgWAhL+G95d27d341KgAsPeBgNqexE+YDGX5esKUfDIDXmOg+VbxDmy04AYHZByNXYo0zAqp4vHDvXcsBuhAEX1sGgKhCY2U1fLCfSkOBImM/1N9DCayGG0K0wtKIDR5l7oc3jIiEVsXKBIT3XIg4imDxY=
Message-ID: <47646A6C.7070007@gmail.com>
Date: Sun, 16 Dec 2007 00:59:40 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       airlied@linux.ie, dri-devel@lists.sourceforge.net
Subject: broken suspend, sometimes (drm related) [Was: 2.6.24-rc5-mm1]
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2007 11:40 AM, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/

Broken @#$%^ suspend, again (and maybe still for a longer time). Unable to
reproduce this with netconsole.

trace led to i915_suspend
        call    pci_bus_read_config_byte        #
        movq    8(%rbx), %rdi   # <variable>.mmio_map, <variable>.mmio_map
        movq    24(%rdi), %rax  # <variable>.handle, D.24395
        movl    458760(%rax), %eax      #, D.24397

address in rax (i.e. dev_priv->mmio_map->handle) is broken, at least it seems so
from the part of the trace and RIP.

        movl    %eax, 408(%rbx) # D.24397, <variable>.savePIPEACONF
        movq    24(%rdi), %rax  # <variable>.handle, temp.676
        movl    393244(%rax), %eax      #, D.24399

in
        pci_save_state(dev->pdev);
        pci_read_config_byte(dev->pdev, LBB, &dev_priv->saveLBB);

        /* Pipe & plane A info */
-->     dev_priv->savePIPEACONF = I915_READ(PIPEACONF);

I use distro pm-utils and it chvt's to some terminal, write out the output,
suspend, resume, switch back to X.

The patch I'm currently using for debugging:
Index: BH/drivers/char/drm/i915_drv.c
===================================================================
--- BH.orig/drivers/char/drm/i915_drv.c
+++ BH/drivers/char/drm/i915_drv.c
@@ -274,9 +274,18 @@ static int i915_suspend(struct drm_devic
                return -ENODEV;
        }

+       if (!dev_priv->mmio_map || !dev_priv->mmio_map->handle) {
+               printk(KERN_ERR "BAD BAD BAD %p %p\n", dev_priv->mmio_map,
+                       dev_priv->mmio_map ? dev_priv->mmio_map->handle : NULL);
+               return -EIO;
+       }
+
        pci_save_state(dev->pdev);
        pci_read_config_byte(dev->pdev, LBB, &dev_priv->saveLBB);

+       printk(KERN_ERR "\n\n\nmap %p, HANDLE: %p\n\n\n", dev_priv->mmio_map,
+                       dev_priv->mmio_map->handle);
+       msleep(5000);
        /* Pipe & plane A info */
        dev_priv->savePIPEACONF = I915_READ(PIPEACONF);
        dev_priv->savePIPEASRC = I915_READ(PIPEASRC);
Index: BH/drivers/char/drm/drm_bufs.c
===================================================================
--- BH.orig/drivers/char/drm/drm_bufs.c
+++ BH/drivers/char/drm/drm_bufs.c
@@ -136,6 +136,7 @@ static int drm_addmap_core(struct drm_de
                return -EINVAL;
        }
        map->mtrr = -1;
+       printk("BLE %s a: map %p, handle %p\n", __func__, map, map->handle);
        map->handle = NULL;

        switch (map->type) {
@@ -183,6 +184,7 @@ static int drm_addmap_core(struct drm_de
                                drm_free(map, sizeof(*map), DRM_MEM_MAPS);
                                return -ENOMEM;
                        }
+       printk("BLE %s b: map %p, handle %p\n", __func__, map, map->handle);
                }

                break;
@@ -201,6 +203,7 @@ static int drm_addmap_core(struct drm_de
                        return 0;
                }
                map->handle = vmalloc_user(map->size);
+       printk("BLE %s c: map %p, handle %p\n", __func__, map, map->handle);
                DRM_DEBUG("%lu %d %p\n",
                          map->size, drm_order(map->size), map->handle);
                if (!map->handle) {
@@ -211,6 +214,7 @@ static int drm_addmap_core(struct drm_de
                if (map->flags & _DRM_CONTAINS_LOCK) {
                        /* Prevent a 2nd X Server from creating a 2nd lock */
                        if (dev->lock.hw_lock != NULL) {
+       printk("BLE %s d: map %p, handle %p\n", __func__, map, map->handle);
                                vfree(map->handle);
                                drm_free(map, sizeof(*map), DRM_MEM_MAPS);
                                return -EBUSY;
@@ -281,6 +285,7 @@ static int drm_addmap_core(struct drm_de
                        return -ENOMEM;
                }
                map->handle = dmah->vaddr;
+       printk("BLE %s f: map %p, handle %p\n", __func__, map, map->handle);
                map->offset = (unsigned long)dmah->busaddr;
                kfree(dmah);
                break;
@@ -291,6 +296,7 @@ static int drm_addmap_core(struct drm_de

        list = drm_alloc(sizeof(*list), DRM_MEM_MAPS);
        if (!list) {
+       printk("BLE %s g: map %p, handle %p\n", __func__, map, map->handle);
                if (map->type == _DRM_REGISTERS)
                        iounmap(map->handle);
                drm_free(map, sizeof(*map), DRM_MEM_MAPS);
@@ -308,6 +314,7 @@ static int drm_addmap_core(struct drm_de
                map->offset;
        ret = drm_map_handle(dev, &list->hash, user_token, 0);
        if (ret) {
+       printk("BLE %s h: map %p, handle %p\n", __func__, map, map->handle);
                if (map->type == _DRM_REGISTERS)
                        iounmap(map->handle);
                drm_free(map, sizeof(*map), DRM_MEM_MAPS);
@@ -355,6 +362,7 @@ int drm_addmap_ioctl(struct drm_device *
                return err;

        /* avoid a warning on 64-bit, this casting isn't very nice, but the API
is set so too late */
+       printk("BLE %s a: map %p, handle %p\n", __func__, map, map->handle);
        map->handle = (void *)(unsigned long)maplist->user_token;
        return 0;
 }
@@ -398,6 +406,9 @@ int drm_rmmap_locked(struct drm_device *

        switch (map->type) {
        case _DRM_REGISTERS:
+       printk("BLE %s a: map %p, handle %p\n", __func__, map, map->handle);
+       dump_stack();
+       msleep(1);
                iounmap(map->handle);
                /* FALLTHROUGH */
        case _DRM_FRAME_BUFFER:
@@ -408,12 +419,14 @@ int drm_rmmap_locked(struct drm_device *
                }
                break;
        case _DRM_SHM:
+       printk("BLE %s b: map %p, handle %p\n", __func__, map, map->handle);
                vfree(map->handle);
                break;
        case _DRM_AGP:
        case _DRM_SCATTER_GATHER:
                break;
        case _DRM_CONSISTENT:
+       printk("BLE %s c: map %p, handle %p\n", __func__, map, map->handle);
                dmah.vaddr = map->handle;
                dmah.busaddr = map->offset;
                dmah.size = map->size;
Index: BH/drivers/char/drm/drm_memory.c
===================================================================
--- BH.orig/drivers/char/drm/drm_memory.c
+++ BH/drivers/char/drm/drm_memory.c
@@ -233,11 +233,13 @@ void drm_core_ioremap(struct drm_map *ma
                map->handle = agp_remap(map->offset, map->size, dev);
        else
                map->handle = ioremap(map->offset, map->size);
+       printk("BLE %s: map %p, handle %p\n", __func__, map, map->handle);
 }
 EXPORT_SYMBOL(drm_core_ioremap);

 void drm_core_ioremapfree(struct drm_map *map, struct drm_device *dev)
 {
+       printk("BLE %s a: map %p, handle %p\n", __func__, map, map->handle);
        if (!map->handle || !map->size)
                return;

@@ -246,5 +248,6 @@ void drm_core_ioremapfree(struct drm_map
                vunmap(map->handle);
        else
                iounmap(map->handle);
+       printk("BLE %s b: map %p, handle %p\n", __func__, map, map->handle);
 }
 EXPORT_SYMBOL(drm_core_ioremapfree);
Index: BH/drivers/char/drm/drm_vm.c
===================================================================
--- BH.orig/drivers/char/drm/drm_vm.c
+++ BH/drivers/char/drm/drm_vm.c
@@ -245,15 +245,18 @@ static void drm_vm_shm_close(struct vm_a
                                                           map->size);
                                        DRM_DEBUG("mtrr_del = %d\n", retcode);
                                }
+       printk("BLE %s a: map %p, handle %p\n", __func__, map, map->handle);
                                iounmap(map->handle);
                                break;
                        case _DRM_SHM:
+       printk("BLE %s b: map %p, handle %p\n", __func__, map, map->handle);
                                vfree(map->handle);
                                break;
                        case _DRM_AGP:
                        case _DRM_SCATTER_GATHER:
                                break;
                        case _DRM_CONSISTENT:
+       printk("BLE %s c: map %p, handle %p\n", __func__, map, map->handle);
                                dmah.vaddr = map->handle;
                                dmah.busaddr = map->offset;
                                dmah.size = map->size;




And the output:

BLE drm_addmap_core a: map ffff81007bd7de40, handle ffff81007bd7de00
BLE drm_addmap_core c: map ffff81007bd7de40, handle ffffc20010092000
BLE drm_rmmap_locked b: map ffff81007bd7de40, handle ffffc20010092000
BLE drm_rmmap_locked a: map ffff81007d02c940, handle ffffc20010380000
BLE drm_addmap_core a: map ffff81007bd7de40, handle ffffc20010092000
BLE drm_addmap_core c: map ffff81007bd7de40, handle ffffc20010092000
BLE drm_rmmap_locked b: map ffff81007bd7de40, handle ffffc20010092000
BLE drm_addmap_core a: map ffff81007bd7de40, handle ffffc20010092000
BLE drm_addmap_core c: map ffff81007bd7de40, handle ffffc20010092000
BLE drm_addmap_core a: map ffff81007bd7da00, handle ffff81007bd7da80
BLE drm_addmap_ioctl a: map ffff81007bd7dc00, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007bd7da00, handle 0000000000000000
BLE drm_addmap_ioctl a: map ffff81007bd7dc00, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007bd7df80, handle ffff81007cc33e10
BLE drm_addmap_core b: map ffff81007bd7df80, handle ffffc20010380000
BLE drm_addmap_ioctl a: map ffff81007bd7dc00, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007bd7d840, handle ffff81007cc33e10
BLE drm_addmap_ioctl a: map ffff81007bd7dc00, handle 0000000000000000
BLE drm_core_ioremap: map ffff81007d0ab050, handle ffffc20010240000
set status page addr 0x00033000
BLE drm_core_ioremap: map ffff81007d0ab098, handle ffffc20010096000
BLE drm_addmap_core a: map ffff81007bd7dbc0, handle 0000000000000000
BLE drm_addmap_ioctl a: map ffff81007bd7df00, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007bd7d5c0, handle 0000000000001000
BLE drm_addmap_ioctl a: map ffff81007bd7df00, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007bd7d740, handle 0000000000000000
BLE drm_addmap_ioctl a: map ffff81007bd7df00, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007bd7d080, handle 0000000000001000
BLE drm_addmap_ioctl a: map ffff81007bd7df00, handle 0000000000000000
BLE drm_core_ioremapfree a: map ffff81007d0ab050, handle ffffc20010240000
BLE drm_core_ioremapfree b: map ffff81007d0ab050, handle ffffc20010240000
BLE drm_core_ioremapfree a: map ffff81007d0ab098, handle ffffc20010096000
BLE drm_core_ioremapfree b: map ffff81007d0ab098, handle ffffc20010096000
BLE drm_rmmap_locked a: map ffff81007bd7df80, handle ffffc20010380000
BLE drm_rmmap_locked b: map ffff81007bd7de40, handle ffffc20010092000
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
sd 2:0:0:0: [sdc] Synchronizing SCSI cache
sd 2:0:0:0: [sdc] Stopping disk
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Stopping disk
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
drm_sysfs_suspend
map ffff81007bd7df80, HANDLE: ffff81007cc33e10

What's this HANDLE address, it has probably nothing to do with the mapping --
note that "BLE drm_addmap_core a" is _between_ "map = drm_alloc" and map->handle
= NULL;". How this address leaked to the i915 handle? Maybe some other place I
haven't spotted which changes handle? Anyway, the mapping ffff81007bd7df80 seems
to be removed in last but one line ("BLE drm_rmmap_locked a").

next suspend/resume try:
BLE drm_addmap_core a: map ffff81007c2d9b00, handle 0000000000000000
BLE drm_addmap_core c: map ffff81007c2d9b00, handle ffffc20010092000
BLE drm_rmmap_locked b: map ffff81007c2d9b00, handle ffffc20010092000
BLE drm_addmap_core a: map ffff81007c2d9b00, handle ffffc20010092000
BLE drm_addmap_core c: map ffff81007c2d9b00, handle ffffc20010092000
BLE drm_rmmap_locked b: map ffff81007c2d9b00, handle ffffc20010092000
BLE drm_addmap_core a: map ffff81007c2d9b00, handle ffffc20010092000
BLE drm_addmap_core c: map ffff81007c2d9b00, handle ffffc20010092000
BLE drm_addmap_core a: map ffff81007c2d90c0, handle 8000000000000000
BLE drm_addmap_ioctl a: map ffff81007c2d96c0, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007c2d90c0, handle 0000000000000000
BLE drm_addmap_ioctl a: map ffff81007c2d96c0, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007c2d9800, handle 0000000000000000
BLE drm_addmap_core b: map ffff81007c2d9800, handle ffffc20010380000
BLE drm_addmap_ioctl a: map ffff81007c2d96c0, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007c2d9e80, handle ffff81007c2d9d40
BLE drm_addmap_ioctl a: map ffff81007c2d96c0, handle 0000000000000000
BLE drm_core_ioremap: map ffff81007d0ab050, handle ffffc20010240000
set status page addr 0x00033000
BLE drm_core_ioremap: map ffff81007d0ab098, handle ffffc20010096000
BLE drm_addmap_core a: map ffff81007bd7d440, handle 6632785c63766632
BLE drm_addmap_ioctl a: map ffff81007bd7d080, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007bd7d700, handle 6632785c63766632
BLE drm_addmap_ioctl a: map ffff81007bd7d080, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007c16f840, handle ffff81007c16f680
BLE drm_addmap_ioctl a: map ffff81007bd7d080, handle 0000000000000000
BLE drm_addmap_core a: map ffff81007c16f2c0, handle ffff81007cc33e10
BLE drm_addmap_ioctl a: map ffff81007c16f640, handle 0000000000000000
BLE drm_core_ioremapfree a: map ffff81007d0ab050, handle ffffc20010240000
BLE drm_core_ioremapfree b: map ffff81007d0ab050, handle ffffc20010240000
BLE drm_core_ioremapfree a: map ffff81007d0ab098, handle ffffc20010096000
BLE drm_core_ioremapfree b: map ffff81007d0ab098, handle ffffc20010096000
BLE drm_rmmap_locked a: map ffff81007c2d9800, handle ffffc20010380000
BLE drm_rmmap_locked b: map ffff81007c2d9b00, handle ffffc20010092000
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
sd 2:0:0:0: [sdc] Synchronizing SCSI cache
sd 2:0:0:0: [sdc] Stopping disk
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Stopping disk
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
drm_sysfs_suspend
BAD BAD BAD ffff81007c2d9800 0000000000000000
suspend_device(): drm_sysfs_suspend+0x0/0x40() returns -5
Could not suspend device card0: error -5
sd 0:0:0:0: [sda] Starting disk

I;m out of ideas, please give me a clue.
