Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZGFNn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZGFNn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZGFNnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:43:21 -0400
Received: from aun.it.uu.se ([130.238.12.36]:35993 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZGFNnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:43:21 -0400
Date: Mon, 6 Jul 2009 15:43:13 +0200 (MEST)
Message-Id: <200907061343.n66DhDbC004009@pilspetsen.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: alan@lxorguk.ukuu.org.uk
Subject: 2.6.31-rc tty layer instabilities
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing semi-frequent warnings and oopses from the
tty layer in 2.6.31-rc1/rc2 at shutdown time. 2.6.30
and earlier did not have this issue.

With 2.6.31-rc1 I saw warnings like the following:

Jul  5 09:24:20 brewer shutdown[3496]: shutting down for system reboot
Jul  5 09:24:20 brewer init: Switching to runlevel: 6
Jul  5 09:24:22 brewer kernel: ------------[ cut here ]------------
Jul  5 09:24:22 brewer kernel: WARNING: at drivers/char/tty_ldisc.c:465 tty_ldisc_close+0x54/0x60()
Jul  5 09:24:22 brewer kernel: Hardware name: System Product Name
Jul  5 09:24:22 brewer kernel: Modules linked in: radeon drm i2c_core sunrpc af_packet sg snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq sr_mod cdrom snd_seq_device 8139too snd_pcm_oss mii snd_mixer_oss bitrev crc32 snd_pcm floppy snd_timer snd soundcore snd_page_alloc ehci_hcd uhci_hcd usbcore
Jul  5 09:24:22 brewer kernel: Pid: 2640, comm: su Not tainted 2.6.31-rc1 #1
Jul  5 09:24:22 brewer kernel: Call Trace:
Jul  5 09:24:22 brewer kernel:  [<c0232484>] ? tty_ldisc_close+0x54/0x60
Jul  5 09:24:22 brewer kernel:  [<c0232484>] ? tty_ldisc_close+0x54/0x60
Jul  5 09:24:22 brewer kernel:  [<c012a3ff>] ? warn_slowpath_common+0x6f/0xd0
Jul  5 09:24:22 brewer kernel:  [<c0232484>] ? tty_ldisc_close+0x54/0x60
Jul  5 09:24:22 brewer kernel:  [<c012a473>] ? warn_slowpath_null+0x13/0x20
Jul  5 09:24:22 brewer kernel:  [<c0232484>] ? tty_ldisc_close+0x54/0x60
Jul  5 09:24:22 brewer kernel:  [<c02326ab>] ? tty_ldisc_reinit+0xb/0x40
Jul  5 09:24:22 brewer kernel:  [<c0232d94>] ? tty_ldisc_hangup+0xe4/0x1c0
Jul  5 09:24:22 brewer kernel:  [<c022bd05>] ? do_tty_hangup+0xc5/0x340
Jul  5 09:24:22 brewer kernel:  [<c022c2ef>] ? disassociate_ctty+0x3f/0x1d0
Jul  5 09:24:22 brewer kernel:  [<c012d77a>] ? do_exit+0x60a/0x660
Jul  5 09:24:22 brewer kernel:  [<c022c730>] ? tty_write+0x0/0x1f0
Jul  5 09:24:22 brewer kernel:  [<c012d7fe>] ? do_group_exit+0x2e/0x90
Jul  5 09:24:22 brewer kernel:  [<c012d871>] ? sys_exit_group+0x11/0x20
Jul  5 09:24:22 brewer kernel:  [<c0102e48>] ? sysenter_do_call+0x12/0x26
Jul  5 09:24:22 brewer kernel: ---[ end trace fa9cd0bb772bb982 ]---

With 2.6.31-rc2 I instead see oopses:

Jul  6 15:23:47 brewer shutdown[29409]: shutting down for system reboot
Jul  6 15:23:47 brewer init: Switching to runlevel: 6
Jul  6 15:23:49 brewer kernel: BUG: unable to handle kernel NULL pointer dereference at 00000004
Jul  6 15:23:49 brewer kernel: IP: [<c0232494>] tty_ldisc_wait_idle+0x84/0x100
Jul  6 15:23:49 brewer kernel: *pdpt = 00000000003da001 *pde = 0000000000000000 
Jul  6 15:23:49 brewer kernel: Oops: 0000 [#1] SMP 
Jul  6 15:23:49 brewer kernel: last sysfs file: /sys/block/sda/sda8/dev
Jul  6 15:23:49 brewer kernel: Modules linked in: radeon drm i2c_core sunrpc af_packet sg snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq sr_mod cdrom snd_seq_device 8139too mii snd_pcm_oss snd_mixer_oss bitrev snd_pcm crc32 snd_timer snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Jul  6 15:23:49 brewer kernel: 
Jul  6 15:23:49 brewer kernel: Pid: 28553, comm: su Not tainted (2.6.31-rc2 #1) System Product Name
Jul  6 15:23:49 brewer kernel: EIP: 0060:[<c0232494>] EFLAGS: 00010246 CPU: 0
Jul  6 15:23:49 brewer kernel: EIP is at tty_ldisc_wait_idle+0x84/0x100
Jul  6 15:23:49 brewer kernel: EAX: 00000000 EBX: 000001f4 ECX: 00000000 EDX: 00000246
Jul  6 15:23:49 brewer kernel: ESI: f6e2b400 EDI: 00000001 EBP: f596bef8 ESP: f596beec
Jul  6 15:23:49 brewer kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jul  6 15:23:49 brewer kernel: Process su (pid: 28553, ti=f596a000 task=f6c72e40 task.ti=f596a000)
Jul  6 15:23:49 brewer kernel: Stack:
Jul  6 15:23:49 brewer kernel:  00000000 f6c72e40 c013d400 c0371d50 c0371d50 f6e2b414 f6e2b528 f6e2b400
Jul  6 15:23:49 brewer kernel: <0> f596a000 c0232c1c 00000001 f6e2b528 f6e2b528 f6e2b400 c022bbb5 00000000
Jul  6 15:23:49 brewer kernel: <0> 00000000 00000001 f741e428 f741e3c0 f7446f40 f6e2b400 00000001 f596a000
Jul  6 15:23:49 brewer kernel: Call Trace:
Jul  6 15:23:49 brewer kernel:  [<c013d400>] ? autoremove_wake_function+0x0/0x50
Jul  6 15:23:49 brewer kernel:  [<c0232c1c>] ? tty_ldisc_hangup+0xdc/0x1d0
Jul  6 15:23:49 brewer kernel:  [<c022bbb5>] ? do_tty_hangup+0xc5/0x340
Jul  6 15:23:49 brewer kernel:  [<c022c19f>] ? disassociate_ctty+0x3f/0x1d0
Jul  6 15:23:49 brewer kernel:  [<c012d73a>] ? do_exit+0x60a/0x660
Jul  6 15:23:49 brewer kernel:  [<c022c5e0>] ? tty_write+0x0/0x1f0
Jul  6 15:23:49 brewer kernel:  [<c012d7be>] ? do_group_exit+0x2e/0x90
Jul  6 15:23:49 brewer kernel:  [<c012d831>] ? sys_exit_group+0x11/0x20
Jul  6 15:23:49 brewer kernel:  [<c0102e48>] ? sysenter_do_call+0x12/0x26
Jul  6 15:23:49 brewer kernel: Code: c7 44 24 08 00 d4 13 c0 89 6c 24 0c 89 6c 24 10 bb f4 01 00 00 66 90 b8 4c 1d 37 c0 b9 02 00 00 00 89 e2 e8 9f b1 f0 ff 8b 46 28 <8b> 78 04 85 ff 74 2d 89 d8 e8 0e b7 0a 00 89 c3 85 c0 75 d8 89 
Jul  6 15:23:49 brewer kernel: EIP: [<c0232494>] tty_ldisc_wait_idle+0x84/0x100 SS:ESP 0068:f596beec
Jul  6 15:23:49 brewer kernel: CR2: 0000000000000004
Jul  6 15:23:49 brewer kernel: ---[ end trace f80c72640210fa7c ]---
Jul  6 15:23:49 brewer kernel: Fixing recursive fault but reboot is needed!
Jul  6 15:23:51 brewer init: open(/dev/console): Input/output error

This happens perhaps once every 5 or so reboots. I haven't yet seen
any specific usage pattern that might be the trigger.

/Mikael
