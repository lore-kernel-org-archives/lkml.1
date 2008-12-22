Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYLVVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYLVVf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbYLVVfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:35:20 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:61803 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYLVVfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=im0FdDvSqz/JlfmDZYN9iflSrsOuNPFhadZBXsYYx5nf85VbN751+W4FBcTZvHWoxH
         aOfR9T+aAKYghvQbNCS7V903ep1fy4sML35glYDP8aAwtmsA7/m6cxa6bOxRT2/rlbkH
         9ThI8k7jNMr1IDtxVkb25ph37Bg2JS4e6llrY=
Message-ID: <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com>
Date: Mon, 22 Dec 2008 22:35:16 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: TSC not updating after resume: Bug or Feature?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
In-Reply-To: <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
	 <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
	 <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>
	 <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com>
	 <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain>
	 <20081222150021.GA13839@elte.hu>
	 <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>
	 <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>
	 <b637ec0b0812221239p169967aemf14b2e591779f5cd@mail.gmail.com>
	 <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas.

On Mon, Dec 22, 2008 at 10:13 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Fabio,
>
> On Mon, 22 Dec 2008, Fabio Comolli wrote:
>> Hi Thomas.
>>
>> On Mon, Dec 22, 2008 at 9:36 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Mon, 22 Dec 2008, Thomas Gleixner wrote:
>> >> On Mon, 22 Dec 2008, Ingo Molnar wrote:
>> >> > * Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> >
>> >> > > > By the way, I don't know if it matters but the problema happened with
>> >> > > > in-kernel hibernation and also in out-of-tree TuxOnIce hibernation.
>> >> > > > Maybe this can help debugging the issue, I don't know.
>> >> > >
>> >> > > Hmm, does not ring a bell here. Can you please apply the patch below to
>> >> > > mainline and retest ?
>> >> >
>> >> > ... and he should send a dmesg after a suspend cycle, right?
>> >>
>> >> Yes :)
>> >>
>> >> I digged more in the bugzillas. Toralf added some debug to
>> >> __update_sched_clock():
>> >>
>> >> -       max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
>> >> +       max_clock = scd->tick_gtod + TICK_NSEC;
>> >> +       if (scd->clock > max_clock)
>> >> +               printk(KERN_INFO "%d %d\n", scd->clock, max_clock);
>> >>
>> >> The interesting output is:
>> >>
>> >> Dec 14 21:55:55 n22 Back to C!
>> >> Dec 14 21:55:55 n22 Extended CMOS year: 2000
>> >> Dec 14 21:55:55 n22 Force enabled HPET at resume
>> >> Dec 14 21:55:55 n22 212611283 77
>> >>
>> >> The 77 is totaly bogus and it's likely not just a truncation of the
>> >> 64bit value because (scd->clock > max_clock) evaluates to true. This
>> >> output is _AFTER_ timekeeping resume because the HPET force enable
>> >> message comes from timekeeping resume.
>> >
>> > Seems I'm talking to myself, but I think I finally decoded the
>> > mystery:
>> >
>> > resume()
>> >  cpufreq_resume()
>> >    tsc:time_cpufreq_notifier()
>> >      set_cyc2ns_scale()
>> >        sched_clock_idle_sleep_event()
>> >          sched_clock_tick()
>> >            ktime_get()
>> >              hpet_read()
>> >
>> > This happens _BEFORE_ timekeeping has resumed, so hpet_read() returns
>> > nonsense and the timekeeping code uses the stale pre suspend
>> > xtime/clocksource reference values to calculate the time. So the gtod
>> > reference in sched_clock can result in total crap depending on the
>> > time when the suspend happened.
>> >
>> > Shaggys patch clamps sched_clock to the stale scd->clock value which
>> > might explain the further wreckage.
>> >
>> > The above sequence happens only for CPUs with a CPU frequency coupled
>> > TSC, so on newer machines with CPU frequency invariant TSC this does
>> > not happen.
>> >
>> > /me stomps off to find a box to confirm that.
>> >
>>
>> Ok, just for reference here is my
>>
>> fcomolli@hawking:~> cat /proc/cpuinfo
>> processor     : 0
>> vendor_id     : GenuineIntel
>> cpu family    : 6
>> model         : 13
>> model name    : Intel(R) Pentium(R) M processor 1.73GHz
>> stepping      : 8
>> cpu MHz               : 800.000
>> cache size    : 2048 KB
>> fdiv_bug      : no
>> hlt_bug               : no
>> f00f_bug      : no
>> coma_bug      : no
>> fpu           : yes
>> fpu_exception : yes
>> cpuid level   : 2
>> wp            : yes
>> flags         : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
>> pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx up bts est tm2
>> bogomips      : 1596.95
>> clflush size  : 64
>> power management:
>
> Can please you revert the last patch and apply the following ? Does
> the WARN_ON trigger ?
>
> Thanks,
>
>        tglx
> ---
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index fa05e88..0d1526d 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -46,6 +46,9 @@ struct timespec xtime __attribute__ ((aligned (16)));
>  struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
>  static unsigned long total_sleep_time;         /* seconds */
>
> +/* flag for if timekeeping is suspended */
> +static int timekeeping_suspended;
> +
>  static struct timespec xtime_cache __attribute__ ((aligned (16)));
>  void update_xtime_cache(u64 nsec)
>  {
> @@ -92,6 +95,8 @@ void getnstimeofday(struct timespec *ts)
>        unsigned long seq;
>        s64 nsecs;
>
> +       WARN_ON(timekeeping_suspended);
> +
>        do {
>                seq = read_seqbegin(&xtime_lock);
>
> @@ -299,8 +304,6 @@ void __init timekeeping_init(void)
>        write_sequnlock_irqrestore(&xtime_lock, flags);
>  }
>
> -/* flag for if timekeeping is suspended */
> -static int timekeeping_suspended;
>  /* time in seconds when suspend began */
>  static unsigned long timekeeping_suspend_time;
>
>

Yes, it does:

[  159.487588] Syncing filesystems ... done.
[  159.488523] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  159.489763] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[  159.491144] PM: Shrinking memory... done (0 pages freed)
[  159.556730] PM: Freed 0 kbytes in 0.06 seconds (0.00 MB/s)
[  159.556752] Suspending console(s) (use no_console_suspend to debug)
[  159.557328] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  159.621764] pciehp 0000:00:1c.0:pcie02: pciehp_suspend ENTRY
[  159.621989] ACPI handle has no context!
[  159.621999] tifm_7xx1 0000:06:06.3: PCI INT A disabled
[  159.622008] ACPI handle has no context!
[  159.636240] ACPI handle has no context!
[  159.652272] eth1: Going into suspend...
[  159.655644] ipw2200 0000:06:05.0: PCI INT A disabled
[  159.655652] ACPI handle has no context!
[  159.668043] [fglrx] Power down the ASIC .
[  159.764052] fglrx_pci 0000:01:00.0: PCI INT A disabled
[  159.764175] ata2: port disabled. ignoring.
[  159.764232] ata_piix 0000:00:1f.1: PCI INT A disabled
[  159.764507] Intel ICH 0000:00:1e.2: PCI INT A disabled
[  159.764646] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  159.764686] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  159.764725] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  159.764764] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  159.764803] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  159.764808] pciehp 0000:00:1c.0:pcie02: pciehp_suspend ENTRY
[  159.765572] ACPI: Preparing to enter system sleep state S4
[  159.766924] Disabling non-boot CPUs ...
[  159.767100] PM: Creating hibernation image:
[  159.768005] PM: Need to copy 178481 pages
[  159.768005] Intel machine check architecture supported.
[  159.768005] Intel machine check reporting enabled on CPU#0.
[  159.768005] ------------[ cut here ]------------
[  159.768005] WARNING: at kernel/time/timekeeping.c:98
getnstimeofday+0x21/0xcd()
[  159.768005] Modules linked in: cisco_ipsec(P) fglrx(P)
[  159.768005] Pid: 5883, comm: s2disk Tainted: P
2.6.28-rc9-00050-gf8fd8a7 #9
[  159.768005] Call Trace:
[  159.768005]  [<c0122ef8>] warn_on_slowpath+0x40/0x61
[  159.768005]  [<c024ddec>] acpi_ex_insert_into_field+0x2cf/0x2ef
[  159.768005]  [<c0154c53>] __rmqueue_smallest+0xbe/0x133
[  159.768005]  [<c01389a2>] getnstimeofday+0x21/0xcd
[  159.768005]  [<c0135e26>] ktime_get_ts+0x1d/0x3f
[  159.768005]  [<c0135e57>] ktime_get+0xf/0x2b
[  159.768005]  [<c013736b>] sched_clock_tick+0x46/0x83
[  159.768005]  [<c01373ad>] sched_clock_idle_wakeup_event+0x5/0xa
[  159.768005]  [<c0108670>] set_cyc2ns_scale+0x3f/0x5e
[  159.768005]  [<c01088af>] time_cpufreq_notifier+0xf9/0x103
[  159.768005]  [<c0136782>] notifier_call_chain+0x2a/0x52
[  159.768005]  [<c0136866>] __srcu_notifier_call_chain+0x35/0x4a
[  159.768005]  [<c0136884>] srcu_notifier_call_chain+0x9/0xc
[  159.768005]  [<c031cbca>] cpufreq_resume+0xf3/0x112
[  159.768005]  [<c028c3f3>] __sysdev_resume+0x24/0x34
[  159.768005]  [<c028c421>] sysdev_resume+0x1e/0x50
[  159.768005]  [<c0290637>] device_power_up+0x8/0x10
[  159.768005]  [<c0149478>] create_image+0x8f/0x9f
[  159.768005]  [<c01494ed>] hibernation_snapshot+0x65/0xce
[  159.768005]  [<c014bddc>] snapshot_ioctl+0x208/0x47d
[  159.768005]  [<c014bbd4>] snapshot_ioctl+0x0/0x47d
[  159.768005]  [<c017a279>] vfs_ioctl+0x1c/0x5f
[  159.768005]  [<c017a785>] do_vfs_ioctl+0x167/0x172
[  159.768005]  [<c017a7bc>] sys_ioctl+0x2c/0x42
[  159.768005]  [<c01038cd>] sysenter_do_call+0x12/0x35
[  159.768005] ---[ end trace 828aa214905e8df0 ]---
[  313.187879] Force enabled HPET at resume
[  159.771124] ACPI: Waking up from system sleep state S4
[  159.792183] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[  159.855414] pcieport-driver 0000:00:01.0: setting latency timer to 64
[  159.855497] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[  159.855502] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
[  160.856182] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  160.856190] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  160.856237] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  160.856244] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  160.856291] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  160.856297] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  160.856343] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  160.856350] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  160.856396] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  160.856404] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  160.856521] pci 0000:00:1e.0: setting latency timer to 64
[  160.856569] Intel ICH 0000:00:1e.2: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[  160.856576] Intel ICH 0000:00:1e.2: setting latency timer to 64
[  161.870198] ata_piix 0000:00:1f.1: restoring config space at offset
0x1 (was 0x2880001, writing 0x2880005)
[  161.870211] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  161.870216] ata_piix 0000:00:1f.1: setting latency timer to 64
[  161.870669] fglrx_pci 0000:01:00.0: power state changed by ACPI to D0
[  161.870679] fglrx_pci 0000:01:00.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[  161.870684] fglrx_pci 0000:01:00.0: setting latency timer to 64
[  161.883293] ata2: port disabled. ignoring.
[  161.884515] [fglrx] Power up the ASIC
[  161.884554] eth1: Coming out of suspend...
[  161.900173] ipw2200 0000:06:05.0: enabling device (0000 -> 0002)
[  161.900181] ipw2200 0000:06:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  161.900196] ipw2200 0000:06:05.0: restoring config space at offset
0xf (was 0x18030100, writing 0x1803010b)
[  161.900226] ipw2200 0000:06:05.0: restoring config space at offset
0x4 (was 0x0, writing 0xc8206000)
[  161.900234] ipw2200 0000:06:05.0: restoring config space at offset
0x3 (was 0x0, writing 0x8008)
[  161.900243] ipw2200 0000:06:05.0: restoring config space at offset
0x1 (was 0x2900002, writing 0x2900116)
[  162.072723] ata1.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[  162.072726] ata1.01: ACPI cmd ef/03:22:00:00:00:b0 filtered out
[  162.080461] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  162.080463] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[  162.096951] ata1.00: configured for UDMA/100
[  162.128666] ata1.01: configured for MWDMA2
[  162.129488] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors:
(80.0 GB/74.5 GiB)
[  162.129519] sd 0:0:0:0: [sda] Write Protect is off
[  162.129521] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  162.129569] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  162.129621] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors:
(80.0 GB/74.5 GiB)
[  162.129648] sd 0:0:0:0: [sda] Write Protect is off
[  162.129650] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  162.129696] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  162.168175] firewire_ohci 0000:06:06.2: restoring config space at
offset 0xf (was 0x4020300, writing 0x402030b)
[  162.168203] firewire_ohci 0000:06:06.2: restoring config space at
offset 0x5 (was 0x0, writing 0xc8200000)
[  162.168211] firewire_ohci 0000:06:06.2: restoring config space at
offset 0x4 (was 0x0, writing 0xc8208000)
[  162.168218] firewire_ohci 0000:06:06.2: restoring config space at
offset 0x3 (was 0x800000, writing 0x808008)
[  162.168228] firewire_ohci 0000:06:06.2: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100116)
[  162.256038] tifm_7xx1 0000:06:06.3: restoring config space at
offset 0xf (was 0x40701ff, writing 0x407010a)
[  162.256067] tifm_7xx1 0000:06:06.3: restoring config space at
offset 0x4 (was 0x0, writing 0xc8204000)
[  162.256075] tifm_7xx1 0000:06:06.3: restoring config space at
offset 0x3 (was 0x800000, writing 0x808008)
[  162.256085] tifm_7xx1 0000:06:06.3: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100106)
[  162.256107] tifm_7xx1 0000:06:06.3: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[  162.256283] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
[  163.260341] sd 0:0:0:0: [sda] Starting disk
[  163.800031] usb 3-1: reset full speed USB device using uhci_hcd and address 2
[  164.014985] Restarting tasks ... done.
