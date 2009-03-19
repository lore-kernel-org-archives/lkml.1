Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZCSINZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZCSINZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZCSINL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:13:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44903 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZCSINH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:13:07 -0400
Message-ID: <49C1FE8A.9000401@jp.fujitsu.com>
Date: Thu, 19 Mar 2009 17:12:58 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, shimada-yxb@necst.nec.co.jp,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] PCI core learns hotplug
References: <20090318222426.887.1008.stgit@bob.kio>
In-Reply-To: <20090318222426.887.1008.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> We're getting close to the new merge window, and I _think_ this
> patch series is ready for consideration. Notably:
> 
> 	- multiple rescans/removes of devices with and without bridges
> 	- verified that resource allocation after multiple remove/rescan
> 	  cycles is the same as what we had during initial boot
> 	- fixes the complete suckage of fakephp (that I created)
> 	- doesn't affect existing hotplug drivers
> 	- tested on x86 and ia64 platforms
> 
> Please review, and consider testing. For testing ease, you can pull
> from my git branch:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/achiang/pci-hotplug.git
> 	branch 'test-20090318' is what you want
>

I got the following oops when I did

# echo 1 > remove

on the bridge device.

[ 6639.239164] =============================================
[ 6639.239191] [ INFO: possible recursive locking detected ]
[ 6639.239212] 2.6.29-rc8-kk #1
[ 6639.239227] ---------------------------------------------
[ 6639.239243] events/8/60 is trying to acquire lock:
[ 6639.239252]  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+0x0/0xa0
[ 6639.239252]
[ 6639.239252] but task is already holding lock:
[ 6639.239252]  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
[ 6639.239252]
[ 6639.239252] other info that might help us debug this:
[ 6639.239252] 3 locks held by events/8/60:
[ 6639.239252]  #0:  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
[ 6639.239252]  #1:  (&ss->work){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
[ 6639.239252]  #2:  (pci_remove_rescan_mutex){--..}, at: [<ffffffff803c05b9>] remove_callback+0x29/0x80
[ 6639.239252]
[ 6639.239252] stack backtrace:
[ 6639.239252] Pid: 60, comm: events/8 Not tainted 2.6.29-rc8-kk #1
[ 6639.239252] Call Trace:
[ 6639.239252]  [<ffffffff8026dfcd>] validate_chain+0xb7d/0x1260
[ 6639.239252]  [<ffffffff8026eade>] __lock_acquire+0x42e/0xa40
[ 6639.239252]  [<ffffffff8026f148>] lock_acquire+0x58/0x80
[ 6639.239252]  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
[ 6639.239252]  [<ffffffff8025800d>] flush_workqueue+0x4d/0xa0
[ 6639.239252]  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
[ 6639.239252]  [<ffffffff80258070>] flush_scheduled_work+0x10/0x20
[ 6639.239252]  [<ffffffffa0158065>] e1000_remove+0x55/0xfe [e1000e]
[ 6639.239252]  [<ffffffff8033ee60>] ? sysfs_schedule_callback_work+0x0/0x50
[ 6639.239252]  [<ffffffff803bf7a2>] pci_device_remove+0x32/0x70
[ 6639.239252]  [<ffffffff80441409>] __device_release_driver+0x59/0x90
[ 6639.241006]  [<ffffffff8044153b>] device_release_driver+0x2b/0x40
[ 6639.241006]  [<ffffffff80441036>] bus_remove_device+0xa6/0x120
[ 6639.241006]  [<ffffffff8043dacb>] device_del+0x12b/0x190
[ 6639.241006]  [<ffffffff8043db56>] device_unregister+0x26/0x70
[ 6639.241006]  [<ffffffff803ba529>] pci_stop_dev+0x49/0x60
[ 6639.241006]  [<ffffffff803ba670>] pci_remove_bus_device+0x40/0xc0
[ 6639.241006]  [<ffffffff803ba71d>] pci_remove_behind_bridge+0x2d/0x50
[ 6639.241006]  [<ffffffff803ba64e>] pci_remove_bus_device+0x1e/0xc0
[ 6639.241006]  [<ffffffff803c05c8>] remove_callback+0x38/0x80
[ 6639.241006]  [<ffffffff8033ee7f>] sysfs_schedule_callback_work+0x1f/0x50
[ 6639.241006]  [<ffffffff8025769a>] run_workqueue+0x15a/0x230
[ 6639.241006]  [<ffffffff80257648>] ? run_workqueue+0x108/0x230
[ 6639.241006]  [<ffffffff8025846f>] worker_thread+0x9f/0x100
[ 6639.241006]  [<ffffffff8025bce0>] ? autoremove_wake_function+0x0/0x40
[ 6639.241006]  [<ffffffff802583d0>] ? worker_thread+0x0/0x100
[ 6639.241006]  [<ffffffff8025b89d>] kthread+0x4d/0x80
[ 6639.241006]  [<ffffffff8020d4ba>] child_rip+0xa/0x20
[ 6639.241006]  [<ffffffff8020cebc>] ? restore_args+0x0/0x30
[ 6639.241006]  [<ffffffff8025b850>] ? kthread+0x0/0x80
[ 6639.241006]  [<ffffffff8020d4b0>] ? child_rip+0x0/0x20
[ 6639.283330] e1000e 0000:40:00.0: PCI INT A disabled
[ 6639.324332] e1000e 0000:40:00.1: PCI INT B disabled
[ 6639.325031] aer 0000:2f:04.0:pcie22: unloading service driver aer

