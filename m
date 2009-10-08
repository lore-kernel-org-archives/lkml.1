Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZJHOIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZJHOIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbZJHOIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:08:45 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:33378 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757974AbZJHOIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:08:44 -0400
Date: Thu, 8 Oct 2009 10:08:05 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: alan@linux.intel.com, gregkh@suse.de
Subject: [Regression, bisected] Transmit failure in et131x.
Message-ID: <20091008140805.GA21535@emergent.ellipticsemi.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, alan@linux.intel.com,
	gregkh@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a PCI-express et131x card which works well with the driver in
2.6.31 but fails in 2.6.32-rc3.  The card works at first (for example, I
can ping another host on the network), but 'scp' will only transfer a
few kilobytes before stalling.  Once this happens, ping no longer works.
After a short while, kernel WARNINGs start being spammed to the system
log.  It is possible to regain a working state by re-loading the
module.

I bisected the problem to the following commit.  The WARN messages and
bisection log are at the end of this email.

356c74b401f6b05ae5d793e9d1a9ba8297b8e3ff is first bad commit
commit 356c74b401f6b05ae5d793e9d1a9ba8297b8e3ff
Author: Alan Cox <alan@linux.intel.com>
Date:   Thu Aug 27 11:01:57 2009 +0100

    Staging: et131x: clean up DMA10/DMA4 types

    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 5b3af63d8ab03c021a31600806a8211606351e67 9a023d8edb540ef53dba297@

Oct  5 23:37:53 aphrodite ------------[ cut here ]------------
Oct  5 23:37:53 aphrodite WARNING: at net/sched/sch_generic.c:261 dev_watchdog+0x13c/0x1fd()
Oct  5 23:37:53 aphrodite Hardware name: System Product Name
Oct  5 23:37:53 aphrodite NETDEV WATCHDOG: eth0 (et131x): transmit queue 0 timed out
Oct  5 23:37:53 aphrodite Modules linked in: nfs lockd sunrpc ipv6 hwmon_vid k8temp hwmon i2c_nforce2 snd_seq_midi snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_hda_codec_atihdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_ens1371 snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc ohci_hcd ehci_hcd usbcore nls_base sg sr_mod cdrom pata_amd et131x(C)
Oct  5 23:37:53 aphrodite Pid: 0, comm: swapper Tainted: G         C 2.6.32-rc3-00053-g152b0bb #18
Oct  5 23:37:53 aphrodite Call Trace:
Oct  5 23:37:53 aphrodite <IRQ>  [<ffffffff8126aad0>] ? dev_watchdog+0x13c/0x1fd
Oct  5 23:37:53 aphrodite [<ffffffff8102ec05>] warn_slowpath_common+0x77/0xa4
Oct  5 23:37:53 aphrodite [<ffffffff8102eca7>] warn_slowpath_fmt+0x64/0x66
Oct  5 23:37:53 aphrodite [<ffffffff8102c26b>] ? default_wake_function+0xd/0xf
Oct  5 23:37:53 aphrodite [<ffffffff8104150b>] ? autoremove_wake_function+0x11/0x38
Oct  5 23:37:53 aphrodite [<ffffffff8125a9d2>] ? netdev_drivername+0x43/0x4a
Oct  5 23:37:53 aphrodite [<ffffffff8126aad0>] dev_watchdog+0x13c/0x1fd
Oct  5 23:37:53 aphrodite [<ffffffff8102b076>] ? __wake_up+0x42/0x46
Oct  5 23:37:53 aphrodite [<ffffffff8103dcad>] ? __queue_work+0x80/0x84
Oct  5 23:37:53 aphrodite [<ffffffff8126a994>] ? dev_watchdog+0x0/0x1fd
Oct  5 23:37:53 aphrodite [<ffffffff810379e7>] run_timer_softirq+0x189/0x20e
Oct  5 23:37:53 aphrodite [<ffffffff81033643>] __do_softirq+0x80/0x101
Oct  5 23:37:53 aphrodite [<ffffffff8100c78a>] call_softirq+0x1a/0x24
Oct  5 23:37:53 aphrodite [<ffffffff8100dd91>] do_softirq+0x31/0x69
Oct  5 23:37:53 aphrodite [<ffffffff81033371>] irq_exit+0x34/0x7a
Oct  5 23:37:53 aphrodite [<ffffffff8101b1dc>] smp_apic_timer_interrupt+0x7a/0x86
Oct  5 23:37:53 aphrodite [<ffffffff8100c2e3>] apic_timer_interrupt+0x13/0x20
Oct  5 23:37:53 aphrodite <EOI>  [<ffffffff8101173b>] ? default_idle+0x1e/0x32
Oct  5 23:37:53 aphrodite [<ffffffff81011a57>] ? c1e_idle+0xd9/0xe0
Oct  5 23:37:53 aphrodite [<ffffffff810450ee>] ? atomic_notifier_call_chain+0xf/0x11
Oct  5 23:37:53 aphrodite [<ffffffff8100ad10>] ? cpu_idle+0x3b/0x7a
Oct  5 23:37:53 aphrodite [<ffffffff812ab466>] ? rest_init+0x7a/0x7e
Oct  5 23:37:53 aphrodite [<ffffffff81426b08>] ? start_kernel+0x30a/0x317
Oct  5 23:37:53 aphrodite [<ffffffff81426295>] ? x86_64_start_reservations+0xa5/0xa9
Oct  5 23:37:53 aphrodite [<ffffffff8142637a>] ? x86_64_start_kernel+0xe1/0xe8
Oct  5 23:37:53 aphrodite ---[ end trace 08f8caa393b9f89b ]---
Oct  5 23:37:53 aphrodite et131x 0000:02:00.0: Send stuck - reset.  pMpTcb->WrIndex 0, Flags 0x00000000

