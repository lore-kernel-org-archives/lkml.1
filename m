Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbYDKXsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbYDKXsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbYDKXsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:48:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:20232 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbYDKXsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YR9wazIPPLQMEq1BJunqxpdVZeuzetFu6L/+2Eh4pM9VlQEy7kqH6MXKAV1B1kZMIJ/6c61G5r3wOqVd+3vMAqZP4v1NP/OndaeW7zAwTBQWToxxTqawn7NAfpUdn8Z1IoaIS0E2ie5vOrFwfSrTdLdYSWoRI/yliOXW/eBxagk=
Date: Sat, 12 Apr 2008 03:43:45 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc8-mm2: panic involving mount_block_root and down the road
Message-ID: <20080411234345.GA4742@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410203354.f0a6f464.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka fixed SLUB for me, and now core2 box survives up and including to
not finding / :

Setup is SATA disk with plain old partitions, nothing lvmancy:

	/dev/sda2 on / type ext3 (rw,noatime)

CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_ATA_PIIX=y
CONFIG_PATA_JMICRON=y

sda1 is for swap.


[    3.920000] NET: Registered protocol family 1
[    3.920000] VFS: Cannot open root device "sda2" or unknown-block(0,0)
[    3.920000] Please append a correct "root=" boot option; here are the available partitions:
[    3.920000] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    3.920000] Pid: 1, comm: swapper Not tainted 2.6.25-rc8-mm2 #19
[    3.920000] 
[    3.920000] Call Trace:
[    3.920000]  [<ffffffff8022ff80>] panic+0xa0/0x180
[    3.920000]  [<ffffffff8044d8c9>] ? mutex_unlock+0x9/0x10
[    3.920000]  [<ffffffff805d8e03>] ? printk_all_partitions+0x23/0x180
[    3.920000]  [<ffffffff8044d8c9>] ? mutex_unlock+0x9/0x10
[    3.920000]  [<ffffffff805d8efc>] ? printk_all_partitions+0x11c/0x180
[    3.920000]  [<ffffffff8044ee46>] ? _read_unlock+0x26/0x30
[    3.920000]  [<ffffffff805c8e82>] mount_block_root+0x102/0x2a0
[    3.920000]  [<ffffffff805c9076>] mount_root+0x56/0x60
[    3.920000]  [<ffffffff805c90cc>] prepare_namespace+0x4c/0x160
[    3.920000]  [<ffffffff805c8bce>] kernel_init+0x23e/0x2f0
[    3.920000]  [<ffffffff80228b17>] ? finish_task_switch+0x67/0xe0
[    3.920000]  [<ffffffff8020c358>] child_rip+0xa/0x12
[    3.920000]  [<ffffffff803184d2>] ? acpi_os_acquire_lock+0x9/0xb
[    3.920000]  [<ffffffff805c8990>] ? kernel_init+0x0/0x2f0
[    3.920000]  [<ffffffff8020c34e>] ? child_rip+0x0/0x12


The very same sequence with lockdep on (I originally thought it's the
culprit):


