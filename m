Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZHSPtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZHSPtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZHSPtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:49:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZHSPta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:49:30 -0400
Date: Wed, 19 Aug 2009 11:49:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, mingo@goodmis.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [BUG] lockup with the latest kernel
Message-ID: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm hitting this funny lockup and I'm not sure why. This box is an older 
i386 SMP box that has two sockets (no dual core).

$ cat  /proc/cpuinfo 
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 6
model		: 10
model name	: AMD Athlon(tm) MP 2800+
stepping	: 0
cpu MHz		: 2133.418
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips	: 4266.83
clflush size	: 32
power management: ts

processor	: 1
vendor_id	: AuthenticAMD
[ same as above ]


$ lspci -vvv
[snip]
00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ACPI (rev 03)
        Subsystem: Advanced Micro Devices [AMD] AMD-768 [Opus] ACPI
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel driver in use: amd756_smbus
[snip]

Here's a few backtraces:

[13288.222084] BUG: NMI Watchdog detected LOCKUP on CPU0, ip c0110821, 
registers:
[13288.222084] Modules linked in: iptable_filter ip_tables x_tables 
binfmt_misc ppdev lp autofs4 nfsd exportfs nfs lockd nfs_acl auth_rpcgss 
sunrpc ipv6 sd_mod dm_snapshot dm_mirror dm_region_hash dm_log dm_mod 
snd_usb_audio snd_usb_lib usbhid usb_storage hid usblp snd_emu10k1_synth 
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_util_mem snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer 3c59x emu10k1_gp snd_seq_device mii 
gameport ohci_hcd snd ehci_hcd soundcore usbcore shpchp pci_hotplug 
i2c_amd756 amd_k7_agp i2c_core amd_rng agpgart rng_core container thermal 
processor thermal_sys button ide_cd_mod evdev cdrom psmouse serio_raw 
pcspkr parport_pc floppy parport
[13288.222084] 
[13288.222084] Pid: 3, comm: migration/0 Not tainted (2.6.30-rc6 #3) 
Unknown
[13288.222084] EIP: 0060:[<c0110821>] EFLAGS: 00000002 CPU: 0
[13288.222084] EIP is at default_send_IPI_mask_logical+0x53/0x92
[13288.222084] EAX: fffff000 EBX: 000000fd ECX: c042cccc EDX: 00000800
[13288.222084] ESI: 00000002 EDI: 00000086 EBP: f7065f10 ESP: f7065f00
[13288.222084]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[13288.222084] Process migration/0 (pid: 3, ti=f7064000 task=f705f0c0 
task.ti=f7064000)
[13288.222084] Stack:
[13288.222084]  c0350550 0000007e efbfea20 c1819c60 f7065f18 c010f1fa 
f7065f24 c011b69c
[13288.222084]  c0350490 f7065f2c c011b70b f7065f5c c01213d3 00000000 
00000000 00000001
[13288.222084]  00000000 00000001 00000000 00000092 c5685f08 c5685f44 
00000003 f7065f64
[13288.222084] Call Trace:
[13288.222084]  [<c010f1fa>] ? native_smp_send_reschedule+0x44/0x46
[13288.222084]  [<c011b69c>] ? resched_task+0x5f/0x62
[13288.222084]  [<c011b70b>] ? check_preempt_curr_idle+0x13/0x15
[13288.222084]  [<c01213d3>] ? try_to_wake_up+0x1f4/0x228
[13288.222084]  [<c0121417>] ? default_wake_function+0x10/0x12
[13288.222084]  [<c011a22f>] ? __wake_up_common+0x39/0x61
[13288.222084]  [<c011b7da>] ? complete+0x30/0x43
[13288.222084]  [<c0123eaa>] ? migration_thread+0x19d/0x1db
[13288.222084]  [<c0123d0d>] ? migration_thread+0x0/0x1db
[13288.222084]  [<c0137411>] ? kthread+0x4b/0x6f
[13288.222084]  [<c01373c6>] ? kthread+0x0/0x6f
[13288.222084]  [<c01033cf>] ? kernel_thread_helper+0x7/0x10
[13288.222084] Code: eb 27 3b c0 e8 56 62 01 00 a1 88 cd 42 c0 83 fb 02 8b 
50 20 75 10 89 55 f0 ff 90 b8 00 00 00 8b 55 f0 eb 12 f3 90 a1 f4 f8 42 c0 
<8b> 80 00 c3 ff ff f6 c4 10 75 ee a1 f4 f8 42 c0 c1 e6 18 2d f0 
[13288.222084] ---[ end trace 94cd80322ca2a918 ]---
[13288.222093] BUG: NMI Watchdog detected LOCKUP on CPU1, ip c03492d5, 
registers:
[13288.222093] Modules linked in: iptable_filter ip_tables x_tables 
binfmt_misc ppdev lp autofs4 nfsd exportfs nfs lockd nfs_acl auth_rpcgss 
sunrpc ipv6 sd_mod dm_snapshot dm_mirror dm_region_hash dm_log dm_mod 
snd_usb_audio snd_usb_lib usbhid usb_storage hid usblp snd_emu10k1_synth 
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_util_mem snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer 3c59x emu10k1_gp snd_seq_device mii 
gameport ohci_hcd snd ehci_hcd soundcore usbcore shpchp pci_hotplug 
i2c_amd756 amd_k7_agp i2c_core amd_rng agpgart rng_core container thermal 
processor thermal_sys button ide_cd_mod evdev cdrom psmouse serio_raw 
pcspkr parport_pc floppy parport
[13288.222093] 
[13288.222093] Pid: 0, comm: swapper Tainted: G      D    (2.6.30-rc6 #3) 
Unknown
[13288.222093] EIP: 0060:[<c03492d5>] EFLAGS: 00000097 CPU: 1
[13288.222093] EIP is at _spin_lock_irq+0x19/0x1f
[13288.222093] EAX: c1819c60 EBX: c1819c60 ECX: f708f6b0 EDX: 00007e7d
[13288.222093] ESI: c04bfc60 EDI: c04bcd18 EBP: f7093f18 ESP: f7093f18
[13288.222093]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[13288.222093] Process swapper (pid: 0, ti=f7092000 task=f708f500 
task.ti=f7092000)
[13288.222093] Stack:
[13288.222093]  f7093f8c c0347415 f7093f28 c012b204 f708f6b0 c01100ba 
c04bcd18 c04bfc60
[13288.222093]  f708f6b4 c1816488 00000000 00000001 00000000 f7093f94 
f7092000 0000007b
[13288.222093]  f708f500 000000d8 00000000 c0468e60 00000001 c1816f8c 
f7093f94 c01424e4
[13288.222093] Call Trace:
[13288.222093]  [<c0347415>] ? __schedule+0xc8/0x855
[13288.222093]  [<c012b204>] ? irq_exit+0x39/0x5c
[13288.222093]  [<c01100ba>] ? smp_error_interrupt+0x61/0x63
[13288.222093]  [<c01424e4>] ? tick_nohz_restart_sched_tick+0x2c/0x139
[13288.222093]  [<c0347baf>] ? schedule+0xd/0x1c
[13288.222093]  [<c0101c5d>] ? cpu_idle+0x60/0x63
[13288.222093]  [<c0344d11>] ? start_secondary+0x195/0x19a
[13288.222093] Code: 66 0f c1 10 38 f2 74 06 f3 90 8a 10 eb f6 89 c8 5d c3 
55 89 e5 0f 1f 44 00 00 fa ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 
<8a> 10 eb f6 5d c3 55 89 e5 0f 1f 44 00 00 9c 5a fa f0 83 28 01 
[13288.222093] ---[ end trace 94cd80322ca2a919 ]---


And another instance:

:
[45012.674548] Modules linked in: vfat fat iptable_filter ip_tables 
x_tables binfmt_misc ppdev lp autofs4 nfsd exportfs nfs lockd nfs_acl 
auth_rpcgss sunrpc ipv6 sd_mod dm_snapshot dm_mirror dm_region_hash dm_log 
dm_mod snd_usb_audio snd_usb_lib usbhid usb_storage hid usblp 
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul 
snd_emu10k1 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_page_alloc snd_util_mem snd_hwdep ohci_hcd snd_seq_dummy ehci_hcd 
snd_seq_oss snd_seq_midi snd_rawmidi usbcore snd_seq_midi_event snd_seq 
3c59x snd_timer snd_seq_device snd nls_base soundcore emu10k1_gp gameport 
amd_k7_agp i2c_amd756 mii i2c_core agpgart ide_cd_mod thermal psmouse 
amd_rng shpchp button pci_hotplug container pcspkr cdrom rng_core evdev 
serio_raw processor thermal_sys parport_pc parport floppy
[45012.674548] 
[45012.674548] Pid: 0, comm: swapper Not tainted (2.6.31-rc6 #9) Unknown
[45012.674548] EIP: 0060:[<c1267059>] EFLAGS: 00000097 CPU: 1
[45012.674548] EIP is at _spin_lock_irq+0x15/0x1f
[45012.674548] EAX: c1c9a200 EBX: c1c9a200 ECX: f708f550 EDX: 0000a7a6
[45012.674548] ESI: 00000001 EDI: f708f708 EBP: f7093f1c ESP: f7093f1c
[45012.674548]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[45012.674548] Process swapper (pid: 0, ti=f7092000 task=f708f550 
task.ti=f7092000)
[45012.674548] Stack:
[45012.674548]  f7093f94 c1265404 c1032f33 f7093f30 c13f0200 f708f704 
c10032e6 c13ec1f4
[45012.674548] <0> f708f708 c13f0200 00000001 00000000 f7093f94 f7092000 
00000001 0000007b
[45012.674548] <0> 000000d8 f708f550 c1395288 00000001 c1c9648c f7093f94 
c104babe f7092000
[45012.674548] Call Trace:
[45012.674548]  [<c1265404>] ? schedule+0xca/0x86c
[45012.674548]  [<c1032f33>] ? irq_exit+0x39/0x5c
[45012.674548]  [<c10032e6>] ? error_interrupt+0x2a/0x30
[45012.674548]  [<c104babe>] ? tick_nohz_restart_sched_tick+0x2c/0x139
[45012.674548]  [<c1001c15>] ? cpu_idle+0x60/0x63
[45012.674548]  [<c1262bc7>] ? start_secondary+0x195/0x19a
[45012.674548] Code: 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 8a 10 eb f6 
89 c8 c9 c3 55 89 e5 0f 1f 44 00 00 fa ba 00 01 00 00 f0 66 0f c1 10 38 f2 
<74> 06 f3 90 8a 10 eb f6 c9 c3 55 89 e5 0f 1f 44 00 00 9c 5a fa 
[45012.674548] ---[ end trace 7323d2c20b35b0b0 ]---
[45012.678548] BUG: NMI Watchdog detected LOCKUP on CPU0, ip c1013ff8, 
registers:
[45012.678548] Modules linked in: vfat fat iptable_filter ip_tables 
x_tables binfmt_misc ppdev lp autofs4 nfsd exportfs nfs lockd nfs_acl 
auth_rpcgss sunrpc ipv6 sd_mod dm_snapshot dm_mirror dm_region_hash dm_log 
dm_mod snd_usb_audio snd_usb_lib usbhid usb_storage hid usblp 
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul 
snd_emu10k1 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_page_alloc snd_util_mem snd_hwdep ohci_hcd snd_seq_dummy ehci_hcd 
snd_seq_oss snd_seq_midi snd_rawmidi usbcore snd_seq_midi_event snd_seq 
3c59x snd_timer snd_seq_device snd nls_base soundcore emu10k1_gp gameport 
amd_k7_agp i2c_amd756 mii i2c_core agpgart ide_cd_mod thermal psmouse 
amd_rng shpchp button pci_hotplug container pcspkr cdrom rng_core evdev 
serio_raw processor thermal_sys parport_pc parport floppy
[45012.678548] 
[45012.678548] Pid: 9294, comm: backup2l Tainted: G      D    (2.6.31-rc6 
#9) Unknown
[45012.678548] EIP: 0060:[<c1013ff8>] EFLAGS: 00000002 CPU: 0
[45012.678548] EIP is at default_send_IPI_mask_logical+0x5c/0x90
[45012.678548] EAX: 000018f0 EBX: 00000082 ECX: c1356b5c EDX: 00000800
[45012.678548] ESI: 000000fd EDI: 00000002 EBP: ceaf7e18 ESP: ceaf7e08
[45012.678548]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[45012.678548] Process backup2l (pid: 9294, ti=ceaf6000 task=db276eb0 
task.ti=ceaf6000)
[45012.678548] Stack:
[45012.678548]  c126fcc8 000000a7 db13e9c0 c1c9a200 ceaf7e20 c10127ce 
ceaf7e2c c1020ebf
[45012.678548] <0> c126fc08 ceaf7e34 c1020f2e ceaf7e64 c1029d20 00000000 
00000000 00000001
[45012.678548] <0> 00000001 00000001 00000000 00000086 ce995e40 e1cee7f8 
00000001 ceaf7e6c
[45012.678548] Call Trace:
[45012.678548]  [<c10127ce>] ? native_smp_send_reschedule+0x44/0x46
[45012.678548]  [<c1020ebf>] ? resched_task+0x5f/0x62
[45012.678548]  [<c1020f2e>] ? check_preempt_curr_idle+0x13/0x15
[45012.678548]  [<c1029d20>] ? try_to_wake_up+0x1f7/0x22b
[45012.678548]  [<c1029d64>] ? default_wake_function+0x10/0x12
[45012.678548]  [<c1040645>] ? autoremove_wake_function+0x14/0x34
[45012.678548]  [<c101e110>] ? __wake_up_common+0x39/0x61
[45012.678548]  [<c1021048>] ? __wake_up_sync_key+0x38/0x4a
[45012.678548]  [<c1021069>] ? __wake_up_sync+0xf/0x12
[45012.678548]  [<c10b0fd8>] ? pipe_release+0x5e/0x92
[45012.678548]  [<c10b103c>] ? pipe_write_release+0x14/0x16
[45012.678548]  [<c10ac42e>] ? __fput+0xcf/0x177
[45012.678548]  [<c10ac4f0>] ? fput+0x1a/0x1c
[45012.678548]  [<c10a982d>] ? filp_close+0x56/0x60
[45012.678548]  [<c102f56b>] ? put_files_struct+0x5d/0xa1
[45012.678548]  [<c102f5ea>] ? exit_files+0x3b/0x40
[45012.678548]  [<c1030ca5>] ? do_exit+0x1ae/0x5b3
[45012.678548]  [<c103110c>] ? do_group_exit+0x62/0x89
[45012.678548]  [<c103114b>] ? sys_exit_group+0x18/0x1c
[45012.678548]  [<c1002944>] ? sysenter_do_call+0x12/0x22
[45012.678548] Code: a1 18 6c 35 c1 83 fe 02 8b 50 20 75 10 89 55 f0 ff 90 
b8 00 00 00 8b 55 f0 eb 12 f3 90 a1 d4 97 35 c1 8b 80 00 c3 ff ff f6 c4 10 
<75> ee a1 d4 97 35 c1 c1 e7 18 2d f0 3c 00 00 89 38 89 f0 09 d0 
[45012.678548] ---[ end trace 7323d2c20b35b0b1 ]---
[45014.223303] Clocksource tsc unstable (delta = 9374024843 ns)
[45014.229055] Fixing recursive fault but reboot is needed!


Always happens where one CPU is sending an IPI and the other has the rq 
spinlock. Seems to be that the IPI expects the other CPU to not have 
interrupts disabled or something?

Note, I've seen this on 2.6.30-rc6 as well (yes that's 2.6.30). But this 
does not happen on 2.6.29. Unfortunately, 2.6.29 makes my NIC go kaputt 
for some reason.

I've enabled LOCKDEP and it just makes the bug trigger easier.

Anyway, anyone have any ideas?

Since this can take up to a week to trigger, I'll start doing a git bisect 
on it from 2.6.29 to 2.6.30-rc6. And see if I can find the change that 
broke. Although this box is my DHCP/web/mail server, so it will be a PITA 
:-(

Thanks,

-- Steve

