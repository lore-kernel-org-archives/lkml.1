Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXKOTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXKOTF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbXKOTFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:05:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513AbXKOTFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:05:13 -0500
Date: Thu, 15 Nov 2007 14:05:11 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: strange oops in iput. (2.6.23.1)
Message-ID: <20071115190511.GA21307@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I got a report from a user this morning with the following oops.

Unable to handle kernel NULL pointer dereference at 0000000000000038 RIP:
 [<ffffffff810ad479>] iput+0x18/0x7b
PGD 6fdf9067 PUD 7810c067 PMD 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in: berry_charge tun vfat fat usb_storage appletalk ipx p8023 i915 drm dcdbas ipt_MASQUERADE iptable_nat nf_nat bridge rfcomm l2cap autofs4 sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath kvm_intel kvm snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq arc4 ecb snd_seq_device blkcipher snd_pcm_oss snd_mixer_oss snd_pcm snd_timer iwl3945 snd_page_alloc mac80211 tg3 snd_hwdep firewire_ohci hci_usb i2c_i801 i2c_core video firewire_core snd option cfg80211 button battery bluetooth ac output usbserial soundcore sg iTCO_wdt crc_itu_t joydev iTCO_vendor_support sr_mod cdrom dm_snapshot dm_zero dm_mirror dm_mod ata_generic ata_piix libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 277, comm: kswapd0 Not tainted 2.6.23.1-42.fc8 #1
RIP: 0010:[<ffffffff810ad479>]  [<ffffffff810ad479>] iput+0x18/0x7b
RSP: 0018:ffff810037f11d60  EFLAGS: 00010283
RAX: 0000000000000000 RBX: ffff81000003fcc8 RCX: ffff81000003fcf8
RDX: ffff81000003fcf8 RSI: ffff8100007c5d50 RDI: ffff81000003fcc8
RBP: 0000000000000001 R08: 0000000000000001 R09: ffff8100007c5b60
R10: 0000000000000282 R11: ffff8100007c5c30 R12: ffff8100007c5d00
R13: 0000000000000060 R14: 0000000000000001 R15: 0000000000000100
FS:  0000000000000000(0000) GS:ffff810037c2c300(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000038 CR3: 000000006f40a000 CR4: 00000000000026a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kswapd0 (pid: 277, threadinfo ffff810037f10000, task ffff810037f05020)
Stack:  ffff810037cc6870 ffffffff810ab41a 0000000000000282 ffff810037cc6870
 0000000000000000 ffffffff810ac118 ffff8100007c5c30 ffff810037cc6870
 ffff8100007c5d00 ffffffff810ac2e1 ffffffff8137e220 000000000000b98c
Call Trace:
 [<ffffffff810ab41a>] d_kill+0x21/0x43
 [<ffffffff810ac118>] prune_one_dentry+0x3a/0xee
 [<ffffffff810ac2e1>] prune_dcache+0x115/0x163
 [<ffffffff810ac34b>] shrink_dcache_memory+0x1c/0x36
 [<ffffffff8107bc99>] shrink_slab+0xdc/0x154
 [<ffffffff8107c576>] kswapd+0x318/0x4a8
 [<ffffffff810493c1>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8107c25e>] kswapd+0x0/0x4a8
 [<ffffffff8104926c>] kthread+0x47/0x73
 [<ffffffff8100c9e8>] child_rip+0xa/0x12
 [<ffffffff8101dd1e>] flat_send_IPI_mask+0x0/0x4c
 [<ffffffff81049225>] kthread+0x0/0x73
 [<ffffffff8100c9de>] child_rip+0x0/0x12
 
Code: 48 8b 40 38 75 04 0f 0b eb fe 48 85 c0 74 0b 48 8b 40 28 48


Which appears that inode->i_sb was null which afaict, shouldn't
ever happen.   How is this possible?  A race perhaps?

(only ext3 filesystems were in use)

	Dave

-- 
http://www.codemonkey.org.uk
