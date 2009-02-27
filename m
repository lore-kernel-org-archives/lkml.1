Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZB0Icl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZB0Icl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZB0Icc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:32:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZB0Icb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:32:31 -0500
Date: Fri, 27 Feb 2009 09:32:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
	3 users
Message-ID: <20090227083212.GE3609@elte.hu>
References: <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere> <20090226224656.5785de9e.akpm@linux-foundation.org> <20090227071212.GC5318@nowhere> <20090226233950.0cfcf883.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226233950.0cfcf883.akpm@linux-foundation.org>
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

> On Fri, 27 Feb 2009 08:12:13 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > Why does the current ftrace_bprintk() need to hack around in (or
> > > duplicate) vprintk() internals?  It's a bit grubby, but by placing an
> > > upper bound on the number of args, it could simply call vscnprintf()
> > > directly?
> > >
> > 
> > The problem is more in the way to save the parameters.
> > 
> > You have two functions:
> > 
> > _int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args)
> > 
> > 
> > This one creates a compact binary packet of all args described in the format.
> > The result is a binary set of random values on bin_buf.
> > 
> > 
> > _int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
> > 
> > 
> > This one lately parses the buffer filled by vbin_printf() and eventually format
> > this binary contiguous set of binary values according to the format in fmt (which is the
> > same that was passed to vbin_printf()
> > The result is formatted in buf.
> > 
> > vbin uses too much specific write-to-bin_buf operations to 
> > allow us to wrap vsnprintf()
> 
> I don't know what vbin is.

a printf variant that outputs not into a string buffer but into 
a binary-values buffer. See earlier mails in this same thread. 
(I Cc:-ed you mid-thread on the assumption that you might be 
interested - but you need to look into the lkml folder to see 
all the context.)

> On little-endian architecture you could do something like
> 
> 	u32 *p = bin_buf;
> 	char *fmt;
> 	u32 a0, a1, a2, a3, a4;
> 
> #ifdef CONFIG_32BIT
> 	fmt = (char *)(*bin_buf++);
> #else
> 	<exercise for the reader>
> #endif
> 
> 	a0 = *bin_buf++;
> 	a1 = *bin_buf++;
> 	a2 = *bin_buf++;
> 	a3 = *bin_buf++;
> 	a4 = *bin_buf++;
> 
> 	snprintf(somewhere, some_size, fmt, a0, a1, a2, a3, a4, a5);
> 
> (as I said, ugly).

Yes, and slow as well. This isnt new functionality - this is 
about speedups, using the format string as a data types 
descriptor.

The goal is to get the speedup that Frederic cited:

  ftrace_printk:  duration average: 8812 ns
  ftrace_bprintk: duration average: 2611 ns

The _fastest_ way of tracing is obviously to know about the 
precise argument layout and having a specific C based tracepoint 
stub that directly stuffs that data into the ring buffer. Most 
tracepoints are of such nature.

That does not remove the ease of use of ad-hoc printk-alike 
tracepoints though, and speeding them up 3-fold is a worthwile 
goal.

> but that won't work for 64-bit values on big-endian 
> architectures.  And it's hacky (and might not even work) for 
> 64-bit on little endian.
> 
> Perhaps this is the secret problem which you haven't described 
> yet?

The first submission was a completely standalone implementations 
not touching vsnprintf at all. I suggested to Frederic to try to 
generalize it, to reduce code duplication. That's why this patch 
touches vsnprintf.

We can do it all in kernel/trace/trace.c if the lib/vsnprintf.c 
bits turn out to be ugly or not useful enough. We just thought 
we'd try to make this more generally useful before stuffing it 
into a specific subsystem.

	Ingo
