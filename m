Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760AbZCIMlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbZCIMlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 08:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZCIMlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 08:41:32 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:33269 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZCIMla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 08:41:30 -0400
X-Greylist: delayed 2045 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 08:41:30 EDT
Message-ID: <49B5066D.1030309@grupopie.com>
Date: Mon, 09 Mar 2009 12:07:09 +0000
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: =?UTF-8?B?TWljaGFlbCBCw7xrZXI=?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <20090304224310.GA29043@electric-eye.fr.zoreil.com>
In-Reply-To: <20090304224310.GA29043@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Michael Büker <m.bueker@berlin.de> :
> [...]
>   
>> With both 2.6.27.19 and 2.6.28.7, I am experiencing "transmit timed out" 
>> errors as reported by the netdev watchdog, for both my PCMCIA Ethernet 
>> adapters, using the r8169 and 8139too drivers respectively.
>>     
>
>   

This seems to be the problem I also reported:
http://lkml.org/lkml/2009/2/16/121

> Can you describe the symptoms a bit more specifically ?
>
> The kernel displays a scary warning, I can guess that it is almost surely
> associated with some loss of network connectivity for a few seconds at the
> very least but it is a bit hard to figure the real scale of your problem.
>
> Please scare me. :o)
>   

Besides the data I've sent on my past message, here is my dmesg output:

Hardware name:
NETDEV WATCHDOG: eth0 (r8169): transmit timed out
Modules linked in: iptable_filter ip_tables x_tables joydev i915 drm
i2c_algo_bit af_packet snd_pcm_oss snd_mixer_oss microcode snd_seq
snd_seq_device binfmt_misc fuse loop dm_mod snd_hda_codec_realtek(N)
snd_hda_intel snd_hda_codec(N) snd_hwdep snd_pcm snd_timer iTCO_wdt snd
ppdev iTCO_vendor_support rtc_cmos r8169 soundcore i2c_i801 rtc_core
parport_pc button snd_page_alloc intel_agp mii i2c_core pcspkr rtc_lib
parport sg floppy raid456 async_xor async_memcpy async_tx xor raid0
ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore edd raid1 ext3 mbcache jbd
fan thermal processor thermal_sys hwmon ide_pci_generic ide_core
ata_generic ata_piix libata scsi_mod
Supported: Yes
Pid: 0, comm: swapper Tainted: G          N 
2.6.29-rc5-git3-master_20090221181736_632072f6-default #1
Call Trace:
 [<ffffffff8020ff2d>] try_stack_unwind+0x70/0x127
 [<ffffffff8020f0c0>] dump_trace+0x9a/0x2a6
 [<ffffffff8020fc7e>] show_trace_log_lvl+0x4c/0x58
 [<ffffffff8020fc9a>] show_trace+0x10/0x12
 [<ffffffff804efbb1>] dump_stack+0x72/0x7b
 [<ffffffff802483f7>] warn_slowpath+0xb1/0xed
 [<ffffffff80480b41>] dev_watchdog+0x13c/0x202
 [<ffffffff80251eda>] run_timer_softirq+0x1a3/0x232
 [<ffffffff8024dedc>] __do_softirq+0xd6/0x1f2
 [<ffffffff8020d83c>] call_softirq+0x1c/0x30
 [<ffffffff8020ea10>] do_softirq+0x44/0x8f
 [<ffffffff8024db87>] irq_exit+0x3f/0x7e
 [<ffffffff8021f012>] smp_apic_timer_interrupt+0x93/0xac
 [<ffffffff8020d1f3>] apic_timer_interrupt+0x13/0x20
DWARF2 unwinder stuck at apic_timer_interrupt+0x13/0x20

Leftover inexact backtrace:

 <IRQ>  <EOI>  [<ffffffff80212e38>] ? mwait_idle+0x6e/0x7a
 [<ffffffff8020b450>] ? enter_idle+0x22/0x24
 [<ffffffff8020b4ab>] ? cpu_idle+0x59/0x9a
 [<ffffffff804de0fd>] ? rest_init+0x61/0x63
---[ end trace 28260c20fab8b205 ]---
r8169: eth0: link up
r8169: eth0: link up
r8169: eth0: link up
r8169: eth0: link up

Just a few other hints for a possible solution:

1) The problem seems only to happen on TX, as Michael states. If I RX a
large file, the NIC will not cease to work, probably because the TX is
enough not to crash it...
2) On my post refered above, only the PCIe card has this problem. The
other tree PCI NICs work flawlessly.
3) The way I use to test it, is just an scp out of a large file. If I
detect the staleness of the transfer on an early stage, the NIC will
recover. If not, the NIC rarely recovers.

> [...]
>   
>> as both kernel config files. I'll gladly provide more information as it is 
>> requested.
>>     
>
> lspci -vx and a complete dmesg.
>
> Can you identify a kernel which worked flawlessly ?
>   
I'm performing a git bisect to try to find the patch that caused it.
Here is the current status:
git bisect start
# bad: [fec6c6fec3e20637bee5d276fb61dd8b49a3f9cc] Linux 2.6.29-rc7
git bisect bad fec6c6fec3e20637bee5d276fb61dd8b49a3f9cc
# good: [0215ffb08ce99e2bb59eca114a99499a4d06e704] Linux 2.6.19
git bisect good 0215ffb08ce99e2bb59eca114a99499a4d06e704
# good: [836341a70471ba77657b0b420dd7eea3c30a038b] mac80211: remove sta
TIM flag, fix expiry TIM handling
git bisect good 836341a70471ba77657b0b420dd7eea3c30a038b ( This is a
2.6.25-rc3-master_20090221181736_632072f6 )

The bisect will take a while as the system is a dual core Atom...
This bisect will take a while as my machine usually will not boot on
2.6.27 kernels...
If I get any further I'll let you know.

Regards,
Rui Santos

