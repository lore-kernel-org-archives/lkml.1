Return-Path: <linux-kernel-owner+w=401wt.eu-S2992453AbXCGWDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992453AbXCGWDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965693AbXCGWDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:03:03 -0500
Received: from www.osadl.org ([213.239.205.134]:40227 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965692AbXCGWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:03:00 -0500
Subject: Re: Linux-2.6.21-rc3 : Dynticks and High resolution Timer hanging
	the system
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stephane Casset <sept@logidee.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070307211659.GA8010@gromalin.logidee.com>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <45EEB66C.9090901@googlemail.com>
	 <Pine.LNX.4.64.0703070827490.5963@woody.linux-foundation.org>
	 <20070307171230.GA21593@elte.hu>
	 <20070307191252.GA6767@gromalin.logidee.com>
	 <1173297130.24738.714.camel@localhost.localdomain>
	 <20070307211659.GA8010@gromalin.logidee.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 23:09:10 +0100
Message-Id: <1173305350.24738.842.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 22:16 +0100, Stephane Casset wrote:
> > > What can I do to help find the bug ?
> > 
> > Can you capture a boot log with highres and/or dynticks enabled ? 
> 
> No, I can handcopy or take a picture of the last page (25 or 50 lines)
> 
> > Enable CONFIG_SERIAL_8250_CONSOLE and add "console=ttyS0,115200" to the
> > commandline. Capture the output with minicom on a second box.
> 
> The system is a laptop without serial port :(

Hrmpf. Netconsole should work.

Enable CONFIG_NETCONSOLE and compile the network driver into your
kernel. See Documentation/networking/netconsole.txt for the kernel
command line option.

run 'netcat -u -l -p <portnr>' on the host.

> > Also please enable CONFIG_MAGIC_SYSRQ and try to send a SysRq-T and a
> > SysRq-Q to the machine via keyboard or the serial line.
> 
> When the system hangs, the keyboard is dead :(

I feared that.

> I just tried clocksource=acpi_pm and the hang disapears... 

Aah.

> I tested 2.6.21-rc1 which also hangs but not always, when it hangs I
> tried Sysrq-T and got this, I noted in parenthesis some value when it does'nt
> hang...
> 
> Tick Device: mode:     1
> Clock Event Device: pit
>  max_delta_ns:   27461866
>  min_delta_ns:   12571
>  mult:           5124677
>  shift:          32
>  mode:           3
>  next_event:     9223372036854775807 nsecs
>  set_next_event: pit_next_event
>  set_mode:       init_pit_timer
>  event_handler:  tick_handle_oneshot_broadcast
> tick_broadcast_mask: 00000001

------------------------------^

ACPI does only take care of one CPU

ACPI: processor limited to max C-state 1
ACPI: CPU0 (power states: C1[C1] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)

but there is no entry for the second CPU.

Also it seems that the power state limit is possibly ignored.

That would explain the hang, as TSC and local APIC might get stuck.

Broken BIOS/ACPI I fear. Can you please go to

http://www.linuxfirmwarekit.org/download.php

and run the CD on your laptop. It tests the BIOS / ACPI correctness.

> tick_broadcast_oneshot_mask: 00000000

> So it seems that the clock source selection is not working properly or the pit
> (the default clock source right ?) is not correctly initialised...

The broadcast mode is not set up for one shot.

> If you need the complete SYSRQ-T trace for 2.6.21-rc1 hanging/not hanging I can
> provide it but it is quiet long to handwrite it :(

Not now.

	tglx


