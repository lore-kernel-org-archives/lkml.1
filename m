Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYFIIER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYFIIER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYFIIEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:04:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbYFIID5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:03:57 -0400
Date: Mon, 9 Jun 2008 10:03:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
	blk_lookup_devt()/prepare_namespace()
Message-ID: <20080609080312.GA32458@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-tip testing has started triggering a new type of sporadic bootup crash 
a few days ago. Find below a collection of 14 crashes i've managed to 
capture so far, which are all similar to this crash pattern:

 BUG: unable to handle kernel paging request at ffff81003b984fb8
 IP: [<ffffffff803fafd4>] blk_lookup_devt+0x42/0xa0
 PGD 8063 PUD 9063 PMD 3be2d163 PTE 800000003b984160
 Oops: 0000 [1] SMP DEBUG_PAGEALLOC

 Call Trace:
  [<ffffffff80bac17b>] ? ip_auto_config+0x0/0xd94
  [<ffffffff80209259>] name_to_dev_t+0x145/0xeec
  [<ffffffff803ff2be>] ? __next_cpu_nr+0x22/0x2b
  [<ffffffff80b7f372>] prepare_namespace+0x91/0x14c
  [<ffffffff80b7eb70>] kernel_init+0x2fe/0x314
  [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
  [<ffffffff80741bbb>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
  [<ffffffff8020d3f8>] child_rip+0xa/0x12
  [<ffffffff8020c90c>] ? restore_args+0x0/0x30
  [<ffffffff8025068d>] ? trace_hardirqs_off+0xd/0xf
  [<ffffffff80b7e872>] ? kernel_init+0x0/0x314
  [<ffffffff8020d3ee>] ? child_rip+0x0/0x12

I have reproduced it on different 32-bit and 64-bit systems as well, so 
it's not a hardware issue and it seems to affect the generic kernel.

Unfortunately the crashes are very sensitive to kernel layout changes so 
my efforts to bisect this failed. Sometimes repeat bootups do not 
reproduce the bug (making bisection even harder), and they all occured 
with DEBUG_PAGEALLOC kernels which suggests it's a timing sensitive data 
structure lifetime problem.

The latest crash's config and full serial console capture is:

  http://redhat.com/~mingo/misc/config-Mon_Jun__9_07_52_56_CEST_2008.bad
  http://redhat.com/~mingo/misc/crash-Mon_Jun__9_07_52_56_CEST_2008.log

i havent had time to look into the bug in detail yet, but it looks 
worrying and i think the bug is in -git too.

The first git-tagged crash was 2.6.26-rc4-00006-g1419a3b-dirty, which 
corresponds to tip-history-2008-06-04_09.44_Wed-6-g1419a3b, which has 
this upstream -git component:

| commit 1beee8dc8cf58e3f605bd7b34d7a39939be7d8d2
| Merge: 9db8ee3... 3446b9d...
| Author: Linus Torvalds <torvalds@linux-foundation.org>
| Date:   Fri May 30 07:45:20 2008 -0700

which is v2.6.26-rc4-103-g1beee8d. Given how sporadic this crash is (it 
takes thousands of random kernel bootups to trigger), it could have been 
introduced anytime, but i'm fairly sure it got introduced (or made more 
prominent) in the v2.6.26 cycle - and not necessarily in the -rc3/-rc4 
timeframe. (that's just when -tip testing has managed to cut through the 
many trivial problems that hit early -rc's and got up to full speed and 
full coverage)

the 14 crashes below are a grep -C 50 context grep from the boot logs.

	Ingo

-------------->
initcall ieee80211_crypto_init+0x0/0x20 returned 0 after 0 msecs
calling  ieee80211_crypto_wep_init+0x0/0x20
ieee80211_crypt: registered algorithm 'WEP'
initcall ieee80211_crypto_wep_init+0x0/0x20 returned 0 after 0 msecs
calling  ieee80211_crypto_ccmp_init+0x0/0x20
ieee80211_crypt: registered algorithm 'CCMP'
initcall ieee80211_crypto_ccmp_init+0x0/0x20 returned 0 after 0 msecs
calling  ieee80211_crypto_tkip_init+0x0/0x20
ieee80211_crypt: registered algorithm 'TKIP'
initcall ieee80211_crypto_tkip_init+0x0/0x20 returned 0 after 0 msecs
calling  tipc_init+0x0/0xb0
TIPC: Activated (version 1.6.3 compiled Jun  1 2008 06:05:50)
NET: Registered protocol family 30
TIPC: Started in single node mode
initcall tipc_init+0x0/0xb0 returned 0 after 3 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  io_apic_bug_finalize+0x0/0x30
initcall io_apic_bug_finalize+0x0/0x30 returned 0 after 0 msecs
calling  balanced_irq_init+0x0/0x180
Starting balanced_irq
initcall balanced_irq_init+0x0/0x180 returned 0 after 0 msecs
calling  check_early_ioremap_leak+0x0/0x50
initcall check_early_ioremap_leak+0x0/0x50 returned 0 after 0 msecs
calling  print_ipi_mode+0x0/0x30
Using IPI No-Shortcut mode
initcall print_ipi_mode+0x0/0x30 returned 0 after 0 msecs
calling  sched_init_debug+0x0/0x20
initcall sched_init_debug+0x0/0x20 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0x60
initcall pm_qos_power_init+0x0/0x60 returned 0 after 0 msecs
calling  afs_init+0x0/0x1a0
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x1a0 returned 0 after 1 msecs
calling  random32_reseed+0x0/0x60
initcall random32_reseed+0x0/0x60 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x50
initcall pci_sysfs_init+0x0/0x50 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0xf0
initcall scsi_complete_async_scans+0x0/0xf0 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned -2 after 0 msecs
initcall tcp_congestion_default+0x0/0x20 returned with error code -2 
BUG: unable to handle kernel paging request at f6e91fd0
IP: [<c0288b34>] blk_lookup_devt+0x34/0x90
*pde = 37120163 *pte = 36e91160 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W (2.6.26-rc4-dirty #1341)
EIP: 0060:[<c0288b34>] EFLAGS: 00010246 CPU: 0
EIP is at blk_lookup_devt+0x34/0x90
EAX: 00000000 EBX: f6e92014 ECX: 00000000 EDX: f7c1cf38
ESI: 00000000 EDI: f7c1cf38 EBP: f7c1cf30 ESP: f7c1cf24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f7c1c000 task=f7c20000 task.ti=f7c1c000)
Stack: f7c1cf38 c09040f1 c0780828 f7c1cf6c c010120f 31616473 00000200 00000000 
       00000246 c0780750 00000000 c0780828 f7c1cf6c c01049a4 fffffeff f7c1cf3c 
       c0780750 00000000 f7c1cf74 c08e0e9c f7c1cfe0 c08e06f4 121e00ec 00000001 
Call Trace:
 [<c010120f>] ? name_to_dev_t+0x11f/0x1c0
 [<c01049a4>] ? mcount_call+0x5/0x9
 [<c08e0e9c>] ? prepare_namespace+0x8c/0x140
 [<c08e06f4>] ? kernel_init+0x244/0x260
 [<c0900890>] ? tcp_congestion_default+0x0/0x20
 [<c02942b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0103e12>] ? restore_nocheck_notrace+0x0/0xe
 [<c08e04b0>] ? kernel_init+0x0/0x260
 [<c08e04b0>] ? kernel_init+0x0/0x260
 [<c010498f>] ? kernel_thread_helper+0x7/0x10
 =======================
Code: e7 ff 89 c7 89 d6 b8 84 a8 86 c0 31 d2 e8 55 9f 38 00 8b 1d dc a7 86 c0 eb 36 8d 83 0c 01 00 00 89 fa e8 20 b6 00 00 85 c0 75 1f <3b> 73 bc 7d 38 8b 83 c4 01 00 00 89 c2 25 00 00 f0 ff 81 e2 ff 
EIP: [<c0288b34>] blk_lookup_devt+0x34/0x90 SS:ESP 0068:f7c1cf24
Kernel panic - not syncing: Fatal exception
Rebooting in 10 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
   [Linux-initrd @ 0x37cd6000, 0x319284 bytes]

�
Fedora release 8 (Werewolf)
Kernel 2.6.23.1-42.fc8 on an x86_64

mercury login: 
Fedora release 8 (Werewolf)
Kernel 2.6.23.1-42.fc8 on an x86_64

mercury login: Press any key to enter the menu
--
initcall ieee80211_crypto_init+0x0/0x20 returned 0 after 0 msecs
calling  ieee80211_crypto_wep_init+0x0/0x20
ieee80211_crypt: registered algorithm 'WEP'
initcall ieee80211_crypto_wep_init+0x0/0x20 returned 0 after 0 msecs
calling  ieee80211_crypto_ccmp_init+0x0/0x20
ieee80211_crypt: registered algorithm 'CCMP'
initcall ieee80211_crypto_ccmp_init+0x0/0x20 returned 0 after 0 msecs
calling  ieee80211_crypto_tkip_init+0x0/0x20
ieee80211_crypt: registered algorithm 'TKIP'
initcall ieee80211_crypto_tkip_init+0x0/0x20 returned 0 after 0 msecs
calling  tipc_init+0x0/0xb0
TIPC: Activated (version 1.6.3 compiled Jun  2 2008 10:59:19)
NET: Registered protocol family 30
TIPC: Started in single node mode
initcall tipc_init+0x0/0xb0 returned 0 after 3 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  io_apic_bug_finalize+0x0/0x30
initcall io_apic_bug_finalize+0x0/0x30 returned 0 after 0 msecs
calling  balanced_irq_init+0x0/0x180
Starting balanced_irq
initcall balanced_irq_init+0x0/0x180 returned 0 after 0 msecs
calling  check_early_ioremap_leak+0x0/0x50
initcall check_early_ioremap_leak+0x0/0x50 returned 0 after 0 msecs
calling  print_ipi_mode+0x0/0x30
Using IPI No-Shortcut mode
initcall print_ipi_mode+0x0/0x30 returned 0 after 0 msecs
calling  sched_init_debug+0x0/0x20
initcall sched_init_debug+0x0/0x20 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0x60
initcall pm_qos_power_init+0x0/0x60 returned 0 after 0 msecs
calling  afs_init+0x0/0x1a0
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x1a0 returned 0 after 0 msecs
calling  random32_reseed+0x0/0x60
initcall random32_reseed+0x0/0x60 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x50
initcall pci_sysfs_init+0x0/0x50 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0xf0
initcall scsi_complete_async_scans+0x0/0xf0 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned -2 after 0 msecs
initcall tcp_congestion_default+0x0/0x20 returned with error code -2 
BUG: unable to handle kernel paging request at f719cfd0
IP: [<c0288b34>] blk_lookup_devt+0x34/0x90
*pde = 37c19163 *pte = 3719c160 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W (2.6.26-rc4-dirty #1342)
EIP: 0060:[<c0288b34>] EFLAGS: 00010246 CPU: 0
EIP is at blk_lookup_devt+0x34/0x90
EAX: 00000000 EBX: f719d014 ECX: 00000000 EDX: f7c1cf38
ESI: 00000000 EDI: f7c1cf38 EBP: f7c1cf30 ESP: f7c1cf24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f7c1c000 task=f7c20000 task.ti=f7c1c000)
Stack: f7c1cf38 c09040f1 c0780828 f7c1cf6c c010120f 31616473 00000200 00000000 
       00000246 c0780750 00000000 c0780828 f7c1cf6c c01049a4 fffffeff f7c1cf3c 
       c0780750 00000000 f7c1cf74 c08e0e9c f7c1cfe0 c08e06f4 123c856c 00000001 
Call Trace:
 [<c010120f>] ? name_to_dev_t+0x11f/0x1c0
 [<c01049a4>] ? mcount_call+0x5/0x9
 [<c08e0e9c>] ? prepare_namespace+0x8c/0x140
 [<c08e06f4>] ? kernel_init+0x244/0x260
 [<c0900890>] ? tcp_congestion_default+0x0/0x20
 [<c02942b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0103e12>] ? restore_nocheck_notrace+0x0/0xe
 [<c08e04b0>] ? kernel_init+0x0/0x260
 [<c08e04b0>] ? kernel_init+0x0/0x260
 [<c010498f>] ? kernel_thread_helper+0x7/0x10
 =======================
Code: e7 ff 89 c7 89 d6 b8 84 a8 86 c0 31 d2 e8 55 9f 38 00 8b 1d dc a7 86 c0 eb 36 8d 83 0c 01 00 00 89 fa e8 20 b6 00 00 85 c0 75 1f <3b> 73 bc 7d 38 8b 83 c4 01 00 00 89 c2 25 00 00 f0 ff 81 e2 ff 
EIP: [<c0288b34>] blk_lookup_devt+0x34/0x90 SS:ESP 0068:f7c1cf24
Kernel panic - not syncing: Fatal exception
Rebooting in 10 seconds..Press any key to enter the menu



    GNU GRUB  version 0.97  (638K lower / 1047488K upper memory)

+-------------------------------------------------------------------------+||||||||||||||||||||||||+-------------------------------------------------------------------------+
      Use the ^ and v keys to select which entry is highlighted.
      Press enter to boot the selected OS, 'e' to edit the
      commands before booting, 'a' to modify the kernel arguments
      before booting, or 'c' for a command-line.  Fedora (2.6.23.1-42.fc8)                                                 Fedora (2.6.23.1-35.fc8)                                                 f8 (2.6.23-0.214.rc8.git2.fc8)                                           f6 (2.6.19-1.2895.fc6)                                                   test-32 (test-32)                                                        test-64 (test-64)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    GNU GRUB  version 0.97  (638K lower / 1047488K upper memory)

 [ Minimal BASH-like line editing is supported.  For the first word, TAB
   lists possible command completions.  Anywhere else TAB lists the possible
   completions of a device/filename.  ESC at any time exits.]

grub>                                                                          om2.2     Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1943
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1946
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1949
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1950
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1953
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1956
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1957
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1958
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1959
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1959
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 1 after 0 msecs
initcall hpet_insert_resource+0x0/0x30 returned with error code 1 
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 7 msecs
calling  fail_page_alloc_debugfs+0x0/0x100
initcall fail_page_alloc_debugfs+0x0/0x100 returned 0 after 0 msecs
calling  afs_init+0x0/0x150
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x150 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x140
initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 0 msecs
calling  edd_init+0x0/0x2c0
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 3 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
device: 'md0': device_add
device: '9:0': device_add
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
BUG: unable to handle kernel paging request at ffff81003e6fdfb0
IP: [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
PGD 8063 PUD 9063 PMD 3ea44163 PTE 800000003e6fd160
Oops: 0000 [1] DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00006-g1419a3b-dirty #1962
RIP: 0010:[<ffffffff80404b23>]  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
RSP: 0000:ffff81003f855e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003e6fe010 RCX: 2222222222222222
RDX: 0000000000000000 RSI: ffff81003f855e65 RDI: ffff81003e6fe1ec
RBP: ffff81003f855e50 R08: 0000000000000001 R09: ffffffff80404ac4
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81003e6fe6f8
R13: ffff81003f855e60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80ad3f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003e6fdfb0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f854000, task ffff81003f858000)
Stack:  ffffffff80b12965 ffff81003f855e60 ffffffff80b0bc00 ffffffff80b21808
 ffff81003f855ea0 ffffffff802092a0 ffffff0036616473 0000000000000001
 00000000fffffeff 0000000000000000 ffff81003f855e64 ffffffff80b0bc00
Call Trace:
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff802092a0>] name_to_dev_t+0x170/0xed0
 [<ffffffff80b0bc00>] ? tcp_congestion_default+0x0/0x20
 [<ffffffff80ade563>] prepare_namespace+0x143/0x1b0
 [<ffffffff80addac4>] kernel_init+0x1a4/0x250
 [<ffffffff807aa97b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8022ceb7>] ? finish_task_switch+0x67/0xc0
 [<ffffffff8020cee8>] child_rip+0xa/0x12
 [<ffffffff802497fe>] ? up+0x1e/0x50
 [<ffffffff80add920>] ? kernel_init+0x0/0x250
 [<ffffffff8020cede>] ? child_rip+0x0/0x12


