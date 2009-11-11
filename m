Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbZKKVcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbZKKVcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbZKKVcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:32:45 -0500
Received: from lucidpixels.com ([75.144.35.66]:60755 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847AbZKKVco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:32:44 -0500
Date: Wed, 11 Nov 2009 16:32:48 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dave Jones <davej@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <20091111195016.GB22225@redhat.com>
Message-ID: <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan> <20091111195016.GB22225@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This also happens if cpufreq is a module ?
> There's no cpufreq code in that trace, so I'm puzzled.

It is not possible(?) to have CPUFREQ modularized:
   | | [*] CPU Frequency scaling

The ACPI_FREQ option can be though and it happens with or without it being 
a module.
   | |        <M>   ACPI Processor P-States driver

(the first part)

The second part is because I had compiled all of the power options in 
CPU_FREQ into the kernel, when I only copied w/ the ACPI processor 
P-States driver, I no longer got the errors that I originally reported 
(cpufreq-core).

The following error still occurs though, I found the offending kernel 
option(s):

> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_THERMAL=y

When this option is set, I get this:

[    3.478541] usb 2-1: configuration #1 chosen from 1 choice
[    3.491263] hub 2-1:1.0: USB hub found
[    3.503731] hub 2-1:1.0: 8 ports detected
[    3.524227] ------------[ cut here ]------------
[    3.536449] WARNING: at arch/x86/kernel/hpet.c:390 hpet_next_event+0x70/0x80()
[    3.548886] Hardware name: 
[    3.561191] Modules linked in:
[    3.573404] Pid: 0, comm: swapper Not tainted 2.6.31.5 #12
[    3.585755] Call Trace:
[    3.597989]  [<ffffffff81043180>] ? hpet_next_event+0x70/0x80
[    3.610401]  [<ffffffff81043180>] ? hpet_next_event+0x70/0x80
[    3.622758]  [<ffffffff810569a4>] ? warn_slowpath_common+0x74/0xd0
[    3.635040]  [<ffffffff81043180>] ? hpet_next_event+0x70/0x80
[    3.647281]  [<ffffffff81077916>] ? tick_dev_program_event+0x36/0xb0
[    3.659534]  [<ffffffff810772f9>] ? tick_broadcast_oneshot_control+0x119/0x120
[    3.671816]  [<ffffffff81076abd>] ? tick_notify+0x22d/0x420
[    3.683947]  [<ffffffff810700b7>] ? notifier_call_chain+0x37/0x70
[    3.696066]  [<ffffffff810763ab>] ? clockevents_notify+0x2b/0x90
[    3.708096]  [<ffffffff81244ac8>] ? acpi_idle_enter_bm+0x15f/0x2d3
[    3.720113]  [<ffffffff8124495e>] ? acpi_idle_enter_c1+0xf1/0xfc
[    3.732057]  [<ffffffff812e7a9a>] ? cpuidle_idle_call+0xba/0x120
[    3.743996]  [<ffffffff8102b832>] ? cpu_idle+0x62/0xc0
[    3.755860] ---[ end trace 747bb91afa915135 ]---
[    3.973002] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    4.209390] usb 4-1: New USB device found, idVendor=051d, idProduct=0002
[    4.221469] usb 4-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2

> Does acpi-cpufreq work when built as a module ?
> If it does, seeing the differences in output from booting with cpufreq.debug=7
> might yield some clues.

When the option is not set, dmesg is normal, no problems (but then, I cannot
run ACPI_FREQ) to achieve turbo mode on my CPU (the ACPI_FREQ driver 
requires the PROCESSOR option to be enabled).

So your next question, does that error occur when processor.ko is a 
module?  Yes:

