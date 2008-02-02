Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbYBBDw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbYBBDw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 22:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbYBBDwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 22:52:47 -0500
Received: from keil-draco.com ([216.193.185.50]:50905 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbYBBDwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 22:52:45 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: linux-kernel@vger.kernel.org
Subject: Various Errors with recent GIT
Date: Fri, 1 Feb 2008 22:52:28 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802012252.29454.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a recent (haven't tested the latest git, but I have tested one pulled down
1/29 - I think it's 24e1c13) I see the following errors when the AES crypto
module is loaded:

[   27.786935] aes_x86_64: Unknown symbol crypto_it_tab
[   27.786984] aes_x86_64: Unknown symbol crypto_aes_set_key
[   27.787141] aes_x86_64: Unknown symbol crypto_fl_tab
[   27.787187] aes_x86_64: Unknown symbol crypto_il_tab
[   27.787232] aes_x86_64: Unknown symbol crypto_ft_tab
[   27.625672] aes_x86_64: Unknown symbol crypto_it_tab
[   27.625721] aes_x86_64: Unknown symbol crypto_aes_set_key
[   27.625793] aes_x86_64: Unknown symbol crypto_fl_tab
[   27.625838] aes_x86_64: Unknown symbol crypto_il_tab
[   27.625883] aes_x86_64: Unknown symbol crypto_ft_tab

Another problem is one I wasn't able to find any kind of trigger for, other 
than just running XChat. Every so often XChat would seem to freeze - but if 
run from the command line, switching to that terminal window and 
hitting "ctrl-c" would cause it to rapidly update and become responsive again. 
The freeze would happen at a random time interval that I couldn't figure out.

The last two problems have different symptoms. With one the kernel would 
sometimes spin unable to get a non-error return from the CD/DVD burner drive 
in my laptop - it'd start at UDMA133 and rapidly devolve down to PIO0 and then 
spin trying and retrying PIO0. The only part of the message I remember exactly 
is { DRDY } on 90% of the messages once it switched to trying only the PIO 
modes, although I have seen similar messages about this kind of error on the 
list recently.

And the final error is one that I've been seeing since 2.6.24-rc6 and reported 
as a secondary error in 2.6.24-rc7. The mac80211 system hits a warning when my 
system initially brings my Wifi connection (iwlwifi is the driver) online. The 
problem points to the following line:

        WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);

so it looks as though the initial packet from the device coming online and/or 
registering with the network is corrupt. This does not happen when I boot 
2.6.22 and load the pre-merge iwlwifi/mac80211 code and I do not have the time 
or resources to bisect this problem at the moment or I would be trying to find 
the cause. (This isn't a hardware problem like I initially thought, since the 
code states that it's up to the driver to format the packet correctly - I 
haven't been able to locate any changes to the iwlwifi code post import, (in
the recieve path that would have caused this, but the search was non 
exhaustive) so I'm wondering if this might be a pre-existing bug...)

[   49.960849] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   50.185438] WARNING: at net/mac80211/rx.c:1486 __ieee80211_rx()
[   50.185446] Pid: 0, comm: swapper Not tainted 2.6.24-rc7-git #1
[   50.185450]
[   50.185451] Call Trace:
[   50.185454]  <IRQ>  [<ffffffff8821b309>] :mac80211:__ieee80211_rx+0xc99/0xd60
[   50.185509]  [<ffffffff80473a26>] _spin_unlock_irqrestore+0x16/0x40
[   50.185526]  [<ffffffff8825230a>] :iwl3945:iwl_rx_queue_restock+0xca/0x170
[   50.185533]  [<ffffffff80473a26>] _spin_unlock_irqrestore+0x16/0x40
[   50.185555]  [<ffffffff8820c228>] :mac80211:ieee80211_tasklet_handler+0xb8/0x120
[   50.185570]  [<ffffffff802466f1>] tasklet_action+0x51/0xc0
[   50.185576]  [<ffffffff80473964>] _spin_unlock+0x14/0x40
[   50.185583]  [<ffffffff802465f4>] __do_softirq+0x64/0xe0
[   50.185592]  [<ffffffff8020d57c>] call_softirq+0x1c/0x30
[   50.185599]  [<ffffffff8020ef0d>] do_softirq+0x3d/0x90
[   50.185605]  [<ffffffff80246508>] irq_exit+0x88/0xa0
[   50.185611]  [<ffffffff8020f025>] do_IRQ+0xc5/0x1b0
[   50.185619]  [<ffffffff8020c8d1>] ret_from_intr+0x0/0xa
[   50.185628]  <EOI>  [<ffffffff880165f2>] :processor:acpi_idle_enter_bm+0x273/0x2e3
[   50.185647]  [<ffffffff880165e8>] :processor:acpi_idle_enter_bm+0x269/0x2e3
[   50.185652]  [<ffffffff803e0f5d>] menu_select+0xad/0xe0
[   50.185657]  [<ffffffff803dfe05>] cpuidle_idle_call+0x95/0xd0
[   50.185661]  [<ffffffff803dfd70>] cpuidle_idle_call+0x0/0xd0
[   50.185665]  [<ffffffff8020b013>] cpu_idle+0x73/0xe0
[   50.185670]  [<ffffffff80220eb5>] start_secondary+0x315/0x410
[   50.185683]

