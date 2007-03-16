Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXCPKaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXCPKaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXCPKaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:30:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:4668 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbXCPKaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=r+jpBsvpLEwW3t7dx6Dc3DBiXaIKj80hvPiHMXjGtBxlZFpsA1BvZXYWBoC4XYpWBx2HyRTmCx87FjNIEx8GJPSvZSrj7LPcPNRfKKjWfRluimm8VibqLzCI3An16e9Fm7/A5IGaB5MXntpIsECBjjS+XqPLIAUgWuq4WW7vZGc=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far
Date: Fri, 16 Mar 2007 12:30:03 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703161230.03712.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Good day, 

I want to report regressions I have with 2.6.21-rc3 kernel.
I use CONFIG_NO_HZ.

1) Both suspend to disk and suspend to RAM are completely broken:
On vanilla 2.6.20 suspend to disk works perfectly and suspend to ram works _almost_ perfectly (I will tell about that later).
On 2.6.21-rc1 and later system hangs even before suspend begins (suspend to disk hangs before image write , and after suspend to ram , 
some devices are powered down (disk,power leds) , and some and not(fans, power) , and system hangs).

I did a git-bisect and I found which commit caused that:
	e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c (breaks  S3)
	ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c (breaks swsusp, I don't use it, but I tested it)
        259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c (breaks uswsusp, that I use)

I reverted those commits and now system suspends correctly to disk, but suspend to ram showed some more regressions.


2) ) After suspend to ram I get this 

