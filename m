Return-Path: <linux-kernel-owner+w=401wt.eu-S933251AbYBURJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbYBURJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 12:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760141AbYBURJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 12:09:05 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:4849 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbYBURJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 12:09:03 -0500
Message-Id: <47BD684C.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 21 Feb 2008 10:02:20 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <rostedt@goodmis.org>, <kevin@hilman.org>, <tglx@linutronix.de>,
       <cminyard@mvista.com>, <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <gregkh@suse.de>, <npiggin@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout
	mechanism
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
 <20080221152707.4804.59177.stgit@novell1.haskins.net>
 <200802211741.10299.ak@suse.de>
In-Reply-To: <200802211741.10299.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Thu, Feb 21, 2008 at 11:41 AM, in message <200802211741.10299.ak@suse.de>,
Andi Kleen <ak@suse.de> wrote: 

>> +config RTLOCK_DELAY
>> +	int "Default delay (in loops) for adaptive rtlocks"
>> +	range 0 1000000000
>> +	depends on ADAPTIVE_RTLOCK
> 
> I must say I'm not a big fan of putting such subtle configurable numbers
> into Kconfig. Compilation is usually the wrong place to configure
> such a thing. Just having it as a sysctl only should be good enough.
> 
>> +	default "10000"
> 
> Perhaps you can expand how you came up with that default number? 

Actually, the number doesn't seem to matter that much as long as it is sufficiently long enough to make timeouts rare.  Most workloads will present some threshold for hold-time.  You generally get the best performance if the value is at least as "long" as that threshold.  Anything beyond that and there is no gain, but there doesn't appear to be a penalty either.  So we picked 10000 because we found it to fit that criteria quite well for our range of GHz class x86 machines.  YMMY, but that is why its configurable ;)

> It looks suspiciously round and worse the actual spin time depends a lot on 
> the 
> CPU frequency (so e.g. a 3Ghz CPU will likely behave quite 
> differently from a 2Ghz CPU) 

Yeah, fully agree.  We really wanted to use a time-value here but ran into various problems that have yet to be resolved.  We have it on the todo list to express this in terms in ns so it at least will scale with the architecture.

> Did you experiment with other spin times?

Of course ;)

> Should it be scaled with number of CPUs?

Not to my knowledge, but we can put that as a research "todo".

> And at what point is real
> time behaviour visibly impacted? 

Well, if we did our jobs correctly, RT behavior should *never* be impacted.  *Throughput* on the other hand... ;)

But its comes down to what I mentioned earlier. There is that threshold that affects the probability of timing out.  Values lower than that threshold start to degrade throughput.  Values higher than that have no affect on throughput, but may drive the cpu utilization higher which can theoretically impact tasks of equal or lesser priority by taking that resource away from them.  To date, we have not observed any real-world implications of this however.

> 
> Most likely it would be better to switch to something that is more
> absolute time, like checking RDTSC every few iteration similar to what
> udelay does. That would be at least constant time.

I agree.  We need to move in the direction of time-basis.  The tradeoff is that it needs to be portable, and low-impact (e.g. ktime_get() is too heavy-weight).  I think one of the (not-included) patches converts a nanosecond value from the sysctl to approximate loop-counts using the bogomips data.  This was a decent compromise between the non-scaling loopcounts and the heavy-weight official timing APIs.  We dropped it because we support older kernels which were conflicting with the patch. We may have to resurrect it, however..

-Greg



