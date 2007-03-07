Return-Path: <linux-kernel-owner+w=401wt.eu-S2992588AbXCGVNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992588AbXCGVNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992593AbXCGVNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:13:53 -0500
Received: from gromalin.logidee.com ([213.91.4.12]:2485 "EHLO
	gromalin.logidee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992588AbXCGVNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:13:52 -0500
Date: Wed, 7 Mar 2007 22:16:59 +0100
From: Stephane Casset <sept@logidee.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux-2.6.21-rc3 : Dynticks and High resolution Timer hanging the system
Message-ID: <20070307211659.GA8010@gromalin.logidee.com>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <45EEB66C.9090901@googlemail.com> <Pine.LNX.4.64.0703070827490.5963@woody.linux-foundation.org> <20070307171230.GA21593@elte.hu> <20070307191252.GA6767@gromalin.logidee.com> <1173297130.24738.714.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1173297130.24738.714.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, Mar 07, 2007 at 08:52:10PM +0100, Thomas Gleixner ecrivait :
> On Wed, 2007-03-07 at 20:12 +0100, Stephane Casset wrote:
> > I also tried compiling the kernel without Tickless and without  High
> > resolution timer, this kernel is working ok and is one of the first
> > kernel to suspend and resume from RAM. Congratulations ! ;p
> >
> > I tried to compile te kernel with only Tickless System or  High
> > Resolution timer, both hang on boot.
> 
> There should be no difference between compile time and runtime
> disabling.

Yes, but I wanted to be sure.

> > The hang is just after :
> > ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> > ICH5: chipset revision 2
> > ICH5: not 100% native mode: will probe irqs later
> >     ide0: BM-DMA at 0x2040-0x2047, BIOS settings: hda:DMA, hdb:pio
> >     ide1: BM-DMA at 0x2048-0x204f, BIOS settings: hdc:DMA, hdd:pio
> > 
> > And I have the message :
> > Switched to NOHZ mode on CPU #1
> > or
> > Switched to high resolution mode on CPU #1
> > Depending on the option enabled/disabled 
> > 
> > What can I do to help find the bug ?
> 
> Can you capture a boot log with highres and/or dynticks enabled ? 

No, I can handcopy or take a picture of the last page (25 or 50 lines)

> Enable CONFIG_SERIAL_8250_CONSOLE and add "console=ttyS0,115200" to the
> commandline. Capture the output with minicom on a second box.

The system is a laptop without serial port :(

> Also please enable CONFIG_MAGIC_SYSRQ and try to send a SysRq-T and a
> SysRq-Q to the machine via keyboard or the serial line.

When the system hangs, the keyboard is dead :(

I just tried clocksource=acpi_pm and the hang disapears... 

I tested 2.6.21-rc1 which also hangs but not always, when it hangs I
tried Sysrq-T and got this, I noted in parenthesis some value when it does'nt
hang...

SysRq : Show Pending Timers
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: X
now at XXXXXXXXXXX nsecs
cpu: 0
 clock 0:
  .index:      0
  .resolution: 10000000 nsecs / 1ns (when it does'nt hang)
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 10000000 nsecs / 1ns (when it does'nt hang)
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
  .expires_next   : 9223372036854775807 nsecs (some thing resonneable when not hanging)
Almost the same for cpu1
and

Tick Device: mode:     1
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   672715459
 min_delta_ns:   1202
 mult:           53557254
 shift:          32
 mode:           3
 next_event:     84460000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   672715459
 min_delta_ns:   1202
 mult:           53557254
 shift:          32
 mode:           3
 next_event:     84790000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

So it seems that the clock source selection is not working properly or the pit
(the default clock source right ?) is not correctly initialised...

If you need the complete SYSRQ-T trace for 2.6.21-rc1 hanging/not hanging I can
provide it but it is quiet long to handwrite it :(

A+
-- 
Stéphane Casset            LOGIDÉE sàrl       Se faire plaisir d'apprendre
1a, rue Pasteur        Tel : +33 388 23 69 77           casset@logidee.com
F-67540 OSTWALD        Fax : +33 388 23 69 77           http://logidee.com
