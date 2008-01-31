Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbYAaCQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbYAaCQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYAaCQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:16:25 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51186 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYAaCQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:16:24 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0801310251090.17507@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801251349120.17507@scrub.home>
	 <1201573686.6766.13.camel@localhost>
	 <Pine.LNX.4.64.0801290439480.17507@scrub.home>
	 <1201659263.6766.40.camel@localhost>
	 <Pine.LNX.4.64.0801310251090.17507@scrub.home>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 18:16:16 -0800
Message-Id: <1201745776.6195.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 02:55 +0100, Roman Zippel wrote:
> Hi,
> 
> On Tue, 29 Jan 2008, john stultz wrote:
> 
> > +/* Because using NSEC_PER_SEC would be too easy */
> > +#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC*NSEC_PER_USEC*USER_HZ)+CLOCK_TICK_ADJUST)/NTP_INTERVAL_FREQ)
> 
> Why are you using USER_HZ? Did you test this with HZ!=100?

I'm using USER_HZ, because ntp_update_frequency() uses USER_HZ.

And my tests were run at HZ=1000.

> Anyway, please don't make more complicated than it already is.
> What I said previously about the update interval is still valid, so the 
> correct solution is to use the simpler NTP_INTERVAL_LENGTH calculation 
> from my last mail and to omit the correction for NO_HZ.

I'm not sure I follow how having two separate and totally different
definitions of NTP_INTERVAL_LENGTH is less complicated then my last
patch.

Maybe I'm missing something from your suggestion? Or maybe could you
contribute your suggestion as a patch?

My concern is we state the accumulation interval is X ns long. Then
current_tick_length() is to return (X + ntp_adjustment), so each
accumulation interval we can keep track of the error and adjust our
interval length.

So if ntp_update_frequency() sets tick_length_base to be:

	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
			<< TICK_LENGTH_SHIFT;
	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
	second_length += (s64)time_freq
				<< (TICK_LENGTH_SHIFT - SHIFT_NSEC);

	tick_length_base = second_length;
	do_div(tick_length_base, NTP_INTERVAL_FREQ);


The above is basically (X + part of ntp_adjustment)

So I'm trying to calculate the X as: 

#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC*NSEC_PER_USEC*USER_HZ)+CLOCK_TICK_ADJUST)/NTP_INTERVAL_FREQ)


thanks
-john


