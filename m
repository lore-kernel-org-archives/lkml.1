Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZKWRTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZKWRTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZKWRTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:19:40 -0500
Received: from www.tglx.de ([62.245.132.106]:46580 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbZKWRTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:19:39 -0500
Date: Mon, 23 Nov 2009 18:19:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       alan@linux.intel.com
Subject: Re: [patch] timer: Add a mod_timer_msec() API function
In-Reply-To: <20091123065108.1fd78779@infradead.org>
Message-ID: <alpine.LFD.2.00.0911231728200.24119@localhost.localdomain>
References: <20091122154111.197e1a8a@infradead.org> <20091123082648.GB13186@elte.hu> <20091123065108.1fd78779@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Arjan van de Ven wrote:
> On Mon, 23 Nov 2009 09:26:48 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > This code first rounds to 1 second - and if that doesnt fall within
> > the slack window it rounds to the (rather aribtrary) rounding of 16
> > jiffies.
> > 
> > I'd suggest to use up the slack to its maximum, by rounding up modulo 
> > the largest power-of-2 value that still fits into the slack.
> > 
> > So if slack is 30, the rounding is 16. If slack is 5, the rounding is
> > 4, etc.
> 
> well.. the point of the rounding is that there is a maximum likelyhood
> that OTHER timers align.
> 
> I suppose what you suggest would do that too; need to think of a clever
> way to not make that expensive
> (after coffee I'll look at if xor + find first bit will work ;-)

I think we need to rethink the timer wheel subsystem in general
instead of adding more and more fancy interfaces.

Looking at the examples you provided for mod_timer_msec() I noticed
that most of the slack values you chose are between 10% and 20% of the
timeout.

That means the larger the timeout the less interesting is the accuracy
which makes a lot of sense.

I really wonder whether there is any timer_list user which has the
need for large and precise timeouts. If not we could simplify the
whole timer wheel business radically and get rid of the worst thing in
it: recascading.

That's what I have in mind:

    	       timeout    accuracy
array0	  <    0.256 s        1 ms
array1	  <    2.560 s       40 ms
array2	  <   25.600 s      400 ms
array3	  <  256.000 s     4000 ms
array4	  >= 256.000 s    40000 ms 

Similar to the current timer wheel, but instead of recascading on
every wraparound of the array0 index we could expire the timers in
array1-4 in their accuracy interval which aligns them automatically
without any slack and rounding business on timer insertion.

The exact array definitions need of course more thought, but you get
the idea.

Such an implementation would also simplify the search for the next
expiring timer as we could keep track of empty/non-empty buckets with
an additional per array bitfield.

If there are a few timers which really need large and precise timeouts
its easy enough to switch them over to hrtimers.

Thoughts ?

Thanks,

	tglx
