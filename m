Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbZAMOFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbZAMOFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZAMOEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:04:50 -0500
Received: from styx.suse.cz ([82.119.242.94]:43076 "EHLO dhcp35"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756065AbZAMOEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:04:44 -0500
Date: Tue, 13 Jan 2009 15:04:41 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Message-ID: <20090113140441.GA5638@dhcp35.suse.cz>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <200901120903.20371.rjw@sisk.pl> <c4e36d110901120414q22d76501r10d643efeea8c65c@mail.gmail.com> <200901121340.21009.rjw@sisk.pl> <c4e36d110901120450q10278979j5cf726a5175cc3f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <c4e36d110901120450q10278979j5cf726a5175cc3f1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I don't have Lenovo T61 but I seem to experience similar resume problem
with Fujitsu Siemens E series notebook except for auto-resume issue
which I have never experienced.

On Mon 12-01-09 13:50:12, Zdenek Kabelac wrote:
> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday 12 January 2009, Zdenek Kabelac wrote:
> >> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > On Sunday 11 January 2009, Zdenek Kabelac wrote:
> >> >> 2009/1/11 Maciej Rutecki <maciej.rutecki@gmail.com>:
> >> >> > 2009/1/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> >> >> >> Hi
> >> >> >>
> >> >> >> I've booted and tested 2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)
> >> >> >>
> >> >> >> I've observed that suspend is unusable - it goes to sleep - the sleep
> >> >> >> LED is on. After few secs system turns on back itself - and stays in
> >> >> >> some frozen state
> >> >> >
> >> >> > A have similar situation, one difference: I get blank screen during
> >> >> > resume from suspend to ram. Also sometimes, like You, system turns on
> >> >> > back itself.
> >> >> >
> >> >>
> >> >> So it looks like reverting this commit:
> >> >>
> >> >> http://marc.info/?l=linux-kernel&m=123140019117968&w=4
> >> >> (6fd9086a518d4f14213a32fe6c9ac17fabebbc1e)
> >> >> (which is already a tracked regression)
> >> >> fixes the problem with auto-resume
> >> >>
> >> >> But the problem with deadlock in the resume phase is still there.
> >> >
> >> > Please check if unloading all of the USB controller modules before suspend
> >> > helps.
> >>
> >> I've booted to single mode without   usbcore module (thus any load of
> >> other usb modules fails)
> >> (removed from initramdisk as well)
> >>
> >> This time the resume stops with these 3 lines (I'm using
> >> no_console_suspend kernel option):
> >>
> >> ....
> >> thinkpad_acpi  thinkpad_acpi: EARLY resume
> >> thinkpad_hwmon  thinkpad_hwmon: EARLY resume
> >> Enabling non-boot CPUs...
> >
> > So it seems we have broken CPU hotplug again.
> >
> > Does disabling/enabling CPU1 using
> > /sys/devices/system/cpu/cpu1/online work?
> >
> > If it does, please boot with 'no_console_suspend' in the kernel command line,
> > run:
> >
> > # echo core > /sys/power/pm_test
> > # echo 8 > /proc/sys/kernel/printk
> > # echo mem > /sys/power/state
> >
> > and see what happens (you need to have PM_DEBUG set in the kernel .config).
> >
> > Please send dmesg output generated right after the above (if it works).
> 
> 
> I've taken from another Ingo's thread the idea to revert patch:
> 
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> 
> 
> With this patch reverted and  o/e/uhci_hcd & usbhid modules removed
> before pm-suspend
> (usbcore could be loaded, I've not trace which one of those usb
> modules makes the problem)
> my system resumes properl again.

This patch reverted helped to get my machine back up (if I suspend from X)
from s2r but screen is blank until I try to get to text console and
back. 

I have tried to run the test suggested by Rafael, but I am not able to
resume (see attached suspend&resume log with Sysrq+T at the end).  
I can see the following BUG during resume:
[...]
platform dock.1: LATE suspend
platform dock.0: LATE suspend
suspend debug: Waiting for 5 seconds.
BUG: using smp_processor_id() in preemptible [00000000] code: sh/2497
caller is retrigger_next_event+0x12/0xa5
Pid: 2497, comm: sh Tainted: G        W  2.6.29-rc1-resume-fix #8
Call Trace:
 [<c0401662>] ? printk+0xf/0x11
 [<c023148a>] debug_smp_processor_id+0xa2/0xb8
 [<c0137f10>] retrigger_next_event+0x12/0xa5
 [<c0403d79>] ? _spin_unlock+0xf/0x23
 [<c0138059>] hres_timers_resume+0xa/0xc
 [<c013b7ee>] timekeeping_resume+0xf9/0xff
 [<c028d600>] __sysdev_resume+0x14/0x38
 [<c028d645>] sysdev_resume+0x21/0x54
 [<c0291e90>] device_power_up+0xb/0x15
 [<c0146fd2>] suspend_devices_and_enter+0xf7/0x159
 [<c0147189>] enter_state+0x130/0x190
 [<c0147278>] state_store+0x8f/0xa2
 [<c01471e9>] ? state_store+0x0/0xa2
 [<c0229505>] kobj_attr_store+0x1a/0x22
 [<c01b4e07>] sysfs_write_file+0xb4/0xdf
 [<c01b4d53>] ? sysfs_write_file+0x0/0xdf
 [<c017de95>] vfs_write+0x8a/0x12e
 [<c017dfd2>] sys_write+0x3b/0x60
 [<c0102f71>] sysenter_do_call+0x12/0x25
[...]

I am not able to resume from the text console (e.g. with init=/bin/sh
results in the blanks screen) but when I resume from X and try to change
to a text console I cannot see anything (X seems to work correctly).

> 
> Zdenek
> 
> PS: I'll do the above 'echo' trace later (being busy right now).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="resume-fix-debug.log"

PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
platform dock.0: preparing suspend
platform dock.1: preparing suspend
agpgart-intel 0000:00:00.0: preparing suspend
pci 0000:00:02.0: preparing suspend
pci 0000:00:02.1: preparing suspend
pci 0000:00:1b.0: preparing suspend
pci 0000:00:1c.0: preparing suspend
pci 0000:00:1c.1: preparing suspend
pci 0000:00:1c.2: preparing suspend
uhci_hcd 0000:00:1d.0: preparing suspend, may wakeup
uhci_hcd 0000:00:1d.1: preparing suspend, may wakeup
uhci_hcd 0000:00:1d.2: preparing suspend, may wakeup
uhci_hcd 0000:00:1d.3: preparing suspend, may wakeup
ehci_hcd 0000:00:1d.7: preparing suspend, may wakeup
pci 0000:00:1e.0: preparing suspend
pci 0000:00:1f.0: preparing suspend
PIIX_IDE 0000:00:1f.1: preparing suspend
ahci 0000:00:1f.2: preparing suspend
pci 0000:00:1f.3: preparing suspend
sky2 0000:02:00.0: preparing suspend
pci 0000:05:00.0: preparing suspend
pci 0000:08:03.0: preparing suspend
ohci1394 0000:08:03.4: preparing suspend
platform pcspkr: preparing suspend
platform microcode: preparing suspend
serial8250 serial8250: preparing suspend
usb usb1: preparing type suspend, may wakeup
usb usb2: preparing type suspend, may wakeup
usb usb3: preparing type suspend, may wakeup
usb usb4: preparing type suspend, may wakeup
usb usb5: preparing type suspend, may wakeup
i8042 i8042: preparing suspend
usb 3-1: preparing type suspend, may wakeup
usb 5-2: preparing type suspend
psmouse serio5: legacy suspend
usb 5-2: type suspend
usb 3-1: type suspend, may wakeup
psmouse serio4: legacy suspend
serio serio3: legacy suspend
serio serio2: legacy suspend
serio serio1: legacy suspend
atkbd serio0: legacy suspend
i8042 i8042: suspend
usb usb5: type suspend, may wakeup
usb usb4: type suspend, may wakeup
usb usb3: type suspend, may wakeup
usb usb2: type suspend, may wakeup
usb usb1: type suspend, may wakeup
sd 0:0:0:0: legacy suspend
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ide-cdrom 0.0: legacy suspend
serial8250 serial8250: suspend
platform microcode: suspend
platform pcspkr: suspend
pnp 00:0c: legacy suspend
pnp 00:0b: legacy suspend
serial 00:0a: legacy suspend
serial 00:0a: disabled
system 00:09: legacy suspend
i8042 aux 00:08: legacy suspend
i8042 kbd 00:07: legacy suspend
pnp 00:06: legacy suspend
pnp 00:05: legacy suspend
pnp 00:04: legacy suspend
pnp 00:03: legacy suspend
system 00:02: legacy suspend
ACPI handle has no context!
pnp 00:01: legacy suspend
system 00:00: legacy suspend
ohci1394 0000:08:03.4: suspend
ACPI handle has no context!
pci 0000:08:03.0: suspend
pci 0000:08:03.0: PCI INT A disabled
pci 0000:05:00.0: suspend
sky2 0000:02:00.0: suspend
sky2 0000:02:00.0: PME# disabled
pci 0000:00:1f.3: suspend
ahci 0000:00:1f.2: suspend
PIIX_IDE 0000:00:1f.1: suspend
PIIX_IDE 0000:00:1f.1: PCI INT A disabled
pci 0000:00:1f.0: suspend
pci 0000:00:1e.0: suspend
ehci_hcd 0000:00:1d.7: suspend, may wakeup
ehci_hcd 0000:00:1d.7: PME# enabled
ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
ehci_hcd 0000:00:1d.7: PCI INT A disabled
uhci_hcd 0000:00:1d.3: suspend, may wakeup
uhci_hcd 0000:00:1d.3: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1d.3: PCI INT D disabled
uhci_hcd 0000:00:1d.2: suspend, may wakeup
uhci_hcd 0000:00:1d.2: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: suspend, may wakeup
uhci_hcd 0000:00:1d.1: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: suspend, may wakeup
uhci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pci 0000:00:1c.2: suspend
pci 0000:00:1c.2: PCI INT C disabled
pci 0000:00:1c.1: suspend
pci 0000:00:1c.1: PCI INT B disabled
pci 0000:00:1c.0: suspend
pci 0000:00:1c.0: PCI INT A disabled
pci 0000:00:1b.0: suspend
pci 0000:00:1b.0: power state changed by ACPI to D3
pci 0000:00:02.1: suspend
pci 0000:00:02.0: suspend
agpgart-intel 0000:00:00.0: suspend
platform dock.1: suspend
platform dock.0: suspend
thermal LNXTHERM:02: legacy suspend
thermal LNXTHERM:01: legacy suspend
acpi LNXTHERM:00: legacy suspend
button PNP0C0E:00: legacy suspend
battery PNP0C0A:01: legacy suspend
battery PNP0C0A:00: legacy suspend
ac ACPI0003:00: legacy suspend
button PNP0C0C:00: legacy suspend
button PNP0C0D:00: legacy suspend
acpi FUJ02E3:00: legacy suspend
acpi device:30: legacy suspend
acpi device:2f: legacy suspend
acpi device:2e: legacy suspend
acpi device:2d: legacy suspend
acpi device:2c: legacy suspend
acpi device:2b: legacy suspend
acpi device:2a: legacy suspend
acpi device:29: legacy suspend
acpi device:28: legacy suspend
acpi device:27: legacy suspend
acpi device:26: legacy suspend
acpi device:25: legacy suspend
acpi device:24: legacy suspend
acpi device:23: legacy suspend
acpi device:22: legacy suspend
acpi device:21: legacy suspend
acpi device:20: legacy suspend
acpi device:1f: legacy suspend
acpi device:1e: legacy suspend
acpi device:1d: legacy suspend
acpi device:1c: legacy suspend
acpi device:1b: legacy suspend
acpi device:1a: legacy suspend
acpi device:19: legacy suspend
acpi device:18: legacy suspend
acpi device:17: legacy suspend
acpi device:16: legacy suspend
acpi device:15: legacy suspend
acpi device:14: legacy suspend
acpi device:13: legacy suspend
acpi device:12: legacy suspend
acpi device:11: legacy suspend
acpi device:10: legacy suspend
acpi device:0f: legacy suspend
acpi device:0e: legacy suspend
acpi device:0d: legacy suspend
acpi device:0c: legacy suspend
acpi device:0b: legacy suspend
acpi device:0a: legacy suspend
acpi device:09: legacy suspend
acpi device:08: legacy suspend
pci_link PNP0C0F:07: legacy suspend
pci_link PNP0C0F:06: legacy suspend
pci_link PNP0C0F:05: legacy suspend
pci_link PNP0C0F:04: legacy suspend
pci_link PNP0C0F:03: legacy suspend
pci_link PNP0C0F:02: legacy suspend
pci_link PNP0C0F:01: legacy suspend
pci_link PNP0C0F:00: legacy suspend
acpi PNP0400:00: legacy suspend
acpi SMCF010:00: legacy suspend
acpi PNP0501:00: legacy suspend
acpi PNP0103:00: legacy suspend
acpi PNP0F13:00: legacy suspend
acpi PNP0303:00: legacy suspend
acpi PNP0C04:00: legacy suspend
acpi PNP0800:00: legacy suspend
acpi PNP0B00:00: legacy suspend
acpi PNP0000:00: legacy suspend
acpi PNP0100:00: legacy suspend
acpi PNP0200:00: legacy suspend
ec PNP0C09:00: legacy suspend
acpi FUJ02B1:00: legacy suspend
acpi device:07: legacy suspend
acpi device:06: legacy suspend
acpi device:05: legacy suspend
acpi device:04: legacy suspend
acpi device:03: legacy suspend
acpi device:02: legacy suspend
acpi device:01: legacy suspend
acpi PNP0C02:01: legacy suspend
pci_root PNP0A08:00: legacy suspend
acpi PNP0C02:00: legacy suspend
acpi device:00: legacy suspend
processor ACPI_CPU:01: legacy suspend
processor ACPI_CPU:00: legacy suspend
button LNXPWRBN:00: legacy suspend
acpi LNXSYSTM:00: legacy suspend
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
i8042 i8042: LATE suspend
serial8250 serial8250: LATE suspend
platform microcode: LATE suspend
platform pcspkr: LATE suspend
ohci1394 0000:08:03.4: LATE suspend
pci 0000:08:03.0: LATE suspend
pci 0000:05:00.0: LATE suspend
sky2 0000:02:00.0: LATE suspend
pci 0000:00:1f.3: LATE suspend
ahci 0000:00:1f.2: LATE suspend
PIIX_IDE 0000:00:1f.1: LATE suspend
pci 0000:00:1f.0: LATE suspend
pci 0000:00:1e.0: LATE suspend
ehci_hcd 0000:00:1d.7: LATE suspend, may wakeup
uhci_hcd 0000:00:1d.3: LATE suspend, may wakeup
uhci_hcd 0000:00:1d.2: LATE suspend, may wakeup
uhci_hcd 0000:00:1d.1: LATE suspend, may wakeup
uhci_hcd 0000:00:1d.0: LATE suspend, may wakeup
pci 0000:00:1c.2: LATE suspend
pci 0000:00:1c.1: LATE suspend
pci 0000:00:1c.0: LATE suspend
pci 0000:00:1b.0: LATE suspend
pci 0000:00:02.1: LATE suspend
pci 0000:00:02.0: LATE suspend
agpgart-intel 0000:00:00.0: LATE suspend
platform dock.1: LATE suspend
platform dock.0: LATE suspend
suspend debug: Waiting for 5 seconds.
BUG: using smp_processor_id() in preemptible [00000000] code: sh/2497
caller is retrigger_next_event+0x12/0xa5
Pid: 2497, comm: sh Tainted: G        W  2.6.29-rc1-resume-fix #8
Call Trace:
 [<c0401662>] ? printk+0xf/0x11
 [<c023148a>] debug_smp_processor_id+0xa2/0xb8
 [<c0137f10>] retrigger_next_event+0x12/0xa5
 [<c0403d79>] ? _spin_unlock+0xf/0x23
 [<c0138059>] hres_timers_resume+0xa/0xc
 [<c013b7ee>] timekeeping_resume+0xf9/0xff
 [<c028d600>] __sysdev_resume+0x14/0x38
 [<c028d645>] sysdev_resume+0x21/0x54
 [<c0291e90>] device_power_up+0xb/0x15
 [<c0146fd2>] suspend_devices_and_enter+0xf7/0x159
 [<c0147189>] enter_state+0x130/0x190
 [<c0147278>] state_store+0x8f/0xa2
 [<c01471e9>] ? state_store+0x0/0xa2
 [<c0229505>] kobj_attr_store+0x1a/0x22
 [<c01b4e07>] sysfs_write_file+0xb4/0xdf
 [<c01b4d53>] ? sysfs_write_file+0x0/0xdf
 [<c017de95>] vfs_write+0x8a/0x12e
 [<c017dfd2>] sys_write+0x3b/0x60
 [<c0102f71>] sysenter_do_call+0x12/0x25
