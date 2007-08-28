Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbXH1N2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbXH1N2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXH1N2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:28:33 -0400
Received: from rwcrmhc13.comcast.net ([204.127.192.83]:44439 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbXH1N2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:28:32 -0400
From: "Michael J. Evans" <mjevans1983@comcast.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch v5 1/1] md: Software Raid autodetect dev list not array
Date: Tue, 28 Aug 2007 06:27:47 -0700
User-Agent: KMail/1.9.7
Cc: Michael Evans <mjevans1983@gmail.com>, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200708222058.45480.mjevans1983@comcast.net> <200708272138.19785.mjevans1983@comcast.net> <46D3A8AD.6000701@oracle.com>
In-Reply-To: <46D3A8AD.6000701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708280627.47678.mjevans1983@comcast.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael J. Evans <mjevans1983@gmail.com>

In current release kernels the md module (Software RAID) uses a static array
 (dev_t[128]) to store partition/device info temporarily for autostart.

This patch replaces that static array with a list.

Signed-off-by: Michael J. Evans <mjevans1983@gmail.com>
--- 
Version 5:
patched modified to cleanly patch against 2.6.23-rc4 (Offsets only)
Removed credit from head of file since the changelogs are archived.

Version 4:
Minor formatting cleanup for kzAlloc error message.
Should I remove the first patch section in version 5?

Version 3:
md_autodetect_dev failure message is now more usefully verbose.
removed unused i_found that was leftover from initial verification.
Thank you Randy Dunlap for pointing where INT_MAX was, fixme fixed.

Version 2:
using list_add_tail, and corrected missing i_passed++;.
removed sections of code that would never be reached.

Version 1:
The data/structures are only used within md.c, and very close together.
However I wonder if the structural information shouldn't go in to...
../../include/linux/raid/md_k.h instead.


I discovered this (and that the devices are added as disks/partitions are
discovered at boot) while I was debugging why only one of my MD arrays would
come up whole, while all the others were short a disk.

I eventually discovered that it was enumerating through all of 9 of my 11 hds
(2 had only 4 partitions apiece) while the other 9 have 15 partitions
(I wanted 64 per drive...). The last partition of the 8th drive in my 9 drive
raid 5 sets wasn't added, thus making the final md array short both a parity
and data disk, and it was started later, elsewhere.

Subject: [patch 1/1] md: Software Raid autodetect dev list not array

SOFTWARE RAID (Multiple Disks) SUPPORT
P:	Ingo Molnar
M:	mingo@redhat.com
P:	Neil Brown
M:	neilb@suse.de
L:	linux-raid@vger.kernel.org
S:	Supported
Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.

12: Has been tested with CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
    CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP all simultaneously
    enabled.

It has been tested with CONFIG_SMP set and unset (Different x86_64 systems).
It has been tested with CONFIG_PREEMPT set and unset (same system).
CONFIG_LBD isn't even an option in my .config file.

Note: between 2.6.22 and 2.6.23-rc3-git5
                rdev = md_import_device(dev,0, 0);
became
                rdev = md_import_device(dev,0, 90);
So the patch has been edited to patch around that line.

Signed-off-by: Michael J. Evans <mjevans1983@gmail.com>
=============================================================
--- linux/drivers/md/md.c.orig	2007-08-21 03:19:42.511576248 -0700
+++ linux/drivers/md/md.c	2007-08-21 04:30:09.775525710 -0700
@@ -5781,13 +5781,26 @@ void md_autodetect_dev(dev_t dev)
  * Searches all registered partitions for autorun RAID arrays
  * at boot time.
  */
-static dev_t detected_devices[128];
-static int dev_cnt;
+
+static LIST_HEAD(all_detected_devices);
+struct detected_devices_node {
+	struct list_head list;
+	dev_t dev;
+};
 
 void md_autodetect_dev(dev_t dev)
 {
-	if (dev_cnt >= 0 && dev_cnt < 127)
-		detected_devices[dev_cnt++] = dev;
+	struct detected_devices_node *node_detected_dev;
+	char strbuf[BDEVNAME_SIZE];
+
+	node_detected_dev = kzalloc(sizeof(*node_detected_dev), GFP_KERNEL);
+	if (node_detected_dev) {
+		node_detected_dev->dev = dev;
+		list_add_tail(&node_detected_dev->list, &all_detected_devices);
+	} else {
+		printk(KERN_CRIT "md: md_autodetect_dev: kzAlloc node failed"
+			", skipping dev(%d,%d)\n", MAJOR(dev), MINOR(dev));
+	}
 }
 
 
@@ -5794,7 +5787,12 @@ static void autostart_arrays(int part)
 static void autostart_arrays(int part)
 {
 	mdk_rdev_t *rdev;
-	int i;
+	struct detected_devices_node *node_detected_dev;
+	dev_t dev;
+	int i_scanned, i_passed;
+
+	i_scanned = 0;
+	i_passed = 0;
 
 	printk(KERN_INFO "md: Autodetecting RAID arrays.\n");
 
@@ -5801,3 +5821,7 @@ static void autostart_arrays(int part)
-	for (i = 0; i < dev_cnt; i++) {
-		dev_t dev = detected_devices[i];
-
+	while (!list_empty(&all_detected_devices) && i_scanned < INT_MAX) {
+		i_scanned++;
+		node_detected_dev = list_entry(all_detected_devices.next,
+					struct detected_devices_node, list);
+		list_del(&node_detected_dev->list);
+		dev = node_detected_dev->dev;
+		kfree(node_detected_dev);
@@ -5810,8 +5834,11 @@ static void autostart_arrays(int part)
 			continue;
 		}
 		list_add(&rdev->same_set, &pending_raid_disks);
+		i_passed++;
 	}
-	dev_cnt = 0;
+
+	printk(KERN_INFO "md: Scanned %d and added %d devices.\n",
+						i_scanned, i_passed);
 
 	autorun_devices(part);
 }
