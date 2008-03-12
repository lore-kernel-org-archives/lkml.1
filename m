Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbYCLXge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbYCLXge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYCLXgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:36:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbYCLXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:36:24 -0400
Date: Wed, 12 Mar 2008 16:35:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <20080312231601.GB24820@kroah.com>
Message-ID: <alpine.LFD.1.00.0803121619420.3557@woody.linux-foundation.org>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com>
 <20080312212704.GA16836@kroah.com> <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org> <20080312223431.GA24150@kroah.com> <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org> <20080312231601.GB24820@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Mar 2008, Greg KH wrote:
> >
> > It's not the warning that worries me. It's the apparent oops (keyboard 
> > leds blinking?) at shutdown/poweroff!
> 
> It oopses at shutdown?  I thought this was originally reported as a
> "will not power off" which for a while was attributed to the cpufreq fix
> that went into -rc2 or -rc3.
> 
> I didn't realize there was an oops, sorry.

I'm not at all sure there is an oops - in fact, I'd have expected it to 
show up on the serial console if there was one.

The bug report says that the keyboard leds blink, which is *sometimes* due 
to having the led oops blinking code enabled, but hey, no actual oops was 
ever shown, and sometimes a blink is just a blink.

Did you see the full dmesg from syslog? That one has not just the 
warnings, but also sysrq output at the point it hangs. The suspicious 
thing seems to be

	halt          R running      0  3291   3289
	       c013d75a 7488242e 00000180 75b8ffa0 c6efbddc c6efbddc c0426d00 c6efbdf0 
	       c0125da4 c6efbe10 c0125ed1 0000000a 00000001 c0426d00 c0426d00 00000046 
	       b7efcff4 c6efbe20 00000046 c0426d00 c0426d00 c6efbe2c c0126068 c110c060 
	Call Trace:
	 [<c013d75a>] ? tick_program_event+0x4a/0x80
	 [<c0125da4>] ? _local_bh_enable+0x24/0x80
	 [<c0125ed1>] ? __do_softirq+0xd1/0xf0
	 [<c0126068>] ? irq_exit+0x28/0x90
	 [<c0313079>] ? preempt_schedule_irq+0x49/0x70
	 [<c0103c28>] ? apic_timer_interrupt+0x28/0x30
	 [<c0251c58>] ? device_shutdown+0x48/0x70
	 [<c012e618>] ? kernel_shutdown_prepare+0x28/0x30
	 [<c012e630>] ? kernel_power_off+0x10/0x40
	...

which makes me suspect we're in some endless loop in device_shutdown(), 
but that's just a random guess (it seems to be running on the othe CPU: 
CPU0 is in idle - and when that happens the stack trace is really not 
very reliable at all, so take all that with a huge pinch of salt!).

> Sorry, I thought this was just a warning at boot time.

If it had been just the warning, I would ignore it as a good thing to be 
cleaned up later. But no, the original problem was the inability to halt 
and reboot, and the bugzilla entry says

	It also introduces these two errors:
	   ^^^^

with underlining by me. So the warnings in themselves are just an 
interesting coincidence (and probably related to the cause, of course).

		Linus
