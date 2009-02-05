Return-Path: <linux-kernel-owner+w=401wt.eu-S1762558AbZBEC1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762558AbZBEC1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbZBEC07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:26:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbZBEC06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:26:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 12561] hang during suspend to RAM
Date: Thu, 5 Feb 2009 03:26:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: bugme-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, jakethompson1@gmail.com,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Mike Travis <travis@sgi.com>
References: <20090204153842.C703C108042@picon.linux-foundation.org>
In-Reply-To: <20090204153842.C703C108042@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050326.15583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We seem to have problems with cpufreq_suspend and later with hres_timers_resume
on the Jake's machine:

On Wednesday 04 February 2009, bugme-daemon@bugzilla.kernel.org wrote:
> ------- Comment #15 from jakethompson1@gmail.com  2009-02-04 07:38 -------
> 2.6.29-rc3 without acpi_sleep=old_ordering -> still freezes during suspend
> 
> 2.6.29-rc3 with acpi_sleep=old_ordering produces the same symptoms as 2.6.28.2,
> and the dmesg includes the following errors:
> 
> BUG: sleeping function called from invalid context at kernel/workqueue.c:440
> in_atomic(): 0, irqs_disabled(): 1, pid: 2431, name: pm-suspend
> Pid: 2431, comm: pm-suspend Not tainted 2.6.29-rc3 #1
> Call Trace:
>  [<c04286fc>] __might_sleep+0xdf/0xe4
>  [<c043c6a4>] flush_work+0x1a/0x93
>  [<c06c2d9e>] ? _spin_unlock_irqrestore+0x22/0x38
>  [<c043c871>] ? __queue_work+0x26/0x2b
>  [<c043c926>] work_on_cpu+0x3c/0x46
>  [<c043bf75>] ? do_work_for_cpu+0x0/0x12
>  [<f045144a>] ? do_drv_read+0x0/0x3e [acpi_cpufreq]
>  [<f0451391>] get_cur_val+0x9a/0xbf [acpi_cpufreq]
>  [<f045140a>] get_cur_freq_on_cpu+0x54/0x94 [acpi_cpufreq]
>  [<c0626b80>] cpufreq_suspend+0x9c/0x114
>  [<c05a4c98>] sysdev_suspend+0x3e/0x175
>  [<c05a8e04>] device_power_down+0xb4/0xf0
>  [<c045037d>] suspend_devices_and_enter+0xcf/0x16d
>  [<c0450570>] enter_state+0x130/0x190
>  [<c045065f>] state_store+0x8f/0xa2
>  [<c04505d0>] ? state_store+0x0/0xa2
>  [<c0527bc1>] kobj_attr_store+0x1a/0x22
>  [<c04d3a7b>] sysfs_write_file+0xb4/0xdf
>  [<c04d39c7>] ? sysfs_write_file+0x0/0xdf
>  [<c04973da>] vfs_write+0x84/0xdf
>  [<c04974ce>] sys_write+0x3b/0x60
>  [<c04038df>] sysenter_do_call+0x12/0x34
> ------------[ cut here ]------------
> WARNING: at kernel/hrtimer.c:618 hres_timers_resume+0x2f/0x45()
> Hardware name: CF-51LCMDDBM
> hres_timers_resume() called with IRQs enabled!Modules linked in: i915 drm
> i2c_al
> go_bit ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6
> cpufreq_ond
> emand acpi_cpufreq dm_multipath uinput snd_intel8x0 snd_intel8x0m snd_seq_dummy 
> snd_ac97_codec ac97_bus snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> sn
> d_pcm_oss snd_mixer_oss snd_pcm snd_timer ppdev parport_pc snd soundcore
> yenta_s
> ocket snd_page_alloc i2c_i801 rsrc_nonstatic ipw2200 serio_raw firewire_ohci
> par
> port video i2c_core iTCO_wdt iTCO_vendor_support libipw sky2 pcspkr
> firewire_cor
> e crc_itu_t output lib80211 joydev ata_generic pata_acpi [last unloaded:
> microco
> de]
> Pid: 2431, comm: pm-suspend Not tainted 2.6.29-rc3 #1
> Call Trace:
>  [<c042e4e1>] warn_slowpath+0x71/0xa8
>  [<c0414740>] ? lapic_next_event+0x13/0x17
>  [<c044769b>] ? clockevents_program_event+0xdb/0xea
>  [<c044848d>] ? tick_dev_program_event+0x28/0x95
>  [<c0448544>] ? tick_program_event+0x22/0x29
>  [<c0447b2e>] ? tick_notify+0x2e1/0x2f0
>  [<c043c21f>] ? insert_work+0x3d/0x45
>  [<c06c4e4c>] ? notifier_call_chain+0x2b/0x4a
>  [<c04416ef>] hres_timers_resume+0x2f/0x45
>  [<c0444d3a>] timekeeping_resume+0x13c/0x142
>  [<c05a4b4c>] __sysdev_resume+0x14/0x38
>  [<c05a4b91>] sysdev_resume+0x21/0x54
>  [<c05a915a>] device_power_up+0xb/0x15
>  [<c04503b1>] suspend_devices_and_enter+0x103/0x16d
>  [<c0450570>] enter_state+0x130/0x190
>  [<c045065f>] state_store+0x8f/0xa2
>  [<c04505d0>] ? state_store+0x0/0xa2
>  [<c0527bc1>] kobj_attr_store+0x1a/0x22
>  [<c04d3a7b>] sysfs_write_file+0xb4/0xdf
>  [<c04d39c7>] ? sysfs_write_file+0x0/0xdf
>  [<c04973da>] vfs_write+0x84/0xdf
>  [<c04974ce>] sys_write+0x3b/0x60
>  [<c04038df>] sysenter_do_call+0x12/0x34
> ---[ end trace 104058e15f9549d5 ]---
> pcmcia_socket pcmcia_socket0: *** DANGER *** unable to remove socket power
> pcmcia_socket pcmcia_socket1: *** DANGER *** unable to remove socket power
> firewire_ohci: Failed to reset ohci card.
> pm_op(): pci_pm_resume+0x0/0x4f returns -16
> PM: Device 0000:06:00.2 failed to resume: error -16
> irq 23: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: swapper Tainted: G        W  2.6.29-rc3 #1
> Call Trace:
>  [<c04653e6>] __report_bad_irq+0x2e/0x6f
>  [<c0465517>] note_interrupt+0xf0/0x149
>  [<c0465a4d>] handle_fasteoi_irq+0x8f/0xb5
>  [<c04659be>] ? handle_fasteoi_irq+0x0/0xb5
>  <IRQ>  [<c0403fac>] ? common_interrupt+0x2c/0x34
>  [<c0574e13>] ? acpi_idle_enter_simple+0x150/0x18b
>  [<c0628658>] ? cpuidle_idle_call+0x60/0x94
>  [<c0402a23>] ? cpu_idle+0x7f/0xa0
>  [<c06b2116>] ? rest_init+0x4e/0x50
> handlers:
> [<c05e441b>] (usb_hcd_irq+0x0/0xa3)
> [<c05e441b>] (usb_hcd_irq+0x0/0xa3)
> Disabling IRQ #23
