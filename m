Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbYASDzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbYASDzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 22:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbYASDzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 22:55:42 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:48237 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758975AbYASDzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 22:55:41 -0500
Date: Fri, 18 Jan 2008 22:55:27 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080119033632.GE27193@redhat.com>
Message-ID: <Pine.LNX.4.58.0801182242440.16333@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
 <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com>
 <20080116201713.GA14336@Krystal> <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com>
 <20080117203740.GA24397@redhat.com> <Pine.LNX.4.58.0801171555120.28350@gandalf.stny.rr.com>
 <20080118222637.GA30900@Krystal> <Pine.LNX.4.58.0801181735140.13971@gandalf.stny.rr.com>
 <20080118231928.GA5563@Krystal> <20080119033632.GE27193@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jan 2008, Frank Ch. Eigler wrote:
>
> All this complexity is to be justified by keeping the raw prev/next
> pointers from being sent to a naive tracer?  It seems to me way out of
> proportion.

Damn, and I just blew away all my marker code for something like this ;-)

Actually, you just gave me a great idea that I think can help all of us.
OK, Mathieu may not be in total agreement, but I think this is the
ultimate compromise.

We have in sched.c the following marker:

 trace_mark(kernel_sched_scheduler, "prev %p next %p", prev, next);


Then Mathieu can add in some code somewhere (or a module, or something)

	ret = marker_probe_register("kernel_sched_scheduler",
				"prev %p next %p",
				pretty_print_sched_switch, NULL);

static void pretty_print_sched_switch(const struct marker *mdata,
				void *private_data,
				const char *format, ...)
{
	va_list ap;
	struct task_struct *prev;
	struct task_struct *next;

	va_start(ap, format);
	prev = va_arg(ap, typeof(prev));
	next = va_arg(ap, typeof(next));
	va_end;

	trace_mark(kernel_pretty_print_sched_switch,
		"prev_pid %d next_pid %d prev_state %ld",
		prev->pid, next->pid, prev->state);
}


Then LTTng on startup could arm the normal kernel_sched_switch code and
have the user see the nice one. All without adding any more goo or
overhead to the non tracing case, and keeping a few critical markers with
enough information to be useful to other tracers!

Thoughts?

-- Steve

