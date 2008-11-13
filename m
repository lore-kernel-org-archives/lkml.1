Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYKMN6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYKMN6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYKMN63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:58:29 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:40673 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYKMN61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:58:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=jzt8RnvJZO4n6faLlEdpuOwm6O8PgyLHvxD/ZNe8YigUz8hTT5sPFilvlPCj7EME30
         PFc82Hnlb5rSnkU8UL5O3XoqMz6M52pji7i7CiObc5lNEdMbasi/WSAwJGtxHd+fN1zA
         2stQrOQiIEERJdcVlFIXoY3QNcqiJSO37bncw=
Message-ID: <c4e36d110811130558s718d5cabn3722bca52bfbc69d@mail.gmail.com>
Date: Thu, 13 Nov 2008 14:58:25 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       mingo@redhat.com, levon@movementarian.org
Subject: OProfile circular lock & crash
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

While just doing a simple oprofiling with 2.6.28-rc4 yesterdays git
head f21f237cf55494c3a4209de323281a3b0528da10

I've got appended messages - the first INFO trace is probably a result
of  opreport command which has created a core

The second fault BUG was the result of running a command with started
oprofiling.
(Spinlock trace error is my internal checker and just shows ongoing
problem after the first BUG)

The final part was that machine could not be turned off while it
staying in docking station (T61) no matter how long I've pressed power
button.
(Maybe it might have something commong with the following acpi error trace ??)


input: Virtual ThinkFinger Keyboard as /devices/virtual/input/input10
hda-intel: IRQ timing workaround is activated for card #0. Suggest a
bigger bdl_pos_adj.
oprofile: using NMI interrupt.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.28-rc4 #85
-------------------------------------------------------
cat/3455 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<ffffffffa04c7ed9>]
sync_buffer+0x2f9/0x4b0 [oprofile]

but task is already holding lock:
 (buffer_mutex){--..}, at: [<ffffffffa04c7c1b>] sync_buffer+0x3b/0x4b0
