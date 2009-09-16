Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZIPO3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZIPO3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZIPO3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:29:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZIPO3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:29:31 -0400
Subject: Re: [PATCH tracing/kprobes 2/6] ftrace: Fix trace_add_event_call()
 to initialize list
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <4AB0F366.6080000@redhat.com>
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20090914204904.18779.59422.stgit@dhcp-100-2-132.bos.redhat.com>
	 <1253058681.20020.147.camel@gandalf.stny.rr.com>
	 <4AB0F366.6080000@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 16 Sep 2009 10:29:31 -0400
Message-Id: <1253111371.20020.198.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 10:17 -0400, Masami Hiramatsu wrote:
> Steven Rostedt wrote:

> >> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> >> index ba34920..38e82a5 100644
> >> --- a/kernel/trace/trace_events.c
> >> +++ b/kernel/trace/trace_events.c
> >> @@ -1009,10 +1009,14 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
> >>  	if (!d_events)
> >>  		return -ENOENT;
> >>  
> >> +	INIT_LIST_HEAD(&call->list);
> > 
> > The INIT_LIST_HEAD is not needed here. The list_add will assign it.
> 
> Without initializing it, list debugging code warns always :-)
> Please see, __list_add()@lib/list_debug.c

/me looks

from: include/linux/list.h

static inline void list_add(struct list_head *new, struct list_head *head)
{
	__list_add(new, head, head->next);
}

from: lib/list_debug.c

void __list_add(struct list_head *new,
			      struct list_head *prev,
			      struct list_head *next)
{
	WARN(next->prev != prev,
		"list_add corruption. next->prev should be "
		"prev (%p), but was %p. (next=%p).\n",
		prev, next->prev, next);
	WARN(prev->next != next,
		"list_add corruption. prev->next should be "
		"next (%p), but was %p. (prev=%p).\n",
		next, prev->next, prev);
	next->prev = new;
	new->next = next;
	new->prev = prev;
	prev->next = new;
}

What you pass in is:

        list_add(&call->list, &ftrace_events);

new = &call->list;
prev = &ftrace_events->prev;
next = &ftrace_events->next;

The above code never tests "new". The INIT_LIST_HEAD is useless.

-- Steve


