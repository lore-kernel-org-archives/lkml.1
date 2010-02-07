Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab0BGTTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 14:19:53 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45399 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab0BGTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 14:19:51 -0500
Date: Sun, 7 Feb 2010 20:19:49 +0100
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6)
Message-ID: <20100207191949.GA23665@rhlx01.hs-esslingen.de>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 06, 2010 at 03:46:50PM +0100, Thomas Gleixner wrote:
> On Sat, 6 Feb 2010, Andreas Mohr wrote:
> > echo t > /proc/sysrq-trigger shows (full output on request):
> 
> At least the state of "kwatchdog" would be interesting.

Hrmm, scrolled out of dmesg buffer :(
(will now increase buffer size)

> > cat           D 00000000     0 19361   2959 0x00000000
> >  de215ef8 00000046 00000000 00000000 c13b0294 dd45c380 dd45c5fc df9c6ef0
> >  de215f28 de215f08 c13b0260 00000202 de215f28 c124fcae dd45c380 c13b0280
> >  c13b0280 c13b0280 dd45c380 de215f08 ffffffff d9de1000 c13b0338 df9c6ef0
> > Call Trace:
> >  [<c124fcae>] mutex_lock_nested+0x157/0x23d
> >  [<c104873e>] sysfs_show_current_clocksources+0x17/0x41
> > 
> > INFO: lockdep is turned off.
> 
> Why is lockdep turned off ?

Good question.

# grep -i lockdep /boot/config-2.6.33-rc6
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
# CONFIG_DEBUG_LOCKDEP is not set


BTW, things get even weirder:

On bootup, I get lockups during

Switching to clocksource acpi_pm

very frequently, but _only_ in case of connected AC adapter.
If I don't connect AC adapter, it always boots.
(I tried about 8 times, with 5 times AC and 3 times without,
and consistent behaviour)

The current boot was with AC connected, and this time it did manage to
boot, but with a slight hang at the
Switching to clocksource acpi_pm
line. And this time NMI watchdog detected things going haywire:

PM: Adding info for No Bus:input1
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
ACPI: Power Button [PBTN]
driver: 'PNP0C0C:00': driver_bound: bound to device 'button'
bus: 'acpi': really_probe: bound device PNP0C0C:00 to driver button
bus: 'acpi': driver_probe_device: matched device PNP0C0E:00 with driver button
bus: 'acpi': really_probe: probing driver button with device PNP0C0E:00
device: 'input2': device_add
PM: Adding info for No Bus:input2
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
ACPI: Sleep Button [SBTN]
driver: 'PNP0C0E:00': driver_bound: bound to device 'button'
bus: 'acpi': really_probe: bound device PNP0C0E:00 to driver button
bus: 'acpi': add driver fan
bus: 'acpi': add driver processor
bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
Marking TSC unstable due to TSC halts in idle
device: 'cooling_device0': device_add
PM: Adding info for No Bus:cooling_device0
Switching to clocksource acpi_pm
BUG: NMI Watchdog detected LOCKUP on CPU0, ip c1046694, registers:
Modules linked in:

Pid: 266, comm: kwatchdog Not tainted 2.6.33-rc6 #3 Inspiron 8000            /Inspiron 8000
EIP: 0060:[<c1046694>] EFLAGS: 00000082 CPU: 0
EIP is at timekeeping_forward_now+0xf0/0x11d
EAX: 342100fe EBX: f3dcdfc8 ECX: 63826cfb EDX: ffffffff
ESI: 003ffd7b EDI: 00000000 EBP: dfa31f50 ESP: dfa31f28
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process kwatchdog (pid: 266, ti=dfa31000 task=dfa4e0a0 task.ti=dfa31000)
Stack:
 005b9e7e 00000000 6184c590 00000fff 002cb338 4b6f0da7 00000000 c13d8524
<0> c13d8524 dfa31f48 dfa31f60 c10466d2 c13d8524 c13d8524 dfa31f6c c104725e
<0> c13b02c0 dfa31f84 c1048376 c13285ec c1328650 c13b03a4 c13d8528 dfa31fa4
Call Trace:
 [<c10466d2>] ? change_clocksource+0x11/0x3e
 [<c104725e>] ? timekeeping_notify+0x20/0x2e
 [<c1048376>] ? clocksource_select+0x9a/0xa3
 [<c10484ba>] ? clocksource_watchdog_kthread+0x13b/0x163
 [<c104837f>] ? clocksource_watchdog_kthread+0x0/0x163
 [<c103fa6e>] ? kthread+0x65/0x6a
 [<c103fa09>] ? kthread+0x0/0x6a
 [<c1002dba>] ? kernel_thread_helper+0x6/0x10
Code: 65 e8 8d 14 17 89 c6 89 d7 31 c0 0f ad d6 d3 ef f6 c1 20 0f 45 f7 0f 45 f8 a1 10 21 48 c1 89 f1 89 fb 99 01 c1 11 d3 31 c0 eb 0a <81> c1 00 36 65 c4 83 d3 ff 40 83 fb 00 77 f1 81 f9 ff c9 9a 3b
---[ end trace a7919e7f17c0a725 ]---
driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
bus: 'acpi': add driver container
bus: 'acpi': add driver thermal




Kernel options I used are:

Kernel command line: BOOT_IMAGE=L2633rc6 root=802 ramdisk=0 video=vesa:mtrr ywrap devfs=nomount apm=off root=/dev/sda2 lapic apic=debug nmi_watchdog=2 usbcore.autosuspend=1



Since clocksource_mutex code invocation seems pretty symmetric, I cannot imagine any problem here,
except for mutex implementation issues, recursive clocksource code calls and NMI / interrupt issues.

Could it be that some system code (ACPI, SMI, ...?) calls clocksource stuff?
_Or_ there's some corruption going on, in the area near the clocksource_mutex storage.

I _think_ older kernels had some slight delays during clocksource switch, too, but I cannot remember any
outright hangs during bootup.

Hrmm, OTOH I changed quite some options after the last build:

$ diff -uN config-2.6.33-rc4 config-2.6.33-rc6|grep ^+
+++ config-2.6.33-rc6   2010-01-31 20:06:59.000000000 +0100
+# Linux kernel version: 2.6.33-rc6
+# Sun Jan 31 20:05:19 2010
+# CONFIG_COMPAT_BRK is not set
+# CONFIG_COMPAT_VDSO is not set
+CONFIG_PARPORT=m
+CONFIG_PARPORT_PC=m
+CONFIG_TRACE_IRQFLAGS=y
+CONFIG_LATENCYTOP=y
+CONFIG_HAVE_FTRACE_NMI_ENTER=y
+CONFIG_TRACER_MAX_TRACE=y
+CONFIG_FTRACE_NMI_ENTER=y
+CONFIG_FUNCTION_TRACER=y
+CONFIG_IRQSOFF_TRACER=y
+CONFIG_SCHED_TRACER=y
+CONFIG_FTRACE_SYSCALLS=y
+CONFIG_BLK_DEV_IO_TRACE=y
+CONFIG_DYNAMIC_FTRACE=y
+# CONFIG_FUNCTION_PROFILER is not set
+CONFIG_FTRACE_MCOUNT_RECORD=y
+CONFIG_4KSTACKS=y



Umm, CONFIG_FTRACE_NMI_ENTER, anyone?
That sounds like the most invasive candidate at least.

Anyway, behaviour does seem broken given that clocksource_mutex use is fully symmetric
and shouldn't cause issues on its own.
If I had a guess, then I'd say some of these options above do some mutex-related things
and corrupt their surroundings. But who knows...

BTW, it's not an lapic thing: I had hangs with and without enabling it.

I'm afraid I'll have to back out one half of the options above and retry...

Any ideas?

Thanks,

Andreas Mohr
