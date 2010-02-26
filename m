Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200Ab0BZPuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:50:21 -0500
Received: from smtp.seznam.cz ([77.75.76.43]:48661 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965185Ab0BZPuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:50:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=post.cz;
	h=Received:From:To:Date:MIME-Version:Subject:CC:Message-ID:Priority:In-reply-to:References:X-mailer:Content-type:Content-transfer-encoding:Content-description:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=YXkSzTM1Utvo/Y3J68pJdmGdPO4dScr+kfKWShiXTjRQyxYMXBbmdu8L51+fyKtRJ
	VWyWZ8TwJA7o6YwaT691t0kocNXJeXnuM6DGPg0kmjXgedSWyHstlTpKSbO7kfyd8xM
	HHuEAGzLWrNBkdCquo/RKqLnLFEzedawg47TuAY=
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: Mikael Pettersson <mikpe@it.uu.se>
Date: Fri, 26 Feb 2010 16:50:11 +0100
MIME-Version: 1.0
Subject: Re: Dynticks on Vortex86SX ? (Cx486SLC + just the standard i8254 PC timer)
CC: linux-kernel@vger.kernel.org
Message-ID: <4B87FBC3.23033.45BDAB1@Frantisek.Rysanek.post.cz>
In-reply-to: <19335.44648.623680.272844@pilspetsen.it.uu.se>
References: <4B86EF85.12688.440738@Frantisek.Rysanek.post.cz>, <19335.44648.623680.272844@pilspetsen.it.uu.se>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.1.7@13984
X-Seznam-User: frantisek.rysanek@post.cz
X-QM-Mark: email-qm5<421559340>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Pettersson,

thanks a lot for your pointer :-) Further comments below:

On 26 Feb 2010 at 12:20, Mikael Pettersson wrote:
> Select HZ=100.
>
right
1) to make the numbers decadic
2) seems like the only true way for me to decrease the rate of PC 
timer interrupts :-)

> Enable CONFIG_DEBUG_KERNEL and CONFIG_TIMER_STATS, rebuild and reboot.
> cat /proc/interrupts, echo 1 > /proc/timer_stats, sleep for 10 seconds,
> cat /proc/timer_stats and /proc/interrupts.
> That'll tell you which timers are firing the most, which translates into
> requiring frequent timer interrupts.
>
(cat /proc/interrupts ; echo 1 > /proc/timer_stats; sleep 10 ; \
 cat /proc/timer_stats; cat /proc/interrupts) > output.txt

[LISTING]

           CPU0       
  0:      18019    XT-PIC-XT        timer
  1:       1130    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  5:      11753    XT-PIC-XT        eth0
  6:          0    XT-PIC-XT        ath
  7:          0    XT-PIC-XT        parport0
  8:          0    XT-PIC-XT        rtc0
  9:          0    XT-PIC-XT        ehci_hcd:usb1
 14:       1217    XT-PIC-XT        ide0
 15:          0    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
ERR:          0
Timer Stats Version: v0.2
Sample period: 10.072 s
1,  1603 bash         sk_reset_timer (tcp_delack_timer)
1,  1605 bash         sk_reset_timer (tcp_write_timer)
9,     0 swapper      run_timer_softirq (r6040_timer)
2,     1 init         hrtimer_start_range_ns (hrtimer_wakeup)
1,   174 bdi-default  bdi_forker_task (process_timeout)
1,   677 flush-1:0    bdi_writeback_task (process_timeout)
1,     0 swapper      dev_watchdog (dev_watchdog)
1,  1605 sleep        hrtimer_start_range_ns (hrtimer_wakeup)
17 total events, 1.687 events/sec
           CPU0       
  0:      19030    XT-PIC-XT        timer
  1:       1131    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  5:      11766    XT-PIC-XT        eth0
  6:          0    XT-PIC-XT        ath
  7:          0    XT-PIC-XT        parport0
  8:          0    XT-PIC-XT        rtc0
  9:          0    XT-PIC-XT        ehci_hcd:usb1
 14:       1217    XT-PIC-XT        ide0
 15:          0    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
ERR:          0

[/LISTING]

The way I understand it, several processes have some timers open,
but the total number of events would amount to maybe 2 wakeups
per second on average. Yet the system timer keeps ticking at 100 Hz.
To me this would seem to imply that the PC timer interrupt just keeps 
ticking at that constant nominal HZ rate and the longer timeouts are 
"extrapolated" (wrapped around many times).
I am aware that the PC timer has a limited resolution (16 bits for 
the single i8254 channel) and thus the maximum time you can possibly 
sleep without an interrupt is about 55 ms (18 Hz). Based on all the 
PR publicity the dynticks patch used to receive in its time, 
I thought that even on my puny hardware, the PC timer would 
automatically flex towards that maximum period. Apparently this is 
not the case...

I'm not a permanent subscriber to the LKML, but coincidentally just 
at this moment there's another interesting relevant thread going on:
[NO_HZ migration of TCP ack timers]
which deals with the TCP timers (two of the timers visible in the 
stats above, I believe). Based on that mailinglist thread and based 
on other reading, I would expect that on more advanced CPU's the TCP 
timers are perhaps propelled by a LAPIC timer on the relevant CPU...
So perhaps the PC timer could actually become silent - but if I 
understand the debate correctly, the LAPIC timers again run at a 
fairly fast pace, and keep waking up the CPU core just to wrap 
around... right?

Anyway, on my tiny Vortex machine, the PC timer is all I have (apart 
from 2 additional proprietary on-chip timers that Linux doesn't know 
about, 24bit @ 32768Hz). And whenever at least one process sets up a 
timer, even if that's well over 1 second, the PC timer interrupt 
starts ticking at HZ, waking up the CPU scheduler upon every tick...

In other words, the very existence of Dynticks is moot.
I was merely curious if there's some room left for further power 
savings in this direction. Now it seems like a dead end.
But to put that fact into a larger context, I have this to add:

On the Vortex CPU, Linux already does fairly well by calling HLT 
whenever the system becomes idle, compared to consumption in DOS or 
BIOS POST for example.
And perhaps the hunt for dynticks is not really worth the bother,
if the wakeup to serve IRQ0 comes once every 3 million CPU cycles :-)
(This board clocks the CPU at 300 MHz.) How many CPU cycles does it 
take before the idle loop calls HLT again? a hundred maybe?  So 
that's 1/30000 of time running out of HLT? :-)

There's another power-saving feature of the Vortex SoC: it can 
decrease the core clock down to 1/8th of the nominal clock. This can 
be configured by a simple IO instruction. This way, you can decrease 
consumption of the whole SoC by maybe 6.5% (= down to 93% of full 
throttle), at the cost of throttling the core clock by 87%. The 
standard PC104 boards don't have a Vcore regulator, so it just 
doesn't get any better than that. I can do the underclocking from 
userspace using IOperm, I was wondering how nice it would be to have 
a "clockmod" driver, but ultimately I guess saving 125 mW is not 
worth the bother, as the whole setup including some peripherials eats 
over 3 Watts...

Have a nice weekend :-)

Frank Rysanek

