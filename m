Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYLLI0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYLLI0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYLLIZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:25:56 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:52082 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYLLIZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:25:55 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] Performance Counters for Linux, v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 09:25:45 +0100
Message-Id: <1229070345.12883.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 13:02 -0500, Vince Weaver wrote:

> I have at least 60 machines that I do regular performance counter work on. 
> They involve Pentium Pro, Pentium II, 32-bit Athlon, 64-bit Athlon, 
> Pentium 4, Pentium D, Core, Core2, Atom, MIPS R12k, Niagara T1, 
> and PPC/Playstation 3.

Good.

> Perfmon3 works for all of those 60 machines.  This new proposal works on a 
> 2 out of the 60.

s/works/is implemented/

> Who is going to add support for all of those machines?  I've spent a lot 
> of developer time getting prefmon going for all of those configurations. 
> But why should I help out with this new inferior proposal?  It could all 
> be another waste of time.

So much for constructive critisism.. have you tried taking the design to
its limits, if so, where do you see problems?

I read the above as: I invested a lot of time in something of dubious
statue (out of tree patch), and now expect it to be merged because I
have invested in it.

> Also, my primary method of using counters is total aggregate count for a 
> single user-space process. 

Process, as in single thread, or multi-threaded? I'll assume
single-thread.

> Can this new infrastructure to this? 

Yes, afaict it can.

You can group counters in v3, a read out of such a group will be an
atomic read out and provide vectored output that contains all the data
in one stream.

> I find the documentation/tools support to be very incomplete.

Gosh, what does one expect from something that is hardly a week old..

> One comment on the patch.
>
> > +	/*
> > +	 * Common hardware events, generalized by the kernel:
> > +	 */
> > +	PERF_COUNT_CYCLES		=  0,
> > +	PERF_COUNT_INSTRUCTIONS		=  1,
> > +	PERF_COUNT_CACHE_REFERENCES	=  2,
> > +	PERF_COUNT_CACHE_MISSES		=  3,
> > +	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
> > +	PERF_COUNT_BRANCH_MISSES	=  5,
> 
> Many machines do not support these counts.  For example, Niagara T1 does 
> not have a CYCLES count.  And good luck if you think you can easily come 
> up with something meaningful for the various kind of CACHE_MISSES on the 
> Pentium 4.  Also, the Pentium D has various flavors of retired instruction 
> count with slightly different semantics.  This kind of abstraction should 
> be done in userspace.

I'll argue to disagree, sure such events might not be supported by any
particular hardware implementation - but the fact that PAPI gives a list
of 'common' events means that they are, well, common. So unifying them
between those archs that do implement them seems like a sane choice, no?

For those archs that do not support it, it will just fail to open. No
harm done.

The proposal allows for you to specify raw hardware events, so you can
just totally ignore this part of the abstraction.