Code: 83 e8 02 00 00 48 3d 20 03 a4 80 41 0f 18 0c 24 75 ca 31 db 48 c7 c7 60 04 a4 80 e8 98 44 3a 00 89 d8 5b 41 5c 41 5d 41 5e c9 c3 <44> 39 73 a0 7e e1 8b 83 00 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff80404b23>] blk_lookup_devt+0x83/0xb0
 RSP <ffff81003f855e30>
CR2: ffff81003e6fdfb0
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu


  Booting 'Fedora (2.6.23.1-42.fc8)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.23.1-42.fc8 ro root=LABEL=/1 rhgb quiet
   [Linux-bzImage, setup=0x2c00, size=0x1d3c18]
initrd /boot/initrd-2.6.23.1-42.fc8.img
--
initcall tipc_init+0x0/0xa8 returned 0 after 11 msecs
calling  hpet_insert_resource+0x0/0x23
initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 msecs
calling  update_mp_table+0x0/0x476
initcall update_mp_table+0x0/0x476 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x40
initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x38
initcall init_lapic_nmi_sysfs+0x0/0x38 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x4f
initcall ioapic_insert_resources+0x0/0x4f returned 0 after 0 msecs
calling  __stack_chk_test+0x0/0x3e
Testing -fstack-protector-all feature
No -fstack-protector-stack-frame!
-fstack-protector-all test failed
initcall __stack_chk_test+0x0/0x3e returned 0 after 9 msecs
calling  init_oops_id+0x0/0x23
initcall init_oops_id+0x0/0x23 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x3a
initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0x61
device: 'cpu_dma_latency': device_add
PM: Adding info for No Bus:cpu_dma_latency
device: 'network_latency': device_add
PM: Adding info for No Bus:network_latency
device: 'network_throughput': device_add
PM: Adding info for No Bus:network_throughput
initcall pm_qos_power_init+0x0/0x61 returned 0 after 24 msecs
calling  debugfs_kprobe_init+0x0/0x89
initcall debugfs_kprobe_init+0x0/0x89 returned 0 after 0 msecs
calling  fail_make_request_debugfs+0x0/0xb
initcall fail_make_request_debugfs+0x0/0xb returned -19 after 0 msecs
calling  random32_reseed+0x0/0x75
initcall random32_reseed+0x0/0x75 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x4c
initcall pci_sysfs_init+0x0/0x4c returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb1
initcall acpi_wakeup_device_init+0x0/0xb1 returned 0 after 0 msecs
calling  acpi_sleep_proc_init+0x0/0x8a
initcall acpi_sleep_proc_init+0x0/0x8a returned 0 after 0 msecs
calling  seqgen_init+0x0/0xf
initcall seqgen_init+0x0/0xf returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0xf0
initcall scsi_complete_async_scans+0x0/0xf0 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x12
initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 msecs
calling  ip_auto_config+0x0/0xd94
initcall ip_auto_config+0x0/0xd94 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
BUG: unable to handle kernel paging request at ffff81003b984fb8
IP: [<ffffffff803fafd4>] blk_lookup_devt+0x42/0xa0
PGD 8063 PUD 9063 PMD 3be2d163 PTE 800000003b984160
Oops: 0000 [1] SMP DEBUG_PAGEALLOC
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc5 #3104
RIP: 0010:[<ffffffff803fafd4>]  [<ffffffff803fafd4>] blk_lookup_devt+0x42/0xa0
RSP: 0000:ffff81003f9c7e10  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003b985018 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff81003f9c7e45 RDI: ffff81003b985214
RBP: ffff81003f9c7e30 R08: 0000000000000000 R09: ffff81003f9c7da0
R10: ffff81003f9c7bd0 R11: ffffffff8025068d R12: ffff81003b9856f0
R13: 0000000000000000 R14: ffff81003f9c7e40 R15: ffffffff80bfd5a0
FS:  0000000000000000(0000) GS:ffffffff80b30200(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff81003b984fb8 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f9c6000, task ffff81003f9c4000)
Stack:  ffff81003f9c7e40 ffffffff80bb7545 ffffffff80bac17b ffff81003f9c7ed0
 ffff81003f9c7e80 ffffffff80209259 ffff810031616473 ffffffff803ff2be
 0000000000000001 0000000000000001 ffff81003f9c7e44 0000000000000000
