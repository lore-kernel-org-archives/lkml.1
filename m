Return-Path: <linux-kernel-owner+w=401wt.eu-S1031052AbXDQBdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031052AbXDQBdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 21:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031053AbXDQBdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 21:33:06 -0400
Received: from qsrv01ps.mx.bigpond.com ([144.140.82.181]:46553 "EHLO
	qsrv01ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031052AbXDQBdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 21:33:05 -0400
Message-ID: <46240F22.2050209@bigpond.net.au>
Date: Tue, 17 Apr 2007 10:04:50 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415152643.GH8915@holomorphy.com> <46239C62.4090302@nortel.com>
In-Reply-To: <46239C62.4090302@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 00:04:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> William Lee Irwin III wrote:
> 
>> The sorts of like explicit decisions I'd like to be made for these are:
>> (1) In a mixture of tasks with varying nice numbers, a given nice number
>>     corresponds to some share of CPU bandwidth. Implementations
>>     should not have the freedom to change this arbitrarily according
>>     to some intention.
> 
> The first question that comes to my mind is whether nice levels should 
> be linear or not.

No. That squishes one end of the table too much.  It needs to be 
(approximately) piecewise linear around nice == 0.  Here's the mapping I 
use in my entitlement based schedulers:

#define NICE_TO_LP(nice) ((nice >=0) ? (20 - (nice)) : (20 + (nice) * 
(nice)))

It has the (good) feature that a nice == 19 task has 1/20th the 
entitlement of a nice == 0 task and a nice == -20 task has 21 times the 
entitlement of a nice == 0 task.  It's not strictly linear for negative 
nice values but is very cheap to calculate and quite easy to invert if 
necessary.

>  I would lean towards nonlinear as it allows a wider 
> range (although of course at the expense of precision).  Maybe something 
> like "each nice level gives X times the cpu of the previous"?  I think a 
> value of X somewhere between 1.15 and 1.25 might be reasonable.
> 
> What about also having something that looks at latency, and how latency 
> changes with niceness?
> 
> What about specifying the timeframe over which the cpu bandwidth is 
> measured?  I currently have a system where the application designers 
> would like it to be totally fair over a period of 1 second.

Have you tried the spa_ebs scheduler?  The half life is no longer a run 
time configurable parameter (as making it highly adjustable results in 
less efficient code) but it could be adjusted to be approximately 
equivalent to 0.5 seconds by changing some constants in the code.

>  As you can 
> imagine, mainline doesn't do very well in this case.

You should look back through the plugsched patches where many of these 
ideas have been experimented with.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
