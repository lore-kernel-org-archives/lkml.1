Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbXJLN1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbXJLN1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbXJLN1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:27:00 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:45817 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbXJLN06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:26:58 -0400
Message-ID: <470F7620.6040705@free.fr>
Date: Fri, 12 Oct 2007 15:26:56 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NMI watchdog
References: <470F3BE0.4050807@free.fr> <Pine.LNX.4.58.0710120625380.8208@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0710120625380.8208@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:

> John Sigler wrote:
> 
>> I'm experiencing a full system lockup. I'm using an out-of-tree driver
>> which I suspect is responsible. I'm trying to enable the NMI watchdog.
>>
>> # cat /proc/version
>> Linux version 2.6.22.1-rt9 (gcc version 3.4.6) #1 PREEMPT RT Tue Oct 9
>> 12:25:47 CEST 2007
>>
>> # cat /proc/cmdline
>> ro root=/dev/hdc1 console=ttyS0,57600n8 console=tty0 panic=3 apic=debug
>> nmi_watchdog=2
> 
> I've noticed on some boxes that nmi_watchdog=2 does what you state. Try
> out nmi_watchdog=1.

# diff boot_message013 boot_message014
49c49
< Kernel command line: ro root=/dev/hdc1 console=ttyS0,57600n8 
console=tty0 panic=3 apic=debug nmi_watchdog=2
---
 > Kernel command line: ro root=/dev/hdc1 console=ttyS0,57600n8 
console=tty0 panic=3 apic=debug nmi_watchdog=1
69c69
< Calibrating delay using timer specific routine.. 4802.79 BogoMIPS 
(lpj=24013960)
---
 > Calibrating delay using timer specific routine.. 4802.80 BogoMIPS 
(lpj=24014009)
88a89
 > activating NMI Watchdog ... done.
97c98
< ..... CPU clock speed is 2400.1215 MHz.
---
 > ..... CPU clock speed is 2400.1221 MHz.
98a100
 > APIC timer registered as dummy, due to nmi_watchdog=1!
213a216,217
 > Clockevents: could not switch to one-shot mode: lapic is not functional.
 > Could not switch to high resolution mode on CPU 0

Do you know why nmi_watchdog=1 disables high-resolution timers?

And why nmi_watchdog=1 implies APIC timer registered as dummy?

# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc acpi_pm pit jiffies

# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

# cat /proc/timer_list
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 4613373211613 nsecs

cpu: 0
  clock 0:
   .index:      0
   .resolution: 10000000 nsecs
   .get_time:   ktime_get_real
   .offset:     0 nsecs
active timers:
  clock 1:
   .index:      1
   .resolution: 10000000 nsecs
   .get_time:   ktime_get
   .offset:     0 nsecs
active timers:
  #0: <cf2c1ec0>, it_real_fn, S:01
  # expires at 4630663830511 nsecs [in 17290618898 nsecs]
   .expires_next   : 9223372036854775807 nsecs
   .hres_active    : 0
   .nr_events      : 0
   .nohz_mode      : 0
   .idle_tick      : 0 nsecs
   .tick_stopped   : 0
   .idle_jiffies   : 0
   .idle_calls     : 0
   .idle_sleeps    : 0
   .idle_entrytime : 0 nsecs
   .idle_sleeptime : 0 nsecs
   .last_jiffies   : 0
   .next_jiffies   : 0
   .idle_expires   : 0 nsecs
jiffies: 431306


Tick Device: mode:     0
Clock Event Device: pit
  max_delta_ns:   27461866
  min_delta_ns:   12571
  mult:           5124677
  shift:          32
  mode:           2
  next_event:     9223372036854775807 nsecs
  set_next_event: pit_next_event
  set_mode:       init_pit_timer
  event_handler:  tick_handle_periodic_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     0
Clock Event Device: lapic
  max_delta_ns:   1006581321
  min_delta_ns:   1799
  mult:           35793226
  shift:          32
  mode:           1
  next_event:     0 nsecs
  set_next_event: lapic_next_event
  set_mode:       lapic_timer_setup
  event_handler:  tick_handle_periodic

# cat /proc/interrupts
            CPU0
   0:     468721   IO-APIC-edge      timer
   4:        326   IO-APIC-edge      serial
   8:          1   IO-APIC-edge      rtc
   9:          0   IO-APIC-fasteoi   acpi
  15:      15964   IO-APIC-edge      ide1
  16:       4217   IO-APIC-fasteoi   eth0
  17:       2340   IO-APIC-fasteoi   eth1
  18:       2340   IO-APIC-fasteoi   eth2
  19:       2340   IO-APIC-fasteoi   eth3
NMI:     468690
LOC:          0
ERR:          0
MIS:          0

Regards.