BUG: using smp_processor_id() in preemptible [00000000] code: sh/2497
caller is retrigger_next_event+0x56/0xa5
Pid: 2497, comm: sh Tainted: G        W  2.6.29-rc1-resume-fix #8
Call Trace:
 [<c0401662>] ? printk+0xf/0x11
 [<c023148a>] debug_smp_processor_id+0xa2/0xb8
 [<c0137f54>] retrigger_next_event+0x56/0xa5
 [<c0138059>] hres_timers_resume+0xa/0xc
 [<c013b7ee>] timekeeping_resume+0xf9/0xff
 [<c028d600>] __sysdev_resume+0x14/0x38
 [<c028d645>] sysdev_resume+0x21/0x54
 [<c0291e90>] device_power_up+0xb/0x15
 [<c0146fd2>] suspend_devices_and_enter+0xf7/0x159
 [<c0147189>] enter_state+0x130/0x190
 [<c0147278>] state_store+0x8f/0xa2
 [<c01471e9>] ? state_store+0x0/0xa2
 [<c0229505>] kobj_attr_store+0x1a/0x22
 [<c01b4e07>] sysfs_write_file+0xb4/0xdf
 [<c01b4d53>] ? sysfs_write_file+0x0/0xdf
 [<c017de95>] vfs_write+0x8a/0x12e
 [<c017dfd2>] sys_write+0x3b/0x60
 [<c0102f71>] sysenter_do_call+0x12/0x25
