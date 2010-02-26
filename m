Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033Ab0BZC0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 21:26:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935018Ab0BZC0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 21:26:24 -0500
X-Authority-Analysis: v=1.0 c=1 a=EPSL5sjMBdAA:10 a=7U3hwN5JcxgA:10 a=GlTInNEu9KYYm3fdAy0A:9 a=jWEM9ER8RJJ6XGEPmYMA:7 a=oHsizBTfpo_Hx0xZ2UiFciRhG6QA:4 a=TdF0ip4hniml00nv:21 a=C5DAESpADrM0BiAF:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2][RFC] tracing: Add extract out softirq names used
 by irq trace events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20100225234806.GD5592@nowhere>
References: <20100212190907.954438555@goodmis.org>
	 <20100212191037.283998401@goodmis.org> <1266057549.557.59605.camel@twins>
	 <1266059470.24271.116.camel@gandalf.stny.rr.com>
	 <20100225234806.GD5592@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 21:26:19 -0500
Message-ID: <1267151179.6328.86.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 00:48 +0100, Frederic Weisbecker wrote:

> 
> And what about a kind of macro that could have two effects:
> 
> - define the enum
> - define the nr -> name pairs for resolution
> 
> This could be something like:
> 
> define_trace_enum(softirq)
> 	enum_entry(TASKLET, 4), //don't know if it's 4, just an example
> 	enum_entry(HRTIMER, 5),
> end_trace_enum()

That wont work. Unless it is in a separate file that can be included
over and over again. That is we would need:

** include/linux/softirq_names.h:

define_trace_enum(softirq)
	enum_entry(HI, 0),
	enum_entry(TIMER, 1),
	[...]
end_trace_enum();



** include/trace/define_enum.h:

#define define_trace_enum(name)  enum name {
#define enum_entry(a, b)  a = b
#define end_trace_enum()  }


** include/linux/interrupt.h

/* instead of declaring an enum we have */

#include <trace/define_enum.h>
#include <linux/softirq_names.h>

Here we could do something special with that file.

> 
> (My naming sucks, as usual).
> 
> In normal headers, it would define an enum:
> 
> enum softirq {
> 	TASKLET = 4,
> 	HRTIMER = 5,
> };
> 
> And in the file that has DEFINE_TRACEPOINT:
> 
> /* can be in ftrace_event.h */
> struct resolve_enum {
> 	const char *name;
> 	int val;
> };
> 
> struct resolve_enum softirq = { //come from define_trace_enum()
> 	{"TASKLET", 4}, //come from enum_entry()
> 	{"HRTIMER", 5},
> 	{ NULL, 0}, /* end */
> };
> 
> /* This can be used from the trace_event macro */
> const char *softirq_name(int nr)
> {
> 	return resolve_enum[nr];
> }
> 
> 
> And then you can get back the struct resolve_enum softirq
> to export the values to debugfs, may be by storing such
> structures in a section (and adding the name of the enum)
> 
> This has the advantage of beeing sync with core header
> changes, but this has the drawback of beeing less readable
> to define an enum usable from a TRACE_EVENT (especially
> if I define the naming personally).
> 


This just gets ugly and I'm not sure people would like doing this. It
also requires that you number the enums specifically.

A better way could be this:

** include/linux/interrupt.h

#define SOFTIRQ_NAMES 	\
	C(HI),		\
	C(TIMER),	\
	[...]		\
	C(RCU)

#define C(name)		name##_SOFTIRQ

enum { SOFTIRQ_NAMES, NR_SOFTIRQS };

#undef C

And in the trace file we could do:

#define C(name)  { #name, name##_SOFTIRQ, sizeof(name##_SOFTIRQ) }

struct {
	char *name;
	int val;
	int size;
} softirq_names[] __attribute__((section("trace_syms"))) =
  { SOFTIRQ_NAMES };

#undef C


This way we don't need to number every enum, or have to move the enum
into another file. My question is...

Would the following be acceptable in normal headers?

#define ENUM_NAMES  	\
	C(a),		\
	C(b),		\
	...

#define C(name) name

enum { ENUM_NAMES };

#undef C

-- Steve


