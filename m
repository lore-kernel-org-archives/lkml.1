Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZCTEQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZCTEQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 00:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbZCTEQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 00:16:24 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47939 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZCTEQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 00:16:23 -0400
Date: Thu, 19 Mar 2009 22:15:00 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, shimada-yxb@necst.nec.co.jp,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] PCI core learns hotplug
Message-ID: <20090320041500.GB26595@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <49C1FE8A.9000401@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C1FE8A.9000401@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>> We're getting close to the new merge window, and I _think_ this
>> patch series is ready for consideration. Notably:
>>
>> 	- multiple rescans/removes of devices with and without bridges
>> 	- verified that resource allocation after multiple remove/rescan
>> 	  cycles is the same as what we had during initial boot
>> 	- fixes the complete suckage of fakephp (that I created)
>> 	- doesn't affect existing hotplug drivers
>> 	- tested on x86 and ia64 platforms
>>
>> Please review, and consider testing. For testing ease, you can pull
>> from my git branch:
>>
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/achiang/pci-hotplug.git
>> 	branch 'test-20090318' is what you want
>>
>
> I got the following oops when I did
>
> # echo 1 > remove
>
> on the bridge device.
>
> [ 6639.239164] =============================================
> [ 6639.239191] [ INFO: possible recursive locking detected ]
> [ 6639.239212] 2.6.29-rc8-kk #1
> [ 6639.239227] ---------------------------------------------
> [ 6639.239243] events/8/60 is trying to acquire lock:
> [ 6639.239252]  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+0x0/0xa0
> [ 6639.239252]
> [ 6639.239252] but task is already holding lock:
> [ 6639.239252]  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> [ 6639.239252]
> [ 6639.239252] other info that might help us debug this:
> [ 6639.239252] 3 locks held by events/8/60:
> [ 6639.239252]  #0:  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> [ 6639.239252]  #1:  (&ss->work){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> [ 6639.239252]  #2:  (pci_remove_rescan_mutex){--..}, at: [<ffffffff803c05b9>] remove_callback+0x29/0x80
> [ 6639.239252]
> [ 6639.239252] stack backtrace:
> [ 6639.239252] Pid: 60, comm: events/8 Not tainted 2.6.29-rc8-kk #1
> [ 6639.239252] Call Trace:
> [ 6639.239252]  [<ffffffff8026dfcd>] validate_chain+0xb7d/0x1260
> [ 6639.239252]  [<ffffffff8026eade>] __lock_acquire+0x42e/0xa40
> [ 6639.239252]  [<ffffffff8026f148>] lock_acquire+0x58/0x80
> [ 6639.239252]  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
> [ 6639.239252]  [<ffffffff8025800d>] flush_workqueue+0x4d/0xa0
> [ 6639.239252]  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
> [ 6639.239252]  [<ffffffff80258070>] flush_scheduled_work+0x10/0x20
> [ 6639.239252]  [<ffffffffa0158065>] e1000_remove+0x55/0xfe [e1000e]
> [ 6639.239252]  [<ffffffff8033ee60>] ? sysfs_schedule_callback_work+0x0/0x50
> [ 6639.239252]  [<ffffffff803bf7a2>] pci_device_remove+0x32/0x70
> [ 6639.239252]  [<ffffffff80441409>] __device_release_driver+0x59/0x90
> [ 6639.241006]  [<ffffffff8044153b>] device_release_driver+0x2b/0x40
> [ 6639.241006]  [<ffffffff80441036>] bus_remove_device+0xa6/0x120
> [ 6639.241006]  [<ffffffff8043dacb>] device_del+0x12b/0x190
> [ 6639.241006]  [<ffffffff8043db56>] device_unregister+0x26/0x70
> [ 6639.241006]  [<ffffffff803ba529>] pci_stop_dev+0x49/0x60
> [ 6639.241006]  [<ffffffff803ba670>] pci_remove_bus_device+0x40/0xc0
> [ 6639.241006]  [<ffffffff803ba71d>] pci_remove_behind_bridge+0x2d/0x50
> [ 6639.241006]  [<ffffffff803ba64e>] pci_remove_bus_device+0x1e/0xc0
> [ 6639.241006]  [<ffffffff803c05c8>] remove_callback+0x38/0x80
> [ 6639.241006]  [<ffffffff8033ee7f>] sysfs_schedule_callback_work+0x1f/0x50
> [ 6639.241006]  [<ffffffff8025769a>] run_workqueue+0x15a/0x230
> [ 6639.241006]  [<ffffffff80257648>] ? run_workqueue+0x108/0x230
> [ 6639.241006]  [<ffffffff8025846f>] worker_thread+0x9f/0x100
> [ 6639.241006]  [<ffffffff8025bce0>] ? autoremove_wake_function+0x0/0x40
> [ 6639.241006]  [<ffffffff802583d0>] ? worker_thread+0x0/0x100
> [ 6639.241006]  [<ffffffff8025b89d>] kthread+0x4d/0x80
> [ 6639.241006]  [<ffffffff8020d4ba>] child_rip+0xa/0x20
> [ 6639.241006]  [<ffffffff8020cebc>] ? restore_args+0x0/0x30
> [ 6639.241006]  [<ffffffff8025b850>] ? kthread+0x0/0x80
> [ 6639.241006]  [<ffffffff8020d4b0>] ? child_rip+0x0/0x20
> [ 6639.283330] e1000e 0000:40:00.0: PCI INT A disabled
> [ 6639.324332] e1000e 0000:40:00.1: PCI INT B disabled
> [ 6639.325031] aer 0000:2f:04.0:pcie22: unloading service driver aer

pci_device_remove() calls the driver's ->remove method directly;
it shouldn't be messing around with that sysfs callback.

Does this only happen with e1000e devices? Or does it happen on
any bridge device?

I am stumped; I've never seen this locking issue before...

Will continue to look, thanks.

/ac

