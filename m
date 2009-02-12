Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbZBLOny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbZBLOny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbZBLOnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:43:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022AbZBLOnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:43:41 -0500
Date: Thu, 12 Feb 2009 15:43:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: kvm@vger.kernel.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] [BUG] Linux 2.6.28.4 freezing on a 32-bits x86
	Thinkpad T43p
Message-ID: <20090212144313.GA14616@elte.hu>
References: <20090204211106.GA30824@Krystal> <20090204211759.GK22608@elte.hu> <20090211193125.GA30975@Krystal> <20090211195038.GC25968@elte.hu> <20090211201349.GB32122@Krystal> <20090212045050.GA13924@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212045050.GA13924@Krystal>
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


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > Here is a new backtrace, taken with a huge amount of debugging active, which still 
> > > > points to an interrupt handler nested over kvm_mmu_pte_write as the culprit. It's 
> > > > weird that the kvm code gets called on my modest Pentium M laptop, which I think 
> > > > has no VT-x support at all. I am not running any KVM VMs on this machine. The 
> > > > problem still happens on 2.6.28.4, and Slub redzones did not identify any memory 
> > > > corruption. This could be due to kvm_mmu_pte_write which either should not be 
> > > > called at all, or due to improper interrupt disabling in this function.
> > > 
> > > Does latest tip:master fix it? In particular this one:
> > > 
> > >   9cf161a: x86/cpa: make sure cpa is safe to call in lazy mmu mode
> > > 
> > > fixes a crasher related to KVM and mmu notifiers ...
> > > 
> > > 	Ingo
> > 
> > I'll try to apply commit 
> > 9cf161a: x86/cpa: make sure cpa is safe to call in lazy mmu mode
> > 
> > To my 2.6.28.4 kernel to change the configuration minimally and see if
> > it helps. I guess we'll have to wait a few days before the problem is
> > reproduced, and even more if it's not. :)
> > 
> 
> OK, it's been much faster to reproduce now that the patch above is
> applied. New stack trace, different this time, but still pointing to
> data corruption seen by get_next_timer_interrupt. It happens in the
> first 5 minutes after bootup.
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c1049aaa>] get_next_timer_interrupt+0x4a/0x220
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> LTT NESTING LEVEL : 0
> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:0b:02.0/rf_kill
> Modules linked in: soundcore snd snd_rawmidi serio_raw snd_seq_midi cryptoloop snd_seq_oss snd_seq_device ipw2200 psmouse unix snd_timer snd_seq usbhid loop nvram pcmcia joydev aes_i586 snd_seq_dummy evdev i2c_i801 snd_seq_midi_event blowfish rsrc_nonstatic led_class ide_generic rfkill ide_cd_mod edd acpi_cpufreq hid_logitech sir_dev pcmcia_core thinkpad_acpi ltt_control ltt_statedump dm_mod snd_intel8x0m irtty_sir yenta_socket snd_mixer_oss ac97_bus agpgart floppy snd_pcm button dm_log dm_region_hash dm_mirror dm_snapshot snd_pcm_oss vfat thermal fat intel_agp snd_intel8x0 nls_cp437 crc_ccitt irda nls_iso8859_1 snd_ac97_codec lp parport ppdev bluetooth af_packet binfmt_misc parport_pc l2cap drm nsc_ircc ac rfcomm output video radeon battery lockd libphy ntfs ipv6 tg3 snd_page_alloc sunrpc nfs
> 
> Pid: 0, comm: swapper Not tainted (2.6.28.4-trace-00235-g6523760-dirty #15) 2687D5U
> EIP: 0060:[<c1049aaa>] EFLAGS: 00010002 CPU: 0
> EIP is at get_next_timer_interrupt+0x4a/0x220
> EAX: 0000006c EBX: c14f2b84 ECX: 00000000 EDX: 00000000
> ESI: c14f2800 EDI: 0000006c EBP: c1489ec8 ESP: c1489e90
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=c1488000 task=c14473a0 task.ti=c1488000)
> Stack:
>  ffffbe6c ffffbe6b c14f2800 0000001e 00000000 00000030 00000000 c1489ec0
>  c105a696 00000000 00000030 0000001e 00000001 ffffbe6b c1489f10 c1060bf8
>  c1044f67 00000046 c1077601 00000001 c25f5d4f 0000001e c25e9f80 0000001e
> Call Trace:
>  [<c105a696>] ? sched_clock_cpu+0xc6/0x120
>  [<c1060bf8>] ? tick_nohz_stop_sched_tick+0x158/0x370
>  [<c1044f67>] ? __do_softirq+0x177/0x1f0
>  [<c1077601>] ? handle_edge_irq+0xd1/0x130
>  [<c104523e>] ? irq_exit+0x7e/0x90
>  [<c1021aad>] ? do_IRQ+0x7d/0x90
>  [<c10207b4>] ? common_interrupt+0x28/0x30
>  [<c1195d15>] ? acpi_idle_enter_simple+0x175/0x1e2
>  [<c124b7ad>] ? cpuidle_idle_call+0x6d/0xb0
>  [<c101ea15>] ? cpu_idle+0x55/0xb0
>  [<c12f9781>] ? rest_init+0x61/0x70
> Code: 0f b6 f9 89 4d c8 89 f8 8b 75 d0 8b 54 c6 24 8b 0a 0f 18 01 90 8d 5c c6 24 39 da 75 1c e9 f9 00 00 00 8d b4 26 00 00 00 00 89 ca <8b> 09 0f 18 01 90 39 da 0f 84 e2 00 00 00 f6 42 14 01 75 ea 85
> EIP: [<c1049aaa>] get_next_timer_interrupt+0x4a/0x220 SS:ESP 0068:c1489e90
> ---[ end trace 32ebcf3d2f51bd62 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> BUG: spinlock lockup on CPU#0, swapper/0, c14f2800
> Pid: 0, comm: swapper Tainted: G      D    2.6.28.4-trace-00235-g6523760-dirty #15
> Call Trace:
>  [<c115ab5b>] _raw_spin_lock+0x10b/0x120
>  [<c1302cb9>] _spin_lock_irq+0x49/0x50
>  [<c1049309>] ? run_timer_softirq+0x29/0x1b0
>  [<c1049309>] run_timer_softirq+0x29/0x1b0
>  [<c101fcd0>] ? restore_nocheck_notrace+0x0/0xe
>  [<c1044ebe>] __do_softirq+0xce/0x1f0
>  [<c1058cf5>] ? hrtimer_interrupt+0x185/0x1a0
>  [<c104504d>] do_softirq+0x6d/0x80
>  [<c1045245>] irq_exit+0x85/0x90
>  [<c102ecb5>] smp_apic_timer_interrupt+0xd5/0x130
>  [<c10207e9>] apic_timer_interrupt+0x2d/0x34
>  [<c12ffd14>] ? panic+0x7b/0xf3
>  [<c10430de>] do_exit+0x68e/0x810
>  [<c103f98a>] ? print_oops_end_marker+0x2a/0x30
>  [<c12ffdeb>] ? printk+0x5f/0x6c
>  [<c103f98a>] ? print_oops_end_marker+0x2a/0x30
>  [<c1304191>] oops_end+0xa1/0xb0
>  [<c1022164>] die+0x54/0x70
>  [<c1305670>] ? do_page_fault+0x0/0xa60
>  [<c1305ac7>] do_page_fault+0x457/0xa60
>  [<c1302a19>] ? _spi....

hm, corrupted timer list? Have you tried my suggestions: debugojects, pagealloc, 
etc?

	Ingo
