Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbZDHJMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbZDHJMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZDHJMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:12:21 -0400
Received: from aun.it.uu.se ([130.238.12.36]:40761 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbZDHJMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:12:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18908.27242.966881.409415@pilspetsen.it.uu.se>
Date: Wed, 8 Apr 2009 11:12:10 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: [BUG 2.6.29] NMI watchdog triggered in rb_insert_color called from enqueue_hrtimer 
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Less than an hour after updating a dual Opteron 8384 box from 2.6.29-rc6
(which it had been running for weeks) to 2.6.29 final it died with the
following watchdog-detected lockup:

BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff80315202, registers:
CPU 0 
Modules linked in: autofs4 sunrpc af_packet sg sr_mod cdrom bnx2 zlib_inflate crc32 pcspkr usb_storage ohci_hcd ehci_hcd usbcore
Pid: 2758, comm: nscd Not tainted 2.6.29 #1 Toonie
RIP: 0010:[<ffffffff80315202>]  [<ffffffff80315202>] rb_insert_color+0x2/0x110
RSP: 0018:ffff8801369c1c28  EFLAGS: 00000002
RAX: 0000000000000000 RBX: ffff8801369c1d48 RCX: 0000000000000000
RDX: ffff880028014fd0 RSI: ffff880028014fd0 RDI: ffff8801369c1d48
RBP: 0000000000000001 R08: 0000000000000001 R09: ffff8801369c1d48
R10: 0000000041a28978 R11: 0000000000000202 R12: ffff880028014fc0
R13: 000000000000c350 R14: 00000195812829fb R15: 00000000ffffffff
FS:  0000000041a29940(0063) GS:ffffffff8059d040(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f6b4daac000 CR3: 000000007f363000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process nscd (pid: 2758, threadinfo ffff8801369c0000, task ffff8801374d2ac0)
Stack:
 00000195812829fb ffffffff8024ffba ffff8801369c1d48 ffff8801369c1d48
 ffff880028014fc0 ffffffff80250644 0000000000000000 ffffffff802565c5
 0000000000000286 000000000000c350 ffff8801369c1d48 ffff8801369c1d10
Call Trace:
 [<ffffffff8024ffba>] ? enqueue_hrtimer+0x6a/0x80
 [<ffffffff80250644>] ? hrtimer_start_range_ns+0xd4/0x160
 [<ffffffff802565c5>] ? get_futex_key+0x135/0x140
 [<ffffffff80257c1a>] ? futex_wait+0x23a/0x410
 [<ffffffff802a96a5>] ? mntput_no_expire+0x35/0x140
 [<ffffffff8024fec0>] ? hrtimer_wakeup+0x0/0x30
 [<ffffffff802301b0>] ? default_wake_function+0x0/0x10
 [<ffffffff80257ed9>] ? do_futex+0xe9/0x960
 [<ffffffff802966c5>] ? cp_new_stat+0xe5/0x100
 [<ffffffff80252e18>] ? getnstimeofday+0x48/0xe0
 [<ffffffff802501c5>] ? ktime_get_ts+0x25/0x60
 [<ffffffff802587d1>] ? sys_futex+0x81/0x140
 [<ffffffff8024bdcc>] ? posix_ktime_get_ts+0xc/0x20
 [<ffffffff8020b71b>] ? system_call_fastpath+0x16/0x1b
Code: e0 03 48 09 c1 48 89 0f c3 48 89 0e 48 8b 07 83 e0 03 48 09 c1 48 89 0f c3 49 89 48 08 eb ed 66 2e 0f 1f 84 00 00 00 00 00 41 56 <49> 89 f6 41 55 49 89 fd 41 54 55 53 66 90 49 8b 5d 00 48 83 e3 
---[ end trace 5244498c0e791391 ]---

lspci appended, full dmesg and .config available on request.

00:00.0 Host bridge: ATI Technologies Inc RD890 Northbridge only dual slot (2x16) PCI-e GFX Hydra part
00:02.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI express gpp port B)
00:04.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI express gpp port D)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [IDE mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3b)
00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Link Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control
00:19.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Link Control
01:00.0 VGA compatible controller: ATI Technologies Inc RV515 [Radeon X1300]
01:00.1 Display controller: ATI Technologies Inc RV515 [Radeon X1300] (Secondary)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
02:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