Call Trace:
 [<ffffffff80bac17b>] ? ip_auto_config+0x0/0xd94
 [<ffffffff80209259>] name_to_dev_t+0x145/0xeec
 [<ffffffff803ff2be>] ? __next_cpu_nr+0x22/0x2b
 [<ffffffff80b7f372>] prepare_namespace+0x91/0x14c
 [<ffffffff80b7eb70>] kernel_init+0x2fe/0x314
 [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
 [<ffffffff80741bbb>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
 [<ffffffff8020d3f8>] child_rip+0xa/0x12
 [<ffffffff8020c90c>] ? restore_args+0x0/0x30
 [<ffffffff8025068d>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80b7e872>] ? kernel_init+0x0/0x314
 [<ffffffff8020d3ee>] ? child_rip+0x0/0x12


Code: 41 54 53 e8 31 5a 34 00 48 8b 1d c0 90 5a 00 48 81 eb 30 03 00 00 eb 3d 48 8d bb f8 01 00 00 4c 89 f6 e8 4e 87 00 00 85 c0 75 22 <44> 3b 6b a0 7d 3f 8b 83 48 03 00 00 89 c2 25 00 00 f0 ff 81 e2 
RIP  [<ffffffff803fafd4>] blk_lookup_devt+0x42/0xa0
 RSP <ffff81003f9c7e10>
CR2: ffff81003b984fb8
Kernel panic - not syncing: Fatal exception
Rebooting in 10 seconds..Press any key to enter the menu


  Booting 'Fedora Core (2.6.22.9-61.fc6)'

root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.22.9-61.fc6 ro root=LABEL=/ rhgb quiet 3 sysrq_always_