platform dock.0: EARLY resume
platform dock.1: EARLY resume
agpgart-intel 0000:00:00.0: EARLY resume
pci 0000:00:02.0: EARLY resume
pci 0000:00:02.1: EARLY resume
pci 0000:00:1b.0: EARLY resume
pci 0000:00:1c.0: EARLY resume
pci 0000:00:1c.1: EARLY resume
pci 0000:00:1c.2: EARLY resume
uhci_hcd 0000:00:1d.0: EARLY resume
uhci_hcd 0000:00:1d.1: EARLY resume
uhci_hcd 0000:00:1d.2: EARLY resume
uhci_hcd 0000:00:1d.3: EARLY resume
ehci_hcd 0000:00:1d.7: EARLY resume
ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10b)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xf0644000)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1f.0: EARLY resume
PIIX_IDE 0000:00:1f.1: EARLY resume
ahci 0000:00:1f.2: EARLY resume
pci 0000:00:1f.3: EARLY resume
sky2 0000:02:00.0: EARLY resume
pci 0000:05:00.0: EARLY resume
pci 0000:05:00.0: restoring config space at offset 0x1 (was 0x100400, writing 0x100006)
pci 0000:08:03.0: EARLY resume
ohci1394 0000:08:03.4: EARLY resume
platform pcspkr: EARLY resume
platform microcode: EARLY resume
serial8250 serial8250: EARLY resume
i8042 i8042: EARLY resume
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
CPU 1 irqstacks, hard=c063d000 soft=c061d000
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.61 BogoMIPS (lpj=7315230)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 02
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
ACPI: Waking up from system sleep state S3
acpi LNXSYSTM:00: legacy resume
button LNXPWRBN:00: legacy resume
processor ACPI_CPU:00: legacy resume
processor ACPI_CPU:01: legacy resume
acpi device:00: legacy resume
acpi PNP0C02:00: legacy resume
pci_root PNP0A08:00: legacy resume
acpi PNP0C02:01: legacy resume
acpi device:01: legacy resume
acpi device:02: legacy resume
acpi device:03: legacy resume
acpi device:04: legacy resume
acpi device:05: legacy resume
acpi device:06: legacy resume
acpi device:07: legacy resume
acpi FUJ02B1:00: legacy resume
ec PNP0C09:00: legacy resume
acpi PNP0200:00: legacy resume
acpi PNP0100:00: legacy resume
acpi PNP0000:00: legacy resume
acpi PNP0B00:00: legacy resume
acpi PNP0800:00: legacy resume
acpi PNP0C04:00: legacy resume
acpi PNP0303:00: legacy resume
acpi PNP0F13:00: legacy resume
acpi PNP0103:00: legacy resume
acpi PNP0501:00: legacy resume
acpi SMCF010:00: legacy resume
acpi PNP0400:00: legacy resume
pci_link PNP0C0F:00: legacy resume
pci_link PNP0C0F:01: legacy resume
pci_link PNP0C0F:02: legacy resume
pci_link PNP0C0F:03: legacy resume
pci_link PNP0C0F:04: legacy resume
pci_link PNP0C0F:05: legacy resume
pci_link PNP0C0F:06: legacy resume
pci_link PNP0C0F:07: legacy resume
acpi device:08: legacy resume
acpi device:09: legacy resume
acpi device:0a: legacy resume
acpi device:0b: legacy resume
acpi device:0c: legacy resume
acpi device:0d: legacy resume
acpi device:0e: legacy resume
acpi device:0f: legacy resume
acpi device:10: legacy resume
acpi device:11: legacy resume
acpi device:12: legacy resume
acpi device:13: legacy resume
acpi device:14: legacy resume
acpi device:15: legacy resume
acpi device:16: legacy resume
acpi device:17: legacy resume
acpi device:18: legacy resume
acpi device:19: legacy resume
acpi device:1a: legacy resume
acpi device:1b: legacy resume
acpi device:1c: legacy resume
acpi device:1d: legacy resume
acpi device:1e: legacy resume
acpi device:1f: legacy resume
acpi device:20: legacy resume
acpi device:21: legacy resume
acpi device:22: legacy resume
acpi device:23: legacy resume
acpi device:24: legacy resume
acpi device:25: legacy resume
acpi device:26: legacy resume
acpi device:27: legacy resume
acpi device:28: legacy resume
acpi device:29: legacy resume
acpi device:2a: legacy resume
acpi device:2b: legacy resume
acpi device:2c: legacy resume
acpi device:2d: legacy resume
acpi device:2e: legacy resume
acpi device:2f: legacy resume
acpi device:30: legacy resume
acpi FUJ02E3:00: legacy resume
button PNP0C0D:00: legacy resume
button PNP0C0C:00: legacy resume
ac ACPI0003:00: legacy resume
battery PNP0C0A:00: legacy resume
battery PNP0C0A:01: legacy resume
button PNP0C0E:00: legacy resume
acpi LNXTHERM:00: legacy resume
thermal LNXTHERM:01: legacy resume
thermal LNXTHERM:02: legacy resume
platform dock.0: resume
platform dock.1: resume
agpgart-intel 0000:00:00.0: resume
pci 0000:00:02.0: resume
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: resume
pci 0000:00:02.1: PME# disabled
pci 0000:00:1b.0: resume
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: resume
pci 0000:00:1c.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: resume
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: resume
pci 0000:00:1c.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.2: setting latency timer to 64
uhci_hcd 0000:00:1d.0: resume
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
uhci_hcd 0000:00:1d.1: resume
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: wake-up capability disabled by ACPI
uhci_hcd 0000:00:1d.2: resume
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: wake-up capability disabled by ACPI
uhci_hcd 0000:00:1d.3: resume
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: wake-up capability disabled by ACPI
ehci_hcd 0000:00:1d.7: resume
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: resume
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:00:1f.0: resume
PIIX_IDE 0000:00:1f.1: resume
PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
PIIX_IDE 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800001, writing 0x2800005)
PIIX_IDE 0000:00:1f.1: setting latency timer to 64
ahci 0000:00:1f.2: resume
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
ahci 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: resume
sky2 0000:02:00.0: resume
sky2 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
sky2 0000:02:00.0: PME# disabled
pci 0000:05:00.0: resume
pci 0000:05:00.0: PME# disabled
pci 0000:08:03.0: resume
pci 0000:08:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci1394 0000:08:03.4: resume
ohci1394 0000:08:03.4: restoring config space at offset 0xf (was 0x100, writing 0x10b)
ohci1394 0000:08:03.4: restoring config space at offset 0x5 (was 0x0, writing 0xf0201000)
ohci1394 0000:08:03.4: restoring config space at offset 0x4 (was 0x0, writing 0xf0200000)
ohci1394 0000:08:03.4: restoring config space at offset 0x3 (was 0x0, writing 0x2010)
ohci1394 0000:08:03.4: restoring config space at offset 0x1 (was 0x2100080, writing 0x2180017)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[f0200000-f02007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
system 00:00: legacy resume
pnp 00:01: legacy resume
system 00:02: legacy resume
pnp 00:03: legacy resume
pnp 00:04: legacy resume
pnp 00:05: legacy resume
pnp 00:06: legacy resume
i8042 kbd 00:07: legacy resume
i8042 aux 00:08: legacy resume
system 00:09: legacy resume
serial 00:0a: legacy resume
serial 00:0a: activated
pnp 00:0b: legacy resume
pnp 00:0c: legacy resume
platform pcspkr: resume
platform microcode: resume
serial8250 serial8250: resume
ide-cdrom 0.0: legacy resume
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
sd 0:0:0:0: legacy resume
sd 0:0:0:0: [sda] Starting disk
ata3: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usb usb1: type resume
usb usb2: type resume
usb usb3: type resume
usb usb4: type resume
usb usb5: type resume
i8042 i8042: resume
atkbd serio0: legacy resume
serio serio1: legacy resume
serio serio2: legacy resume
serio serio3: legacy resume
psmouse serio4: legacy resume
usb 3-1: type resume
usb 5-2: type resume
usb 5-2: reset full speed USB device using uhci_hcd and address 2
psmouse serio5: legacy resume
usb 5-2: completing type resume
usb 3-1: completing type resume
i8042 i8042: completing resume
usb usb5: completing type resume
usb usb4: completing type resume
usb usb3: completing type resume
usb usb2: completing type resume
usb usb1: completing type resume
serial8250 serial8250: completing resume
platform microcode: completing resume
platform pcspkr: completing resume
ohci1394 0000:08:03.4: completing resume
pci 0000:08:03.0: completing resume
pci 0000:05:00.0: completing resume
sky2 0000:02:00.0: completing resume
pci 0000:00:1f.3: completing resume
ahci 0000:00:1f.2: completing resume
PIIX_IDE 0000:00:1f.1: completing resume
pci 0000:00:1f.0: completing resume
pci 0000:00:1e.0: completing resume
ehci_hcd 0000:00:1d.7: completing resume
uhci_hcd 0000:00:1d.3: completing resume
uhci_hcd 0000:00:1d.2: completing resume
uhci_hcd 0000:00:1d.1: completing resume
uhci_hcd 0000:00:1d.0: completing resume
pci 0000:00:1c.2: completing resume
pci 0000:00:1c.1: completing resume
pci 0000:00:1c.0: completing resume
pci 0000:00:1b.0: completing resume
pci 0000:00:02.1: completing resume
pci 0000:00:02.0: completing resume
agpgart-intel 0000:00:00.0: completing resume
platform dock.1: completing resume
platform dock.0: completing resume
PM: Finishing wakeup.
Restarting tasks ... done.
SysRq : Show State
  task                PC stack   pid father
sh            S 00000024     0     1      0
 f701fe98 00000086 4a0180ae 00000024 00000004 f701fe34 c0618100 c0617b80
 c0617b80 c0617b80 00000700 f7030000 f7030258 c57fbb80 00000000 4a02a240
 00000024 c027e769 ffffff00 00000001 f73fe800 f6436000 f7030258 00000064
Call Trace:
 [<c027e769>] ? do_con_write+0x195f/0x1988
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c04024fe>] schedule_timeout+0x17/0xbc
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c02718eb>] n_tty_read+0x36b/0x5a3
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c012140d>] ? default_wake_function+0x0/0xd
 [<c0271580>] ? n_tty_read+0x0/0x5a3
 [<c026df3e>] tty_read+0x62/0x99
 [<c026dedc>] ? tty_read+0x0/0x99
 [<c017e07e>] vfs_read+0x87/0x12b
 [<c017e1bb>] sys_read+0x3b/0x60
 [<c0102f71>] sysenter_do_call+0x12/0x25
