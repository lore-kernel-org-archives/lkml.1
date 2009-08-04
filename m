Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZHDOiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZHDOiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZHDOiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:38:08 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36056 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbZHDOiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:38:06 -0400
Message-ID: <4A7847B9.5050907@us.ibm.com>
Date: Tue, 04 Aug 2009 07:37:45 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
       "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: 2.6.31-rc4-rt1: BUG: panic in requeue_pi test case
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a slightly modified version of pthread_cond_many from 
ltp/testcases/realtime/perf/latency I tripped over the following crash 
while using a patched glibc to make use of the new futex requeue_pi 
syscalls.  The changes to the test boil down to making the "child_mutex" 
PI aware.  The unmodified test ran for 10 hours using the old futex 
behavior (stock glibc).  I'll do some more investigation and see if I 
can reproduce on mainline, or on a 2.6.29 rt kernel.


Kernel panic - not syncing: softlockup: hung tasks
BUG: soft lockup - CPU#5 stuck for 61s! [pthread_cond_ma:30534]
Modules linked in: ipv6 autofs4 i2c_dev i2c_core hidp rfcomm l2cap 
bluetooth rfkill sunrpc dm_mirror dm_multipath scsi_dh video output sbs 
sbshc battery ac parport_pc lp parport sg snd_seq_dummy snd_seq_oss 
button serio_raw bnx2 bnx2x snd_seq_midi_event snd_seq i5k_amb hwmon 
crc32c snd_seq_device i5000_edac pata_acpi snd_pcm_oss iTCO_wdt 
ata_generic snd_mixer_oss edac_core iTCO_vendor_support libcrc32c 
snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr dm_region_hash 
dm_log dm_mod ata_piix libata shpchp mptsas mptscsih mptbase 
scsi_transport_sas sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd 
ohci_hcd ehci_hcd
Modules linked in: ipv6 autofs4 i2c_dev i2c_core hidp rfcomm l2cap 
bluetooth rfkill sunrpc dm_mirror dm_multipath scsi_dh video output sbs 
sbshc battery ac parport_pc lp parport sg snd_seq_dummy snd_seq_oss 
button serio_raw bnx2 bnx2x snd_seq_midi_event snd_seq i5k_amb hwmon 
crc32c snd_seq_device i5000_edac pata_acpi snd_pcm_oss iTCO_wdt 
ata_generic snd_mixer_oss edac_core iTCO_vendor_support libcrc32c 
snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr dm_region_hash 
dm_log dm_mod ata_piix libata shpchp mptsas mptscsih mptbase 
scsi_transport_sas sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd 
ohci_hcd ehci_hcd
Call Trace:
  [<ffffffff813fe78a>] ? rt_spin_lock_slowlock+0xdb/0x1b9
  [<ffffffff813fe6af>] ? rt_spin_lock_slowlock+0x0/0x1b9
  [<ffffffff8108de6d>] ? rt_spin_lock_fastlock+0x77/0x93
  [<ffffffff813feddf>] ? rt_spin_lock+0x28/0x3e
  [<ffffffff8108a6c8>] ? queue_lock+0x46/0x66
  [<ffffffff8108bcc0>] ? futex_lock_pi+0xf9/0x2c1
  [<ffffffff8113a59b>] ? __pollwait+0x0/0x107
  [<ffffffff813ff581>] ? _atomic_spin_unlock_irqrestore+0x49/0x68
  [<ffffffff8108e296>] ? rt_mutex_adjust_prio+0x49/0x68
  [<ffffffff8108ddc5>] ? rt_spin_lock_fastunlock+0x54/0x85
  [<ffffffff8108cc43>] ? do_futex+0x7e2/0xb41
  [<ffffffff810421a0>] ? pick_next_task_idle+0x2b/0x4d
  [<ffffffff81060809>] ? timespec_add_safe+0x4b/0x94
  [<ffffffff8100cdde>] ? apic_timer_interrupt+0xe/0x20
  [<ffffffff8108d0c7>] ? sys_futex+0x125/0x157
  [<ffffffff8100c29b>] ? system_call_fastpath+0x16/0x1b
