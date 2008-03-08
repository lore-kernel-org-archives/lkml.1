Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYCHWHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYCHWHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 17:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYCHWHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 17:07:06 -0500
Received: from 27.mail-out.ovh.net ([91.121.30.210]:47082 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752369AbYCHWHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 17:07:04 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Mar 2008 17:07:03 EST
Subject: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
From: Laurent GUERBY <laurent@guerby.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 08 Mar 2008 23:00:15 +0100
Message-Id: <1205013615.15075.409.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 82.235.162.148 (gut75-4-82-235-162-148.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a system with an "AMD64 Phenom 9500" quad core cpu, 4GB RAM,
"ASUS M3A32 MVP Deluxe wifi" motherboard with latest vendor BIOS (0801).

I tried stock debian etch kernel (Debian 2.6.18.dfsg.1-18etch1), machine
froze with no message, debian etch backport kernel same, and then
Debian 2.6.24-4 from unstable and I got some messages: machine
is not frozen but some userland processes are (ps says "Dl" state
with child in "Zs" state) and "events/3" is taking 100% cpu
according to top:

   18 root      15  -5     0    0    0 R  100  0.0  74:59.46 events/3  

Got to the same state with ubuntu hardy 2.6.24-8-server kernel. All
kernels are untainted, no X running anyway.

It takes a few hours of doing some stuff, in my case bootstraping or
testing GCC at -j 4, and then the problem happens.

I did 32 hours of memtest without issue on this system, temperatures
are very low and the case has plenty of airflow, making memory
issue less likely.

Here is what I found by looking around:

"BUG: soft lockup with kernel 2.6.23.12 (x86-64)"
http://lkml.org/lkml/2008/1/11/98

"[BUG] 2.6.24-git6 soft lockup detected while running libhugetlbfs"
http://lkml.org/lkml/2008/1/30/30
(this one has some discussion)

Bug I reported in ubuntu BTS "BUG: soft lockup - CPU#3 stuck for 11s!
[events/3:18]"
https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/197252

"BUG: soft lockup - CPU#0 stuck for 11s! [swapper:0]"
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=464387

Let me know if you need more information or if there's something
I should try. ssh and root access to this box is possible for known
developpers (send me your ssh public key), there's nothing of value on
it, I'm trying to make this system stable for use in the GCC compile
farm (which is open for free software projects):

http://gcc.gnu.org/wiki/CompileFarm

Thanks in advance,

Laurent

Mar  8 21:36:28 gcc04 kernel: BUG: soft lockup - CPU#3 stuck for 11s! [events/3:18]
Mar  8 21:36:28 gcc04 kernel: CPU 3:
Mar  8 21:36:28 gcc04 kernel: Modules linked in: tun nfs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ac battery ipv6 loop ath5k mac80211 serio_raw snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc floppy psmouse pcspkr cfg80211 button i2c_piix4 i2c_core sky2 evdev ext3 jbd mbcache dm_mirror dm_snapshot dm_mod ata_generic sd_mod usbhid hid ahci pata_marvell firewire_ohci firewire_core crc_itu_t libata r8169 atiixp ehci_hcd ohci_hcd scsi_mod generic ide_core thermal processor fan
Mar  8 21:36:28 gcc04 kernel: Pid: 18, comm: events/3 Not tainted 2.6.24-1-amd64 #1
Mar  8 21:36:28 gcc04 kernel: RIP: 0010:[<ffffffff8021bc75>]  [<ffffffff8021bc75>] __smp_call_function_mask+0x9b/0xbf
Mar  8 21:36:28 gcc04 kernel: RSP: 0000:ffff81012b773e00  EFLAGS: 00000297
Mar  8 21:36:28 gcc04 kernel: RAX: 00000000000008fc RBX: 0000000000000003 RCX: 0000000000000001
Mar  8 21:36:28 gcc04 kernel: RDX: 00000000000008fc RSI: 00000000000000fc RDI: 0000000000000007
Mar  8 21:36:28 gcc04 kernel: RBP: ffff81000103c8c0 R08: ffff81012b772000 R09: ffff810001040ee0
Mar  8 21:36:28 gcc04 kernel: R10: ffff81010484c800 R11: 0000000000000000 R12: 0000000280428760
Mar  8 21:36:28 gcc04 kernel: R13: 0000000000000000 R14: ffff81012b773d90 R15: ffff81012b773e24
Mar  8 21:36:28 gcc04 kernel: FS:  00002b97e47336d0(0000) GS:ffff81012b6b58c0(0000) knlGS:0000000000000000
Mar  8 21:36:28 gcc04 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar  8 21:36:28 gcc04 kernel: CR2: 00002b97e4c6d008 CR3: 0000000000201000 CR4: 00000000000006e0
Mar  8 21:36:28 gcc04 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  8 21:36:28 gcc04 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  8 21:36:28 gcc04 kernel: 
Mar  8 21:36:28 gcc04 kernel: Call Trace:
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff8021611c>] mcheck_check_cpu+0x0/0x37
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff8021611c>] mcheck_check_cpu+0x0/0x37
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff8021bcf7>] smp_call_function_mask+0x5e/0x70
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff802159c2>] mcheck_timer+0x0/0x7c
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff8021611c>] mcheck_check_cpu+0x0/0x37
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff8023a0cb>] on_each_cpu+0x10/0x22
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff802159df>] mcheck_timer+0x1d/0x7c
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff8027cb05>] vmstat_update+0x0/0x31
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff80244695>] run_workqueue+0x7f/0x10b
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff80244fa7>] worker_thread+0x0/0xe4
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff80245081>] worker_thread+0xda/0xe4
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff80247ff2>] autoremove_wake_function+0x0/0x2e
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff80247ed3>] kthread+0x47/0x74
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff8020cc48>] child_rip+0xa/0x12
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff80247e8c>] kthread+0x0/0x74
Mar  8 21:36:28 gcc04 kernel:  [<ffffffff8020cc3e>] child_rip+0x0/0x12
Mar  8 21:36:28 gcc04 kernel: 
Mar  8 21:36:40 gcc04 kernel: BUG: soft lockup - CPU#3 stuck for 11s! [events/3:18]
(repeated about every 11s)

# lspci
00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual slot PCI-e_GFX and HT3 K8 part
00:02.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (external gfx0 port A)
00:04.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express gpp port A)
00:06.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express gpp port C)
00:07.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express gpp port D)
00:09.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express gpp port E)
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Link Control
01:00.0 VGA compatible controller: ATI Technologies Inc RV515 [Radeon X1600]
01:00.1 Display controller: ATI Technologies Inc Unknown device 7160
02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Controller (rev b1)
03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)
04:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Controller (rev b2)
05:00.0 Ethernet controller: Atheros Communications, Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
06:08.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70)


