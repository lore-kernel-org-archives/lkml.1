Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYAaFDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYAaFDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 00:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYAaFDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 00:03:01 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:4734 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYAaFC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:02:59 -0500
Date: Thu, 31 Jan 2008 06:02:50 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1201745776.6195.14.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0801310404480.17507@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home> <1201745776.6195.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 30 Jan 2008, john stultz wrote:

> My concern is we state the accumulation interval is X ns long. Then
> current_tick_length() is to return (X + ntp_adjustment), so each
> accumulation interval we can keep track of the error and adjust our
> interval length.
> 
> So if ntp_update_frequency() sets tick_length_base to be:
> 
> 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
> 			<< TICK_LENGTH_SHIFT;
> 	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
> 	second_length += (s64)time_freq
> 				<< (TICK_LENGTH_SHIFT - SHIFT_NSEC);
> 
> 	tick_length_base = second_length;
> 	do_div(tick_length_base, NTP_INTERVAL_FREQ);
> 
> 
> The above is basically (X + part of ntp_adjustment)

CLOCK_TICK_ADJUST is based on LATCH and HZ, if the update frequency isn't 
based on HZ, there is no point in using it!

Let's look at what actually needs to be done:

1. initializing clock interval:

	clock_cycle_interval = timer_cycle_interval * clock_frequency / timer_frequency

It's simply about converting timer cycles into clock cycles, so they're 
about the same time interval.
We already make it a bit more complicated than necessary as we go via 
nsec:

	ntp_interval = timer_cycle_interval * 10^9nsec / timer_frequency

and in clocksource_calculate_interval() basically:

	clock_cycle_interval = ntp_interval * clock_frequency / 10^9nsec

Without a fixed timer tick it's actually even easier, then we use the same 
frequency for clock and timer and the cycle interval is simply:

	clock_cycle_interval = timer_cycle_interval = clock_frequency / NTP_INTERVAL_FREQ

There is no need to use the adjustment here, you'll only cause a mismatch 
between the clock and timer cycle interval, which had to be corrected by 
NTP.

2. initializing clock adjustment:

	clock_adjust = timer_cycle_interval * NTP_INTERVAL_FREQ / timer_frequency - 1sec

This adjustment is used make up for the difference that the timer 
frequency isn't evenly divisible by HZ, so that the clock is advanced by 
1sec after timer_frequency cycles.

Like above the clock frequency is used for the timer frequency for this 
calculation for CONFIG_NO_HZ, so it would be incorrect to use 
CLOCK_TICK_RATE/LATCH/HZ here and since NTP_INTERVAL_FREQ is quite small 
the resulting adjustment would be rather small, it's easier not to bother 
in this case.

What you're basically trying is to add an error to the clock 
initialization, so that we can later compensate for it. The correct 
solution is really to not add the error in first place, so that there is 
no need to compensate for it.

bye. Roman
