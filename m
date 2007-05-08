Return-Path: <linux-kernel-owner+w=401wt.eu-S968188AbXEHVoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968188AbXEHVoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967821AbXEHVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:44:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967047AbXEHVoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:44:11 -0400
Message-ID: <4640EF28.2000903@redhat.com>
Date: Tue, 08 May 2007 17:44:08 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: kernel oops after ACPI dock initialization fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.21.1 when dock driver initialization fails it does a kfree()
of dock_station. (Below, this is due to some error installing a
notify handler.) Later when a bay is discovered it calls 
is_dock_device() which attempts to lock the (nonexistent)
dock_station. Reason is this test in is_dock_device():

        if (!dock_station)
                return 0;

dock_station is 0x6b6b6b6b after being freed. Either it needs
to be zeroed or some other flag should be used to decide
whether a dock station is present...

====================================================================

ACPI: Error installing notify handler
Device 'dock.0' does not have a release() function, it is broken and must be fixed.
BUG: warning at drivers/base/core.c:106/device_release() (Not tainted)
 [<c04061e9>] show_trace_log_lvl+0x1a/0x2f
 [<c04067ad>] show_trace+0x12/0x14
 [<c0406831>] dump_stack+0x16/0x18
 [<c0560435>] device_release+0x85/0x87
 [<c04efcfc>] kobject_cleanup+0x46/0x60
 [<c04efd21>] kobject_release+0xb/0xd
 [<c04f08d8>] kref_put+0x75/0x83
 [<c04efcb4>] kobject_put+0x14/0x16
 [<c0560592>] put_device+0x11/0x13
 [<c05645b3>] platform_device_put+0xf/0x11
 [<c0564612>] platform_device_unregister+0x12/0x15
 [<f8b95711>] find_dock+0x1ed/0x20e [dock]
 [<c0526659>] acpi_ns_walk_namespace+0xf9/0x114
 [<c0524da7>] acpi_walk_namespace+0x57/0x74
 [<f884003d>] dock_init+0x3d/0x53 [dock]
 [<c0449855>] sys_init_module+0x159b/0x16ea
 [<c0405078>] syscall_call+0x7/0xb
 =======================
No dock devices found.
ACPI: \_SB_.PCI0.PATA.PRID.P_D0: found ejectable bay
ACPI: \_SB_.PCI0.PATA.PRID.P_D0: Adding notify handler
BUG: unable to handle kernel paging request at virtual address 6b6b6b83
 printing eip:
c044160f
*pde = 00000000
Oops: 0000 [#1]
SMP 
last sysfs file: /block/loop3/dev
Modules linked in: bay dock battery ac parport_pc lp parport loop kvm_intel kvm snd_hda_intel snd_hda_codec arc4 ecb blkcipher snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device iwl3945 snd_pcm_oss mac80211 snd_mixer_oss e1000 sdhci snd_pcm mmc_core fw_ohci tifm_7xx1 cfg80211 fw_core tifm_core serio_raw snd_timer snd i2c_i801 soundcore i2c_core iTCO_wdt iTCO_vendor_support snd_page_alloc ata_generic pcspkr rtc_cmos rtc_core rtc_lib sr_mod cdrom joydev sg ata_piix ahci libata sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
CPU:    1
EIP:    0060:[<c044160f>]    Not tainted VLI
EFLAGS: 00210002   (2.6.21-1.3142.fc7 #1)
EIP is at mark_lock+0x1f/0x419
eax: 6b6b6b6b   ebx: f7260ffc   ecx: 00000004   edx: 00000010
esi: f7260ac0   edi: 00000004   ebp: f7315cb8   esp: f7315c94
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process modprobe (pid: 1388, ti=f7315000 task=f7260ac0 task.ti=f7315000)
Stack: f7366ed4 f7315cbc c0441c56 c0525aba 0000004e 00000010 00200246 6b6b6b6b 
       00000000 f7315d08 c04424b2 f8b95421 00200286 c2aee3e4 00000005 00000002 
       00000000 00000000 f76cfd40 f7260ac0 f7260ffc f7315d3c c047aa84 c052cafb 
Call Trace:
 [<c04061e9>] show_trace_log_lvl+0x1a/0x2f
 [<c0406299>] show_stack_log_lvl+0x9b/0xa3
 [<c0406459>] show_registers+0x1b8/0x289
 [<c0406657>] die+0x12d/0x242
 [<c061886e>] do_page_fault+0x3ee/0x4ba
 [<c0617004>] error_code+0x7c/0x84
 [<c04424b2>] __lock_acquire+0x448/0xba4
 [<c0443000>] lock_acquire+0x56/0x6f
 [<c0616a59>] _spin_lock+0x2b/0x38
 [<f8b95421>] find_dock_dependent_device+0x18/0x4e [dock]
 [<f8b95482>] is_dock_device+0x2b/0x37 [dock]
 [<f8a7044b>] find_bay+0x1e7/0x2b3 [bay]
 [<c0526659>] acpi_ns_walk_namespace+0xf9/0x114
 [<c0524da7>] acpi_walk_namespace+0x57/0x74
 [<f8840047>] bay_init+0x47/0x52 [bay]
 [<c0449855>] sys_init_module+0x159b/0x16ea
 [<c0405078>] syscall_call+0x7/0xb
