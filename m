Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYKZCTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYKZCTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYKZCTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:19:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYKZCTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:19:24 -0500
Date: Tue, 25 Nov 2008 21:19:21 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable
 output
In-Reply-To: <20081126020459.GA16374@elte.hu>
Message-ID: <alpine.DEB.1.10.0811252113270.26424@gandalf.stny.rr.com>
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu> <20081126020459.GA16374@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Ingo Molnar wrote:
> 
> The changes would be:
> 
> 1) Compression of non-nested calls into a single line.
> 
>    Implementing this probably necessiates some trickery with the
>    ring-buffer: we'd have to look at the next entry as well and see 
>    whether it closes the function call.

The latency_trace file does this already:

You can look into the trace buffer without moving it with:

  entry = ring_buffer_iter_peek(iter->buffer_iter[iter->cpu], &ts);

where, ts will give you the time stamp, it can be NULL if you do not care.

When your print function is called, the item in the ring buffer has 
already been consumed. So the peek will give you the next item in the ring 
buffer.

> 
> 2) Adding a closing ';' semicolon to single-line calls. It's the C 
>    syntax and i'm missing it :-)
> 
> 3) The first column: single-character visual shortcuts for "overhead". 
>    This is a concept we used in the -rt tracer and it still lives in 
>    the latency tracer bits of ftrace and is quite useful:
> 
>     '+' means "overhead spike": overhead is above 10 usecs.
>     '!' means "large overhead": overhead is above 100 usecs.
> 
>    These give at-a-glance hotspot analysis - hotspots are easier to 
>    miss as pure numbers.

The latency_trace file has this too. And it uses the above peek to figure 
it out ;-)

> 
> 4) Printing out in units of microseconds, with a decimal point and by
>    explicitly mentioning the 'us' unit.
> 
>    All of these are important properties: microseconds is still the 
>    most common 'overhead' unit in kernel circles. It also gives rather 
>    human single-digit or two-digit results. Nanoseconds is three or- 
>    four-digit - which is too much. Repeating 'us' so many times is not 
>    a problem - these lines will be grepped, quoted, etc - constant 
>    reminder about the unit is just fine.
> 
> 5) Nesting the overhead numbers aligned to the right end of the graph. 
>  
>    This cleans up the view of the source code printout, but not 
>    cluttering it with numbers. It also structures the numbers some 
>    more. Visual cues are given via '-' and '+' signs, to follow 
>    nesting. This nesting aligns up with the function nesting levels on 
>    the left side - so it's easy to pair up number and function name. 
>    It also separates the numbers from the symbol length effects in the 
>    single-line case. (which is the most common trace line)
> 
> What do you think? It's lots of work (sorry! :-), but it would produce 
> even more stunning graph-tracer output IMO.

I like it, and I hope Frederic has enough time on his hands to do it ;)

-- Steve