[oprofile]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (buffer_mutex){--..}:
       [<ffffffff8026f079>] __lock_acquire+0xd49/0x11a0
       [<ffffffff8026f561>] lock_acquire+0x91/0xc0
       [<ffffffff80529b3f>] mutex_lock_nested+0xbf/0x300
       [<ffffffffa04c7c1b>] sync_buffer+0x3b/0x4b0 [oprofile]
       [<ffffffffa04c775c>] wq_sync_buffer+0x2c/0x90 [oprofile]
       [<ffffffff80257c8c>] run_workqueue+0xfc/0x240
       [<ffffffff80257fdf>] worker_thread+0xaf/0x130
       [<ffffffff8025c289>] kthread+0x49/0x90
       [<ffffffff8020d719>] child_rip+0xa/0x11
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (&(&b->work)->work){--..}:
       [<ffffffff8026f079>] __lock_acquire+0xd49/0x11a0
       [<ffffffff8026f561>] lock_acquire+0x91/0xc0
       [<ffffffff80257c86>] run_workqueue+0xf6/0x240
       [<ffffffff80257fdf>] worker_thread+0xaf/0x130
       [<ffffffff8025c289>] kthread+0x49/0x90
       [<ffffffff8020d719>] child_rip+0xa/0x11
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (events){--..}:
       [<ffffffff8026f079>] __lock_acquire+0xd49/0x11a0
       [<ffffffff8026f561>] lock_acquire+0x91/0xc0
       [<ffffffff802586bc>] flush_work+0x5c/0x110
       [<ffffffff8025894c>] schedule_on_each_cpu+0xcc/0x100
       [<ffffffff802adbb0>] lru_add_drain_all+0x10/0x20
       [<ffffffff802baa10>] __mlock_vma_pages_range+0x50/0x280
       [<ffffffff802bad8b>] mlock_fixup+0x14b/0x270
       [<ffffffff802bb189>] do_mlock+0xd9/0x120
       [<ffffffff802bb32c>] sys_mlock+0xbc/0x110
       [<ffffffff8020c57b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mm->mmap_sem){----}:
       [<ffffffff8026f140>] __lock_acquire+0xe10/0x11a0
       [<ffffffff8026f561>] lock_acquire+0x91/0xc0
       [<ffffffff8052a426>] down_read+0x46/0x80
       [<ffffffffa04c7ed9>] sync_buffer+0x2f9/0x4b0 [oprofile]
       [<ffffffffa04c80a1>] task_exit_notify+0x11/0x20 [oprofile]
       [<ffffffff8052f43f>] notifier_call_chain+0x3f/0x80
       [<ffffffff80261728>] __blocking_notifier_call_chain+0x58/0x80
       [<ffffffff80261761>] blocking_notifier_call_chain+0x11/0x20
       [<ffffffff80263575>] profile_task_exit+0x15/0x20
       [<ffffffff802480e5>] do_exit+0x25/0xa50
       [<ffffffff80248b55>] do_group_exit+0x45/0xc0
       [<ffffffff80248be2>] sys_exit_group+0x12/0x20
       [<ffffffff8020c57b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by cat/3455:
 #0:  ((task_exit_notifier).rwsem){----}, at: [<ffffffff80261712>]
__blocking_notifier_call_chain+0x42/0x80
 #1:  (buffer_mutex){--..}, at: [<ffffffffa04c7c1b>]
sync_buffer+0x3b/0x4b0 [oprofile]

stack backtrace:
Pid: 3455, comm: cat Not tainted 2.6.28-rc4 #85
Call Trace:
 [<ffffffff8026ce17>] print_circular_bug_tail+0xa7/0xf0
 [<ffffffff8026f140>] __lock_acquire+0xe10/0x11a0
 [<ffffffff8026f561>] lock_acquire+0x91/0xc0
 [<ffffffffa04c7ed9>] ? sync_buffer+0x2f9/0x4b0 [oprofile]
 [<ffffffff8052a426>] down_read+0x46/0x80
 [<ffffffffa04c7ed9>] ? sync_buffer+0x2f9/0x4b0 [oprofile]
 [<ffffffffa04c7ed9>] sync_buffer+0x2f9/0x4b0 [oprofile]
 [<ffffffff8039bffd>] ? __down_read_trylock+0x3d/0x60
 [<ffffffffa04c80a1>] task_exit_notify+0x11/0x20 [oprofile]
 [<ffffffff8052f43f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80261728>] __blocking_notifier_call_chain+0x58/0x80
 [<ffffffff80261761>] blocking_notifier_call_chain+0x11/0x20
 [<ffffffff80263575>] profile_task_exit+0x15/0x20
 [<ffffffff802480e5>] do_exit+0x25/0xa50
 [<ffffffff80213863>] ? native_sched_clock+0x13/0x60
 [<ffffffff802d2e9e>] ? sys_close+0xae/0x120
 [<ffffffff8020cc21>] ? retint_swapgs+0xe/0x13
 [<ffffffff80248b55>] do_group_exit+0x45/0xc0
 [<ffffffff80248be2>] sys_exit_group+0x12/0x20
 [<ffffffff8020c57b>] system_call_fastpath+0x16/0x1b

opreport[3783]: segfault at 0 ip 00000000004b5516 sp 00007fffb54d4ce8
error 4 in opreport[400000+195000]

kernel: [ 1534.346954] CE: hpet increasing min_delta_ns to 15000 nsec

BUG: unable to handle kernel paging request at 000000000010cad4
IP: [<ffffffff802d17fa>] __kmalloc+0x6a/0x120
PGD 7b73d067 PUD 79399067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Dumping ftrace buffer:
   (ftrace buffer empty)
CPU 0
Modules linked in: oprofile fuse ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc bluetooth
autofs4 sunrpc ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod
kvm_intel kvm i915 drm uinput snd_hda_intel snd_seq_oss
snd_seq_midi_event arc4 snd_seq ecb snd_seq_device snd_pcm_oss
cryptomgr aead snd_mixer_oss snd_pcm i2c_i801 rtc_cmos
crypto_blkcipher usbhid hid thinkpad_acpi backlight rtc_core i2c_core
snd_timer psmouse iTCO_wdt led_class crypto_algapi iwl3945 rfkill
mac80211 snd sdhci_pci sdhci mmc_core e1000e evdev soundcore sr_mod
iTCO_vendor_support serio_raw nvram rtc_lib cfg80211 cdrom intel_agp
snd_page_alloc button battery ac uhci_hcd ohci_hcd ehci_hcd usbcore
[last unloaded: microcode]
Pid: 2765, comm: X Not tainted 2.6.28-rc4 #85
RIP: 0010:[<ffffffff802d17fa>]  [<ffffffff802d17fa>] __kmalloc+0x6a/0x120
RSP: 0018:ffff88007db6fde8  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 000000000010cad4 RCX: ffffffffa032a360
RDX: ffff880004385ac0 RSI: 00000000000000d0 RDI: ffffffff802d17d7
RBP: ffff88007db6fe18 R08: ffffffffa0320b40 R09: 0000000000000001
R10: 000000000420cdd8 R11: 0000000000003246 R12: ffffffff807015e8
R13: 0000000000000286 R14: 00000000000000d0 R15: ffffffffa0300c1f
FS:  00007f5b9c18d780(0000) GS:ffffffff80702640(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000010cad4 CR3: 00000000793aa000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 2765, threadinfo ffff88007db6e000, task ffff88007926c320)
Stack:
 00000008a0300a75 00000000fffffff4 ffff88007d623800 ffff88006a544100
 0000000000000000 0000000040046460 ffff88007db6fe78 ffffffffa0300c1f
 ffff880004515440 ffff880004515440 ffffffffa0320b40 00007fffa41b9950
Call Trace:
 [<ffffffffa0300c1f>] drm_ioctl+0x2cf/0x330 [drm]
 [<ffffffffa0320b40>] ? i915_gem_sw_finish_ioctl+0x0/0xd0 [i915]
 [<ffffffff802e36ed>] vfs_ioctl+0x7d/0xa0
 [<ffffffff802e3784>] do_vfs_ioctl+0x74/0x470
 [<ffffffff8052899b>] ? thread_return+0x3d/0x582
 [<ffffffff802e3c19>] sys_ioctl+0x99/0xa0
 [<ffffffff8020c57b>] system_call_fastpath+0x16/0x1b
Code: 41 5d fa e8 39 8d f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94
c4 18 01 00 00 8b 42 18 89 45 d4 48 8b 1a 48 85 db 74 69 8b 42 14 <48>
8b 04 c3 48 89 02 41 f7 c5 00 02 00 00 74 46 e8 c1 c8 f9 ff
RIP  [<ffffffff802d17fa>] __kmalloc+0x6a/0x120
 RSP <ffff88007db6fde8>
CR2: 000000000010cad4
---[ end trace f72aa40b717798d6 ]---
SPIN IRQ ALREADY DISABLED
Pid: 2765, comm: X Tainted: G      D    2.6.28-rc4 #85
Call Trace:
 [<ffffffff8052bf03>] _spin_lock_irq+0x83/0x90
 [<ffffffff802ae270>] ____pagevec_lru_add+0xa0/0x130
 [<ffffffff802ae37b>] drain_cpu_pagevecs+0x7b/0xd0
 [<ffffffff802ae441>] lru_add_drain+0x11/0x20
 [<ffffffff802bbcfd>] exit_mmap+0x4d/0x170
 [<ffffffff80241f40>] mmput+0x40/0xe0
 [<ffffffff80246468>] exit_mm+0x108/0x140
 [<ffffffff80248261>] do_exit+0x1a1/0xa50
 [<ffffffff8052d2de>] oops_end+0xae/0xb0
 [<ffffffff8052ec28>] do_page_fault+0x288/0xa60
 [<ffffffff8023ac70>] ? finish_task_switch+0x0/0x120
 [<ffffffff80250016>] ? lock_timer_base+0x36/0x70
 [<ffffffff8052b705>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffffa0300c1f>] ? drm_ioctl+0x2cf/0x330 [drm]
 [<ffffffff8052c582>] error_exit+0x0/0xa9
 [<ffffffffa0300c1f>] ? drm_ioctl+0x2cf/0x330 [drm]
 [<ffffffffa0320b40>] ? i915_gem_sw_finish_ioctl+0x0/0xd0 [i915]
 [<ffffffff802d17d7>] ? __kmalloc+0x47/0x120
 [<ffffffff802d17fa>] ? __kmalloc+0x6a/0x120
 [<ffffffff802d17d7>] ? __kmalloc+0x47/0x120
 [<ffffffffa0300c1f>] drm_ioctl+0x2cf/0x330 [drm]
 [<ffffffffa0320b40>] ? i915_gem_sw_finish_ioctl+0x0/0xd0 [i915]
 [<ffffffff802e36ed>] vfs_ioctl+0x7d/0xa0
 [<ffffffff802e3784>] do_vfs_ioctl+0x74/0x470
 [<ffffffff8052899b>] ? thread_return+0x3d/0x582
 [<ffffffff802e3c19>] sys_ioctl+0x99/0xa0
 [<ffffffff8020c57b>] system_call_fastpath+0x16/0x1b
[drm:drm_release] *ERROR* Device busy: 1 0
 HAL disappeared
BUG: unable to handle kernel paging request at 000000000010cad4
IP: [<ffffffff802d17fa>] __kmalloc+0x6a/0x120
PGD 7b730067 PUD 7b675067 PMD 0
Oops: 0000 [#2] SMP
last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/present
CPU 0
Modules linked in: oprofile fuse ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc bluetooth
autofs4 sunrpc ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod
kvm_intel kvm i915 drm uinput snd_hda_intel snd_seq_oss
snd_seq_midi_event arc4 snd_seq ecb snd_seq_device snd_pcm_oss
cryptomgr aead snd_mixer_oss snd_pcm i2c_i801 rtc_cmos
crypto_blkcipher usbhid hid thinkpad_acpi backlight rtc_core i2c_core
snd_timer psmouse iTCO_wdt led_class crypto_algapi iwl3945 rfkill
mac80211 snd sdhci_pci sdhci mmc_core e1000e evdev soundcore sr_mod
iTCO_vendor_support serio_raw nvram rtc_lib cfg80211 cdrom intel_agp
snd_page_alloc button battery ac uhci_hcd ohci_hcd ehci_hcd usbcore
[last unloaded: microcode]
Pid: 2306, comm: hald Tainted: G      D    2.6.28-rc4 #85
RIP: 0010:[<ffffffff802d17fa>]  [<ffffffff802d17fa>] __kmalloc+0x6a/0x120
RSP: 0018:ffff88007b6e7a38  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 000000000010cad4 RCX: ffff88007b6e7b34
RDX: ffff880004385ac0 RSI: 00000000000000d0 RDI: ffffffff802d17d7
RBP: ffff88007b6e7a68 R08: 0000000000000040 R09: ffffffff80642d9e
R10: ffff88007b7ec320 R11: 0000000000000000 R12: ffffffff807015e8
R13: 0000000000000286 R14: 00000000000000d0 R15: ffffffff803d3db1
FS:  00007fd8d35f96f0(0000) GS:ffffffff80702640(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000010cad4 CR3: 000000007b72a000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hald (pid: 2306, threadinfo ffff88007b6e6000, task ffff88007b7ec320)
Stack:
 0000000879348678 0000000000000007 0000000000000000 0000000000000000
 0000000000000001 ffffc200000262bd ffff88007b6e7a98 ffffffff803d3db1
 0000000000000000 ffff88007da5d750 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff803d3db1>] acpi_ex_allocate_name_string+0x41/0xbc
 [<ffffffff803d4266>] acpi_ex_get_name_string+0x264/0x2ee
 [<ffffffff803cd82f>] acpi_ds_create_operand+0x7f/0x292
 [<ffffffff803cda8b>] acpi_ds_evaluate_name_path+0x49/0xff
 [<ffffffff803e06b8>] ? acpi_ps_get_next_namepath+0x75/0x250
 [<ffffffff803cc0a2>] acpi_ds_exec_end_op+0x96/0x570
 [<ffffffff803e1c25>] acpi_ps_parse_loop+0x786/0x941
 [<ffffffff803e0cd1>] acpi_ps_parse_aml+0xee/0x3c0
 [<ffffffff803e24db>] acpi_ps_execute_method+0x18a/0x293
 [<ffffffff803dd838>] acpi_ns_evaluate+0x1e4/0x33c
 [<ffffffff803dd13e>] acpi_evaluate_object+0x15e/0x2a8
 [<ffffffffa006c33c>] acpi_battery_get_state+0x82/0xf6 [battery]
 [<ffffffffa006c660>] acpi_battery_get_property+0x2f/0x1ad [battery]
 [<ffffffff80485e14>] power_supply_show_property+0x54/0x150
 [<ffffffff8042a9bd>] dev_attr_show+0x2d/0x70
 [<ffffffff8032d8e5>] sysfs_read_file+0x105/0x200
 [<ffffffff802d57d8>] vfs_read+0xc8/0x180
 [<ffffffff802d5980>] sys_read+0x50/0x90
 [<ffffffff8020c57b>] system_call_fastpath+0x16/0x1b
Code: 41 5d fa e8 39 8d f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94
c4 18 01 00 00 8b 42 18 89 45 d4 48 8b 1a 48 85 db 74 69 8b 42 14 <48>
8b 04 c3 48 89 02 41 f7 c5 00 02 00 00 74 46 e8 c1 c8 f9 ff
RIP  [<ffffffff802d17fa>] __kmalloc+0x6a/0x120
 RSP <ffff88007b6e7a38>
CR2: 000000000010cad4
---[ end trace f72aa40b717798d6 ]---
------------[ cut here ]------------
WARNING: at kernel/softirq.c:138 local_bh_enable_ip+0xb5/0xf0()
Modules linked in: oprofile fuse ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc bluetooth
autofs4 sunrpc ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod
kvm_intel kvm i915 drm uinput snd_hda_intel snd_seq_oss
snd_seq_midi_event arc4 snd_seq ecb snd_seq_device snd_pcm_oss
cryptomgr aead snd_mixer_oss snd_pcm i2c_i801 rtc_cmos
crypto_blkcipher usbhid hid thinkpad_acpi backlight rtc_core i2c_core
snd_timer psmouse iTCO_wdt led_class crypto_algapi iwl3945 rfkill
mac80211 snd sdhci_pci sdhci mmc_core e1000e evdev soundcore sr_mod
iTCO_vendor_support serio_raw nvram rtc_lib cfg80211 cdrom intel_agp
snd_page_alloc button battery ac uhci_hcd ohci_hcd ehci_hcd usbcore
[last unloaded: microcode]
Pid: 2306, comm: hald Tainted: G      D    2.6.28-rc4 #85
Call Trace:
 [<ffffffff8024465f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff8052bc36>] ? _spin_unlock+0x26/0x30
 [<ffffffff802aa79f>] ? free_pages_bulk+0x29f/0x310
 [<ffffffff8050da03>] ? unix_release_sock+0x83/0x270
 [<ffffffff8024ac15>] local_bh_enable_ip+0xb5/0xf0
 [<ffffffff8052b8df>] _write_unlock_bh+0x2f/0x40
 [<ffffffff8050da03>] unix_release_sock+0x83/0x270
 [<ffffffff8050dc11>] unix_release+0x21/0x30
 [<ffffffff80496134>] sock_release+0x24/0x90
 [<ffffffff804961b2>] sock_close+0x12/0x30
 [<ffffffff802d6710>] __fput+0xd0/0x1e0
 [<ffffffff802d683d>] fput+0x1d/0x30
 [<ffffffff802d2dbb>] filp_close+0x5b/0x90
 [<ffffffff80246749>] put_files_struct+0x79/0xe0
 [<ffffffff802467fe>] exit_files+0x4e/0x60
 [<ffffffff802482a6>] do_exit+0x1e6/0xa50
 [<ffffffff8052d2de>] oops_end+0xae/0xb0
 [<ffffffff8052ec28>] do_page_fault+0x288/0xa60
 [<ffffffff803d014c>] ? acpi_ev_address_space_dispatch+0x205/0x216
 [<ffffffff803ed0d5>] ? acpi_ec_space_handler+0x0/0x133
 [<ffffffff803d5354>] ? acpi_ex_access_region+0x254/0x2e9
 [<ffffffff8052b705>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff803d3db1>] ? acpi_ex_allocate_name_string+0x41/0xbc
 [<ffffffff8052c582>] error_exit+0x0/0xa9
 [<ffffffff803d3db1>] ? acpi_ex_allocate_name_string+0x41/0xbc
 [<ffffffff802d17d7>] ? __kmalloc+0x47/0x120
 [<ffffffff802d17fa>] ? __kmalloc+0x6a/0x120
 [<ffffffff802d17d7>] ? __kmalloc+0x47/0x120
 [<ffffffff803d3db1>] acpi_ex_allocate_name_string+0x41/0xbc
 [<ffffffff803d4266>] acpi_ex_get_name_string+0x264/0x2ee
 [<ffffffff803cd82f>] acpi_ds_create_operand+0x7f/0x292
 [<ffffffff803cda8b>] acpi_ds_evaluate_name_path+0x49/0xff
 [<ffffffff803e06b8>] ? acpi_ps_get_next_namepath+0x75/0x250
 [<ffffffff803cc0a2>] acpi_ds_exec_end_op+0x96/0x570
 [<ffffffff803e1c25>] acpi_ps_parse_loop+0x786/0x941
 [<ffffffff803e0cd1>] acpi_ps_parse_aml+0xee/0x3c0
 [<ffffffff803e24db>] acpi_ps_execute_method+0x18a/0x293
 [<ffffffff803dd838>] acpi_ns_evaluate+0x1e4/0x33c
 [<ffffffff803dd13e>] acpi_evaluate_object+0x15e/0x2a8
 [<ffffffffa006c33c>] acpi_battery_get_state+0x82/0xf6 [battery]
 [<ffffffffa006c660>] acpi_battery_get_property+0x2f/0x1ad [battery]
 [<ffffffff80485e14>] power_supply_show_property+0x54/0x150
 [<ffffffff8042a9bd>] dev_attr_show+0x2d/0x70
 [<ffffffff8032d8e5>] sysfs_read_file+0x105/0x200
 [<ffffffff802d57d8>] vfs_read+0xc8/0x180
 [<ffffffff802d5980>] sys_read+0x50/0x90
 [<ffffffff8020c57b>] system_call_fastpath+0x16/0x1b
---[ end trace f72aa40b717798d6 ]---
SysRq : Emergency Sync
Emergency Sync complete
SysRq : Emergency Sync
Emergency Sync complete
SysRq : Emergency Sync
Emergency Sync complete
SysRq : Emergency Remount R/O
