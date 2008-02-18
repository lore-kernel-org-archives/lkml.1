Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYBRABf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYBRABf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 19:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbYBRABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 19:01:25 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:52120 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754663AbYBRABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 19:01:23 -0500
X-Authority-Analysis: v=1.0 c=1 a=ZlWJWtZrzcEafByRBEdDrg==:17
 a=CiFO0WPq7kWt5Z2roPoA:9 a=aV5xuJNALr0R4v-zu04A:7
 a=JB3qHSU2ZxsfexY4GMTHvGng5NcA:4 a=8t_6ZPhla3UA:10
From: kelk1@comcast.net (Quel Qun)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
Date: Mon, 18 Feb 2008 00:01:21 +0000
Message-Id: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -------------- Original message ----------------------
From: Thomas Gleixner <tglx@linutronix.de>
> On Sat, 16 Feb 2008, Quel Qun wrote:
> Unfortunately we only see that the list is corrupted but not which
> code caused it. This looks like something forgot to delete the timer
> before freeing the datastructure which contains it.
> 
> Can you please enable CONFIG_SLUB_DEBUG=y and CONFIG_SLUB_DEBUG_ON=y
> and give it another try?
> 
> If we can not catch it that way, I'll whip up a patch which points us
> to the code which added the offending timer.
> 
Hi,

Note: I switched to 2.6.25-rc2. The only new thing I see is this message:

hci_cmd_task: hci0 command tx timeout

This comes from net/bluetooth/hci_core.c, line 1547

There is indeed a timeout message in the log (at the end of this email). I tried to boot 
with slub_debug but did not get anything more. slabinfo -v does not report anything either.

Crash log:

hci_cmd_task: hci0 command tx timeout
BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<c012d1af>] get_next_timer_interrupt+0xf6/0x1fc
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: hidp rfcomm l2cap nfsd exportfs nfs lockd nfs_acl sunrpc af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat piix ide_core fuse snd_pcm_oss snd_mixer_oss hci_usb snd_intel8x0 snd_ac97_codec ac97_bus bluetooth parport_pc i2c_i801 parport i2c_core sr_mod snd_pcm pcspkr rtc_cmos snd_timer snd iTCO_wdt soundcore iTCO_vendor_support snd_page_alloc thermal button processor tg3 evdev dcdbas sg ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted (2.6.25-rc2kk1 #1)
EIP: 0060:[<c012d1af>] EFLAGS: 00010016 CPU: 0
EIP is at get_next_timer_interrupt+0xf6/0x1fc
EAX: 6b6b6b6b EBX: 00084e8e ECX: c043067c EDX: 6b6b6b6b
ESI: 0000000e EDI: c043060c EBP: c03afee8 ESP: c03afeb0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c03ae000 task=c03803a0 task.ti=c03ae000)
Stack: 00084e00 00084d00 c042fe00 00000000 00000001 0000000e 0000084e c043060c 
       c043080c c0430a0c c0430c0c c18090c0 8251f800 00084d00 c03aff2c c013f9a8 
       00000001 c03a2b08 00000046 c03aff20 825216b1 000000c4 8251f800 000000c4 
Call Trace:
 [<c013f9a8>] ? tick_nohz_stop_sched_tick+0x130/0x337
 [<c01299d4>] ? irq_exit+0x55/0x6e
 [<c0114717>] ? smp_apic_timer_interrupt+0x59/0x92
 [<c010582c>] ? apic_timer_interrupt+0x28/0x30
 [<c013007b>] ? send_group_sigqueue+0xdc/0x10e
 [<c011879f>] ? native_safe_halt+0x5/0x7
 [<c0103965>] ? default_idle+0x4d/0x7f
 [<c0103918>] ? default_idle+0x0/0x7f
 [<c01037c4>] ? cpu_idle+0x6f/0x100
 [<c02e29b9>] ? rest_init+0x49/0x50
 =======================
Code: 8d e0 8b 45 e0 83 e0 3f 89 45 dc 89 c6 8b 04 f7 8b 10 0f 18 02 90 8d 0c f7 39 c8 0f 84 82 00 00 00 8b 40 08 39 d8 0f 48 d8 89 d0 <8b> 12 0f 18 02 90 39 c1 75 ec c7 45 d4 01 00 00 00 8b 7d dc 85 
EIP: [<c012d1af>] get_next_timer_interrupt+0xf6/0x1fc SS:ESP 0068:c03afeb0
---[ end trace 04af5dc7a2225613 ]---
Kernel panic - not syncing: Attempted to kill the idle task!

Here is the log when I get something before it crashes. No difference with when it works under 2.6.23.1:

kernel: Bluetooth: L2CAP socket layer initialized
bluetooth: Starting bluetooth service
hcid[5014]: Bluetooth HCI daemon
hcid[5014]: HCI dev 0 registered
hcid[5014]: HCI dev 0 already up
hcid[5014]: Device hci0 has been added
hcid[5014]: Starting security manager 0
kernel: Bluetooth: RFCOMM socket layer initialized
kernel: Bluetooth: RFCOMM TTY layer initialized
kernel: Bluetooth: RFCOMM ver 1.8
bluetooth: Starting hidd
kernel: Bluetooth: HIDP (Human Interface Emulation) ver 1.2
hidd[5056]: Bluetooth HID daemon
hcid[5014]: Can't read version info for hci0: Connection timed out (110)
hcid[5014]: Starting SDP server
hcid[5014]: Created local server at unix:abstract=/var/run/dbus-oaCBrCPPW2,guid=200dae308c72ef5021d6344847b8c631

Sorry for the meager yield.
--
kk1
