Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYFTUI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYFTUI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYFTUIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:08:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:33790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYFTUIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:08:18 -0400
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
In-Reply-To: <20080620174529.GB10943@Krystal>
References: <485BE2C6.1080901@redhat.com>  <20080620174529.GB10943@Krystal>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 22:07:25 +0200
Message-Id: <1213992446.3223.195.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-20 at 13:45 -0400, Mathieu Desnoyers wrote:

> All this work look good, thanks Masami! Sorry I did not find time to do
> it lately, I've been busy on other things. A small question though :
> since LTTng is configurable both as an external module or as an
> in-kernel tracer, I wonder if it would really hurt to add the format
> strings to DEFINE_TRACE, e.g. :
> 
> DEFINE_TRACE(name, prototype, format_string, args...)
> 
> which would give :
> 
> DEFINE_TRACE(irq_entry, (int irq_id, int kernel_mode), "%d %d",
>     irq_id, kernel_mode);
> 
> DEFINE_TRACE(irq_exit, (void), MARK_NOARGS);
> 
> and calling this in the kernel code :
> 
> trace_irq_entry(irq, (regs)?(!user_mode(regs)):(1));
> ...
> trace_irq_exit();
> 
> and for quick-and-dirty debug usage, one would add this to kernel code :
> 
> trace_mark(subsystem_event, "(int arg, struct task_struct *task)",
>  "%d %p", arg, current);

How would this work for:

DEFINE_TRACE(sched_switch, (struct task_struct *prev, struct task_struct *next), prev, next);

You'd want a string like: "%d %d", prev->pid, next->pid
not: "%p %p", prev, next

perhaps we can do something like:

DEFINE_TRACER(sched_switch, (struct task_struct *prev, struct task_struct *next), prev, next,
		"%d %d", prev->pid, next->pid);

that defines a default tracer function for the previously defined trace
point. That way its optional, and allows for generic trace points.

Of course, all this could be ruined by reality - C really sucks wrt
forwarding functions.. :-/

