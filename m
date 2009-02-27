Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZB0Grk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZB0Grk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZB0Gra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:47:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbZB0Gr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:47:29 -0500
Date: Thu, 26 Feb 2009 22:46:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
 3 users
Message-Id: <20090226224656.5785de9e.akpm@linux-foundation.org>
In-Reply-To: <20090227061936.GA5318@nowhere>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com>
	<20090226130243.GA22460@elte.hu>
	<20090226170524.GB5889@nowhere>
	<20090226174303.GC29439@elte.hu>
	<20090226174547.GC5889@nowhere>
	<20090226175225.GA4527@elte.hu>
	<20090226183415.GE5889@nowhere>
	<20090226185208.GA6658@nowhere>
	<20090226185635.GA12895@elte.hu>
	<20090227061936.GA5318@nowhere>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 07:19:37 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 
> An new optimization is making its way to ftrace. Its purpose is to
> make ftrace_printk() consuming less memory and be faster.
> 
> Written by Lai Jiangshan, the approach is to delay the formatting
> job from tracing time to output time.
> Currently, a call to ftrace_printk will format the whole string and
> insert it into the ring buffer.

It does that?   eek.

> Then you can read it on /debug/tracing/trace
> file.
> 
> The new implementation stores the address of the format string and
> the binary parameters into the ring buffer, making the packet more compact
> and faster to insert.
> Later, when the user exports the traces, the format string is retrieved
> with the binary parameters and the formatting job is eventually done.
> 
> Here is the result of a small comparative benchmark while putting the following
> ftrace_printk on the timer interrupt. ftrace_printk is the old implementation,
> ftrace_bprintk is a the new one:
> 
> ftrace_printk("This is the timer interrupt: %llu", jiffies_64);
> 
> After some time running on low load (no X, no really active processes):
> 
> ftrace_printk:  duration average: 2044 ns, avg of bytes stored per entry: 39
> ftrace_bprintk: duration average: 1426 ns, avg of bytes stored per entry: 16
> 
> Higher load (started X and launched a cat running on an X console looping on
> traces printing):
> 
> ftrace_printk:  duration average: 8812 ns
> ftrace_bprintk: duration average: 2611 ns
> 
> Which means the new implementation can be 70 % faster on higher load.
> And it consumes lesser memory on the ring buffer.
> 
> The curent implementation rewrites a lot of format decoding bits from
> vsnprintf() function, making now 3 differents functions to maintain
> in their duplicated parts of printf format decoding bits.

<looks for ftrace_bprintk() in linux-next, fails>

Why does the current ftrace_bprintk() need to hack around in (or
duplicate) vprintk() internals?  It's a bit grubby, but by placing an
upper bound on the number of args, it could simply call vscnprintf()
directly?

