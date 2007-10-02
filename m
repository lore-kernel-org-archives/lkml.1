Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXJBWdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXJBWdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbXJBWd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:33:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbXJBWd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:33:27 -0400
Date: Tue, 2 Oct 2007 15:32:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Anders Bostr?m <anders@bostrom.dyndns.org>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com
Subject: Re: PROBLEM: high load average when idle
In-Reply-To: <20071002150748.906970bc.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
 <20071002150748.906970bc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Oct 2007, Andrew Morton wrote:
> 
> This is unexpected.  High load average is due to either a task chewing a
> lot of CPU time or a task stuck in uninterruptible sleep.

Not necessarily.

We saw high loadaverages with the timer bogosity with "gettimeofday()" and 
"select()" not agreeing, so they would do things like

	date = time(..)
	select(.. , timeout = <time + 1> )

and when "date" wasn't taking the jiffies offset into account, and thus 
mixing these kinds of different time sources, the select ended up 
returning immediately because they effectively used different clocks, and 
suddenly we had some applications chewing up 30% CPU time, because they 
were in a loop that *tried* to sleep.

And I wonder if the same kind thing is effectively happening here: the 
code is written so that it *tries* to sleep, but the rounding of the clock 
basically means that it's trying to sleep using a different clock than the 
one we're using to wake things up with, so some percentage of the time it 
doesn't sleep at all!

I wonder if the whole "round_jiffies()" thing should be written so that it 
never rounds down, or at least never rounds down to before the current 
second!

I have to say, I also think it's a bit iffy to do "round_jiffies()" at all 
in that per-CPU kind of way. The "per-cpu" thing is quite possibly going 
to change by the time we actually add the timer, so the goal of trying to 
get wakeups to happen in "bunches" per CPU should really be done by 
setting a flag on the timer itself - so that we could do that rounding 
when the timer is actually added to the per-cpu queues!

Now, I think the JBD "t_expires" field should never be "near" in seconds, 
so I do find it a bit surprising that this rounding can have any effect, 
but on the other hand it clearly *does* have some effect, so.. It migt 
just be interacting with some other use, of course.

		Linus
