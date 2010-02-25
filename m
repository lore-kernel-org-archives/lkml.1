Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573Ab0BYXsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:48:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40855 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553Ab0BYXsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:48:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DACm13rTcQFgdjXQ48ueDD73wmo/8lw1QShshSjGe7Pj0+sGfBtTJCa6OwEP/mqcgG
         7aqZU90B/oXiJVEs28ZiFzkWR/y4yTQhkt2tedSEQiANjYwdurlrvABAWqsAXP3hIpzr
         MVZLmHW4/0cJZq13POegB+JHNXW9wCkGtFfA4=
Date: Fri, 26 Feb 2010 00:48:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2][RFC] tracing: Add extract out softirq names used
	by irq trace events
Message-ID: <20100225234806.GD5592@nowhere>
References: <20100212190907.954438555@goodmis.org> <20100212191037.283998401@goodmis.org> <1266057549.557.59605.camel@twins> <1266059470.24271.116.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266059470.24271.116.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 06:11:09AM -0500, Steven Rostedt wrote:
> We don't care about adding them near the definition site. We care about
> what is used. In this same file we have:
> 
> #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
> #define show_softirq_name(val)                          \
>         __print_symbolic(val,                           \
>                          softirq_name(HI),              \
>                          softirq_name(TIMER),           \
>                          softirq_name(NET_TX),          \
>                          softirq_name(NET_RX),          \
>                          softirq_name(BLOCK),           \
>                          softirq_name(BLOCK_IOPOLL),    \
>                          softirq_name(TASKLET),         \
>                          softirq_name(SCHED),           \
>                          softirq_name(HRTIMER),         \
>                          softirq_name(RCU))
> 
> Which uses the variables. If another softirq name is added, the
> TRACE_EVENT already misses it. That's not the point of the EXTRACT
> macro. The point is, if a TRACE_EVENT uses a name that is not a macro,
> this gives a way for it to display that value.


And what about a kind of macro that could have two effects:

- define the enum
- define the nr -> name pairs for resolution

This could be something like:

define_trace_enum(softirq)
	enum_entry(TASKLET, 4), //don't know if it's 4, just an example
	enum_entry(HRTIMER, 5),
end_trace_enum()

(My naming sucks, as usual).

In normal headers, it would define an enum:

enum softirq {
	TASKLET = 4,
	HRTIMER = 5,
};

And in the file that has DEFINE_TRACEPOINT:

/* can be in ftrace_event.h */
struct resolve_enum {
	const char *name;
	int val;
};

struct resolve_enum softirq = { //come from define_trace_enum()
	{"TASKLET", 4}, //come from enum_entry()
	{"HRTIMER", 5},
	{ NULL, 0}, /* end */
};

/* This can be used from the trace_event macro */
const char *softirq_name(int nr)
{
	return resolve_enum[nr];
}


And then you can get back the struct resolve_enum softirq
to export the values to debugfs, may be by storing such
structures in a section (and adding the name of the enum)

This has the advantage of beeing sync with core header
changes, but this has the drawback of beeing less readable
to define an enum usable from a TRACE_EVENT (especially
if I define the naming personally).

