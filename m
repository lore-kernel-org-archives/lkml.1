Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYI2Pwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYI2Pwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYI2Pwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:52:45 -0400
Received: from styx.suse.cz ([82.119.242.94]:51996 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751522AbYI2Pwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:52:44 -0400
Date: Mon, 29 Sep 2008 17:52:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251913300.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <alpine.LNX.1.10.0809291740140.4022@jikos.suse.cz>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251913300.1736@jbrandeb-desk.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Brandeburg, Jesse wrote:

> in case your mailer hoses something apply in this order:
> # This series applies on GIT commit 011fcfcb75311c7368f13170b9e68adcf146a557
> 01-e-mem.patch
> 02-e_flash.patch
> 03-e1000e-release-lock-in-reset.patch
> 04-e1000e-dont-sleep.patch
> 05-e1000e-no-deeplocks.patch
> 06-e1000e-drop-stats-lock.patch
> 07-subject-e1000e-debug-patch.patch
> 08-e1000e-version.patch
> 09-e1000e-allow-bad-checksum.patch
> 10-e1000e-dump-eeprom-to-dmesg.txt

When using this patchset (plus patch that adds check for address range in 
pci_mmap_resource() by Jesse Barnes), the machine (that already has 
corrupted (but not completely erased)) hangs after dumping eeprom 
contents:

0000:00:19.0: 0000:00:19.0: The NVM Checksum Is Not Valid
/*********************/
Current EEPROM Checksum : 0x2259
Calculated              : 0xa259
Offset    Values
========  ======
00000000: 00 15 58 c6 4a ff 00 08 ff ff 30 00 ff ff ff ff
00000010: ff ff ff ff c7 10 b9 20 aa 17 49 10 86 80 00 00
00000020: 01 0d 00 00 00 00 05 16 20 50 00 38 00 00 8b 0d
00000030: 02 06 c1 01 03 08 00 00 00 00 00 00 00 00 00 00
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000060: 00 01 00 40 28 12 07 40 ff ff ff ff ff ff ff ff
00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 59 22
/*********************/


after this, alt-sysrq-p indicates that it's somehow running in the loops 
around r1000_read_nvm_ich8lan and e1000_release_swflag_uch8lan. Below 
there are several subsequent alt-sysrq-p outputs on this frozen system



SysRq : Show Regs
CPU 1:
Modules linked in: pcmcia_core v4l1_compat pcspkr(+) e1000e(+) button(+) 
joydev led_class parport soundcore sg sr_mod cdrom sd_mod crc_t10r
Pid: 841, comm: modprobe Tainted: G          2.6.27-rc6-7.10-default #1
RIP: 0010:[<ffffffffa01e6a88>]  [<ffffffffa01e6a88>] 
e1000_release_swflag_ich8lan+0x15/0x3c [e1000e]
RSP: 0018:ffff88003adb5b48  EFLAGS: 00000286
RAX: ffffc20004540f00 RBX: ffff88003adb5b48 RCX: ffff88003adb5b7e
RDX: 0000000000000022 RSI: 000000000000431c RDI: ffff88003c44cb28
RBP: 0000000000000000 R08: ffff88003adb5b7e R09: ffff88003c44cb28
R10: ffff88003adb5b7e R11: ffff88003adb5ad8 R12: ffff88003c44cb28
R13: ffffc20004520008 R14: ffffffff8020c394 R15: ffff88003adb5b08
FS:  00007f398e1eb6f0(0000) GS:ffff88003e1e93c0(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000061ee78 CR3: 000000003b125000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
Inexact backtrace:

 [<ffffffffa01e6a7c>] ? e1000_release_swflag_ich8lan+0x9/0x3c [e1000e]
 [<ffffffffa01e7184>] ? e1000_read_nvm_ich8lan+0xf2/0x10a [e1000e]
 [<ffffffff8020c394>] ? mcount_call+0x5/0x31
 [<ffffffffa01e9c46>] ? e1000e_validate_nvm_checksum_generic+0x34/0x62 
[e1000e]
 [<ffffffffa01e63b4>] ? e1000_validate_nvm_checksum_ich8lan+0x6c/0x73 
[e1000e]
 [<ffffffffa01f661e>] ? e1000_probe+0x5a4/0xb7e [e1000e]
 [<ffffffffa01f661e>] ? e1000_probe+0x5a4/0xb7e [e1000e]
 [<ffffffff8023e290>] ? set_cpus_allowed_ptr+0x119/0x126
 [<ffffffff803784a8>] ? kobject_get+0x1a/0x22
 [<ffffffff8038b889>] ? pci_device_probe+0xc9/0x120
 [<ffffffff80401958>] ? driver_probe_device+0xc5/0x173
 [<ffffffff80401a5a>] ? __driver_attach+0x54/0x7e
 [<ffffffff80401a06>] ? __driver_attach+0x0/0x7e
 [<ffffffff80401186>] ? bus_for_each_dev+0x54/0x8e
 [<ffffffff80401794>] ? driver_attach+0x21/0x23
 [<ffffffff80400a74>] ? bus_add_driver+0xbc/0x206
 [<ffffffff80401c6c>] ? driver_register+0xad/0x12d
 [<ffffffff8038bb5e>] ? __pci_register_driver+0x6b/0xa5
 [<ffffffffa0177000>] ? e1000_init_module+0x0/0x75 [e1000e]
 [<ffffffffa0177059>] ? e1000_init_module+0x59/0x75 [e1000e]
 [<ffffffff8020904c>] ? _stext+0x4c/0x151
 [<ffffffff80268169>] ? sys_init_module+0xae/0x1cc
 [<ffffffff8020c57a>] ? system_call_fastpath+0x16/0x1b



SysRq : Show Regs
CPU 1:
Modules linked in: pcmcia_core v4l1_compat pcspkr(+) e1000e(+) button(+) 
joydev led_class parport soundcore sg sr_mod cdrom sd_mod crc_t10r
Pid: 841, comm: modprobe Tainted: G          2.6.27-rc6-7.10-default #1
RIP: 0010:[<ffffffffa01e6481>]  [<ffffffffa01e6481>] 
e1000_flash_cycle_ich8lan+0x3d/0x6d [e1000e]
RSP: 0018:ffff88003adb5ae8  EFLAGS: 00000282
RAX: ffffc20004526009 RBX: ffff88003adb5b08 RCX: 000000006dae9ce2
RDX: 000000006dae9ce2 RSI: 000000000000431c RDI: 00000000000007bc
RBP: 0000000000000018 R08: ffff88003adb5b7e R09: ffff88003c44cb28
R10: ffff88003adb5b7e R11: ffff88003adb5ac8 R12: ffff88003adb5a68
R13: 0000000000000282 R14: 0000000000000010 R15: ffffffff802135d0
FS:  00007f398e1eb6f0(0000) GS:ffff88003e1e93c0(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000061ee78 CR3: 000000003b125000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
Inexact backtrace:

 [<ffffffffa01e6491>] ? e1000_flash_cycle_ich8lan+0x4d/0x6d [e1000e]
 [<ffffffffa01e66ac>] ? e1000_read_flash_data_ich8lan+0xab/0x104 [e1000e]
 [<ffffffffa01e715e>] ? e1000_read_nvm_ich8lan+0xcc/0x10a [e1000e]
 [<ffffffff8020c394>] ? mcount_call+0x5/0x31
 [<ffffffffa01e9c46>] ? e1000e_validate_nvm_checksum_generic+0x34/0x62 
[e1000e]
 [<ffffffffa01e63b4>] ? e1000_validate_nvm_checksum_ich8lan+0x6c/0x73 
[e1000e]
 [<ffffffffa01f661e>] ? e1000_probe+0x5a4/0xb7e [e1000e]
 [<ffffffffa01f661e>] ? e1000_probe+0x5a4/0xb7e [e1000e]
 [<ffffffff8023e290>] ? set_cpus_allowed_ptr+0x119/0x126
 [<ffffffff803784a8>] ? kobject_get+0x1a/0x22
 [<ffffffff8038b889>] ? pci_device_probe+0xc9/0x120
 [<ffffffff80401958>] ? driver_probe_device+0xc5/0x173
 [<ffffffff80401a5a>] ? __driver_attach+0x54/0x7e
 [<ffffffff80401a06>] ? __driver_attach+0x0/0x7e
 [<ffffffff80401186>] ? bus_for_each_dev+0x54/0x8e
 [<ffffffff80401794>] ? driver_attach+0x21/0x23
 [<ffffffff80400a74>] ? bus_add_driver+0xbc/0x206
 [<ffffffff80401c6c>] ? driver_register+0xad/0x12d
 [<ffffffff8038bb5e>] ? __pci_register_driver+0x6b/0xa5
 [<ffffffffa0177000>] ? e1000_init_module+0x0/0x75 [e1000e]
 [<ffffffffa0177059>] ? e1000_init_module+0x59/0x75 [e1000e]
 [<ffffffff8020904c>] ? _stext+0x4c/0x151
 [<ffffffff80268169>] ? sys_init_module+0xae/0x1cc
 [<ffffffff8020c57a>] ? system_call_fastpath+0x16/0x1b


SysRq : Show Regs
CPU 1:
Modules linked in: pcmcia_core v4l1_compat pcspkr(+) e1000e(+) button(+) 
joydev led_class parport soundcore sg sr_mod cdrom sd_mod crc_t10r
Pid: 841, comm: modprobe Tainted: G          2.6.27-rc6-7.10-default #1
RIP: 0010:[<ffffffffa01e66bc>]  [<ffffffffa01e66bc>] 
e1000_read_flash_data_ich8lan+0xbb/0x104 [e1000e]
RSP: 0018:ffff88003adb5b18  EFLAGS: 00000282
RAX: 0000000000000000 RBX: ffff88003adb5b48 RCX: 000000002edf089a
RDX: 0000000000000000 RSI: 000000000000431c RDI: 00000000000007bc
RBP: 000000000027e044 R08: ffff88003adb5b7e R09: ffff88003c44cb28
R10: ffff88003adb5b7e R11: ffff88003adb5ac8 R12: 0000000000000000
R13: 0000000000000100 R14: ffffffff8037db03 R15: ffff88003adb5ac8
FS:  00007f398e1eb6f0(0000) GS:ffff88003e1e93c0(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000061ee78 CR3: 000000003b125000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
Inexact backtrace:

 [<ffffffffa01e66ac>] ? e1000_read_flash_data_ich8lan+0xab/0x104 [e1000e]
 [<ffffffffa01e715e>] ? e1000_read_nvm_ich8lan+0xcc/0x10a [e1000e]
 [<ffffffff8020c394>] ? mcount_call+0x5/0x31
 [<ffffffffa01e9c46>] ? e1000e_validate_nvm_checksum_generic+0x34/0x62 
[e1000e]
 [<ffffffffa01e63b4>] ? e1000_validate_nvm_checksum_ich8lan+0x6c/0x73 
[e1000e]
 [<ffffffffa01f661e>] ? e1000_probe+0x5a4/0xb7e [e1000e]
 [<ffffffffa01f661e>] ? e1000_probe+0x5a4/0xb7e [e1000e]
 [<ffffffff8023e290>] ? set_cpus_allowed_ptr+0x119/0x126
 [<ffffffff803784a8>] ? kobject_get+0x1a/0x22
 [<ffffffff8038b889>] ? pci_device_probe+0xc9/0x120
 [<ffffffff80401958>] ? driver_probe_device+0xc5/0x173
 [<ffffffff80401a5a>] ? __driver_attach+0x54/0x7e
 [<ffffffff80401a06>] ? __driver_attach+0x0/0x7e
 [<ffffffff80401186>] ? bus_for_each_dev+0x54/0x8e
 [<ffffffff80401794>] ? driver_attach+0x21/0x23
 [<ffffffff80400a74>] ? bus_add_driver+0xbc/0x206
 [<ffffffff80401c6c>] ? driver_register+0xad/0x12d
 [<ffffffff8038bb5e>] ? __pci_register_driver+0x6b/0xa5
 [<ffffffffa0177000>] ? e1000_init_module+0x0/0x75 [e1000e]
 [<ffffffffa0177059>] ? e1000_init_module+0x59/0x75 [e1000e]
 [<ffffffff8020904c>] ? _stext+0x4c/0x151
 [<ffffffff80268169>] ? sys_init_module+0xae/0x1cc
 [<ffffffff8020c57a>] ? system_call_fastpath+0x16/0x1b                                                                                     

-- 
Jiri Kosina
SUSE Labs