Thanks,
Kenji Kaneshige

 
> Note, this test branch does contain the small assorted patches in AER
> and the PCIe portdriver that I fixed along the way, but does not contain
> the sysfs callback mutex that I introduced to protect myself from
> Vegard Nossum. ;) If you want to hammer away at the sysfs interface,
> please apply this patch on top:
> 
> 	http://thread.gmane.org/gmane.linux.kernel/806648
> 
> What I'm continuing to do:
> 
> 	- investigate converting existing hotplug drivers to use
> 	  new pci_rescan_bus() interface
> 
> Thanks.
> 
> /ac
> 
> v3 -> v4:
> 	- protect sysfs interfaces with mutex
> 	- undo changes in pci_do_scan_bus
> 	- introduce pci_rescan_bus instead
> 	- do not initialize bridges more than once
> 
> v2 -> v3:
> 	- properly remove device with internal bridge
> 	- added Kenji Kaneshige's pci_is_root_bus() interface
> 	- dropped whitespace cleanups for another time
> 
> v1 -> v2:
> 	- incorporated lots of Trent Piepho's work
> 	- beefed up pci_do_scan_bus as heavy lifter for rescanning
> 	- small bugfixes folded into earlier patches to get everything working
> 
> ---
> 
> Alex Chiang (8):
>       PCI Hotplug: schedule fakephp for feature removal
>       PCI Hotplug: rename legacy_fakephp to fakephp
>       PCI: Introduce /sys/bus/pci/devices/.../rescan
>       PCI: Introduce /sys/bus/pci/devices/.../remove
>       PCI: Introduce /sys/bus/pci/rescan
>       PCI: Introduce pci_rescan_bus()
>       PCI: do not initialize bridges more than once
>       PCI: always scan child buses
> 
> Kenji Kaneshige (1):
>       PCI: pci_is_root_bus helper
> 
> Trent Piepho (3):
>       PCI Hotplug: restore fakephp interface with complete reimplementation
>       PCI: pci_scan_slot() returns newly found devices
>       PCI: don't scan existing devices
> 
> 
>  Documentation/ABI/testing/sysfs-bus-pci    |   27 ++
>  Documentation/feature-removal-schedule.txt |   32 ++
>  Documentation/filesystems/sysfs-pci.txt    |   10 +
>  drivers/pci/hotplug/fakephp.c              |  443 +++++++---------------------
>  drivers/pci/pci-driver.c                   |    1 
>  drivers/pci/pci-sysfs.c                    |   95 ++++++
>  drivers/pci/pci.h                          |    6 
>  drivers/pci/probe.c                        |  103 ++++---
>  drivers/pci/setup-bus.c                    |    3 
>  include/linux/pci.h                        |   12 +
>  10 files changed, 358 insertions(+), 374 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


