Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbXLCVje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbXLCVje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXLCVjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:39:14 -0500
Received: from rtr.ca ([76.10.145.34]:3344 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXLCVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:39:12 -0500
Message-ID: <4754777F.7020302@rtr.ca>
Date: Mon, 03 Dec 2007 16:39:11 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
Cc: davids@webmaster.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
References: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com> <47545F88.6070609@nortel.com>
In-Reply-To: <47545F88.6070609@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> David Schwartz wrote:
>> Chris Friesen wrote:
..
>>> The problem is where do we insert the task that is yielding?  CFS is
>>> based around a tree structure ordered by time.
> 
>> We put it exactly where we would have when its timeslice ran out. If 
>> we can
>> reward it a little bit, that's great. But if not, we can live with that.
>> Just imagine that the timer interrupt fired to indicate the end of the
>> thread's run time when the thread called 'sched_yield'.
> 
> CFS doesn't really do "timeslice".  But in essence what you are 
> describing is the default behaviour currently...it simply removes the 
> task from the tree and reinserts it based on how much cpu time it used up.
> 
>> Then what does he do when the task runs out of run time? It's hard to
>> imagine we can't do that when the task calls sched_yield.
> 
> It gets reinserted into the tree at a position based on how much cpu 
> time it used.  This is exactly the current sched_yield() behaviour.
..

That's not the same thing at all.
I think that David is suggesting that the reinsertion logic
should pretend that the task used up all of the CPU time it
was offered in the slot leading up to the sched_yield() call.

If it did that, then the task would be far more likely not to
end up as the next task chosen to run.

Without doing that, the task is highly likely to be chosen
to run again immediately, as it will appear to have done
nothing since it was previously chosen -- and so the same 
criteria will result in it being chosen again, and again,
and again, until it finally wastes enough cycles to not
be reinserted into the "currently active" slot of the tree.

Cheers
