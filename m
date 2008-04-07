Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYDGWyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYDGWyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYDGWx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:53:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:15838 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYDGWx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KYVEp7xCO6o/YDoM4uaqRS2eADmFglAw/jFcXIG0j08QK9wppmthLSkJnQIQqBD/zl4RWdFW3fxjZs06KgzL5Uplo67l7ZwDBnQHsqLzV4OwY+jFtWRaG7Z4Q5sWO8+YSUtgRnxto34YWNDqAhSrQ5FAFjx1xWgmA8pW1w97ndg=
Message-ID: <c4e36d110804071553x6ce219b2tc1e27ce5d3a722af@mail.gmail.com>
Date: Tue, 8 Apr 2008 00:53:52 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Andi Kleen" <andi@firstfloor.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
	 <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz>
	 <20080407222352.GG16647@one.firstfloor.org>
	 <200804080029.31102.rjw@sisk.pl>
	 <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/8, Jiri Kosina <jkosina@suse.cz>:
> On Tue, 8 Apr 2008, Rafael J. Wysocki wrote:
>
>  > > The mce resume is a sysdev.
>  > > sysdevs were always supposed to run completely with interrupts off. If they
>  > > don't anymore that's some kind of higher level resume code bug which you need
>  > > to fix there, not hack around in the low level code.
>  > They are executed with interrupts disabled, on one CPU.
>
>
> So, any idea why mce_resume() -> mce_init() -> debug_smp_processor_id()
>  triggers the warning? Apparently preempt_count is zero, irqs_disabled()
>  returns false, and cpumask_of_cpu() is not equal to current->cpus_allowed.
>
>  So there clearly is a bug somewhere.
>
>
>  > > Obviously turning on preemption anywhere around the machine check is
>  > > fatal because it touches CPU state and if you reschedule you could
>  > > switch to another CPU and change or access the wrong CPU's state.
>  > FWIW, at the point when sysdevs are resumed we are single-threaded.
>
>
> Is that really relevant here? We still could be switched over to another
>  CPU, and that would break things.


To avoid some mystery - these two warns precede warnings I've
initially posted here - the reason why I've not posted also these 2
kvm related warns is that kvm maintainers already know about this
problem and said in the past that they will eventually fix them (If I
remember correctly)

Warnings and bug looked somewhat unrelated - but I could be wrong and
the mystery irq could be mangles in kvm....


ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
kvm: disabling virtualization on CPU1
------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp_64.c:424 smp_call_function_single+0xea/0x100()
Modules linked in: cpufreq_userspace tun i915 drm ipt_MASQUERADE
iptable_nat nf_na
t nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge llc nfsd lockd nfs_acl auth
_rpcgss exportfs autofs4 sunrpc binfmt_misc dm_mirror dm_log
dm_multipath dm_mod uinput kvm_intel kvm snd_hda_intel snd_seq_oss snd
_seq_midi_event snd_seq arc4 snd_seq_device snd_pcm_oss ecb
snd_mixer_oss snd_pcm crypto_blkcipher video snd_timer iTCO_wdt
cryptom
gr crypto_algapi rtc_cmos iwl3945 sdhci mmc_core thinkpad_acpi snd
mac80211 psmouse evdev iTCO_vendor_support rtc_core i2c_i801 out
put rtc_lib soundcore snd_page_alloc e1000e sr_mod intel_agp battery
ac backlight nvram serio_raw i2c_core cfg80211 cdrom button uh
ci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
Pid: 18951, comm: kstopmachine Not tainted 2.6.25-rc8 #32

Call Trace:
 [warn_on_slowpath+95/144] warn_on_slowpath+0x5f/0x90
 [vprintk+560/1136] ? vprintk+0x230/0x470
 [hrtick_set+57/304] ? hrtick_set+0x39/0x130
 [_end+108902941/2109239016] ? :kvm:decache_vcpus_on_cpu+0x65/0xe0
 [smp_call_function_single+234/256] smp_call_function_single+0xea/0x100
 [_end+109030358/2109239016] :kvm_intel:vmx_vcpu_decache+0x2e/0x40
 [_end+108903005/2109239016] :kvm:decache_vcpus_on_cpu+0xa5/0xe0
 [_end+108882341/2109239016] :kvm:hardware_disable+0x2d/0x40
 [_end+108882503/2109239016] :kvm:kvm_cpu_hotplug+0x8f/0xe0
 [notifier_call_chain+63/128] notifier_call_chain+0x3f/0x80
 [raw_notifier_call_chain+17/32] raw_notifier_call_chain+0x11/0x20
 [take_cpu_down+27/64] take_cpu_down+0x1b/0x40
 [do_stop+328/576] do_stop+0x148/0x240
 [do_stop+0/576] ? do_stop+0x0/0x240
 [do_stop+0/576] ? do_stop+0x0/0x240
 [kthread+73/144] kthread+0x49/0x90
 [child_rip+10/18] child_rip+0xa/0x12
 [restore_args+0/48] ? restore_args+0x0/0x30
 [kthread+0/144] ? kthread+0x0/0x90
 [child_rip+0/18] ? child_rip+0x0/0x12

---[ end trace ca143223eefdc828 ]---
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU1 is down
------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp_64.c:424 smp_call_function_single+0xea/0x100()
Modules linked in: cpufreq_userspace tun i915 drm ipt_MASQUERADE
iptable_nat nf_na
ECT xt_tcpudp iptable_filter ip_tables x_tables bridge llc nfsd lockd
nfs_acl auth
rror dm_log dm_multipath dm_mod uinput kvm_intel kvm snd_hda_intel
snd_seq_oss snd
cm_oss ecb snd_mixer_oss snd_pcm crypto_blkcipher video snd_timer
iTCO_wdt cryptom
thinkpad_acpi snd mac80211 psmouse evdev iTCO_vendor_support rtc_core
i2c_i801 out
d intel_agp battery ac backlight nvram serio_raw i2c_core cfg80211
cdrom button uh
microcode]
Pid: 18791, comm: pm-suspend Not tainted 2.6.25-rc8 #32

Call Trace:
 [warn_on_slowpath+95/144] warn_on_slowpath+0x5f/0x90
 [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
 [release_console_sem+535/560] ? release_console_sem+0x217/0x230
 [vprintk+560/1136] ? vprintk+0x230/0x470
 [_end+108902941/2109239016] ? :kvm:decache_vcpus_on_cpu+0x65/0xe0
 [smp_call_function_single+234/256] smp_call_function_single+0xea/0x100
 [_end+109030358/2109239016] :kvm_intel:vmx_vcpu_decache+0x2e/0x40
 [_end+108903005/2109239016] :kvm:decache_vcpus_on_cpu+0xa5/0xe0
 [_end+108882341/2109239016] :kvm:hardware_disable+0x2d/0x40
 [_end+108882595/2109239016] :kvm:kvm_suspend+0xb/0x10
 [sysdev_suspend+209/560] sysdev_suspend+0xd1/0x230
 [device_power_down+177/256] device_power_down+0xb1/0x100
 [suspend_devices_and_enter+300/416] suspend_devices_and_enter+0x12c/0x1a0
 [enter_state+326/464] enter_state+0x146/0x1d0
 [state_store+186/256] state_store+0xba/0x100
 [kobj_attr_store+23/32] kobj_attr_store+0x17/0x20
 [sysfs_write_file+202/320] sysfs_write_file+0xca/0x140
 [vfs_write+203/368] vfs_write+0xcb/0x170
 [sys_write+80/144] sys_write+0x50/0x90
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80

---[ end trace ca143223eefdc828 ]---
Extended CMOS year: 2000

Zdenek
