Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZBZNDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZBZNDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBZNDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:03:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZBZNDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:03:06 -0500
Date: Thu, 26 Feb 2009 14:02:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] add binary printf
Message-ID: <20090226130243.GA22460@elte.hu>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a38304.0506d00a.1f4b.406d@mx.google.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Impact: Add APIs for binary trace printk infrastructure
> 
> vbin_printf(): write args to binary buffer, string is copied
> when "%s" is occurred.
> 
> bstr_printf(): read from binary buffer for args and format a string
> 
> [fweisbec@gmail.com: ported to latest -tip]
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/string.h |    7 +
>  lib/Kconfig            |    3 +
>  lib/vsprintf.c         |  442 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 452 insertions(+), 0 deletions(-)

OK, it's a nice idea and speedup for printf based tracing - 
which is common and convenient. Would you mind to post the 
performance measurements you've done using the new bstr_printf() 
facility? (the nanoseconds latency figures you did in the timer 
irq in a system under load and on a system that is idle)

The new printf code itself should be done cleaner i think and is 
not acceptable in its current form.

These two new functions:

> +#ifdef CONFIG_BINARY_PRINTF
> +/*
> + * bprintf service:
> + * vbin_printf() - VA arguments to binary data
> + * bstr_printf() - Binary data to text string
> + */

Duplicate hundreds of lines of code into three large functions 
(vsnprintf, vbin_printf, bstr_printf). These functions only have 
a difference in the way the argument list is iterated and the 
way the parsed result is stored:

  vsnprintf:   iterates va_list, stores into string
  bstr_printf: iterates bin_buf, stores into string
  vbin_printf: iterates va_list, stores into bin_buf

We should try _much_ harder at unifying these functions before 
giving up and duplicating them...

An opaque in_buf/out_buf handle plus two helper function 
pointers passed in would be an obvious implementation.

That way we'd have a single generic (inline) function that knows 
about the printf format itself:

 __generic_printf(void *in_buf,
		  void *out_buf,
		  void * (*read_in_buf)(void **),
		  void * (*store_out_buf)(void **));

And we'd have various variants for read_in_buf and 
store_out_buf. The generic function iterates the following way:

	in_val = read_in_buf(&in_buf);
	...
	store_out_buf(&out_buf, in_val);

(where in_val is wide enough to store a single argument.) The 
iterators modify the in_buf / out_buf pointers. Argument 
skipping can be done by reading the in-buf and not using it. I 
think we can do it with just two iterator methods.

Or something like that - you get the idea. It can all be inlined 
so that we'd end up with essentially the same vsnprint() 
instruction sequence we have today.

	Ingo