[   12.770000] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
[   17.820000] atl1 0000:03:00.0: eth0 link is up 1000 Mbps full duplex
[    3.500000] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    3.500000] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    3.500000] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    3.500000] scsi0 : ahci
[    3.500000] scsi1 : ahci
[    3.500000] ata1: SATA max UDMA/133 abar m8192@0xfe8fe000 port 0xfe8fe100 irq 16
[    3.500000] ata2: SATA max UDMA/133 abar m8192@0xfe8fe000 port 0xfe8fe180 irq 16
[    3.500000] INFO: trying to register non-static key.
[    3.500000] the code is fine but needs lockdep annotation.
[    3.500000] turning off the locking correctness validator.
[    3.500000] Pid: 358, comm: scsi_eh_0 Not tainted 2.6.25-rc8-mm2 #17
[    3.500000] 
[    3.500000] Call Trace:
[    3.500000]  [<ffffffff80250631>] ? static_obj+0xd1/0xe0
[    3.500000]  [<ffffffff80252bba>] register_lock_class+0x44a/0x4f0
[    3.500000]  [<ffffffff80252cd0>] __lock_acquire+0x70/0xc50
[    3.500000]  [<ffffffff80253907>] lock_acquire+0x57/0x80
[    3.500000]  [<ffffffff80241ea5>] ? __cancel_work_timer+0x55/0x230
[    3.500000]  [<ffffffff80241ed5>] __cancel_work_timer+0x85/0x230
[    3.500000]  [<ffffffff8025262d>] ? trace_hardirqs_on+0xd/0x10
[    3.500000]  [<ffffffff80252599>] ? trace_hardirqs_on_caller+0xc9/0x150
[    3.500000]  [<ffffffff8025262d>] ? trace_hardirqs_on+0xd/0x10
[    3.500000]  [<ffffffff8045425b>] ? _spin_unlock_irq+0x2b/0x40
[    3.500000]  [<ffffffff80228e60>] ? finish_task_switch+0x0/0xe0
[    3.500000]  [<ffffffff80228ec7>] ? finish_task_switch+0x67/0xe0
[    3.500000]  [<ffffffff8024208d>] cancel_delayed_work_sync+0xd/0x10
[    3.500000]  [<ffffffff8037d0a8>] ata_port_flush_task+0x18/0x50
[    3.500000]  [<ffffffff80389ac4>] ata_scsi_error+0x24/0x680
[    3.500000]  [<ffffffff80371b70>] ? scsi_error_handler+0x0/0x330
[    3.500000]  [<ffffffff80371c4c>] scsi_error_handler+0xdc/0x330
[    3.500000]  [<ffffffff80451d4a>] ? thread_return+0x4e/0x4e4
[    3.500000]  [<ffffffff80252599>] ? trace_hardirqs_on_caller+0xc9/0x150
[    3.500000]  [<ffffffff80371b70>] ? scsi_error_handler+0x0/0x330
[    3.500000]  [<ffffffff802456fd>] kthread+0x4d/0x80
[    3.500000]  [<ffffffff8020c408>] child_rip+0xa/0x12
[    3.500000]  [<ffffffff8020bb1f>] ? restore_args+0x0/0x30
[    3.500000]  [<ffffffff802456b0>] ? kthread+0x0/0x80
[    3.500000]  [<ffffffff8020c3fe>] ? child_rip+0x0/0x12
[    3.500000] 
[    3.600000] ata1: SATA link down (SStatus 0 SControl 300)
[    3.690000] ata2: SATA link down (SStatus 0 SControl 300)
[    3.690000] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.690000] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    3.690000] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.690000] mice: PS/2 mouse device common for all mice
[    3.690000] Advanced Linux Sound Architecture Driver Version 1.0.16.
[    3.700000] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[    3.700000] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    3.720000] input: AT Translated Set 2 keyboard as /class/input/input0
[    4.000000] ALSA device list:
[    4.000000]   #0: HDA Intel at 0xfebf8000 irq 22
[    4.000000] TCP cubic registered
[    4.000000] NET: Registered protocol family 1
[    4.000000] VFS: Cannot open root device "sda2" or unknown-block(0,0)
[    4.000000] Please append a correct "root=" boot option; here are the available partitions:
[    4.000000] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    4.000000] Pid: 1, comm: swapper Not tainted 2.6.25-rc8-mm2 #17
[    4.000000] 
[    4.000000] Call Trace:
[    4.000000]  [<ffffffff80230720>] panic+0xa0/0x180
[    4.000000]  [<ffffffff80452b79>] ? mutex_unlock+0x9/0x10
[    4.000000]  [<ffffffff80452b79>] ? mutex_unlock+0x9/0x10
[    4.000000]  [<ffffffff805df01c>] ? printk_all_partitions+0x11c/0x180
[    4.000000]  [<ffffffff804541e6>] ? _read_unlock+0x26/0x30
[    4.000000]  [<ffffffff805ceea2>] mount_block_root+0x102/0x2a0
[    4.000000]  [<ffffffff805cf096>] mount_root+0x56/0x60
[    4.000000]  [<ffffffff805cf0ec>] prepare_namespace+0x4c/0x160
[    4.000000]  [<ffffffff805cebeb>] kernel_init+0x23b/0x2f0
[    4.000000]  [<ffffffff80453f37>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    4.000000]  [<ffffffff80252599>] ? trace_hardirqs_on_caller+0xc9/0x150
[    4.000000]  [<ffffffff8020c408>] child_rip+0xa/0x12
[    4.000000]  [<ffffffff8020bb1f>] ? restore_args+0x0/0x30
[    4.000000]  [<ffffffff805ce9b0>] ? kernel_init+0x0/0x2f0
[    4.000000]  [<ffffffff8020c3fe>] ? child_rip+0x0/0x12