Oct  5 23:37:53 aphrodite ------------[ cut here ]------------
Oct  5 23:37:53 aphrodite WARNING: at kernel/irq/manage.c:842 __free_irq+0x52/0x172()
Oct  5 23:37:53 aphrodite Hardware name: System Product Name
Oct  5 23:37:53 aphrodite Trying to free IRQ 16 from IRQ context!
Oct  5 23:37:53 aphrodite Modules linked in: nfs lockd sunrpc ipv6 hwmon_vid k8temp hwmon i2c_nforce2 snd_seq_midi snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_hda_codec_atihdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_ens1371 snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc ohci_hcd ehci_hcd usbcore nls_base sg sr_mod cdrom pata_amd et131x(C)
Oct  5 23:37:53 aphrodite Pid: 0, comm: swapper Tainted: G        WC 2.6.32-rc3-00053-g152b0bb #18
Oct  5 23:37:53 aphrodite Call Trace:
Oct  5 23:37:53 aphrodite <IRQ>  [<ffffffff8105821a>] ? __free_irq+0x52/0x172
Oct  5 23:37:53 aphrodite [<ffffffff8102ec05>] warn_slowpath_common+0x77/0xa4
Oct  5 23:37:53 aphrodite [<ffffffff8102eca7>] warn_slowpath_fmt+0x64/0x66
Oct  5 23:37:53 aphrodite [<ffffffff812b1c62>] ? printk+0x67/0x6d
Oct  5 23:37:53 aphrodite [<ffffffff8105821a>] __free_irq+0x52/0x172
Oct  5 23:37:53 aphrodite [<ffffffff81058377>] free_irq+0x3d/0x63
Oct  5 23:37:53 aphrodite [<ffffffffa00064b2>] et131x_close+0x50/0x5f [et131x]
Oct  5 23:37:53 aphrodite [<ffffffffa0006693>] et131x_tx_timeout+0x125/0x160 [et131x]
Oct  5 23:37:53 aphrodite [<ffffffff8102eca7>] ? warn_slowpath_fmt+0x64/0x66
Oct  5 23:37:53 aphrodite [<ffffffff8102c26b>] ? default_wake_function+0xd/0xf
Oct  5 23:37:53 aphrodite [<ffffffff8104150b>] ? autoremove_wake_function+0x11/0x38
Oct  5 23:37:53 aphrodite [<ffffffff8126aae8>] dev_watchdog+0x154/0x1fd
Oct  5 23:37:53 aphrodite [<ffffffff8102b076>] ? __wake_up+0x42/0x46
Oct  5 23:37:53 aphrodite [<ffffffff8103dcad>] ? __queue_work+0x80/0x84
Oct  5 23:37:53 aphrodite [<ffffffff8126a994>] ? dev_watchdog+0x0/0x1fd
Oct  5 23:37:53 aphrodite [<ffffffff810379e7>] run_timer_softirq+0x189/0x20e
Oct  5 23:37:53 aphrodite [<ffffffff81033643>] __do_softirq+0x80/0x101
Oct  5 23:37:53 aphrodite [<ffffffff8100c78a>] call_softirq+0x1a/0x24
Oct  5 23:37:53 aphrodite [<ffffffff8100dd91>] do_softirq+0x31/0x69
Oct  5 23:37:53 aphrodite [<ffffffff81033371>] irq_exit+0x34/0x7a
Oct  5 23:37:53 aphrodite [<ffffffff8101b1dc>] smp_apic_timer_interrupt+0x7a/0x86
Oct  5 23:37:53 aphrodite [<ffffffff8100c2e3>] apic_timer_interrupt+0x13/0x20
Oct  5 23:37:53 aphrodite <EOI>  [<ffffffff8101173b>] ? default_idle+0x1e/0x32
Oct  5 23:37:53 aphrodite [<ffffffff81011a57>] ? c1e_idle+0xd9/0xe0
Oct  5 23:37:53 aphrodite [<ffffffff810450ee>] ? atomic_notifier_call_chain+0xf/0x11
Oct  5 23:37:53 aphrodite [<ffffffff8100ad10>] ? cpu_idle+0x3b/0x7a
Oct  5 23:37:53 aphrodite [<ffffffff812ab466>] ? rest_init+0x7a/0x7e
Oct  5 23:37:53 aphrodite [<ffffffff81426b08>] ? start_kernel+0x30a/0x317
Oct  5 23:37:53 aphrodite [<ffffffff81426295>] ? x86_64_start_reservations+0xa5/0xa9
Oct  5 23:37:53 aphrodite [<ffffffff8142637a>] ? x86_64_start_kernel+0xe1/0xe8
Oct  5 23:37:53 aphrodite ---[ end trace 08f8caa393b9f89c ]---
Oct  5 23:37:54 aphrodite et131x 0000:02:00.0: Send stuck - reset.  pMpTcb->WrIndex 0, Flags 0x00000000

