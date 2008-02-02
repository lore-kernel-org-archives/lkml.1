Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbYBBBD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbYBBBD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759838AbYBBBDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:03:16 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60089 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759558AbYBBBDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:03:15 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: John Stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0801310404480.17507@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801251349120.17507@scrub.home>
	 <1201573686.6766.13.camel@localhost>
	 <Pine.LNX.4.64.0801290439480.17507@scrub.home>
	 <1201659263.6766.40.camel@localhost>
	 <Pine.LNX.4.64.0801310251090.17507@scrub.home>
	 <1201745776.6195.14.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801310404480.17507@scrub.home>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 17:02:55 -0800
Message-Id: <1201914175.6216.46.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 06:02 +0100, Roman Zippel wrote:
> Hi,
> 
> On Wed, 30 Jan 2008, john stultz wrote:
> 
> > My concern is we state the accumulation interval is X ns long. Then
> > current_tick_length() is to return (X + ntp_adjustment), so each
> > accumulation interval we can keep track of the error and adjust our
> > interval length.
> > 
> > So if ntp_update_frequency() sets tick_length_base to be:
> > 
> > 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
> > 			<< TICK_LENGTH_SHIFT;
> > 	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
> > 	second_length += (s64)time_freq
> > 				<< (TICK_LENGTH_SHIFT - SHIFT_NSEC);
> > 
> > 	tick_length_base = second_length;
> > 	do_div(tick_length_base, NTP_INTERVAL_FREQ);
> > 
> > 
> > The above is basically (X + part of ntp_adjustment)
> 
> CLOCK_TICK_ADJUST is based on LATCH and HZ, if the update frequency isn't 
> based on HZ, there is no point in using it!

Hey Roman,

Again, I'm sorry I don't seem to be following your objections. If you
want to suggest a different patch to fix the issue, it might help.

The big issue for me, is that we have to initialize the clocksource
cycle interval so it matches the base tick_length that NTP uses.

To be clear, the issue I'm trying to address is only this:
Assuming there is no NTP adjustment yet to be made, if we initialize the
clocksource interval to X, then compare it with Y when we accumulate, we
introduce error if X and Y are not the same.

It really doesn't matter how long the length is, if we're including
CLOCK_TICK_ADJUST, or if it really matches the actual HZ tick length or
not. The issue is that we have to be consistent. If we're not, then we
introduce error that ntpd has to additionally correct for.

Now, once we're consistent, then CLOCK_TICK_ADJUST can be zero or not
and it won't really matter, other then making sure we accumulate at
exact tick length units. You can set it either way with my patch and
things will still work out to be correct.

My apologies for being so thick headed if I'm just missing something. I
do appreciate the feedback.
-john

