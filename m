Return-Path: <linux-kernel-owner+w=401wt.eu-S1751505AbYKFRcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbYKFRcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYKFRc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:32:26 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37056 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYKFRcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:32:25 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 6 Nov 2008 18:31:50 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] ieee1394 updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.b1f97f6a2ed64d76@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive one post .27 regression fix, one fix for an old corner-case
bug, and two things that may be questionable for a pull request in the
-rc phase but I'd like to get rid of:

Kay Sievers (2):
      firewire: struct device - replace bus_id with dev_name(), dev_set_name()
      ieee1394: struct device - replace bus_id with dev_name(), dev_set_name()

Stefan Richter (2):
      ieee1394: raw1394: fix possible deadlock in multithreaded clients
      ieee1394: dv1394: fix possible deadlock in multithreaded clients

 drivers/firewire/fw-device.c |   14 ++++++--------
 drivers/firewire/fw-ohci.c   |    2 +-
 drivers/firewire/fw-sbp2.c   |    2 +-
 drivers/ieee1394/dv1394.c    |   10 ++++++++--
 drivers/ieee1394/hosts.c     |    4 ++--
 drivers/ieee1394/nodemgr.c   |   14 +++++---------
 drivers/ieee1394/raw1394.c   |    9 ++++++---
 7 files changed, 29 insertions(+), 26 deletions(-)


commit 8449fc3ae58bf8ee5acbd2280754cde67b5db128
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Oct 26 12:02:03 2008 +0100

    ieee1394: dv1394: fix possible deadlock in multithreaded clients
    
    Fix a possible though highly unlikely deadlock:
    
    Thread A:                  Thread B:
     - acquire mmap_sem         - dv1394_ioctl/read/write()
     - dv1394_mmap()            - acquire video->mtx
     - acquire video->mtx       - copy_to/from_user(), possible page fault:
                                  acquire mmap_sem
    
    The simplest fix is to use mutex_trylock() instead of mutex_lock() in
    dv1394_mmap().  This changes the behavior under contention in a way
    which is visible to userspace clients.  However, my guess is that no
    clients exist which use mmap vs. ioctl/read/write on the dv1394
    character device file interface in concurrent threads.
    
    Reported-by: Johannes Weiner <hannes@saeurebad.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index df70f51..5332997 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -1270,8 +1270,14 @@ static int dv1394_mmap(struct file *file, struct vm_area_struct *vma)
 	struct video_card *video = file_to_video_card(file);
 	int retval = -EINVAL;
 