kthreadd      S 00000017     0     2      0
 f7022fc0 00000046 f0135629 00000017 ec6fab9a 00000017 c0618100 c0617b80
 c0617b80 c0617b80 f6437500 f7030c10 f7030e68 c57fbb80 00000000 f0135aa4
 00000017 f65f8e28 00000001 f7022f80 c0121418 f6437500 f7030e68 f65f8e2c
Call Trace:
 [<c0121418>] ? default_wake_function+0xb/0xd
 [<c04019c8>] ? preempt_schedule+0x30/0x3f
 [<c0403d1c>] ? _spin_unlock_irqrestore+0x23/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c013556a>] kthreadd+0x6b/0x147
 [<c01354ff>] ? kthreadd+0x0/0x147
 [<c010378b>] kernel_thread_helper+0x7/0x10
migration/0   S 00000017     0     3      2
 f7023fa8 00000046 ff424668 00000017 00000000 c5805bd8 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f7031820 f7031a78 c57fbb80 00000000 c010fe4e
 f7023f68 00000002 f7036080 00000001 00000001 f6437500 f7031a78 ffff3fac
Call Trace:
 [<c010fe4e>] ? xapic_wait_icr_idle+0x14/0x1b
 [<c011c5f9>] ? double_rq_unlock+0x19/0x1d
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c0121d38>] migration_thread+0x17e/0x202
 [<c0121bba>] ? migration_thread+0x0/0x202
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
ksoftirqd/0   S 00000018     0     4      2
 f7038fbc 00000046 e029c3d3 00000018 c055933c f7038fd0 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f7032430 f7032688 c57fbb80 00000000 defeedab
 00000018 f7032688 c57fbb80 00000000 07641bd1 f6436000 f7032688 ffff433b
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0129bb8>] ksoftirqd+0x4a/0x139
 [<c0129b6e>] ? ksoftirqd+0x0/0x139
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
watchdog/0    S 00000000     0     5      2
 f7039fb0 00000046 07641bd1 00000000 c57fbb80 f7039f54 c0618100 c0617b80
 c0617b80 c0617b80 c57fbb80 f7033040 f7033298 c57fbb80 00000000 07641bd1
 00000000 00000000 07641bd1 00000000 569c2d28 c05591a0 f7033298 f7039f94
Call Trace:
 [<c01399dc>] ? sched_clock_cpu+0x145/0x152
 [<c014dcbc>] ? watchdog+0x0/0x1cb
 [<c014dcf6>] watchdog+0x3a/0x1cb
 [<c014dcbc>] ? watchdog+0x0/0x1cb
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
rcu_sched_gra S 00000017     0     9      2
 f7318f9c 00000046 ff92662c 00000017 f7318f30 c012d5e8 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f7036c90 f7036ee8 c57fbb80 00000000 f7318f50
 c012d663 ffff3fb0 f7318f94 c040258d 00000000 f6437500 f7036ee8 ffff3fac
Call Trace:
 [<c012d5e8>] ? lock_timer_base+0x1f/0x3e
 [<c012d663>] ? del_timer_sync+0xd/0x18
 [<c040258d>] ? schedule_timeout+0xa6/0xbc
 [<c040257f>] ? schedule_timeout+0x98/0xbc
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0150381>] rcu_sched_grace_period+0x21e/0x268
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c0150163>] ? rcu_sched_grace_period+0x0/0x268
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
events/0      R running      0    10      2
 f731afa8 00000046 14eafbe2 00000027 c06ad180 f731af40 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f7330000 f7330258 c57fbb80 00000000 f731af58
 c0403d0a f731af78 c0125dbb 00000246 fffea05c f6436000 f7330258 ffff7e2d
Call Trace:
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0125dbb>] ? release_console_sem+0x17b/0x1a8
 [<c027ce05>] ? console_callback+0xf3/0xf8
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
khelper       S 00000002     0    12      2
 f731cfa8 00000046 721d9bad 00000002 00000096 f701fcf4 c0618100 c0617b80
 c0617b80 c0617b80 f731cf60 f7331820 f7331a78 c57fbb80 00000000 721da36b
 00000002 f731cf60 c0403d0a f731cf7c c011a702 c05591a0 f7331a78 f640b980
Call Trace:
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kblockd/0     S 00000018     0   146      2
 f7387fa8 00000046 3443de49 00000018 f6b39c00 f7387f34 c0618100 c0617b80
 c0617b80 c0617b80 f7387f64 f7332430 f7332688 c57fbb80 00000000 3443eb3c
 00000018 f6b40548 f6b40548 f6b405f8 f6b40548 f6437500 f7332688 f7387f7c
