Return-Path: <linux-kernel-owner+w=401wt.eu-S1766686AbXDSNUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766686AbXDSNUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766692AbXDSNUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:20:13 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:25609 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766686AbXDSNUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:20:11 -0400
Message-ID: <46276C83.40608@bigpond.net.au>
Date: Thu, 19 Apr 2007 23:20:03 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <462763A4.8080601@bigpond.net.au>
In-Reply-To: <462763A4.8080601@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Thu, 19 Apr 2007 13:20:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Con Kolivas wrote:
>> Ok, there are 3 known schedulers currently being "promoted" as solid 
>> replacements for the mainline scheduler which address most of the 
>> issues with mainline (and about 10 other ones not currently being 
>> promoted). The main way they do this is through attempting to maintain 
>> solid fairness. There is enough evidence mounting now from the 
>> numerous test cases fixed by much fairer designs that this is the way 
>> forward for a general purpose cpu scheduler which is what linux needs.
>> Interactivity of just about everything that needs low latency (ie 
>> audio and video players) are easily managed by maintaining low latency 
>> between wakeups and scheduling of all these low cpu users.
> 
> On a "fair" scheduler these will all get high priority (and good 
> response) because their CPU bandwidth usage will be much smaller than 
> their entitlement and the scheduler will be trying to help them "catch 
> up".  So (as you say) they shouldn't be a problem.
> 
>> The one fly in the ointment for linux remains X. I am still, to this 
>> moment, completely and utterly stunned at why everyone is trying to 
>> find increasingly complex unique ways to manage X when all it needs is 
>> more cpu[1]. Now most of these are actually very good ideas about 
>> _extra_ features that would be desirable in the long run for linux, 
>> but given the ludicrous simplicity of renicing X I cannot fathom why 
>> people keep promoting these alternatives. At the time of 2.6.0 coming 
>> out we were desparately trying to get half decent interactivity within 
>> a reasonable time frame to release 2.6.0 without rewiring the whole 
>> scheduler. So I tweaked the crap out of the tunables that were already 
>> there[2].
> 
> X's needs are more complex than that (from my observations) in that the 
> part of X that processes input doesn't use much CPU but the part that 
> does output can be quite a heavy user of CPU (e.g. do a "ls -lR /" in an 
> xterm and watch X chew up the CPU).  At the same time, the part of X 
> that processes input needs quick responsiveness as it's part of the 
> interactive chain where this is less so for the output part.
> 
> Where X comes unstuck in the current scheduler is that when the output 
> part goes on one of its CPU storms it ceases to look like an interactive 
> task and gets given lower priority.  Ironically, this doesn't effect the 
> output part of X but it does effect the input part and is manifest as 
> crappy interactive response.  One wonders whether modifying X so that it 
> has two threads: one for output and one for input; that could be 
> scheduled separately might help.  I guess it would depend on whether 
> there is insufficient independence between the two halves.

I forgot to make my point here and that was that if X could be split in 
two neither half would need to be reniced.  As a very low CPU bandwidth 
user the input half would get along just fine like the other interactive 
tasks that you mention.  And the output put part isn't adversely 
effected by not having a boost so it would get along just fine as well 
and you don't want it having a boost when it's in a CPU storm anyway.

Of course, if the interdependence between the two halves is such that 
the equivalent of priority inversion occurs between the two threads. 
However, that might be solved by making the division between the two 
halves on a dimension other than the input/output one.

Peter
PS I think that the tasks most likely to be adversely effected by X's 
CPU storms (enough to annoy the user) are audio streamers so when you're 
doing tests to determine the best nice value for X I suggest that would 
be a good criterion.  Video streamers are also susceptible but glitches 
in video don't seem to annoy users as much as audio ones.
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
