Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbXFZPp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbXFZPp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXFZPpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:45:51 -0400
Received: from www.osadl.org ([213.239.205.134]:53869 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753231AbXFZPpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:45:50 -0400
Subject: Re: Dynamic ticks make system jerking
From: Thomas Gleixner <tglx@linutronix.de>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070626150015.GA20233@informatik.uni-freiburg.de>
References: <20070626150015.GA20233@informatik.uni-freiburg.de>
Content-Type: text/plain; charset=utf-8
Date: Tue, 26 Jun 2007 17:45:49 +0200
Message-Id: <1182872749.11854.27.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 17:00 +0200, Uwe Kleine-König wrote:
> If I enable NO_HZ, the system jerks (I hope this is an understandable
> term ...).   E.g. 
> 
> 	# time find /sys
> 	...
> 	real    1m 19.52s
> 	user    0m 0.18s
> 	sys     0m 0.15s
> 
> on a freshly booted machine.  The output comes in several hunks with
> pausing between them.  With no_hz=off, I get approx. the same.

it's nohz=off not no_hz=off

> If I have NO_HZ disabled however, I get
> 
> 	# time find /sys
> 	...
> 	real    0m 1.53s
> 	user    0m 0.15s
> 	sys     0m 0.18s

Well, you run in periodic mode then.

> Another thing is, if I press Enter once, the next prompt appears in a
> reasonable time.  If I press twice in a row the 2nd prompt needs
> perceptible longer.
> 
> Does someone have a hint for me how to debug (or even solve) this problem?
> 
> First I wondered why set_next_event is called twice between two timer
> interrupts most of the time.  I found out that the timer is programed
> for the next tick in any case and if nothing needs the next tick, the
> interval is enlarged.  I didn't spend time yet to check if it is
> easier/faster to only program the timer once.

We optimize for the non-idle path, i.e. we keep the timer running as
long as we are not idle. Once we go idle we reprogram it.

I looked at the patch and as far as I can understand it, there is
nothing obviously wrong about it.

One remark: why did you expand the clocksource to be 64 bit? The generic
code handles the 32 bit wrap already, so the expansion in your read
routine is adding overhead. The counter will wrap every 24 seconds, so
there is nothing to worry about.

The behavior you are describing is might be related to some problem with
the clocksource readout, as the reprogramming values are calculated from
there. 

	tglx




