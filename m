Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYFLRHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYFLRHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYFLRHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:07:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbYFLRHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:07:31 -0400
Message-ID: <48515770.4020002@redhat.com>
Date: Thu, 12 Jun 2008 13:05:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins> <20080612155332.GA16658@redhat.com> <48514BE3.3000506@redhat.com> <20080612164318.GB17814@redhat.com>
In-Reply-To: <20080612164318.GB17814@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Jun 12, 2008 at 12:16:35PM -0400, Masami Hiramatsu wrote:
>> [...]
>>> Think this through.  How should systemtap (or another user-space
>>> separate-compiled tool like lttng) do this exactly?
>>> [...]
>>> (d) or another way?
>> use a lookup table. we can expect that the marking points which
>> regularly inserted in the upstream kernel are stable(not so
>> frequently change). In that case, we can easily maintain
>> a lookup table which has pairs of format strings like as
>> "sched_switch(struct task_struct * next, struct task_struct * prev)":"next %p prev %p"
>> out of tree. Thus, you can use the printf-style format parser.
> 
> That's an interesting idea, but errors in this table would themselves
> only be caught at C compilation time.

Hmm, why would you think so?
I think if we can't find corresponding entry from the lookup table,
it becomes an error.

>  Worse, it does nothing helpful
> for actually pulling out the next/prev fields of interest.  Remember,
> real tracing users don't care so much about the task_struct pointers,
> but about observable things like PIDs.  Systemtap would be back to the
> debuginfo or C-header-guessing/parsing job (or embedded-C, yuck).

Yeah, but that is same as previous marker. It depends on what parameter
the kernel pass to the marker. I mean, the parameter issue is not an
issue of the marker framework, but a discussion point of marking points.

> This is another reason why markers are a nice solution.  They allow
> passing of actual useful values: not just the %p pointers but the most
> interesting derived values (e.g., prev->pid).  And they do this
> *efficiently* - in out-of-line code that imposes no measurable
> overhead in the normal case..

Even if you use trace_mark() markers, you have to post a kernel patch
which passes the prev->pid to the marking point and to discuss it.
for example,
DEFINE_TRACE(sched_switch, (int prev_pid, int next_pid), prev_pid, next_pid)

But it might not so general, we have to discuss what parameters are enough
good for each marking point.

> 
> 
> - FChE

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

