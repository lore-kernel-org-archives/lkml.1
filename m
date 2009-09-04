Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbZIDJNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbZIDJNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933083AbZIDJNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:13:05 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41469 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031AbZIDJNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xDBwH7iI4RUdccdbYu0svw/x5yVuv3AuxM6VqTpjAV6wBjC66D5+J3sgD4k3MChB6L
         LN5wT0LKcJZ1P4c5p0/mPzTZShfTdqU1ka6ffPbqUSDCXSuQNObXcK9r4c5rsfOMLdku
         HGfhf4UebYB5XBVOe2Vzc9En178ieuLs7a6ww=
MIME-Version: 1.0
In-Reply-To: <87ljkvmt71.fsf@devron.myhome.or.jp>
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
	 <200908312119.12121.rjw@sisk.pl>
	 <c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
	 <c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
	 <20090903232317.GA6760@lst.de> <87ljkvmt71.fsf@devron.myhome.or.jp>
Date: Fri, 4 Sep 2009 11:13:02 +0200
Message-ID: <c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@lst.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/4 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Christoph Hellwig <hch@lst.de> writes:
>
>> On Fri, Sep 04, 2009 at 12:29:04AM +0200, Zdenek Kabelac wrote:
>>> Ok - another bisect game played - and unexpected winner is:
>>>
>>> (fat: add ->sync_fs)
>>>
>>> f83d6d46e7adf241a064a4a425e5cd8a8fd8925f
>>>
>>> Reverting this commit with current -rc8 kernel makes the system happy
>>> during the suspend/resume cycle. Obviously it has it price :) so just
>>> plain revert is probably not a good solution so the problem looks
>>> 'more serious'  (fat is not the only fs with this patch) thus adding
>>> original author to this thread.
>
> From it, I suspect the possible reason seems to read mmc after remove
> event. I.e. the following sequence or something
>
>    sync fs process
>    [...]
>    removed mmc event
>    [...]
>    fat_sync_fs()                   <- sync again?
>        fat_clusters_flush()
>            sb_bread()              <- read block on removed mmc
>
> Can you add dump_stack() to the top of fat_sync_fs()? I hope it tells
> why fat_sync_fs() is called (it is called from device unplug event?).
>
> Well, that commit seems a bit strange. It calls fat_clusters_flush()
> unconditionally without checking sb->s_dirt. However, if my guess is
> right, "sync after removed event" itself sounds like the issue in
> suspend process.
>
> Thanks.
>
>> Note that when you rever this patch on a current kernel you do actually
>> get different behvaviour than when going back to before this commit.
>>
>> In 2.6.30 we called ->write_super in the various sync functions and
>> then ->sync_fs, in 2.6.31-rc8 you would not call any syncing at all
>> anymore.  I think this patch might just be a symptom for a situation
>> where the suspend code causes a sync and the mmc driver can't handle
>> it anymore.

So - here is the console trace from suspend when I've added
dump_stack() to the fat_sync_fs()   (and also added debug prints
around each call in this function -so its obvious the function is
actually left - but then it freezes later somewhere.)

It's interesting that 3 calls to sync happens.

Zdenek

usb 3-1: USB disconnect, address 2
btusb_intr_complete: hci0 urb ffff880137fdd630 failed to resubmit (19)
btusb_bulk_complete: hci0 urb ffff880137fdd738 failed to resubmit (19)
btusb_bulk_complete: hci0 urb ffff880137fdd840 failed to resubmit (19)
PM: Removing info for No Bus:ep_81
PM: Removing info for No Bus:ep_82
PM: Removing info for No Bus:ep_02
PM: Removing info for usb:3-1:1.0
btusb_send_frame: hci0 urb ffff88013356b528 submission failed
PM: Removing info for No Bus:rfkill0
PM: Removing info for No Bus:hci0
PM: Removing info for No Bus:ep_83
PM: Removing info for No Bus:ep_03
PM: Removing info for usb:3-1:1.1
PM: Removing info for No Bus:ep_84
PM: Removing info for No Bus:ep_04
PM: Removing info for usb:3-1:1.2
PM: Removing info for usb:3-1:1.3
PM: Removing info for No Bus:ep_00
PM: Removing info for usb:3-1
PM: Removing info for No Bus:usbdev3.2
PM: Adding info for No Bus:vcs63
PM: Adding info for No Bus:vcsa63
FAT: dump before lock
Pid: 2271, comm: sync Not tainted 2.6.31-rc8-00043-g54a3792 #32
Call Trace:
 [<ffffffffa0537d94>] fat_sync_fs+0x24/0x80 [fat]
 [<ffffffff81132206>] __sync_filesystem+0x36/0x50
 [<ffffffff81132318>] sync_filesystems+0xf8/0x130
 [<ffffffff811323a7>] sys_sync+0x17/0x40
 [<ffffffff8100c15b>] system_call_fastpath+0x16/0x1b
