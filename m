Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab0BCV1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:27:00 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55293 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab0BCV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:26:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EIqq6iVz3KcvS/PxY/uBArwhVd1y12RMLfWEgPgI1rRFBK3zawZpdlRnFxMYUoR5u2
         D28hJP8ucrvRiPCoWdVsB/PZXfjEF7KRV5GnwD2T0nM+4hQafTxxwk9RXXnpFSVe/eF6
         dHw02tC8spyJKuzbBzyS5wOp6lhhgClvuGgXk=
Date: Wed, 3 Feb 2010 22:26:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
	improvements
Message-ID: <20100203212648.GC5068@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <20100203102611.GA22693@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203102611.GA22693@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 11:26:11AM +0100, Ingo Molnar wrote:
> There's one area that needs more thought i think: the dump-all-classes 
> init-event-injector approach. It is async, hence we could lose events if 
> there's a lot of lock classes to dump.


Yeah, the dump itself is purely async.

But the lock_class_init event is used from two sites:

- the injector, purely aynchronous and catch up from the past
  thing

- register_lock_class(), this is the synchronous point, each time
  we have a new class created.

When we register a lock_class_init ftrace/perf event, we first activate
the synchronous point, it behaves here as a usual event, and will hook
in every present new events.

And only after, we call the injector, asynchronous, rely on past events.

That beeing split in two part covers every events.


> Plus we eventually want to use your 
> injector approach for other things as well (such as to dump the state of a 
> collection of tasks) - so i think we want it to be more synchronous.


Yeah, that would work also for tasks. And we can follow the same
pattern for that.

We can set up a synchronous trace point in fork and have a secondary
asynchronous point that can dump the task list. That too would
cover every events we want.

 
> One approach would be to allow a gradual read() deplete the dump. Also, i 
> think the 'state dump' events should be separate from regular init events. 
> Filters attached to these events will automatically cause the dumping to be 
> restricted to the filter set. For example in the case of tasks one could dump 
> only tasks from a particular UID - by adding a 'uid == 1234' filter before 
> the dump (on a per tasks basis - so the filtering is nicely task local).


But this is what we want right? If the init event and the dump event are
the same, which is the case currently, the filter will apply to both.

And if we are only interested in tasks for uid == 1234, I guess we
want async and sync events that have the same filter.

May be we want to split up init events from dump events, say,
have an event class that you can open in either async or
sync mode. But I can't figure out a workflow for which it can
be useful.

