Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXJBWq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXJBWq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXJBWqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:46:20 -0400
Received: from rtr.ca ([76.10.145.34]:3418 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbXJBWqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:46:19 -0400
Message-ID: <4702CA3A.50600@rtr.ca>
Date: Tue, 02 Oct 2007 18:46:18 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: PROBLEM: high load average when idle
References: <20071002.233731.119908363.anders@bostrom.dyndns.org> <20071002150748.906970bc.akpm@linux-foundation.org> <alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 2 Oct 2007, Andrew Morton wrote:
>> This is unexpected.  High load average is due to either a task chewing a
>> lot of CPU time or a task stuck in uninterruptible sleep.
> 
> Not necessarily.
> 
> We saw high loadaverages with the timer bogosity with "gettimeofday()" and 
> "select()" not agreeing, so they would do things like
> 
> 	date = time(..)
> 	select(.. , timeout = <time + 1> )
> 
> and when "date" wasn't taking the jiffies offset into account, and thus 
> mixing these kinds of different time sources, the select ended up 
> returning immediately because they effectively used different clocks, and 
> suddenly we had some applications chewing up 30% CPU time, because they 
> were in a loop that *tried* to sleep.
> 
> And I wonder if the same kind thing is effectively happening here: the 
> code is written so that it *tries* to sleep, but the rounding of the clock 
> basically means that it's trying to sleep using a different clock than the 
> one we're using to wake things up with, so some percentage of the time it 
> doesn't sleep at all!
> 
> I wonder if the whole "round_jiffies()" thing should be written so that it 
> never rounds down, or at least never rounds down to before the current 
> second!
...

On a related note, {set/get}itimer() currently are buggy (since 2.6.11 or so),
also due to this round_jiffies() thing I believe.

If one sets ITIMER_PROF to, say, 5.000000 seconds, and then reads it back
very shortly thereafter, it will give 5.200000 seconds as the value (HZ==1000).

AFAIK, this should *never* be possible --> any read of get_itimer should never
return a value higher than the starting value.  This makes ITIMER_PROF not very
useful for measuring one's own CPU usage, for example.

Cheers