Call Trace:
 [<c021ef5c>] ? generic_unplug_device+0x2c/0x2f
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kacpid        S 00000000     0   148      2
 f7389fa8 00000046 11682f0d 00000000 f7389f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f7333c50 f7333ea8 c5805b80 00000001 c040fbc0
 c0618100 c0617b80 c0617b80 c0617b80 c0617b80 c05591a0 f7333ea8 fffedb44
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kacpi_notify  S 00000000     0   149      2
 f738afa8 00000046 11682f0d 00000000 f738af3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f7334860 f7334ab8 c5805b80 00000001 c040fbc0
 c0618100 c0617b80 c0617b80 c0617b80 c0617b80 c05591a0 f7334ab8 fffedb44
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
ata/0         S 00000000     0   229      2
 f73c6fa8 00000046 3f180117 00000000 f73c6f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f7335470 f73356c8 c57fbb80 00000000 c040fbc0
 c0618100 c0617b80 c0617b80 c0617b80 c0617b80 c05591a0 f73356c8 fffedbf4
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
ata_aux       S 00000018     0   231      2
 f73c8fa8 00000046 351b3de9 00000018 c028c409 f73c8f38 c0618100 c0617b80
 c0617b80 c0617b80 c02ddcc4 f7336c90 f7336ee8 c57fbb80 00000000 3594e59c
 00000018 f73c8f60 c028c409 f73c8f70 f6b39c00 f6437500 f7336ee8 f73c8f8c
Call Trace:
 [<c028c409>] ? put_device+0xf/0x11
 [<c02ddcc4>] ? scsi_disk_put+0x2f/0x33
 [<c028c409>] ? put_device+0xf/0x11
 [<c02ec525>] ? ata_scsi_dev_rescan+0x9e/0xa5
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
ksuspend_usbd S 00000019     0   232      2
 f73c9fa8 00000046 90d4e406 00000019 f73c9f2c c0403ce5 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f73e8000 f73e8258 c5805b80 00000001 00000000
 00000001 00000000 00000402 f6b3a400 f731da80 f6437500 f73e8258 ffff4568
Call Trace:
 [<c0403ce5>] ? _spin_unlock_irq+0x10/0x24
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
khubd         S 00000018     0   238      2
 f73cbf20 00000046 ded824b3 00000018 f6bd5480 00000004 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f73e8c10 f73e8e68 c5805b80 00000001 f6aea600
 ffffffed f6b3b400 f73cbefc c031672e 00000400 f6437500 f73e8e68 ffff4359
Call Trace:
 [<c031672e>] ? usb_suspend_both+0x6d/0x23e
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c03122c3>] hub_thread+0xd52/0xdc7
 [<c0121418>] ? default_wake_function+0xb/0xd
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c011a702>] ? complete+0x34/0x3e
 [<c0311571>] ? hub_thread+0x0/0xdc7
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kseriod       S 0000001a     0   241      2
 f73ccfa0 00000046 0a579e27 0000001a f73ccf24 c0403ce5 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f73e9820 f73e9a78 c57fbb80 00000000 f73ccf60
 c033cc34 f6435600 f73ccf5c c0403ce5 f73ccf6c f6436000 f73e9a78 ffff4808
Call Trace:
 [<c0403ce5>] ? _spin_unlock_irq+0x10/0x24
 [<c033cc34>] ? psmouse_sliced_command+0x46/0x5d
 [<c0403ce5>] ? _spin_unlock_irq+0x10/0x24
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0335656>] serio_thread+0x27f/0x2e2
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c03353d7>] ? serio_thread+0x0/0x2e2
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
pdflush       S 00000018     0   303      2
 f682cfa4 00000046 ded7c2d4 00000018 c0617b80 c0617b80 c0618100 c0617b80
 c0617b80 c0617b80 00000000 f73ea430 f73ea688 c57fbb80 00000000 ded7c9dd
 00000018 f6437500 f73ea688 00000000 f682cf68 f6437500 f73ea688 c01219b1
Call Trace:
 [<c01219b1>] ? set_cpus_allowed_ptr+0xc6/0xd0
 [<c04019c8>] ? preempt_schedule+0x30/0x3f
 [<c01626b6>] pdflush+0xb9/0x1a6
 [<c01625fd>] ? pdflush+0x0/0x1a6
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
pdflush       S 00000026     0   304      2
 f735bfa4 00000046 d702d35d 00000026 c012d5e8 f735bf44 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f73eb040 f73eb298 c57fbb80 00000000 f735bf6c
 ffff82d2 f735bf64 c012d835 f735bf6c ffff82d2 f6436000 f73eb298 ffff7def
Call Trace:
 [<c012d5e8>] ? lock_timer_base+0x1f/0x3e
 [<c012d835>] ? mod_timer+0x55/0x59
 [<c01626b6>] pdflush+0xb9/0x1a6
 [<c01625fd>] ? pdflush+0x0/0x1a6
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kswapd0       S 00000018     0   305      2
 f682df30 00000046 ded7fd1b 00000018 c0617b80 c0617b80 c0618100 c0617b80
 c0617b80 c0617b80 00000001 f73ebc50 f73ebea8 c5805b80 00000001 ded8033a
 00000018 f6437500 f73ebea8 00000000 f682def4 f6437500 f73ebea8 fffedcfe
Call Trace:
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c01658e4>] ? kswapd+0x0/0x569
 [<c01659c5>] kswapd+0xe1/0x569
 [<c040234e>] ? schedule+0x977/0x9ab
 [<c0403ce5>] ? _spin_unlock_irq+0x10/0x24
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c01658e4>] ? kswapd+0x0/0x569
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
aio/0         S 00000000     0   354      2
 f6a36fa8 00000046 8295b2c3 00000000 f6a36f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 f6a36fd0 f73ec860 f73ecab8 c57fbb80 00000000 8295b913
 00000000 c0617b80 c0617b80 c0617b80 f6a36f84 c05591a0 f73ecab8 c57fbb80
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
nfsiod        S 00000000     0   365      2
 f6a40fa8 00000046 829e957e 00000000 f6a40f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f73ee080 f73ee2d8 c57fbb80 00000000 f6a40f64
 c0618100 c0617b80 c0617b80 c0617b80 f6a40f84 c05591a0 f73ee2d8 fffedcfe
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
scsi_eh_0     S 00000018     0  1072      2
 f6b33f94 00000046 3594e59c 00000018 f6b406a0 f6b38c00 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6a75470 f6a756c8 c57fbb80 00000000 f6b39c00
 f6b33f4c c022962a 00000000 f6b33f54 c028c409 f6437500 f6a756c8 ffff407e
Call Trace:
 [<c022962a>] ? kobject_put+0x37/0x3c
 [<c028c409>] ? put_device+0xf/0x11
 [<c02ade7a>] ? __scsi_iterate_devices+0x56/0x5f
 [<c02b27bc>] ? scsi_run_host_queues+0x1c/0x26
 [<c02b0ed0>] scsi_error_handler+0x40/0x280
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c02b0e90>] ? scsi_error_handler+0x0/0x280
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
scsi_eh_1     S 00000018     0  1074      2
 f6b35f94 00000046 1da87047 00000018 f6b35f20 c0403b5d c0618100 c0617b80
 c0617b80 c0617b80 f6b49e58 f6a70000 f6a70258 c57fbb80 00000000 1da8840d
 00000018 00000003 00000246 f6b35f54 c0403d0a f6437500 f6a70258 f6b35f64