Mar 14 00:22:23 MAIN kernel: [    2.072875] caller is check_tsc_sync_source+0x1d/0x100
Mar 14 00:22:23 MAIN kernel: [    2.072878]  [show_trace_log_lvl+26/48] show_trace_log_lvl+0x1a/0x30
Mar 14 00:22:23 MAIN kernel: [    2.072881]  [show_trace+18/32] show_trace+0x12/0x20
Mar 14 00:22:23 MAIN kernel: [    2.072884]  [dump_stack+22/32] dump_stack+0x16/0x20
Mar 14 00:22:23 MAIN kernel: [    2.072887]  [debug_smp_processor_id+173/176] debug_smp_processor_id+0xad/0xb0
Mar 14 00:22:23 MAIN kernel: [    2.072891]  [check_tsc_sync_source+29/256] check_tsc_sync_source+0x1d/0x100
Mar 14 00:22:23 MAIN kernel: [    2.072894]  [__cpu_up+80/384] __cpu_up+0x50/0x180
Mar 14 00:22:23 MAIN kernel: [    2.072897]  [_cpu_up+98/208] _cpu_up+0x62/0xd0
Mar 14 00:22:23 MAIN kernel: [    2.072901]  [cpu_up+46/80] cpu_up+0x2e/0x50
Mar 14 00:22:23 MAIN kernel: [    2.072903]  [enable_nonboot_cpus+110/160] enable_nonboot_cpus+0x6e/0xa0
Mar 14 00:22:23 MAIN kernel: [    2.072906]  [enter_state+326/496] enter_state+0x146/0x1f0
Mar 14 00:22:23 MAIN kernel: [    2.072909]  [state_store+174/192] state_store+0xae/0xc0
Mar 14 00:22:23 MAIN kernel: [    2.072912]  [subsys_attr_store+43/64] subsys_attr_store+0x2b/0x40
Mar 14 00:22:23 MAIN kernel: [    2.072917]  [sysfs_write_file+186/272] sysfs_write_file+0xba/0x110
Mar 14 00:22:23 MAIN kernel: [    2.072920]  [vfs_write+150/352] vfs_write+0x96/0x160
Mar 14 00:22:23 MAIN kernel: [    2.072923]  [sys_write+61/112] sys_write+0x3d/0x70
Mar 14 00:22:23 MAIN kernel: [    2.072926]  [sysenter_past_esp+93/153] sysenter_past_esp+0x5d/0x99
Mar 14 00:22:23 MAIN kernel: [    2.072929]  =======================
Mar 14 00:22:23 MAIN kernel: [    2.072931] checking TSC synchronization [CPU#0 -> CPU#1]:
Mar 14 00:22:23 MAIN kernel: [    2.092922] Measured 72051818872 cycles TSC warp between CPUs, turning off

It looks clear that preempt is enabled all the way in second cpu initialization, ( I think that at least in check_tsc_sync_source, it should be disabled,
shouldn't it ? )

Then I did add preempt_disable() / preempt_enable()  to this function , and  I still got this:

Mar 14 00:22:23 MAIN kernel: [    2.072931] checking TSC synchronization [CPU#0 -> CPU#1]:
Mar 14 00:22:23 MAIN kernel: [    2.092922] Measured 72051818872 cycles TSC warp between CPUs, turning off

It happens after second CPU is brought back on-line.

Now I understand that this is TSC sync problem and I tried to do some tests:

 I tried to disable/enable second CPU by hand, eg I did number of times,

echo "0" > /sys/devices/system/cpu/cpu1/online
echo "1" > /sys/devices/system/cpu/cpu1/online

and TSC sync was ok.

Then I disabled 2nd CPU, have suspended system to RAM , resumed it  , and then enabled 2nd CPU and got same error message.
Then I disabled cpufreq , and did above tests, and got same results.
I think that maybe this error is false, that there is some difference in TSC clock, but this difference is constant, and can be fixed

3) Sometimes I get this (once in three boots or so)

[   36.217405] ENABLING IO-APIC IRQs
[   36.217587] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   36.433917] APIC timer disabled due to verification failure.

And NO_HZ is disabled due to that (I get 1000/s timer's interrupts)
I haven't investigated that yet.
It looks like another new test that my hardware fails to perform... 


And now I want to tell you about that _almost_ working suspend to ram I got in 2.6.20:
To put it simply sometimes system wakes from resume, and sometimes not (about 1 in 5 times)
When it does it works perfectly. 

This is quite common problem but ironically my case is very different and harder to solve.

The fact is that I found thanks to RTC tricks , similar to PM_TRACE that system hangs in exactly three places (in one of them of course)

I put between instructions, code like that to save a position in RTC alarm which is not cleared on reboot
Note that this code uses ax, but I checked every time I put it that ax can be used (eg, it is loaded in next instruction)

#define TRACE(val) 			 \
	movb	$0x01, %al		; \
	outb	%al, $0x70 		; \
	movb	$ ## val, %al 		; \
	outb	%al, $0x71

It hangs very early in asm code, and those are places:

1) /home/maxim/software/kernel/linux-2.6.20-mod/arch/i386/kernel/acpi/wakeup.S:wakeup_start:
	ljmpl	$__KERNEL_CS,$wakeup_pmode_return
As I see that is first time wakeup low page is addressing kernel memory by jumping to it.

2)  /home/maxim/software/kernel/linux-2.6.20-mod/arch/i386/kernel/acpi/wakeup.S:do_suspend_lowlevel
	call	restore_registers 
It hangs exacly on that instruction, I can only see that this is first time protected stack is accessed

3) /home/maxim/software/kernel/linux-2.6.20-mod/arch/i386/power/cpu.c :__restore_processor_state(struct saved_context *ctxt)
	mtrr_ap_init();

It hangs somewhere inside this function, and because is is long I haven't found where exactly, it is easier to disable MTRR all together.

Note that all three places have different external behavier:

in first case, system powers on -> off -> on -> hangs
I did put test in RTC to see whenever BIOS call kernel twice but I know from this test for sure that it calls it only once,
It actualy makes sense, because exception occures before IDT is loaded, so system has no choice but to power down

in second case I see blinking leds -> almost sure a oops

in third case system just hangs

That's all, I will continue to dig those problems out

Thanks for attention,
	Maxim Levitsky
