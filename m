Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZKBLCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZKBLCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZKBLCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:02:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56127 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZKBLCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:02:44 -0500
From: "Dasgupta, Romit" <romit@ti.com>
To: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "rjw@sisk.pl" <rjw@sisk.pl>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 2 Nov 2009 16:32:13 +0530
Subject: [PATCH 0/1] PM: Making bdi threads non-freezable
Thread-Topic: [PATCH 0/1] PM: Making bdi threads non-freezable
Thread-Index: Acpbq+6/nJ9rhkNJSSGwee60PVnNTA==
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE1EBC63@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
                  For last few days I am facing an interesting suspend resume issue when I have a SD card inserted in
a development platform. My kernel is built without CONFIG_MMC_UNSAFE_RESUME. (Most of the problems 
don't appear with CONFIG_MMC_UNSAFE_RESUME=y but that option seems to be not-recommended). 
When I try to issue system suspend (S2R) I can see that my shell is hung. 
Enabling CONFIG_DETECT_HUNG_TASK would reveal the following:

# echo mem > /sys/power/state
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
platform_legacy_suspend(): serial8250_suspend+0x0/0x54 returns 1
mmc1: card 0001 removed
platform_legacy_suspend(): omap_hsmmc_suspend+0x0/0x104 returns 1
mmc0: card 25b7 removed
INFO: task sh:387 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh            D c027e89c     0   387      1 0x00000000
[<c027e89c>] (schedule+0x2e0/0x36c) from [<c00c36e4>] (bdi_sched_wait+0x8/0x10)
[<c00c36e4>] (bdi_sched_wait+0x8/0x10) from [<c027f24c>] (__wait_on_bit+0x5c/0xa8)
[<c027f24c>] (__wait_on_bit+0x5c/0xa8) from [<c027f30c>] (out_of_line_wait_on_bit+0x74/0x80)
[<c027f30c>] (out_of_line_wait_on_bit+0x74/0x80) from [<c00c3774>] (sync_inodes_sb+0x88/0x178)
[<c00c3774>] (sync_inodes_sb+0x88/0x178) from [<c00c76e4>] (__sync_filesystem+0x5c/0x88)
[<c00c76e4>] (__sync_filesystem+0x5c/0x88) from [<c00d02f0>] (fsync_bdev+0x18/0x38)
[<c00d02f0>] (fsync_bdev+0x18/0x38) from [<c0174230>] (invalidate_partition+0x18/0x34)
[<c0174230>] (invalidate_partition+0x18/0x34) from [<c00f22d8>] (del_gendisk+0x24/0xb4)
[<c00f22d8>] (del_gendisk+0x24/0xb4) from [<c01e686c>] (mmc_blk_remove+0x24/0x44)
[<c01e686c>] (mmc_blk_remove+0x24/0x44) from [<c01e151c>] (mmc_bus_remove+0x18/0x20)
[<c01e151c>] (mmc_bus_remove+0x18/0x20) from [<c01af6ac>] (__device_release_driver+0x64/0xa4)
[<c01af6ac>] (__device_release_driver+0x64/0xa4) from [<c01af7e4>] (device_release_driver+0x1c/0x28)
[<c01af7e4>] (device_release_driver+0x1c/0x28) from [<c01aed5c>] (bus_remove_device+0x7c/0x90)
[<c01aed5c>] (bus_remove_device+0x7c/0x90) from [<c01ad538>] (device_del+0x110/0x160)
[<c01ad538>] (device_del+0x110/0x160) from [<c01e15d4>] (mmc_remove_card+0x50/0x64)
[<c01e15d4>] (mmc_remove_card+0x50/0x64) from [<c01e2ed0>] (mmc_sd_remove+0x24/0x30)
[<c01e2ed0>] (mmc_sd_remove+0x24/0x30) from [<c01e0df8>] (mmc_suspend_host+0x110/0x1a8)
[<c01e0df8>] (mmc_suspend_host+0x110/0x1a8) from [<c01e7d30>] (omap_hsmmc_suspend+0x74/0x104)
[<c01e7d30>] (omap_hsmmc_suspend+0x74/0x104) from [<c01b09bc>] (platform_pm_suspend+0x60/0x8c)
[<c01b09bc>] (platform_pm_suspend+0x60/0x8c) from [<c01b2820>] (pm_op+0x30/0x74)
[<c01b2820>] (pm_op+0x30/0x74) from [<c01b2ef8>] (dpm_suspend_start+0x3b4/0x518)
[<c01b2ef8>] (dpm_suspend_start+0x3b4/0x518) from [<c0078b20>] (suspend_devices_and_enter+0x3c/0x1c4)
[<c0078b20>] (suspend_devices_and_enter+0x3c/0x1c4) from [<c0078d88>] (enter_state+0xe0/0x138)
[<c0078d88>] (enter_state+0xe0/0x138) from [<c0078444>] (state_store+0x94/0xbc)
[<c0078444>] (state_store+0x94/0xbc) from [<c017e124>] (kobj_attr_store+0x18/0x1c)
[<c017e124>] (kobj_attr_store+0x18/0x1c) from [<c00f3a08>] (sysfs_write_file+0x108/0x13c)
[<c00f3a08>] (sysfs_write_file+0x108/0x13c) from [<c00a76b8>] (vfs_write+0xac/0x154)
[<c00a76b8>] (vfs_write+0xac/0x154) from [<c00a780c>] (sys_write+0x3c/0x68)
[<c00a780c>] (sys_write+0x3c/0x68) from [<c0025e60>] (ret_fast_syscall+0x0/0x2c)

A closer investigation showed that when this happens the 'bdi' tasks (i.e. forker and the individual flush kthreads) are 
already in the 'refrigerator' hence we are blocked. I made those tasks as non-freezable and things were fine until I hit
yet another deeper issue.  I have attached the patch for the first fix in the next part of the mail.

The second problem shows up when I have filesystem(s) mounted on the MMC card and I try the following:
1) I successfully suspend/resume followed by
2) attempt to next suspend/resume cycle. This time again I get blocked. khungd outputs the following:

INFO: task sh:387 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh            D c027e83c     0   387      1 0x00000000
[<c027e83c>] (schedule+0x2e0/0x36c) from [<c00c36b0>] (bdi_sched_wait+0x8/0x10)
[<c00c36b0>] (bdi_sched_wait+0x8/0x10) from [<c027f1ec>] (__wait_on_bit+0x5c/0xa8)
[<c027f1ec>] (__wait_on_bit+0x5c/0xa8) from [<c027f2ac>] (out_of_line_wait_on_bit+0x74/0x80)
[<c027f2ac>] (out_of_line_wait_on_bit+0x74/0x80) from [<c00c3740>] (sync_inodes_sb+0x88/0x178)
[<c00c3740>] (sync_inodes_sb+0x88/0x178) from [<c00c76a8>] (__sync_filesystem+0x5c/0x88)
[<c00c76a8>] (__sync_filesystem+0x5c/0x88) from [<c00c77a4>] (sync_filesystems+0xd0/0x140)
[<c00c77a4>] (sync_filesystems+0xd0/0x140) from [<c00c7860>] (sys_sync+0x1c/0x3c)
[<c00c7860>] (sys_sync+0x1c/0x3c) from [<c0078ce0>] (enter_state+0x38/0x138)
[<c0078ce0>] (enter_state+0x38/0x138) from [<c0078444>] (state_store+0x94/0xbc)
[<c0078444>] (state_store+0x94/0xbc) from [<c017e0e4>] (kobj_attr_store+0x18/0x1c)
[<c017e0e4>] (kobj_attr_store+0x18/0x1c) from [<c00f39cc>] (sysfs_write_file+0x108/0x13c)
[<c00f39cc>] (sysfs_write_file+0x108/0x13c) from [<c00a7684>] (vfs_write+0xac/0x154)
[<c00a7684>] (vfs_write+0xac/0x154) from [<c00a77d8>] (sys_write+0x3c/0x68)
[<c00a77d8>] (sys_write+0x3c/0x68) from [<c0025e60>] (ret_fast_syscall+0x0/0x2c)

After some investigation I could see that on the first successful suspend 'bdi_unregister' was called as a part 
of MMC removal. However the vfat filesystem was still mounted out of MMC and the superblock had a stale 
value for the 's_bdi' field pointing to the just removed struct backing_dev_info. On the next attempt for system 
suspend, 'sync_inodes_sb' was trying to queue work to the bdi work list for an invalid bdi while waking up the
'forker' task. The forker task would never find this bdi on the 'bdi_list' and hence we see this apparent lockup.

So how do we handle unsafe removal while filesystem is still mounted? This is perhaps a bigger discussion.
However for fixing this issue I will suggest the following (I am not even close to a FS internals beginner but I will
try):

i) On the suspend path save the information (disk + partition) of the disk being deleted and the superblocks that 
    were mounted on this device.
ii) On resume path when we try to add a newly detected disk we would compare the disk info and the partition info.
iii) If the saved values and the detected values are same then update the 's_bdi' fields of the superblocks which were 
      mounted on the partitions of this device.

Please let me know if this is totally irrelevant or a brain dead idea?

Regards,
-Romit

