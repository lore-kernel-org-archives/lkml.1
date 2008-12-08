Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYLHVFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYLHVFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYLHVFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:05:25 -0500
Received: from mail.cacr.caltech.edu ([131.215.145.9]:37043 "EHLO
	mail.cacr.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYLHVFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:05:24 -0500
X-Greylist: delayed 752 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 16:05:24 EST
Date: Mon, 8 Dec 2008 12:52:51 -0800
From: Jan Lindheim <lindheim@cacr.caltech.edu>
To: linux-kernel@vger.kernel.org
Subject: stability problems with ixgb
Message-ID: <20081208205250.GH29279@cacr.caltech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a few large linux file servers, where we have tried to use
the Intel 10 GigE (PCI-X version) without much success.  We can easily stress
the network in a way that makes the adapter die in less than an hour.
Here's the kernel trace from when the adapter dies, using kernel 2.6.27.8:

Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950053] WARNING: at net/sched/sch_generic.c:219 dev_watchdog+0x1f8/0x210()
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950055] NETDEV WATCHDOG: eth2 (ixgb): transmit timed out
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950057] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ppdev video output pci_slot ac sbs sbshc battery ipv6 xfs sbp2 lp cfi_cmdset_0002 cfi_util jedec_probe cfi_probe i2c_nforce2 gen_probe i2c_core psmouse ixgb parport_pc pcspkr k8temp parport ck804xrom shpchp pci_hotplug mtd chipreg map_funcs container button evdev ext3 jbd mbcache sg ide_cd_mod sr_mod cdrom sd_mod sata_nv pata_amd pata_acpi floppy arcmsr ata_generic tg3 libphy libata amd74xx scsi_mod ide_core ohci1394 dock ieee1394 ehci_hcd ohci_hcd usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan fuse
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950106] Pid: 0, comm: swapper Not tainted 2.6.27.8 #2
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950108] 
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950108] Call Trace:
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950111]  <IRQ>  [<ffffffff8023beec>] warn_slowpath+0xbc/0xf0
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950120]  [<ffffffff8022d397>] ? source_load+0x37/0x70
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950124]  [<ffffffff80367a69>] ? __next_cpu+0x19/0x30
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950128]  [<ffffffff80230e1a>] ? find_busiest_group+0x19a/0x850
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950131]  [<ffffffff8036d4df>] ? strlcpy+0x4f/0x70
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950135]  [<ffffffff80427670>] ? dev_watchdog+0x0/0x210
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950138]  [<ffffffff80427868>] dev_watchdog+0x1f8/0x210
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950142]  [<ffffffff802467a8>] run_timer_softirq+0x1a8/0x220
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950146]  [<ffffffff8021db39>] ? lapic_next_event+0x9/0x20
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950149]  [<ffffffff80241ce4>] __do_softirq+0x84/0x110
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950153]  [<ffffffff8020d76c>] call_softirq+0x1c/0x30
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950156]  [<ffffffff8020f2ba>] do_softirq+0x6a/0xb0
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950158]  [<ffffffff80241c48>] irq_exit+0x98/0xb0
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950161]  [<ffffffff8021dfa7>] smp_apic_timer_interrupt+0x87/0xc0
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950164]  [<ffffffff8020d1bb>] apic_timer_interrupt+0x6b/0x70
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950166]  <EOI>  [<ffffffff80213a45>] ? default_idle+0x35/0x50
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950173]  [<ffffffff80213a43>] ? default_idle+0x33/0x50
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950175]  [<ffffffff8020aeaf>] ? cpu_idle+0x5f/0xe0
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950180]  [<ffffffff8049a885>] ? start_secondary+0x145/0x1a0
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950182] 
Dec  8 11:48:54 shc-storage02 kernel: [ 3106.950183] ---[ end trace 6be5d7707d0de713 ]---

Once the adapter stops to respond, the only way to bring it back,
is to reboot.  Unloading and restarting the kernel module and/or network
does not help.

One of the most reliable ways to bring it down, is to run a bonnie++ test from
6 clients to the server, over NFS.  Each client has gigabit network.

This is not a new problem with the latest kernel.  We have also tested with
2.6.25.6, which fails the same way.

Any insight and suggestions to the problem is much appreciated.

Regards,
Jan Lindheim