The second WARNING is continuously spammed at a rate of about one per second.

git bisect start
# bad: [0eca52a92735f43462165efe00a7e394345fb38e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6
git bisect bad 0eca52a92735f43462165efe00a7e394345fb38e
# good: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
git bisect good 74fca6a42863ffacaf7ba6f1936a9f228950f657
# good: [910d7b31f598a1ce7a0325889537aa993ed1ce1c] Staging: hv: remove include/HvHalApi.h
git bisect good 910d7b31f598a1ce7a0325889537aa993ed1ce1c
# bad: [43368e74d126f8e874fce2c248f094edfcf0baa6] MAINTAINERS: acpi: add 'include/acpi'
git bisect bad 43368e74d126f8e874fce2c248f094edfcf0baa6
# bad: [fa877c71e2136bd682b45022c96d5e073ced9f58] Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6
git bisect bad fa877c71e2136bd682b45022c96d5e073ced9f58
# bad: [5bf9cbef9972f851172391a37261b12bba63f733] Blackfin: update ftrace for latest toolchain
git bisect bad 5bf9cbef9972f851172391a37261b12bba63f733
# good: [76efa5e34ed81587e26e483a624dc7f72efb389a] Staging: pohmelfs: fix atomic type spew
git bisect good 76efa5e34ed81587e26e483a624dc7f72efb389a
# good: [0950efd1a1490e869d19ec631eed75ef57772f8b] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/pcmcia-2.6
git bisect good 0950efd1a1490e869d19ec631eed75ef57772f8b
# bad: [7ea61767e41e2baedd6a968d13f56026522e1207] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
git bisect bad 7ea61767e41e2baedd6a968d13f56026522e1207
# bad: [ecdfa44610fa18678c3dd481af75368b9800c6c7] Staging: add Realtek 8192 PCI wireless driver
git bisect bad ecdfa44610fa18678c3dd481af75368b9800c6c7
# good: [13071fded6df0979d50307a463be819377fc2822] Staging: et131x: eeprom remove features
git bisect good 13071fded6df0979d50307a463be819377fc2822
# bad: [e266b2022209a2bc389c1cd6b809395c67671a92] Staging: et131x: kill MSI type
git bisect bad e266b2022209a2bc389c1cd6b809395c67671a92
# good: [f2c98d27b8e88cd17bb3e77f8fccf70f8d2ebd2f] Staging: et131x: clean up PM_CSR_t
git bisect good f2c98d27b8e88cd17bb3e77f8fccf70f8d2ebd2f
# bad: [f6b35d66cf3284fd76cd3b7dd170630235ce304c] Staging: et131x: clean up MP_FLAG macros
git bisect bad f6b35d66cf3284fd76cd3b7dd170630235ce304c
# bad: [356c74b401f6b05ae5d793e9d1a9ba8297b8e3ff] Staging: et131x: clean up DMA10/DMA4 types
git bisect bad 356c74b401f6b05ae5d793e9d1a9ba8297b8e3ff

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

