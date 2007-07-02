Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbXGBQmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbXGBQmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 12:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXGBQmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 12:42:15 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:29208 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754601AbXGBQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 12:42:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=maRBndPigZbNHkeSHigxrlb2nEKPHew1aPSB44kEVbEtWXEF2TfUyfVz+pBpFlkBiUNNJGN2BzFT1fUW3IbDTMXTOu8X/zXQbUWcgwhogCLApbKxDEY3+pT93ymG+i582jzoYOfFvjqN98o0z7ACDOz0FcUFZqD7FHnenwbKFOY=  ;
X-YMail-OSG: yVpCDfYVM1kSVQSn_nB32RBTgNTvo68XvC63BePm5j44ayb0XFDjZl_Jn33HTV4LMQrbD_E54Q--
From: David Brownell <david-b@pacbell.net>
To: Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: [BUG] clockevents : clockevent_delta2ns usage
Date: Mon, 2 Jul 2007 09:42:10 -0700
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "Remy Bohmer" <l.pinguin@gmail.com>
References: <200707021043.39617.marc.pignat@hevs.ch>
In-Reply-To: <200707021043.39617.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707020942.10744.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2007, Marc Pignat wrote:
> Hello all!
> 
> We're currently working with David Brownell and Remy Bohmer on implementation
> of clocksource/events on the at91rm9200 processor (arm arch).
> 
> While debugging our implementation, we came about a rounding problem, in the
> setting of min_delta_ns field, and I think it can be in almost all clock_event_device.
> 
> Almost all clock_event_device initialize the field min_delta_ns this way:
> 	clkevt32k.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, clkevt32k.shift);
> 	clkevt32k.max_delta_ns = clockevent_delta2ns(0x000fffff, &clkevt32k);
> 	clkevt32k.min_delta_ns = clockevent_delta2ns(1, &clkevt32k);
> 
> The clockevent_delta2ns function rounds the result down, so the rounded min_delta_ns
> can be smaller than the real min_delta_ns.

For concrete numbers:  CLOCK_TICK_RATE = 32768, making 30517.58 nsec
per tick  But min_delta_ns becomes 30517.  (And the shift is 32 bits;
in-kernel docs could stand to include guidance about how to choose
a good shift value.)


> When clockevents_program_event is called, this rounding problem shows up:
> ...
> 	if (delta < dev->min_delta_ns)
> 		delta = dev->min_delta_ns;
> 
> 	clc = delta * dev->mult;
> 	clc >>= dev->shift;
> 
> 	return dev->set_next_event((unsigned long) clc, dev)
> 
> When delta is to small, min_delta_ns will be used, and with a wrong rounding,
> will call set_next_event with a value smaller than the expected, and 
> set_next_event will fail.

Will be passed a value of zero, that is -- rather troublesome.
 

> This will result in an infinite loop when clockevents_program_event is called
> from tick_program_event with a too short delay.

Unless zero ticks gets special cased to return -ETIME and then the
backup strategies kick in, eventually asking for more ticks...

 
> In our driver, we fixed this problem using that:
> -	clkevt32k.min_delta_ns = clockevent_delta2ns(1, &clkevt32k);
> +	clkevt32k.min_delta_ns = clockevent_delta2ns(1, &clkevt32k)+1;
> 
> I think other clock_event_device can have the same problem.
> 
> Regards
> 
> Marc
> 


