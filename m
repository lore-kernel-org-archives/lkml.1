Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbXF2WdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbXF2WdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbXF2WdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:33:10 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:42208 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143AbXF2WdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:33:09 -0400
Date: Sat, 30 Jun 2007 00:33:03 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Dynamic ticks make system jerking
Message-ID: <20070629223303.GA26926@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20070626150015.GA20233@informatik.uni-freiburg.de> <1182872749.11854.27.camel@chaos> <20070627163529.GA12978@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070627163529.GA12978@informatik.uni-freiburg.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Uwe Kleine-König wrote:
> > it's nohz=off not no_hz=off
> Currently I'm not sure, which I was really using.  I think it was the
> right one, because dmesg changed.  But anyhow, I will retest if I made
> it wrong.
OK, I was really using no_hz, and with nohz I got approx the same result
as with CONFIG_NO_HZ=n.  Uups.

> > > First I wondered why set_next_event is called twice between two timer
> > > interrupts most of the time.  I found out that the timer is programed
> > > for the next tick in any case and if nothing needs the next tick, the
> > > interval is enlarged.  I didn't spend time yet to check if it is
> > > easier/faster to only program the timer once.
> > 
> > We optimize for the non-idle path, i.e. we keep the timer running as
> > long as we are not idle. Once we go idle we reprogram it.
> OK, sounds sane.
Probably you understand that better, but your argument only convinced me
for a short time.  Is it really better to program at least once and in
the idle case a 2nd time instead of only once every time.  Moreover
if you program the timer late you can notice if the time to tick is
already over because the timer irq handling took to long (or CONFIG_HZ
is too large).

> > I looked at the patch and as far as I can understand it, there is
> > nothing obviously wrong about it.
> What a pity.
I found the problem, it had only indirectly to do with nohz.  I didn't
acknowledge the serial interrupt but as the timer and the serial need
the same acknowledgement the serial irq got his ack always when the
timer triggerd.  Up to now that delay didn't stick out as the delay was
< 10ms.

> > One remark: why did you expand the clocksource to be 64 bit? The generic
> > code handles the 32 bit wrap already, so the expansion in your read
> > routine is adding overhead. The counter will wrap every 24 seconds, so
> > there is nothing to worry about.
> OK, I thought it to be better to have 64bit + some overhead.  I will
> change that.
done.  (But I reserve the right to evaluate the 64bit case and check how
worse the overhead is :-)

Best regards
Uwe

-- 
Uwe Kleine-König

http://www.google.com/search?q=sin%28pi%2F2%29