FAT: fat_cluster_flush
FAT: before unlock
FAT: leaving fat_sync_fs
FAT: dump before lock
Pid: 2271, comm: sync Not tainted 2.6.31-rc8-00043-g54a3792 #32
Call Trace:
 [<ffffffffa0537d94>] fat_sync_fs+0x24/0x80 [fat]
 [<ffffffff81132206>] __sync_filesystem+0x36/0x50
 [<ffffffff81132318>] sync_filesystems+0xf8/0x130
 [<ffffffff811323b1>] sys_sync+0x21/0x40
 [<ffffffff8100c15b>] system_call_fastpath+0x16/0x1b
FAT: fat_cluster_flush
FAT: before unlock
FAT: leaving fat_sync_fs
PM: Removing info for No Bus:iwl-phy0::assoc
PM: Syncing filesystems ...
FAT: dump before lock
Pid: 2143, comm: pm-suspend Not tainted 2.6.31-rc8-00043-g54a3792 #32
Call Trace:
 [<ffffffffa0537d94>] fat_sync_fs+0x24/0x80 [fat]
 [<ffffffff81132206>] __sync_filesystem+0x36/0x50
 [<ffffffff81132318>] sync_filesystems+0xf8/0x130
 [<ffffffff811323a7>] sys_sync+0x17/0x40
 [<ffffffff8108d22b>] enter_state+0x6b/0x150
 [<ffffffff8108c7f9>] state_store+0x99/0x100
 [<ffffffff81226807>] kobj_attr_store+0x17/0x20
 [<ffffffff8116e8f9>] sysfs_write_file+0xd9/0x160
 [<ffffffff8110cc78>] vfs_write+0xb8/0x1a0
 [<ffffffff8109eb8b>] ? audit_syscall_entry+0x28b/0x2b0
 [<ffffffff8110d781>] sys_write+0x51/0x90
 [<ffffffff8100c15b>] system_call_fastpath+0x16/0x1b
FAT: fat_cluster_flush
FAT: before unlock
FAT: leaving fat_sync_fs
PM: Removing info for No Bus:iwl-phy0::RX
PM: Removing info for No Bus:iwl-phy0::TX
PM: Removing info for No Bus:iwl-phy0::radio
FAT: dump before lock
Pid: 2143, comm: pm-suspend Not tainted 2.6.31-rc8-00043-g54a3792 #32
Call Trace:
 [<ffffffffa0537d94>] fat_sync_fs+0x24/0x80 [fat]
 [<ffffffff81132206>] __sync_filesystem+0x36/0x50
 [<ffffffff81132318>] sync_filesystems+0xf8/0x130
 [<ffffffff811323b1>] sys_sync+0x21/0x40
 [<ffffffff8108d22b>] enter_state+0x6b/0x150
 [<ffffffff8108c7f9>] state_store+0x99/0x100
 [<ffffffff81226807>] kobj_attr_store+0x17/0x20
 [<ffffffff8116e8f9>] sysfs_write_file+0xd9/0x160
 [<ffffffff8110cc78>] vfs_write+0xb8/0x1a0
 [<ffffffff8109eb8b>] ? audit_syscall_entry+0x28b/0x2b0
 [<ffffffff8110d781>] sys_write+0x51/0x90
 [<ffffffff8100c15b>] system_call_fastpath+0x16/0x1b
