Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYAQUm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYAQUm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYAQUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:42:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbYAQUmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:42:46 -0500
Date: Thu, 17 Jan 2008 15:37:40 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080117203740.GA24397@redhat.com>
References: <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com> <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com> <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com> <20080116201713.GA14336@Krystal> <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jan 17, 2008 at 03:08:33PM -0500, Steven Rostedt wrote:
> [...]
> +       trace_mark(kernel_sched_schedule,
> +               "prev_pid %d next_pid %d prev_state %ld",
> +               prev->pid, next->pid, prev->state);
> [...]
> But...
> 
> Tracers that want to do a bit more work, like recording timings and seeing
> if we hit some max somewhere, can't do much with that pretty print data.

If you find yourself wanting to perform computations like finding
maxima, or responding right there as opposed to later during userspace
trace data extraction, then you're trending toward a tool like
systemtap.

> [...]
> So, at a minimum, I'd like to at least have meta data attached:
> 	trace_mark(kernel_sched_schedule,
> 		"prev_pid %d next_pid %d prev_state %ld\0"
> 		"prev %p next %p",
> 		prev->pid, next->pid, prev->state,
> 		prev, next);
> 
> This would allow for both the nice pretty print of your trace, as well as
> allowing other tracers to get to better meta data.

Yes, more self-contained marker events are necessary for meaningful
in-situ processing.  That needs to be balanced by the increased cost
for computing and passing the extra parameters, multiplied the event
occurrence rate.

In this case, the prev/next pointers are sufficient to compute the
other values.  For particularly performance-critical markers, it may
not be unreasonable to expect the callback functions to dereference
such pointers for pretty-printing or other processing.


> The '\0' would keep your tracer from recording the extra data, and we
> could add some way to ignore the parameters in the printf to let other
> traces get straight to the meta data.

This \0 hack is perhaps too clever.  Much of the cost of the extra
parameters is already paid by the time that a simpleminded tracing
callback function starts going through the string.  Also, I believe
the systemtap marker interface would break if the format strings were
not singly terminated ordinary strings.

- FChE
