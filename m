Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZB0JgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZB0JgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZB0Jf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:35:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZB0Jf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:35:58 -0500
Date: Fri, 27 Feb 2009 10:35:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
	3 users
Message-ID: <20090227093531.GA24674@elte.hu>
References: <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere> <20090226224656.5785de9e.akpm@linux-foundation.org> <20090227071212.GC5318@nowhere> <20090226233950.0cfcf883.akpm@linux-foundation.org> <20090227083212.GE3609@elte.hu> <20090227004513.f53ed532.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227004513.f53ed532.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 27 Feb 2009 09:32:12 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > a printf variant that outputs not into a string buffer but 
> > into a binary-values buffer.
> 
> Oh, OK.
> 
> Of course, parsing a printf string (using our 
> nobody-bothered-optimising-it parser) isn't particularly 
> efficient either.
> 
> Is there a case here for adding a new way of describing how to 
> serialise the incoming data?  Perhaps with a new and simpler 
> control string or perhaps even
> 
> 	struct ftrace_thing ft;
> 
> 	init_ftrace_thing(&ft, "%d %l %s");
> 	add_ftrace_thing_int(&ft, some_int);
> 	add_ftrace_thing_long(&ft, some_long);
> 	add_ftrace_thing_string(&ft, some_string);
> 	emit_ftrace_thing(&ft);
> 
> or some similar thing.

Maybe - but i think it misses the main point.

If we care about a tracepoint from a performance POV we wont use 
printf. When it comes to raw performance then we already have 
direct, non-string ways of describing data: the C language and 
function calls straight to a tracepoint function. No "inbetween" 
solution will be able to beat that.

The beauty (and pretty much only point) of trace_printk() is the 
convenience of the well-known printf usage. It might be slow to 
parse but it is what we are using in:

  earth4:~/tip> git grep printk | wc -l
  68603

... tens of thousands of places in the kernel.

We could invent something inbetween but why? We wont be able to 
beat the performance of tracepoints that leave out the format 
string middle-man, and we dont want to.

So what Lai and Frederic is trying is to offer a transparent 
speedup for trace_printk().

	Ingo
