Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbZB0Hkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbZB0Hkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZB0Hkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:40:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbZB0Hkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:40:42 -0500
Date: Thu, 26 Feb 2009 23:39:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
 3 users
Message-Id: <20090226233950.0cfcf883.akpm@linux-foundation.org>
In-Reply-To: <20090227071212.GC5318@nowhere>
References: <20090226130243.GA22460@elte.hu>
	<20090226170524.GB5889@nowhere>
	<20090226174303.GC29439@elte.hu>
	<20090226174547.GC5889@nowhere>
	<20090226175225.GA4527@elte.hu>
	<20090226183415.GE5889@nowhere>
	<20090226185208.GA6658@nowhere>
	<20090226185635.GA12895@elte.hu>
	<20090227061936.GA5318@nowhere>
	<20090226224656.5785de9e.akpm@linux-foundation.org>
	<20090227071212.GC5318@nowhere>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 08:12:13 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > Why does the current ftrace_bprintk() need to hack around in (or
> > duplicate) vprintk() internals?  It's a bit grubby, but by placing an
> > upper bound on the number of args, it could simply call vscnprintf()
> > directly?
> >
> 
> The problem is more in the way to save the parameters.
> 
> You have two functions:
> 
> _int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args)
> 
> 
> This one creates a compact binary packet of all args described in the format.
> The result is a binary set of random values on bin_buf.
> 
> 
> _int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
> 
> 
> This one lately parses the buffer filled by vbin_printf() and eventually format
> this binary contiguous set of binary values according to the format in fmt (which is the
> same that was passed to vbin_printf()
> The result is formatted in buf.
> 
> vbin uses too much specific write-to-bin_buf operations to allow us to wrap
> vsnprintf()

I don't know what vbin is.

On little-endian architecture you could do something like

	u32 *p = bin_buf;
	char *fmt;
	u32 a0, a1, a2, a3, a4;

#ifdef CONFIG_32BIT
	fmt = (char *)(*bin_buf++);
#else
	<exercise for the reader>
#endif

	a0 = *bin_buf++;
	a1 = *bin_buf++;
	a2 = *bin_buf++;
	a3 = *bin_buf++;
	a4 = *bin_buf++;

	snprintf(somewhere, some_size, fmt, a0, a1, a2, a3, a4, a5);

(as I said, ugly).

but that won't work for 64-bit values on big-endian architectures.  And
it's hacky (and might not even work) for 64-bit on little endian.

Perhaps this is the secret problem which you haven't described yet?
