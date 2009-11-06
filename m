Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZKFJfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZKFJfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 04:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZKFJfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 04:35:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41173 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbZKFJft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:35:49 -0500
From: "Dasgupta, Romit" <romit@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Nov 2009 15:05:01 +0530
Subject: [PATCH 0/1] PM: Thaws refrigerated and to be exited kernel threads 
Thread-Topic: [PATCH 0/1] PM: Thaws refrigerated and to be exited kernel
 threads 
Thread-Index: AcpexGmiGuUkesr/TZCmZ5EDusiz4Q==
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F931@dbde02.ent.ti.com>
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

Hi,
    The following patch overcomes the issue when an active thread 
invokes kthread_stop on a refrigerated kernel thread. The active thread
would block until the exiting kernel thread is cleaned up. If the exiting
thread is in refrigerator it never cleans up and the caller blocks.

I found the issue while trying out the following:

1) suspend and resume the system with an mmc card.
2) after resume mount a filesystem on the mmc card.
3) unmount the same filesystem.
4) One can see an active bdi thread in the system for the FS.
5) Attempted suspend on the system. This resulted in hang.

Here was the dump from khungd
# echo mem > /sys/power/state
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
mmc1: card 0001 removed
mmc0: card 25b7 removed
INFO: task sh:388 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh            D c027e86c     0   388      1 0x00000000
[<c027e86c>] (schedule+0x2e0/0x36c) from [<c027ee78>] (schedule_timeout+0x18/0x1ec)
[<c027ee78>] (schedule_timeout+0x18/0x1ec) from [<c027ed10>] (wait_for_common+0xe0/0x198)
[<c027ed10>] (wait_for_common+0xe0/0x198) from [<c0063dd4>] (kthread_stop+0x44/0x78)
[<c0063dd4>] (kthread_stop+0x44/0x78) from [<c0090938>] (bdi_unregister+0x64/0xa4)
[<c0090938>] (bdi_unregister+0x64/0xa4) from [<c0173958>] (unlink_gendisk+0x20/0x3c)
[<c0173958>] (unlink_gendisk+0x20/0x3c) from [<c00f2338>] (del_gendisk+0x84/0xb4)
[<c00f2338>] (del_gendisk+0x84/0xb4) from [<c01e6840>] (mmc_blk_remove+0x24/0x44)
[<c01e6840>] (mmc_blk_remove+0x24/0x44) from [<c01e14f0>] (mmc_bus_remove+0x18/0x20)
[<c01e14f0>] (mmc_bus_remove+0x18/0x20) from [<c01af6ac>] (__device_release_driver+0x64/0xa4)
[<c01af6ac>] (__device_release_driver+0x64/0xa4) from [<c01af7e4>] (device_release_driver+0x1c/0x28)
[<c01af7e4>] (device_release_driver+0x1c/0x28) from [<c01aed5c>] (bus_remove_device+0x7c/0x90)
[<c01aed5c>] (bus_remove_device+0x7c/0x90) from [<c01ad538>] (device_del+0x110/0x160)
[<c01ad538>] (device_del+0x110/0x160) from [<c01e15a8>] (mmc_remove_card+0x50/0x64)
[<c01e15a8>] (mmc_remove_card+0x50/0x64) from [<c01e2ea4>] (mmc_sd_remove+0x24/0x30)
[<c01e2ea4>] (mmc_sd_remove+0x24/0x30) from [<c01e0dcc>] (mmc_suspend_host+0x110/0x1a8)
[<c01e0dcc>] (mmc_suspend_host+0x110/0x1a8) from [<c01e7d04>] (omap_hsmmc_suspend+0x74/0x104)
[<c01e7d04>] (omap_hsmmc_suspend+0x74/0x104) from [<c01b08e8>] (platform_pm_suspend+0x50/0x5c)
[<c01b08e8>] (platform_pm_suspend+0x50/0x5c) from [<c01b27f0>] (pm_op+0x30/0x74)
[<c01b27f0>] (pm_op+0x30/0x74) from [<c01b2ec8>] (dpm_suspend_start+0x3b4/0x518)
[<c01b2ec8>] (dpm_suspend_start+0x3b4/0x518) from [<c0078b20>] (suspend_devices_and_enter+0x3c/0x1c4)
[<c0078b20>] (suspend_devices_and_enter+0x3c/0x1c4) from [<c0078d88>] (enter_state+0xe0/0x138)
[<c0078d88>] (enter_state+0xe0/0x138) from [<c0078444>] (state_store+0x94/0xbc)
[<c0078444>] (state_store+0x94/0xbc) from [<c017e124>] (kobj_attr_store+0x18/0x1c)
[<c017e124>] (kobj_attr_store+0x18/0x1c) from [<c00f3a08>] (sysfs_write_file+0x108/0x13c)
[<c00f3a08>] (sysfs_write_file+0x108/0x13c) from [<c00a76b8>] (vfs_write+0xac/0x154)
[<c00a76b8>] (vfs_write+0xac/0x154) from [<c00a780c>] (sys_write+0x3c/0x68)
[<c00a780c>] (sys_write+0x3c/0x68) from [<c0025e60>] (ret_fast_syscall+0x0/0x2c)


Before the hang I did a ps and found the following the following bdi thread active
474 root            SW  [flush-179:0]
After applying the patch (patch in next email) I saw successful suspend and the offensive thread was cleaned up properly.

Thanks,
-Romit
