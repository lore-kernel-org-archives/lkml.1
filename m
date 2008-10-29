Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYJ2W60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYJ2W60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYJ2Wq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:28 -0400
Received: from kroah.org ([198.145.64.141]:56283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756480AbYJ2WqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:14 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "vijaykumar@bravegnu.org" <vijaykumar@bravegnu.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/49] Staging: poch: minor fixes
Date: Wed, 29 Oct 2008 15:40:07 -0700
Message-Id: <1225320016-21803-40-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vijaykumar@bravegnu.org <vijaykumar@bravegnu.org>

Unmap PCI bars on remove().
Validate sysfs values before using them.

Signed-off-by: Vijay Kumar <vijaykumar@bravegnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/poch.c |   37 +++++++++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index 52fc3d4..afc9863 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -397,11 +397,38 @@ static int poch_channel_alloc_groups(struct channel_info *channel)
 	return 0;
 }
 
-static void channel_latch_attr(struct channel_info *channel)
+static int channel_latch_attr(struct channel_info *channel)
 {
 	channel->group_count = atomic_read(&channel->sys_group_count);
 	channel->group_size = atomic_read(&channel->sys_group_size);
 	channel->block_size = atomic_read(&channel->sys_block_size);
+
+	if (channel->group_count == 0) {
+		printk(KERN_ERR PFX "invalid group count %lu",
+		       channel->group_count);
+		return -EINVAL;
+	}
+
+	if (channel->group_size == 0 ||
+	    channel->group_size < channel->block_size) {
+		printk(KERN_ERR PFX "invalid group size %lu",
+		       channel->group_size);
+		return -EINVAL;
+	}
+
+	if (channel->block_size == 0 || (channel->block_size % 8) != 0) {
+		printk(KERN_ERR PFX "invalid block size %lu",
+		       channel->block_size);
+		return -EINVAL;
+	}
+
+	if (channel->group_size % channel->block_size != 0) {
+		printk(KERN_ERR PFX
+		       "group size should be multiple of block size");
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 /*
@@ -547,7 +574,9 @@ static int poch_channel_init(struct channel_info *channel,
 
 	printk(KERN_WARNING "channel_latch_attr\n");
 
-	channel_latch_attr(channel);
+	ret = channel_latch_attr(channel);
+	if (ret != 0)
+		goto out;
 
 	channel->transfer = 0;
 
@@ -1359,12 +1388,12 @@ static void poch_pci_remove(struct pci_dev *pdev)
 	unsigned int minor = MINOR(poch_dev->cdev.dev);
 	unsigned int id = minor / poch_dev->nchannels;
 
-	/* FIXME: unmap fpga_iomem and bridge_iomem */
-
 	poch_class_dev_unregister(poch_dev, id);
 	cdev_del(&poch_dev->cdev);
 	idr_remove(&poch_ids, id);
 	free_irq(pdev->irq, poch_dev);
+	iounmap(poch_dev->fpga_iomem);
+	iounmap(poch_dev->bridge_iomem);
 	uio_unregister_device(uio);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
1.6.0.2

