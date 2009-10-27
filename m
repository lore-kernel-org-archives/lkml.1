Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZJ0MBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZJ0MBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 08:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZJ0MBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 08:01:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55786 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbZJ0MBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 08:01:52 -0400
From: "Dasgupta, Romit" <romit@ti.com>
To: "Hilman, Kevin" <khilman@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 27 Oct 2009 17:31:30 +0530
Subject: [PATCH] PM: Fixes warning on suspend errors
Thread-Topic: [PATCH] PM: Fixes warning on suspend errors
Thread-Index: AcpW/TguHlLgiK/OSwWE73VOdePpNg==
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE0DC96A@dbde02.ent.ti.com>
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
     I get the following errors when I choose devices in /sys/power/pm_test. It also shows that if 'dpm_suspend_start' fails somewhere down the line then the kernel does not reset the 'transition_started' variable and we can get warning similar to below. IMHO 'dpm_resume_noirq' is not the right place for setting this variable. Please see the patch below which fixes the issue.

Thanks,
-Romit


# [  113.713958] mmcblk0: mmc1:0001 STM16G 14.8 GiB
[  113.718902]  mmcblk0: unknown partition table
[  113.745574] ------------[ cut here ]------------
[  113.751525] WARNING: at drivers/base/power/main.c:98 device_pm_add+0x94/0xdc()
[  113.758819] Device: bdi
[  113.758819] Parentless device registered during a PM transaction
[  113.773071] Modules linked in:
[  113.776214] [<c002b87c>] (unwind_backtrace+0x0/0xdc) from [<c004ff58>] (warn_slowpath_common+0x48/0x60)
[  113.785705] [<c004ff58>] (warn_slowpath_common+0x48/0x60) from [<c004ffa8>] (warn_slowpath_fmt+0x24/0x30)
[  113.799896] [<c004ffa8>] (warn_slowpath_fmt+0x24/0x30) from [<c01b36b8>] (device_pm_add+0x94/0xdc)
[  113.808990] [<c01b36b8>] (device_pm_add+0x94/0xdc) from [<c01ad9bc>] (device_add+0x3a8/0x534)
[  113.817565] [<c01ad9bc>] (device_add+0x3a8/0x534) from [<c01adbd8>] (device_create_vargs+0x78/0xa8)
[  113.829650] [<c01adbd8>] (device_create_vargs+0x78/0xa8) from [<c0090a9c>] (bdi_register+0x3c/0x154)
[  113.839263] [<c0090a9c>] (bdi_register+0x3c/0x154) from [<c0090bd4>] (bdi_register_dev+0x20/0x28)
[  113.851348] [<c0090bd4>] (bdi_register_dev+0x20/0x28) from [<c0173b98>] (add_disk+0xe4/0x124)
[  113.859954] [<c0173b98>] (add_disk+0xe4/0x124) from [<c01e6b54>] (mmc_blk_probe+0x250/0x288)
[  113.870513] [<c01e6b54>] (mmc_blk_probe+0x250/0x288) from [<c01e14d4>] (mmc_bus_probe+0x18/0x1c)
[  113.879394] [<c01e14d4>] (mmc_bus_probe+0x18/0x1c) from [<c01af97c>] (driver_probe_device+0xa0/0x14c)
[  113.893890] [<c01af97c>] (driver_probe_device+0xa0/0x14c) from [<c01aef44>] (bus_for_each_drv+0x44/0x80)
[  113.905609] [<c01aef44>] (bus_for_each_drv+0x44/0x80) from [<c01afb60>] (device_attach+0x50/0x68)
[  113.914550] [<c01afb60>] (device_attach+0x50/0x68) from [<c01aed94>] (bus_probe_device+0x24/0x40)
[  113.925170] [<c01aed94>] (bus_probe_device+0x24/0x40) from [<c01ad9f0>] (device_add+0x3dc/0x534)
[  113.934082] [<c01ad9f0>] (device_add+0x3dc/0x534) from [<c01e1688>] (mmc_add_card+0xcc/0x118)
[  113.945251] [<c01e1688>] (mmc_add_card+0xcc/0x118) from [<c01e2408>] (mmc_attach_mmc+0xdc/0x13c)
[  113.954132] [<c01e2408>] (mmc_attach_mmc+0xdc/0x13c) from [<c01e12f0>] (mmc_rescan+0x2b0/0x2e8)
[  113.964874] [<c01e12f0>] (mmc_rescan+0x2b0/0x2e8) from [<c0060840>] (worker_thread+0x16c/0x218)
[  113.973693] [<c0060840>] (worker_thread+0x16c/0x218) from [<c0063d88>] (kthread+0x7c/0x84)
[  113.986694] [<c0063d88>] (kthread+0x7c/0x84) from [<c0026ea0>] (kernel_thread_exit+0x0/0x8)
[  113.995147] ---[ end trace aaa7bf5becc572f5 ]---




Fixes the location where we decide that our power transition is complete.
Signed-off-by: Romit Dasgupta <romit@ti.com>
---
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index e0dc407..6b9e991 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -365,7 +365,6 @@ void dpm_resume_noirq(pm_message_t state)
 	struct device *dev;
 
 	mutex_lock(&dpm_list_mtx);
-	transition_started = false;
 	list_for_each_entry(dev, &dpm_list, power.entry)
 		if (dev->power.status > DPM_OFF) {
 			int error;
@@ -529,6 +528,7 @@ static void dpm_complete(pm_message_t state)
 		put_device(dev);
 	}
 	list_splice(&list, &dpm_list);
+	transition_started = false;
 	mutex_unlock(&dpm_list_mtx);
 }

