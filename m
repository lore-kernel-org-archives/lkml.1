Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbZB0HMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbZB0HMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZB0HMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:12:20 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:57467 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZB0HMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TA2TEqNbopCXEbUiXbj8QE8WKpZn8BkRH+fPvorPs4vmA3ERsB1bBygcPyBHkCJ3bj
         QY7evtzs2N4sqvKXsKLr37qXCO58JBaBtcn6EeqbYOutPx6E/lwYhrHENC1g2WDx8K0c
         PAFyiaj9GLSD0aQxzDNJOqdWeW3vMd0t95zMg=
Date: Fri, 27 Feb 2009 08:12:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
	3 users
Message-ID: <20090227071212.GC5318@nowhere>
References: <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere> <20090226224656.5785de9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226224656.5785de9e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:46:56PM -0800, Andrew Morton wrote:
> On Fri, 27 Feb 2009 07:19:37 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 
> > An new optimization is making its way to ftrace. Its purpose is to
> > make ftrace_printk() consuming less memory and be faster.
> > 
> > Written by Lai Jiangshan, the approach is to delay the formatting
> > job from tracing time to output time.
> > Currently, a call to ftrace_printk will format the whole string and
> > insert it into the ring buffer.
> 
> It does that?   eek.
> 
> > Then you can read it on /debug/tracing/trace
> > file.
> > 
> > The new implementation stores the address of the format string and
> > the binary parameters into the ring buffer, making the packet more compact
> > and faster to insert.
> > Later, when the user exports the traces, the format string is retrieved
> > with the binary parameters and the formatting job is eventually done.
> > 
> > Here is the result of a small comparative benchmark while putting the following
> > ftrace_printk on the timer interrupt. ftrace_printk is the old implementation,
> > ftrace_bprintk is a the new one:
> > 
> > ftrace_printk("This is the timer interrupt: %llu", jiffies_64);
> > 
> > After some time running on low load (no X, no really active processes):
> > 
> > ftrace_printk:  duration average: 2044 ns, avg of bytes stored per entry: 39
> > ftrace_bprintk: duration average: 1426 ns, avg of bytes stored per entry: 16
> > 
> > Higher load (started X and launched a cat running on an X console looping on
> > traces printing):
> > 
> > ftrace_printk:  duration average: 8812 ns
> > ftrace_bprintk: duration average: 2611 ns
> > 
> > Which means the new implementation can be 70 % faster on higher load.
> > And it consumes lesser memory on the ring buffer.
> > 
> > The curent implementation rewrites a lot of format decoding bits from
> > vsnprintf() function, making now 3 differents functions to maintain
> > in their duplicated parts of printf format decoding bits.
> 
> <looks for ftrace_bprintk() in linux-next, fails>


It hasn't been applied for now, waiting for this cleanup.
Grr, I can't find an http link for the patchset...
 

> Why does the current ftrace_bprintk() need to hack around in (or
> duplicate) vprintk() internals?  It's a bit grubby, but by placing an
> upper bound on the number of args, it could simply call vscnprintf()
> directly?
>

The problem is more in the way to save the parameters.

You have two functions:

_int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args)


This one creates a compact binary packet of all args described in the format.
The result is a binary set of random values on bin_buf.


_int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)


This one lately parses the buffer filled by vbin_printf() and eventually format
this binary contiguous set of binary values according to the format in fmt (which is the
same that was passed to vbin_printf()
The result is formatted in buf.

vbin uses too much specific write-to-bin_buf operations to allow us to wrap
vsnprintf()

It's the same for bstr_printf, but in the read from buffer way.