Call Trace:
 [<c0403b5d>] ? _spin_lock_irqsave+0x14/0x2e
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c02ade6c>] ? __scsi_iterate_devices+0x48/0x5f
 [<c02b27bc>] ? scsi_run_host_queues+0x1c/0x26
 [<c02b0ed0>] scsi_error_handler+0x40/0x280
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c02b0e90>] ? scsi_error_handler+0x0/0x280
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
scsi_eh_2     S 00000018     0  1076      2
 f6b37f94 00000046 32066600 00000018 f6b37f20 c0403b5d c0618100 c0617b80
 c0617b80 c0617b80 f6b4de58 f6a70c10 f6a70e68 c57fbb80 00000000 32067720
 00000018 00000003 00000246 f6b37f54 c0403d0a f6437500 f6a70e68 f6b37f64
Call Trace:
 [<c0403b5d>] ? _spin_lock_irqsave+0x14/0x2e
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c02ade6c>] ? __scsi_iterate_devices+0x48/0x5f
 [<c02b27bc>] ? scsi_run_host_queues+0x1c/0x26
 [<c02b0ed0>] scsi_error_handler+0x40/0x280
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c02b0e90>] ? scsi_error_handler+0x0/0x280
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
scsi_eh_3     S 00000018     0  1078      2
 f6b56f94 00000046 1da92827 00000018 f6b56f20 c0403b5d c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6a76c90 f6a76ee8 c57fbb80 00000000 00000000
 00000000 00000003 00000246 f6b56f54 c0403d0a f6437500 f6a76ee8 ffff3fac
Call Trace:
 [<c0403b5d>] ? _spin_lock_irqsave+0x14/0x2e
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c02ade6c>] ? __scsi_iterate_devices+0x48/0x5f
 [<c02b27bc>] ? scsi_run_host_queues+0x1c/0x26
 [<c02b0ed0>] scsi_error_handler+0x40/0x280
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c02b0e90>] ? scsi_error_handler+0x0/0x280
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
khpsbpkt      S 00000018     0  1099      2
 f6baafb4 00000046 eef2ae92 00000018 c040fc70 f6baaf3c c0618100 c0617b80
 c0617b80 c0617b80 00000003 f6bba430 f6bba688 c57fbb80 00000000 eef2b3f1
 00000018 f6baaf6c c0121418 f6baaf90 c01197e4 f6436000 f6bba688 f6bd3e9c
Call Trace:
 [<c0121418>] ? default_wake_function+0xb/0xd
 [<c01197e4>] ? __wake_up_common+0x35/0x5b
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c011a702>] ? complete+0x34/0x3e
 [<c02fc320>] hpsbpkt_thread+0xc5/0xe7
 [<c02fc25b>] ? hpsbpkt_thread+0x0/0xe7
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
knodemgrd_0   S 00000019     0  1108      2
 f6bd3f6c 00000046 a555d7df 00000019 f6bd3f00 f6bd3f20 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6a73040 f6a73298 c57fbb80 00000000 ffff4699
 f6bd3f5c c040258d 00000000 00200200 f6bdc078 f6436000 f6a73298 ffff4663
Call Trace:
 [<c040258d>] ? schedule_timeout+0xa6/0xbc
 [<c03f2ec4>] ? klist_next+0x78/0x90
 [<c028c7c3>] ? device_for_each_child+0x3f/0x49
 [<c0301119>] nodemgr_host_thread+0x85/0x861
 [<c0121418>] ? default_wake_function+0xb/0xd
 [<c011a701>] ? complete+0x33/0x3e
 [<c0301094>] ? nodemgr_host_thread+0x0/0x861
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kpsmoused     S 00000002     0  1171      2
 f6410fa8 00000046 6a3c1ae4 00000002 f6410f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6bb8000 f6bb8258 c57fbb80 00000000 f6410f64
 c0618100 c0617b80 c0617b80 c0617b80 f6410f84 c05591a0 f6bb8258 fffee4fd
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kstriped      S 00000002     0  1174      2
 f640dfa8 00000046 6a3f0809 00000002 f640df3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6bb8c10 f6bb8e68 c5805b80 00000001 c040fbc0
 c0618100 c0617b80 c0617b80 c0617b80 c0617b80 c05591a0 f6bb8e68 fffee529
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kondemand/0   S 00000002     0  1177      2
 f6bf9fa8 00000046 6ae7a29f 00000002 f6bf9f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 f6bf9fd0 f6bb9820 f6bb9a78 c57fbb80 00000000 6ae7a996
 00000002 c0617b80 c0617b80 c0617b80 f6bf9f84 c05591a0 f6bb9a78 c57fbb80
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
rpciod/0      S 00000002     0  1237      2
 f6b30fa8 00000046 6e351eaa 00000002 f6b30f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6bbe080 f6bbe2d8 c57fbb80 00000000 c040fbc0
 c0618100 c0617b80 c0617b80 c0617b80 c0617b80 c05591a0 f6bbe2d8 fffee4fd
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kjournald     S 00000002     0  2471      2
 f663ff8c 00000046 ba8bd028 00000002 f663ff10 c04019c8 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6a2d470 f6a2d6c8 c5805b80 00000001 c01359a2
 00000000 f646cdcc f6538848 f663ff68 c01197e4 f6a69880 f6a2d6c8 fffee67a
Call Trace:
 [<c04019c8>] ? preempt_schedule+0x30/0x3f
 [<c01359a2>] ? autoremove_wake_function+0xf/0x33
 [<c01197e4>] ? __wake_up_common+0x35/0x5b
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c01ccb34>] kjournald+0x167/0x1d7
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c01cc9cd>] ? kjournald+0x0/0x1d7
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kjournald     S 00000016     0  2495      2
 f64cdf8c 00000046 dd0d26cc 00000016 f64cdf58 00000001 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6a2b040 f6a2b298 c5805b80 00000001 f64f0000
 00000000 00000000 00000000 00000000 f7020ed0 f6437340 f6a2b298 ffff3ae1
Call Trace:
 [<c012d5e8>] ? lock_timer_base+0x1f/0x3e
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c01ccb34>] kjournald+0x167/0x1d7
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c01cc9cd>] ? kjournald+0x0/0x1d7
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
migration/1   S 00000017     0  2500      2
 f6600fa8 00000046 fbb38587 00000017 f6600f3c c011f852 c0618100 c0617b80
 c0617b80 c0617b80 f6600fd0 f6a2bc50 f6a2bea8 c5805b80 00000001 fbb39598
 00000017 c0617b80 c0617b80 c0617b80 f6600f78 c05591a0 f6a2bea8 c5805b80
