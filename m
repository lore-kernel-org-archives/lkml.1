Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXDFXEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXDFXEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933322AbXDFXEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:04:39 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313AbXDFXEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:04:38 -0400
Date: Fri, 6 Apr 2007 16:04:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.21-rc6 - regressions update
In-Reply-To: <1175899460.5393.9.camel@localhost>
Message-ID: <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
 <1175899460.5393.9.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Added some people to the cc.. Len, Thomas, Ingo - look for the exact 
  report on linux-kernel, but basically it's a "irq 9: nobody cared" issue 
  with acpi_irq on irq9 ]

On Sat, 7 Apr 2007, Soeren Sonnenburg wrote:
> 
> regression update for 21-rc6:
> 
> 1) all s2ram and NO_HZ related things seem to be resolved on my macbook
> pro, also 
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> 
> don't break resume anymore.

Goodie. I think we fixed most stuff..

> 2) However I am still having problems with
> +CONFIG_HIGH_RES_TIMERS=y
> +CONFIG_HPET=y
> +CONFIG_HPET_MMAP=y
> although the machine resumes, I've managed to get the attached oops.

Ok, interesting. I'd have blamed ACPI for this one (stuck IRQ9 is almost 
always some ACPI event that got stuck or the SCI got mis-routed and/or 
marked with the wrong polarity), although from your message I take it you 
don't get it without high-res timers? 

In fact,  I have a theory.. Your backtrace is:

 [<c0119637>] smp_apic_timer_interrupt+0x57/0x90
 [<c0142d30>] retrigger_next_event+0x0/0xb0
 [<c0104d30>] apic_timer_interrupt+0x28/0x30
 [<c0142d30>] retrigger_next_event+0x0/0xb0
 [<c0140068>] __kfifo_put+0x8/0x90
 [<c0130fe5>] on_each_cpu+0x35/0x60
 [<c0143538>] clock_was_set+0x18/0x20
 [<c0135cdc>] timekeeping_resume+0x7c/0xa0
 [<c02aabe1>] __sysdev_resume+0x11/0x80
 [<c02ab0c7>] sysdev_resume+0x47/0x80
 [<c02b0b05>] device_power_up+0x5/0x10

and the thing is, I don't think we should have interrupt enabled at this 
point in time! I susect that the timer resume enables interrupts too 
early! We should be doing the whole "device_power_up()" sequence with 
irq's off, I think..

> 3) Subject    : SATA breakage on resume
> References : http://lkml.org/lkml/2007/3/7/233
> Submitter  : Thomas Gleixner <tglx@linutronix.de>
>              Soeren Sonnenburg <kernel@nn7.de>
> Status     : unknown
> 
> I am still seeing these messages after a suspend/resume cycle (though
> all devices work even after multiple suspend/resume cycles)
> 
> ATA: abnormal status 0x80 on port 0x000140df

This seems to be normal, and related to some unknown timing issue. If the 
thing works for you apart from the message, I'd just ignore it..

		Linus
