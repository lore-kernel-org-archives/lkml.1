Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYKNFQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYKNFQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 00:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYKNFQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 00:16:38 -0500
Received: from mga07.intel.com ([143.182.124.22]:5833 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752844AbYKNFQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 00:16:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,600,1220252400"; 
   d="scan'208";a="76000079"
Subject: system fails to boot
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: tj@kernel.org, LKML <linux-kernel@vger.kernel.org>, albcamus@gmail.com,
       pjones@redhat.com, alex.shi@intel.com
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Nov 2008 13:16:21 +0800
Message-Id: <1226639781.2866.77.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

We run into system boot failure with kernel 2.6.28-rc. We found it on a couple of
machines, including T61 notebook, nehalem machine, and another HPC NX6325 notebook.
All the machines use FedoraCore 8 or FedoraCore 9. With kernel prior to 2.6.28-rc,
system boot doesn't fail.

I debug it and locate the root cause. Pls. see
http://bugzilla.kernel.org/show_bug.cgi?id=11899
https://bugzilla.redhat.com/show_bug.cgi?id=471517

As a matter of fact, there are 2 bugs.

﻿1)root=/dev/sda1, system boot randomly fails. Mostly, boot for 5
times and fails once. nash has a bug. Some of its functions misuse return value 0.
Sometimes, 0 means timeout and no uevent available. Sometimes, 0 means nash gets
an uevent, but the uevent isn't block-related (for exmaple, usb). If by coincidence,
kernel tells nash that uevents are available, but kernel also set timeout, nash
might stops collecting other uevents in queue if current uevent isn't block-related.
I work out a patch for nash to fix it. 
http://bugzilla.kernel.org/attachment.cgi?id=18858

2) root=LABEL=/, system always can't boot. initrd init reports
switchroot fails. Here is an executation branch of nash when booting:
    (1) nash read /sys/block/sda/dev; Assume major is 8 (on my desktop)
    (2) nash query /proc/devices with the major number; It found line  "8 sd";
    (3) nash use 'sd' to search its own probe table to find device (DISK) type for the device
       and add it to its own list;
    (4) Later on, it probes all devices in its list to get filesystem labels;
       scsi register "8 sd" always.
When major is 259, nash fails to find the device(DISK) type. I enables CONFIG_DEBUG_BLOCK_EXT_DEVT=y
when compiling kernel, so 259 is picked up for device /dev/sda1, which causes nash to fail
to find device (DISK) type.
To fixing issue 2), I create a patch for nash and another patch for kernel.
http://bugzilla.kernel.org/attachment.cgi?id=18859
http://bugzilla.kernel.org/attachment.cgi?id=18837

Below is the patch for kernel 2.6.28-rc4. It registers blkext, a new block device in proc/devices.

With 2 patches on nash and 1 patch on kernel, I boot my machines for dozens of times
without failure.

﻿Signed-off-by Zhang Yanmin <yanmin.zhang@linux.intel.com>
﻿
Would you like to accept the kernel patch into your testing tree? Pls. do CC to me when replying
as I couldn't subscribe LKML emails now.

---

--- linux-2.6.28-rc4/block/genhd.c	2008-11-11 08:37:24.000000000 +0800
+++ linux-2.6.28-rc4_label/block/genhd.c	2008-11-13 04:05:35.000000000 +0800
@@ -1028,6 +1028,7 @@ static int __init proc_genhd_init(void)
 {
 	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
 	proc_create("partitions", 0, NULL, &proc_partitions_operations);
+	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
 	return 0;
 }
 module_init(proc_genhd_init);