(That's the complete warning from my 2.6.24-rc7 kernel... The following is the
complete warning from the 24e1c13 build)

[  182.298665] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  182.359208] ppdev: user-space parallel port driver
[  182.623816] ------------[ cut here ]------------
[  182.623826] WARNING: at net/mac80211/rx.c:1704 __ieee80211_rx_handle_packet+0x8e7/0x980 [mac80211]()
[  182.623831] Modules linked in: ppdev acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats freq_t
able dock container sbs sbshc dm_crypt dm_mod ipv6 sbp2 parport_pc lp parport arc4 ecb crypto_blkcipher iwl3945 mac80211 cfg80211 ata_generic snd_hda_intel snd_hwdep snd_pcm_oss s
nd_pcm snd_page_alloc snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event sdhci serio_raw psmouse pcspkr iTCO_wdt iTCO_vendor_support ricoh_mmc mmc
_core pata_acpi snd_seq snd_timer snd_seq_device video snd soundcore ac shpchp pci_hotplug button battery intel_agp evdev ext3 jbd mbcache sg sd_mod ohci1394 ieee1394 ata_piix ahc
i tg3 libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[  182.623925] Pid: 0, comm: swapper Not tainted 2.6.24-git-latest #2
[  182.623929]
[  182.623930] Call Trace:
[  182.623933]  <IRQ>  [warn_on_slowpath+95/128] warn_on_slowpath+0x5f/0x80
[  182.623963]  [mempool_free_slab+18/32] ? mempool_free_slab+0x12/0x20
[  182.623971]  [__slab_free+488/976] ? __slab_free+0x1e8/0x3d0
[  182.623981]  [_spin_lock_irqsave+49/96] ? _spin_lock_irqsave+0x31/0x60
[  182.623988]  [_spin_unlock_irqrestore+27/64] ? _spin_unlock_irqrestore+0x1b/0x40
[  182.623996]  [skb_queue_tail+73/96] ? skb_queue_tail+0x49/0x60
[  182.624020]  [_end+129987174/2129698072] ? :mac80211:ieee80211_rx_irqsafe+0x7e/0x90
[  182.624044]  [_end+129989631/2129698072] :mac80211:__ieee80211_rx_handle_packet+0x8e7/0x980
[  182.624063]  [local_bh_disable+14/16] ? local_bh_disable+0xe/0x10
[  182.624069]  [local_bh_enable_ip+59/112] ? local_bh_enable_ip+0x3b/0x70
[  182.624076]  [_read_unlock_bh+26/32] ? _read_unlock_bh+0x1a/0x20
[  182.624101]  [_end+129993193/2129698072] :mac80211:__ieee80211_rx+0x241/0x5e0
[  182.624107]  [_spin_lock_irqsave+49/96] ? _spin_lock_irqsave+0x31/0x60
[  182.624112]  [_spin_unlock_irqrestore+27/64] ? _spin_unlock_irqrestore+0x1b/0x40
[  182.624127]  [_end+129925072/2129698072] :mac80211:ieee80211_tasklet_handler+0xb8/0x120
[  182.624138]  [tasklet_action+95/208] tasklet_action+0x5f/0xd0
[  182.624149]  [_end+130205890/2129698072] ? :iwl3945:iwl3945_isr+0x22a/0x340
[  182.624155]  [__do_softirq+100/208] __do_softirq+0x64/0xd0
[  182.624161]  [call_softirq+28/48] call_softirq+0x1c/0x30
[  182.624166]  [do_softirq+86/160] do_softirq+0x56/0xa0
[  182.624170]  [irq_exit+135/144] irq_exit+0x87/0x90
[  182.624174]  [do_IRQ+197/432] do_IRQ+0xc5/0x1b0
[  182.624181]  [ret_from_intr+0/25] ret_from_intr+0x0/0x19
[  182.624183]  <EOI>  [native_irq_enable+6/16] ? native_irq_enable+0x6/0x10
[  182.624203]  [_end+127007654/2129698072] ? :processor:acpi_idle_enter_bm+0x2a7/0x321
[  182.624208]  [menu_select+173/224] ? menu_select+0xad/0xe0
[  182.624216]  [cpuidle_idle_call+161/224] ? cpuidle_idle_call+0xa1/0xe0

Despite the difference in lines and the name of the surrounding function, the
actual warning that spawns the error is the same. I've 

At any rate, I'll be quiet now and go back to doing other things. (Maybe even 
testing the latest git revision o.O)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