FAT: fat_cluster_flush
FAT: before unlock
FAT: leaving fat_sync_fs
done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
platform dock.0: preparing suspend
platform dock.1: preparing suspend
platform dock.2: preparing suspend
agpgart-intel 0000:00:00.0: preparing suspend
pci 0000:00:02.0: preparing suspend
pci 0000:00:02.1: preparing suspend
e1000e 0000:00:19.0: preparing suspend, may wakeup
uhci_hcd 0000:00:1a.0: preparing suspend
uhci_hcd 0000:00:1a.1: preparing suspend
ehci_hcd 0000:00:1a.7: preparing suspend
HDA Intel 0000:00:1b.0: preparing suspend
pcieport-driver 0000:00:1c.0: preparing suspend
pcieport-driver 0000:00:1c.1: preparing suspend
pcieport-driver 0000:00:1c.2: preparing suspend
pcieport-driver 0000:00:1c.3: preparing suspend
pcieport-driver 0000:00:1c.4: preparing suspend
uhci_hcd 0000:00:1d.0: preparing suspend
uhci_hcd 0000:00:1d.1: preparing suspend
uhci_hcd 0000:00:1d.2: preparing suspend
ehci_hcd 0000:00:1d.7: preparing suspend
pci 0000:00:1e.0: preparing suspend
pci 0000:00:1f.0: preparing suspend
ata_piix 0000:00:1f.1: preparing suspend
ahci 0000:00:1f.2: preparing suspend
i801_smbus 0000:00:1f.3: preparing suspend
iwl3945 0000:03:00.0: preparing suspend
pci 0000:15:00.0: preparing suspend
sdhci-pci 0000:15:00.2: preparing suspend
pci 0000:15:00.3: preparing suspend
pci 0000:15:00.4: preparing suspend
pci 0000:15:00.5: preparing suspend
platform vesafb.0: preparing suspend
serial8250 serial8250: preparing suspend
i8042 i8042: preparing suspend
platform hdaps: preparing suspend
usb usb1: preparing type suspend, may wakeup
usb usb2: preparing type suspend, may wakeup
usb usb3: preparing type suspend, may wakeup
usb usb4: preparing type suspend, may wakeup
usb usb5: preparing type suspend, may wakeup
usb usb6: preparing type suspend, may wakeup
usb usb7: preparing type suspend, may wakeup
usb 1-4: preparing type suspend, may wakeup
usb 3-2: preparing type suspend, may wakeup
usb 1-4.4: preparing type suspend, may wakeup
iTCO_wdt iTCO_wdt: preparing suspend
platform regulatory.0: preparing suspend
thinkpad_acpi thinkpad_acpi: preparing suspend
thinkpad_hwmon thinkpad_hwmon: preparing suspend
backlight acpi_video0: legacy class suspend
drm card0: legacy class suspend
pci 0000:00:02.0: power state changed by ACPI to D3
mmcblk mmc0:b368: legacy suspend
leds mmc0::: legacy class suspend
rfkill rfkill2: legacy class suspend
ieee80211 phy0: legacy class suspend
leds tpacpi::thinkvantage: legacy class suspend
leds tpacpi::standby: legacy class suspend
leds tpacpi::power: legacy class suspend
leds tpacpi::thinklight: legacy class suspend
rfkill rfkill1: legacy class suspend
thinkpad_hwmon thinkpad_hwmon: suspend
thinkpad_acpi thinkpad_acpi: suspend
psmouse serio2: legacy suspend
platform regulatory.0: suspend
iTCO_wdt iTCO_wdt: suspend
usb 1-4.4: type suspend, may wakeup
usb 3-2: type suspend, may wakeup
usb 1-4: type suspend, may wakeup
usb usb7: type suspend, may wakeup
usb usb6: type suspend, may wakeup
usb usb5: type suspend, may wakeup
usb usb4: type suspend, may wakeup
usb usb3: type suspend, may wakeup
usb usb2: type suspend, may wakeup
usb usb1: type suspend, may wakeup
sr 3:0:0:0: legacy suspend
scsi target3:0:0: legacy suspend
sd 0:0:0:0: legacy suspend
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
scsi target0:0:0: legacy suspend
platform hdaps: suspend
psmouse serio1: legacy suspend
atkbd serio0: legacy suspend
i8042 i8042: suspend
scsi host4: legacy suspend
scsi host3: legacy suspend
scsi host2: legacy suspend
scsi host1: legacy suspend
scsi host0: legacy suspend
serial8250 serial8250: suspend
platform vesafb.0: suspend
pnp 00:0a: legacy suspend
i8042 aux 00:09: legacy suspend
i8042 kbd 00:08: legacy suspend
rtc_cmos 00:07: legacy suspend, may wakeup
pnp 00:06: legacy suspend
pnp 00:05: legacy suspend
pnp 00:04: legacy suspend
pnp 00:03: legacy suspend
system 00:02: legacy suspend
pnp 00:01: legacy suspend
system 00:00: legacy suspend
pci 0000:15:00.5: suspend
pci 0000:15:00.4: suspend
pci 0000:15:00.3: suspend
sdhci-pci 0000:15:00.2: suspend
mmc0: card b368 removed
PM: Removing info for mmc:mmc0:b368
FAT: dump before lock
Pid: 2143, comm: pm-suspend Not tainted 2.6.31-rc8-00043-g54a3792 #32
Call Trace:
 [<ffffffffa0537d94>] fat_sync_fs+0x24/0x80 [fat]
 [<ffffffff81132206>] __sync_filesystem+0x36/0x50
 [<ffffffff8113240a>] sync_filesystem+0x3a/0x70
 [<ffffffff8113b8ce>] fsync_bdev+0x2e/0x70
 [<ffffffff8121b3ce>] invalidate_partition+0x2e/0x50
 [<ffffffff81169d2f>] del_gendisk+0x3f/0x140
 [<ffffffffa02791ee>] mmc_blk_remove+0x2e/0x60 [mmc_block]
 [<ffffffffa022b2f7>] mmc_bus_remove+0x17/0x20 [mmc_core]
 [<ffffffff812d2036>] __device_release_driver+0x66/0xc0
 [<ffffffff812d219d>] device_release_driver+0x2d/0x40
 [<ffffffff812d112c>] bus_remove_device+0xac/0xe0
 [<ffffffff812cf2af>] device_del+0x12f/0x1a0
 [<ffffffffa022b3db>] mmc_remove_card+0x5b/0x90 [mmc_core]
 [<ffffffffa022d097>] mmc_sd_remove+0x27/0x50 [mmc_core]
 [<ffffffffa022ae9d>] mmc_suspend_host+0xed/0x120 [mmc_core]
 [<ffffffffa023bda8>] sdhci_suspend_host+0x38/0x60 [sdhci]
 [<ffffffffa025d270>] sdhci_pci_suspend+0x50/0x130 [sdhci_pci]
 [<ffffffff81242c3d>] pci_legacy_suspend+0x4d/0xf0
 [<ffffffff8124369d>] pci_pm_suspend+0xdd/0x130
 [<ffffffff812d660b>] pm_op+0x15b/0x1b0
 [<ffffffff812d7763>] dpm_suspend_start+0x423/0x580
 [<ffffffff8108d04f>] suspend_devices_and_enter+0x5f/0x1d0
 [<ffffffff8108d2e8>] enter_state+0x128/0x150
 [<ffffffff8108c7f9>] state_store+0x99/0x100
 [<ffffffff81226807>] kobj_attr_store+0x17/0x20
 [<ffffffff8116e8f9>] sysfs_write_file+0xd9/0x160
 [<ffffffff8110cc78>] vfs_write+0xb8/0x1a0
 [<ffffffff8109eb8b>] ? audit_syscall_entry+0x28b/0x2b0
 [<ffffffff8110d781>] sys_write+0x51/0x90
 [<ffffffff8100c15b>] system_call_fastpath+0x16/0x1b
