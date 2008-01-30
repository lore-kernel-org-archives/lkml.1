Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYA3DpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYA3DpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYA3Do5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:44:57 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35348 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752594AbYA3Do4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:44:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zt/hqk3xMYHBZQaIpEkoIVBawssC96vKX+jiLcjAhhmJLbMfJA2kdfqy9zCqQ6yu4bnAirGK1nlvT9BgzK/YrlgtknKBMokBd63p5hnMmNq7SR/uWenc9FSALPGhqbzRMJQvv9x4Rj0zRPR3sgcQ2vIGEC0p0UKTDPlYST1mVR0=  ;
X-YMail-OSG: RwItHuUVM1kAJTglP1wzLrVdDxueI2OR.A2YojbWMC_2Lqh0P9jpJtPQgpZTqs3KqdOcvt.t0g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: at91sam9260 wakeup on serial port
Date: Tue, 29 Jan 2008 19:44:53 -0800
User-Agent: KMail/1.9.6
Cc: michael <trimarchi@gandalf.sssup.it>, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
References: <479DB934.6090806@gandalf.sssup.it> <200801281021.57317.david-b@pacbell.net> <20080128195114.33d7616d@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080128195114.33d7616d@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291944.53591.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Haavard Skinnemoen wrote:
> 
> > What will AVR32 (AP7) need to do, when it supports system sleep states?
> 
> Not sure. The PIOs seem to require a clock in order to detect a pin
> change, so I don't think we can enter very deep sleep states if we want
> to be woken up by the USART.

Right; if no DMA is pending, then the HSB matrix clock can be idled, DRAM put
into self-refresh, and most peripherals can issue wakeups ... AP7 "Frozen"
state, very analagous to AT91 "standby" on Linux.  UARTs and GPIOs can wake.

Deeper sleep states -- "standby" with clocks running, "stop" with all
except 32K (and RTC) off, "static" with no clocks at all -- can only
wake from WAKE_N and external interrupts; and RTC except in "static".
I suspect "stop" and "static" might want to use the on-chip SRAMs so
they don't need to change DRAM timings while they fiddle with clocks.

The closest analogue to the AT91 support would map /sys/power/state:

	standby --> to AP7 "Frozen"
	mem --> to AP7 "Stop"

Except that there could be no GPIO wakeups from "mem" ... so the $SUBJECT
patch wouldn't be useful on AVR32 (just AT91), unless USARTn.RXD is wired
up to one of those special wake-capable pins (extremely board-specific).


> There's a separate WAKE_N pin that is completely asynchronous, so with
> some external logic, we can probably wake up the CPU all the way from
> Static mode if a given input state is present. But that's definitely
> "board specific" territory, and starting the oscillators take a _long_
> time on the AP7000 (especially the 32 kHz, but then again, it barely
> consumes any power, so we might as well keep it running and keep the
> RTC going as well.)

I'd think the support of any "deeper" state for "mem" sleep would not
be entirely board specific ... when the RTC alarm is set, any board
should be able to use states other than "static".  But otherwise, no
board could enter those states unless WAKE_N or an external IRQ are
doing something useful (like being hooked up to a button).

Matching those few "deep wake" events to a given device would imply
board-specific glue code.


> So on AP7000, I think we'll just need to keep clocking the USART and
> let it generate the interrupt that wakes up the rest of the system.

For "standby" sleep state, yes -- map to at most AVR32 "Frozen" state.
That'd be a good first step for PM support.

- Dave