[    6.331411] processor LNXCPU:00: registered as cooling_device0
[    6.340372] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.15-NAPI
[    6.340373] e1000e: Copyright(c) 1999 - 2009 Intel Corporation.
[    6.340402] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.340411] e1000e 0000:00:19.0: setting latency timer to 64
[    6.397934] ACPI: Processor [CPU0] (supports
[    6.398080] e1000e 0000:00:19.0: irq 38 for MSI/MSI-X
[    6.414813]  8 throttling states)
[    6.432030] ACPI: CPU1 (power states: C1[C1] C3[C3])
[    6.448937] processor LNXCPU:01: registered as cooling_device1
[    6.465770] ACPI: Processor [CPU1] (supports 8 throttling states)
[    6.483179] ACPI: CPU2 (power states: C1[C1] C3[C3])
[    6.499971] processor LNXCPU:02: registered as cooling_device2
[    6.516762] ACPI: Processor [CPU2] (supports 8 throttling states)
[    6.534255] ACPI: CPU3 (power states: C1[C1] C3[C3])
[    6.551147] processor LNXCPU:03: registered as cooling_device3
[    6.568112] ACPI: Processor [CPU3] (supports 8 throttling states)
[    6.609973] ACPI: CPU4 (power states: C1[C1] C3[C3])
[    6.627180] processor LNXCPU:04: registered as cooling_device4
[    6.644334] ACPI: Processor [CPU4] (supports 8 throttling states)
[    6.662005] ACPI: CPU5 (power states: C1[C1] C3[C3])
[    6.679323] processor LNXCPU:05: registered as cooling_device5
[    6.696652] ACPI: Processor [CPU5] (supports 8 throttling states)
[    6.714578] ACPI: CPU6 (power states: C1[C1] C3[C3])
[    6.716148] ------------[ cut here ]------------
[    6.716153] WARNING: at arch/x86/kernel/hpet.c:390 hpet_next_event+0x70/0x80()
[    6.716154] Hardware name: 
[    6.716155] Modules linked in: e1000e(+) thermal processor(+)
[    6.716158] Pid: 0, comm: swapper Not tainted 2.6.31.5 #15
[    6.716159] Call Trace:
[    6.716161]  [<ffffffff81042090>] ? hpet_next_event+0x70/0x80
[    6.716163]  [<ffffffff81042090>] ? hpet_next_event+0x70/0x80
[    6.716166]  [<ffffffff810558b4>] ? warn_slowpath_common+0x74/0xd0
[    6.716168]  [<ffffffff81042090>] ? hpet_next_event+0x70/0x80
[    6.716170]  [<ffffffff81076826>] ? tick_dev_program_event+0x36/0xb0
[    6.716172]  [<ffffffff81076209>] ? tick_broadcast_oneshot_control+0x119/0x120
[    6.716174]  [<ffffffff810759cd>] ? tick_notify+0x22d/0x420
[    6.716176]  [<ffffffff8106efc7>] ? notifier_call_chain+0x37/0x70
[    6.716178]  [<ffffffff810752bb>] ? clockevents_notify+0x2b/0x90
[    6.716182]  [<ffffffffa00022a0>] ? acpi_idle_enter_bm+0x15f/0x2d3 [processor]
[    6.716185]  [<ffffffffa0002136>] ? acpi_idle_enter_c1+0xf1/0xfc [processor]
[    6.716188]  [<ffffffff812de4fa>] ? cpuidle_idle_call+0xba/0x120
[    6.716191]  [<ffffffff8102b7f2>] ? cpu_idle+0x62/0xc0
[    6.716192] ---[ end trace dc2616d16ddbce62 ]---
[    6.852167] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:c0:f6:b6:50
[    6.852169] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.852244] 0000:00:19.0: eth0: MAC: 10, PHY: 9, PBA No: ffffff-0ff
[    6.852320] e1000e 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.852334] e1000e 0000:04:00.0: setting latency timer to 64
[    7.115593] processor LNXCPU:06: registered as cooling_device6
[    7.115992] e1000e 0000:04:00.0: irq 39 for MSI/MSI-X
[    7.115994] e1000e 0000:04:00.0: irq 40 for MSI/MSI-X
[    7.131290] ACPI: Processor [CPU6] (supports 8 throttling states)
[    7.147607] ACPI: CPU7 (power states: C1[C1] C3[C3])
[    7.163485] processor LNXCPU:07: registered as cooling_device7
[    7.179105] ACPI: Processor [CPU7] (supports 8 throttling states)


Justin.