Call Trace:
 [<c011f852>] ? finish_task_switch+0x3d/0xa4
 [<c0403ce5>] ? _spin_unlock_irq+0x10/0x24
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0121bba>] ? migration_thread+0x0/0x202
 [<c0121d38>] migration_thread+0x17e/0x202
 [<c0121bba>] ? migration_thread+0x0/0x202
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
ksoftirqd/1   S 00000018     0  2501      2
 f731bfbc 00000046 0042b1d6 00000018 f6a2a430 f731bfd0 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6a29820 f6a29a78 c5805b80 00000001 0042b753
 00000018 f6a29a78 c5805b80 00000001 ec6e8e8e f6437500 f6a29a78 ffff3fac
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0129bb8>] ksoftirqd+0x4a/0x139
 [<c0129b6e>] ? ksoftirqd+0x0/0x139
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
watchdog/1    S 00000017     0  2502      2
 f7388fb0 00000046 fbb3aa72 00000017 c5805b80 f7388f54 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6a28000 f6a28258 c5805b80 00000001 c5806080
 fbb3c133 00000017 fbb3bfdd 00000017 a1a7baf1 c05591a0 f6a28258 ffff4099
Call Trace:
 [<c01399dc>] ? sched_clock_cpu+0x145/0x152
 [<c014dcbc>] ? watchdog+0x0/0x1cb
 [<c014dcf6>] watchdog+0x3a/0x1cb
 [<c014dcbc>] ? watchdog+0x0/0x1cb
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
rpciod/1      S 00000017     0  2503      2
 f73c7fa8 00000046 ff413ce7 00000017 f73c7f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 f73c7fd0 f6a2c860 f6a2cab8 c5805b80 00000001 ff414937
 00000017 c0617b80 c0617b80 c0617b80 f73c7f78 c05591a0 f6a2cab8 c5805b80
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kondemand/1   S 00000017     0  2504      2
 f6a34fa8 00000046 ff417df2 00000017 f6a34f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 f6a34fd0 f6a28c10 f6a28e68 c5805b80 00000001 ff4185e6
 00000017 c0617b80 c0617b80 c0617b80 f6a34f78 c05591a0 f6a28e68 c5805b80
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
aio/1         S 00000017     0  2505      2
 f6bfcfa8 00000046 ff4185e6 00000017 f6bfcf3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6a2e080 f6a2e2d8 c5805b80 00000001 c01237ca
 c0618100 c0617b80 c0617b80 c0617b80 f6bfcf78 c05591a0 f6a2e2d8 ffff3fac
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c01237ca>] ? __cleanup_signal+0x28/0x2b
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
ata/1         S 00000017     0  2506      2
 f6b31fa8 00000046 ff414937 00000017 f6b31f3c c011f83e c0618100 c0617b80
 c0617b80 c0617b80 f6b31fd0 f6a2ec90 f6a2eee8 c5805b80 00000001 ff415600
 00000017 c0617b80 c0617b80 c0617b80 f6b31f78 c05591a0 f6a2eee8 c5805b80
Call Trace:
 [<c011f83e>] ? finish_task_switch+0x29/0xa4
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
kblockd/1     S 00000018     0  2507      2
 f64b8fa8 00000046 3206dc9b 00000018 f6b39c00 f64b8f34 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6bbec90 f6bbeee8 c5805b80 00000001 f6b39d18
 f6b39c28 f6b40548 f6b40548 f6b405f8 f6b40548 f6437500 f6bbeee8 ffff3fac
Call Trace:
 [<c021ef5c>] ? generic_unplug_device+0x2c/0x2f
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
events/1      S 00000024     0  2508      2
 f7315fa8 00000046 395a6f41 00000024 c5802ab8 f7315f30 c0618100 c0617b80
 c0617b80 c0617b80 c0617b80 f6bbd470 f6bbd6c8 c5805b80 00000001 f7315f68
 c0133046 ffffffff c5802aa8 000000fa c5802aa8 f6437500 f6bbd6c8 ffff482a
Call Trace:
 [<c0133046>] ? queue_delayed_work_on+0xad/0xba
 [<c0133332>] ? schedule_delayed_work+0x11/0x13
 [<c0403d0a>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0135ae4>] ? prepare_to_wait+0x43/0x48
 [<c0132a23>] worker_thread+0x89/0xc3
 [<c0135993>] ? autoremove_wake_function+0x0/0x33
 [<c013299a>] ? worker_thread+0x0/0xc3
 [<c0135681>] kthread+0x3b/0x61
 [<c0135646>] ? kthread+0x0/0x61
 [<c010378b>] kernel_thread_helper+0x7/0x10
Sched Debug Version: v0.08, 2.6.29-rc1-resume-fix #8
now at 170685.733728 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 24191

cpu#0, 1828.643 MHz
  .nr_running                    : 1
  .load                          : 3121
  .nr_switches                   : 19312
  .nr_load_updates               : 3426
  .nr_uninterruptible            : 7
  .jiffies                       : 4294934295
  .next_balance                  : 4294.934061
  .curr->pid                     : 0
  .clock                         : 167999.662514
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 10
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 6
  .sched_switch                  : 0
  .sched_count                   : 20478
  .sched_goidle                  : 8080
  .ttwu_count                    : 8783
  .ttwu_local                    : 7603
  .bkl_count                     : 551

cfs_rq[0]:
  .exec_clock                    : 6284.351069
  .MIN_vruntime                  : 17177.554413
  .min_vruntime                  : 17190.428840
  .max_vruntime                  : 17177.554413
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 3121
  .nr_spread_over                : 0

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
        events/0    10     17177.554413       640   115     17177.554413         5.902936    167517.468747

cpu#1, 1828.643 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 6863
  .nr_load_updates               : 2250
  .nr_uninterruptible            : 4294967289
  .jiffies                       : 4294934295
  .next_balance                  : 4294.920234
  .curr->pid                     : 0
  .clock                         : 155581.052130
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 8203
  .sched_goidle                  : 2430
  .ttwu_count                    : 2386
  .ttwu_local                    : 1174
  .bkl_count                     : 785

cfs_rq[1]:
  .exec_clock                    : 3653.495251
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 13584.895984
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -3605.532856
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

rt_rq[1]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-2.6.29-rc1-resume-fix"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc1-resume-fix
# Tue Jan 13 13:36:16 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set

#
# Control Group support
#
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_STRIP_GENERATED=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_CLASSIC_RCU is not set
# CONFIG_TREE_RCU is not set
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_32=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
# CONFIG_X86_PTRACE_BTS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=2001
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_NET_NS is not set
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=m
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_NL80211=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_C2PORT is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=4000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_FCOE is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
# CONFIG_IEEE1394_PCILYNX is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
CONFIG_IEEE1394_RAWIO=y
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLWIFI_RFKILL is not set
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLAGN is not set
CONFIG_IWL3945=m
# CONFIG_IWL3945_RFKILL is not set
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
CONFIG_IWL3945_DEBUG=y
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=m
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_USB_DSBR is not set
# CONFIG_USB_SI470X is not set
# CONFIG_USB_MR800 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_DVB_DYNAMIC_MINORS is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=60
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_TOPSEED=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_HP_DISK is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_ROOT_NFS is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_TRACE is not set
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--YZ5djTAD1cGYuMQK--