FAT: fat_cluster_flush
FAT: before unlock
FAT: leaving fat_sync_fs
FAT: dump before lock
Pid: 2143, comm: pm-suspend Not tainted 2.6.31-rc8-00043-g54a3792 #32
Call Trace:
 [<ffffffffa0537d94>] fat_sync_fs+0x24/0x80 [fat]
 [<ffffffff81132206>] __sync_filesystem+0x36/0x50
 [<ffffffff8113241b>] sync_filesystem+0x4b/0x70
 [<ffffffff8113b8ce>] fsync_bdev+0x2e/0x70
 [<ffffffff8121b3ce>] invalidate_partition+0x2e/0x50
 [<ffffffff81169d2f>] del_gendisk+0x3f/0x140
 [<ffffffffa02791ee>] mmc_blk_remove+0x2e/0x60 [mmc_block]
 [<ffffffffa022b2f7>] mmc_bus_remove+0x17/0x20 [mmc_core]
 [<ffffffff812d2036>] __device_release_driver+0x66/0xc0
 [<ffffffff812d219d>] device_release_driver+0x2d/0x40
 [<ffffffff812d112c>] bus_remove_device+0xac/0xe0
 [<ffffffff812cf2af>] device_del+0x12f/0x1a0
 [<ffffffffa022b3db>] mmc_remove_card+0x5b/0x90 [mmc_core]
 [<ffffffffa022d097>] mmc_sd_remove+0x27/0x50 [mmc_core]
 [<ffffffffa022ae9d>] mmc_suspend_host+0xed/0x120 [mmc_core]
 [<ffffffffa023bda8>] sdhci_suspend_host+0x38/0x60 [sdhci]
 [<ffffffffa025d270>] sdhci_pci_suspend+0x50/0x130 [sdhci_pci]
 [<ffffffff81242c3d>] pci_legacy_suspend+0x4d/0xf0
 [<ffffffff8124369d>] pci_pm_suspend+0xdd/0x130
 [<ffffffff812d660b>] pm_op+0x15b/0x1b0
 [<ffffffff812d7763>] dpm_suspend_start+0x423/0x580
 [<ffffffff8108d04f>] suspend_devices_and_enter+0x5f/0x1d0
 [<ffffffff8108d2e8>] enter_state+0x128/0x150
 [<ffffffff8108c7f9>] state_store+0x99/0x100
 [<ffffffff81226807>] kobj_attr_store+0x17/0x20
 [<ffffffff8116e8f9>] sysfs_write_file+0xd9/0x160
 [<ffffffff8110cc78>] vfs_write+0xb8/0x1a0
 [<ffffffff8109eb8b>] ? audit_syscall_entry+0x28b/0x2b0
 [<ffffffff8110d781>] sys_write+0x51/0x90
 [<ffffffff8100c15b>] system_call_fastpath+0x16/0x1b
FAT: fat_cluster_flush
FAT: before unlock
FAT: leaving fat_sync_fs