Kernel panic - not syncing: softlockup: hung tasks
BUG: soft lockup - CPU#6 stuck for 61s! [pthread_cond_ma:30536]
Modules linked in: ipv6 autofs4 i2c_dev i2c_core hidp rfcomm l2cap 
bluetooth rfkill sunrpc dm_mirror dm_multipath scsi_dh video output sbs 
sbshc battery ac parport_pc lp parport sg snd_seq_dummy snd_seq_oss 
button serio_raw bnx2 bnx2x snd_seq_midi_event snd_seq i5k_amb hwmon 
crc32c snd_seq_device i5000_edac pata_acpi snd_pcm_oss iTCO_wdt 
ata_generic snd_mixer_oss edac_core iTCO_vendor_support libcrc32c 
snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr dm_region_hash 
dm_log dm_mod ata_piix libata shpchp mptsas mptscsih mptbase 
scsi_transport_sas sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd 
ohci_hcd ehci_hcd
Modules linked in: ipv6 autofs4 i2c_dev i2c_core hidp rfcomm l2cap 
bluetooth rfkill sunrpc dm_mirror dm_multipath scsi_dh video output sbs 
sbshc battery ac parport_pc lp parport sg snd_seq_dummy snd_seq_oss 
button serio_raw bnx2 bnx2x snd_seq_midi_event snd_seq i5k_amb hwmon 
crc32c snd_seq_device i5000_edac pata_acpi snd_pcm_oss iTCO_wdt 
ata_generic snd_mixer_oss edac_core iTCO_vendor_support libcrc32c 
snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr dm_region_hash 
dm_log dm_mod ata_piix libata shpchp mptsas mptscsih mptbase 
scsi_transport_sas sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd 
ohci_hcd ehci_hcd
Call Trace:
  [<ffffffff813fe78a>] ? rt_spin_lock_slowlock+0xdb/0x1b9
  [<ffffffff813fe6af>] ? rt_spin_lock_slowlock+0x0/0x1b9
  [<ffffffff8108de6d>] ? rt_spin_lock_fastlock+0x77/0x93
  [<ffffffff813feddf>] ? rt_spin_lock+0x28/0x3e
  [<ffffffff8108a6c8>] ? queue_lock+0x46/0x66
  [<ffffffff8108bcc0>] ? futex_lock_pi+0xf9/0x2c1
  [<ffffffff8113a59b>] ? __pollwait+0x0/0x107
  [<ffffffff8108e296>] ? rt_mutex_adjust_prio+0x49/0x68
  [<ffffffff813fe692>] ? rt_spin_lock_slowunlock+0x6f/0x8c
  [<ffffffff813fe623>] ? rt_spin_lock_slowunlock+0x0/0x8c
  [<ffffffff8108ddd9>] ? rt_spin_lock_fastunlock+0x68/0x85
  [<ffffffff8108cc43>] ? do_futex+0x7e2/0xb41
  [<ffffffff810421a0>] ? pick_next_task_idle+0x2b/0x4d
  [<ffffffff81060809>] ? timespec_add_safe+0x4b/0x94
  [<ffffffff8100cdde>] ? apic_timer_interrupt+0xe/0x20
  [<ffffffff8108d0c7>] ? sys_futex+0x125/0x157
  [<ffffffff8100c29b>] ? system_call_fastpath+0x16/0x1b
Kernel panic - not syncing: softlockup: hung tasks
BUG: soft lockup - CPU#7 stuck for 61s! [pthread_cond_ma:30537]
Modules linked in: ipv6 autofs4 i2c_dev i2c_core hidp rfcomm l2cap 
bluetooth rfkill sunrpc dm_mirror dm_multipath scsi_dh video output sbs 
sbshc battery ac parport_pc lp parport sg snd_seq_dummy snd_seq_oss 
button serio_raw bnx2 bnx2x snd_seq_midi_event snd_seq i5k_amb hwmon 
crc32c snd_seq_device i5000_edac pata_acpi snd_pcm_oss iTCO_wdt 
ata_generic snd_mixer_oss edac_core iTCO_vendor_support libcrc32c 
snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr dm_region_hash 
dm_log dm_mod ata_piix libata shpchp mptsas mptscsih mptbase 
scsi_transport_sas sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd 
ohci_hcd ehci_hcd
Modules linked in: ipv6 autofs4 i2c_dev i2c_core hidp rfcomm l2cap 
bluetooth rfkill sunrpc dm_mirror dm_multipath scsi_dh video output sbs 
sbshc battery ac parport_pc lp parport sg snd_seq_dummy snd_seq_oss 
button serio_raw bnx2 bnx2x snd_seq_midi_event snd_seq i5k_amb hwmon 
crc32c snd_seq_device i5000_edac pata_acpi snd_pcm_oss iTCO_wdt 
ata_generic snd_mixer_oss edac_core iTCO_vendor_support libcrc32c 
snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr dm_region_hash 
dm_log dm_mod ata_piix libata shpchp mptsas mptscsih mptbase 
scsi_transport_sas sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd 
ohci_hcd ehci_hcd
Call Trace:
  [<ffffffff813fe78a>] ? rt_spin_lock_slowlock+0xdb/0x1b9
  [<ffffffff813fe6af>] ? rt_spin_lock_slowlock+0x0/0x1b9
  [<ffffffff8108de6d>] ? rt_spin_lock_fastlock+0x77/0x93
  [<ffffffff813feddf>] ? rt_spin_lock+0x28/0x3e
  [<ffffffff8108a6c8>] ? queue_lock+0x46/0x66
  [<ffffffff8108bcc0>] ? futex_lock_pi+0xf9/0x2c1
  [<ffffffff8113a59b>] ? __pollwait+0x0/0x107
  [<ffffffff8108e296>] ? rt_mutex_adjust_prio+0x49/0x68
  [<ffffffff813fe692>] ? rt_spin_lock_slowunlock+0x6f/0x8c
  [<ffffffff813fe623>] ? rt_spin_lock_slowunlock+0x0/0x8c
  [<ffffffff8108ddd9>] ? rt_spin_lock_fastunlock+0x68/0x85
  [<ffffffff8108cc43>] ? do_futex+0x7e2/0xb41
  [<ffffffff810421a0>] ? pick_next_task_idle+0x2b/0x4d
  [<ffffffff81060809>] ? timespec_add_safe+0x4b/0x94
  [<ffffffff8108d0c7>] ? sys_futex+0x125/0x157
  [<ffffffff8100c29b>] ? system_call_fastpath+0x16/0x1b
Kernel panic - not syncing: softlockup: hung tasks


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