-	/* serialize mmap */
-	mutex_lock(&video->mtx);
+	/*
+	 * We cannot use the blocking variant mutex_lock here because .mmap
+	 * is called with mmap_sem held, while .ioctl, .read, .write acquire
+	 * video->mtx and subsequently call copy_to/from_user which will
+	 * grab mmap_sem in case of a page fault.
+	 */
+	if (!mutex_trylock(&video->mtx))
+		return -EAGAIN;
 
 	if ( ! video_card_initialized(video) ) {
 		retval = do_dv1394_init_default(video);

commit 638570b54346f140bc09b986d93e76025d35180f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Oct 26 12:03:37 2008 +0100

    ieee1394: raw1394: fix possible deadlock in multithreaded clients
    
    Regression in 2.6.28-rc1:  When I added the new state_mutex which
    prevents corruption of raw1394's internal state when accessed by
    multithreaded client applications, the following possible though
    highly unlikely deadlock slipped in:
    
    Thread A:                  Thread B:
     - acquire mmap_sem         - raw1394_write() or raw1394_ioctl()
     - raw1394_mmap()           - acquire state_mutex
     - acquire state_mutex      - copy_to/from_user(), possible page fault:
                                  acquire mmap_sem
    
    The simplest fix is to use mutex_trylock() instead of mutex_lock() in
    raw1394_mmap().  This changes the behavior under contention in a way
    which is visible to userspace clients.  However, since multithreaded
    access was entirely buggy before state_mutex was added and libraw1394's
    documentation advised application programmers to use a handle only in a
    single thread, this change in behaviour should not be an issue in
    practice at all.
    
    Since we have to use mutex_trylock() in raw1394_mmap() regardless
    whether /dev/raw1394 was opened with O_NONBLOCK or not, we now use
    mutex_trylock() unconditionally everywhere for state_mutex, just to have
    consistent behavior.
    
    Reported-by: Johannes Weiner <hannes@saeurebad.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index 2cf4ae7..4bdfff0 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -2268,7 +2268,8 @@ static ssize_t raw1394_write(struct file *file, const char __user * buffer,
 		return -EFAULT;
 	}
 
-	mutex_lock(&fi->state_mutex);
+	if (!mutex_trylock(&fi->state_mutex))
+		return -EAGAIN;
 
 	switch (fi->state) {
 	case opened:
@@ -2548,7 +2549,8 @@ static int raw1394_mmap(struct file *file, struct vm_area_struct *vma)
 	struct file_info *fi = file->private_data;
 	int ret;
 
-	mutex_lock(&fi->state_mutex);
+	if (!mutex_trylock(&fi->state_mutex))
+		return -EAGAIN;
 
 	if (fi->iso_state == RAW1394_ISO_INACTIVE)
 		ret = -EINVAL;
@@ -2669,7 +2671,8 @@ static long raw1394_ioctl(struct file *file, unsigned int cmd,
 		break;
 	}
 
-	mutex_lock(&fi->state_mutex);
+	if (!mutex_trylock(&fi->state_mutex))
+		return -EAGAIN;
 
 	switch (fi->iso_state) {
 	case RAW1394_ISO_INACTIVE:

commit 233976e539a93de1320fc7625b24076b1f9e2c9c
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Thu Oct 30 01:49:20 2008 +0100

    ieee1394: struct device - replace bus_id with dev_name(), dev_set_name()
    
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/hosts.c b/drivers/ieee1394/hosts.c
index 8dd09d8..237d0c9 100644
--- a/drivers/ieee1394/hosts.c
+++ b/drivers/ieee1394/hosts.c
@@ -155,11 +155,11 @@ struct hpsb_host *hpsb_alloc_host(struct hpsb_host_driver *drv, size_t extra,
 	memcpy(&h->device, &nodemgr_dev_template_host, sizeof(h->device));
 	h->device.parent = dev;
 	set_dev_node(&h->device, dev_to_node(dev));
-	snprintf(h->device.bus_id, BUS_ID_SIZE, "fw-host%d", h->id);
+	dev_set_name(&h->device, "fw-host%d", h->id);
 
 	h->host_dev.parent = &h->device;
 	h->host_dev.class = &hpsb_host_class;
-	snprintf(h->host_dev.bus_id, BUS_ID_SIZE, "fw-host%d", h->id);
+	dev_set_name(&h->host_dev, "fw-host%d", h->id);
 
 	if (device_register(&h->device))
 		goto fail;
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 2376b72..9e39f73 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -826,13 +826,11 @@ static struct node_entry *nodemgr_create_node(octlet_t guid,
 	memcpy(&ne->device, &nodemgr_dev_template_ne,
 	       sizeof(ne->device));
 	ne->device.parent = &host->device;
-	snprintf(ne->device.bus_id, BUS_ID_SIZE, "%016Lx",
-		 (unsigned long long)(ne->guid));
+	dev_set_name(&ne->device, "%016Lx", (unsigned long long)(ne->guid));
 
 	ne->node_dev.parent = &ne->device;
 	ne->node_dev.class = &nodemgr_ne_class;
-	snprintf(ne->node_dev.bus_id, BUS_ID_SIZE, "%016Lx",
-		(unsigned long long)(ne->guid));
+	dev_set_name(&ne->node_dev, "%016Lx", (unsigned long long)(ne->guid));
 
 	if (device_register(&ne->device))
 		goto fail_devreg;
@@ -932,13 +930,11 @@ static void nodemgr_register_device(struct node_entry *ne,
 
 	ud->device.parent = parent;
 
-	snprintf(ud->device.bus_id, BUS_ID_SIZE, "%s-%u",
-		 ne->device.bus_id, ud->id);
+	dev_set_name(&ud->device, "%s-%u", dev_name(&ne->device), ud->id);
 
 	ud->unit_dev.parent = &ud->device;
 	ud->unit_dev.class = &nodemgr_ud_class;
-	snprintf(ud->unit_dev.bus_id, BUS_ID_SIZE, "%s-%u",
-		 ne->device.bus_id, ud->id);
+	dev_set_name(&ud->unit_dev, "%s-%u", dev_name(&ne->device), ud->id);
 
 	if (device_register(&ud->device))
 		goto fail_devreg;
@@ -953,7 +949,7 @@ static void nodemgr_register_device(struct node_entry *ne,
 fail_classdevreg:
 	device_unregister(&ud->device);
 fail_devreg:
-	HPSB_ERR("Failed to create unit %s", ud->device.bus_id);
+	HPSB_ERR("Failed to create unit %s", dev_name(&ud->device));
 }	
 
 

commit a1f64819fe9f136c98d572794a35a7e377c951ef
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Thu Oct 30 01:41:56 2008 +0100

    firewire: struct device - replace bus_id with dev_name(), dev_set_name()
    
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index 3fccdd4..6b9be42 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -587,8 +587,7 @@ static void create_units(struct fw_device *device)
 		unit->device.bus = &fw_bus_type;
 		unit->device.type = &fw_unit_type;
 		unit->device.parent = &device->device;
-		snprintf(unit->device.bus_id, sizeof(unit->device.bus_id),
-			 "%s.%d", device->device.bus_id, i++);
+		dev_set_name(&unit->device, "%s.%d", dev_name(&device->device), i++);
 
 		init_fw_attribute_group(&unit->device,
 					fw_unit_attributes,
@@ -711,8 +710,7 @@ static void fw_device_init(struct work_struct *work)
 	device->device.type = &fw_device_type;
 	device->device.parent = device->card->device;
 	device->device.devt = MKDEV(fw_cdev_major, minor);
-	snprintf(device->device.bus_id, sizeof(device->device.bus_id),
-		 "fw%d", minor);
+	dev_set_name(&device->device, "fw%d", minor);
 
 	init_fw_attribute_group(&device->device,
 				fw_device_attributes,
@@ -741,13 +739,13 @@ static void fw_device_init(struct work_struct *work)
 		if (device->config_rom_retries)
 			fw_notify("created device %s: GUID %08x%08x, S%d00, "
 				  "%d config ROM retries\n",
-				  device->device.bus_id,
+				  dev_name(&device->device),
 				  device->config_rom[3], device->config_rom[4],
 				  1 << device->max_speed,
 				  device->config_rom_retries);
 		else
 			fw_notify("created device %s: GUID %08x%08x, S%d00\n",
-				  device->device.bus_id,
+				  dev_name(&device->device),
 				  device->config_rom[3], device->config_rom[4],
 				  1 << device->max_speed);
 		device->config_rom_retries = 0;
@@ -883,12 +881,12 @@ static void fw_device_refresh(struct work_struct *work)
 		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
 		goto gone;
 
-	fw_notify("refreshed device %s\n", device->device.bus_id);
+	fw_notify("refreshed device %s\n", dev_name(&device->device));
 	device->config_rom_retries = 0;
 	goto out;
 
  give_up:
-	fw_notify("giving up on refresh of device %s\n", device->device.bus_id);
+	fw_notify("giving up on refresh of device %s\n", dev_name(&device->device));
  gone:
 	atomic_set(&device->state, FW_DEVICE_SHUTDOWN);
 	fw_device_shutdown(work);
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 8e16bfb..46610b0 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -2468,7 +2468,7 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 		goto fail_self_id;
 
 	fw_notify("Added fw-ohci device %s, OHCI version %x.%x\n",
-		  dev->dev.bus_id, version >> 16, version & 0xff);
+		  dev_name(&dev->dev), version >> 16, version & 0xff);
 	return 0;
 
  fail_self_id:
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index d334cac..97df6da 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1135,7 +1135,7 @@ static int sbp2_probe(struct device *dev)
 	tgt->unit = unit;
 	kref_init(&tgt->kref);
 	INIT_LIST_HEAD(&tgt->lu_list);
-	tgt->bus_id = unit->device.bus_id;
+	tgt->bus_id = dev_name(&unit->device);
 	tgt->guid = (u64)device->config_rom[3] << 32 | device->config_rom[4];
 
 	if (fw_device_enable_phys_dma(device) < 0)

Thanks,
-- 
Stefan Richter
-=====-==--- =-== --==-
http://arcgraph.de/sr/

