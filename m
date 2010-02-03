Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab0BCK0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 05:26:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57257 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab0BCK0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 05:26:37 -0500
Date: Wed, 3 Feb 2010 11:26:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
 improvements
Message-ID: <20100203102611.GA22693@elte.hu>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> There are many things that happen in this patchset, treating
> different problems:
> 
> - remove most of the string copy overhead in fast path
> - open the way for lock class oriented profiling (as
>   opposite to lock instance profiling. Both can be useful
>   in different ways).
> - remove the buffers muliplexing (less contention)
> - event injection support
> - remove violent lock events recursion (only 2 among 3, the remaining
>   one is detailed below).
> 
> Some differences, by running:
> 	perf lock record perf sched pipe -l 100000
> 
> Before the patchset:
> 
> 	Total time: 91.015 [sec]
> 
> 	     910.157300 usecs/op
> 		   1098 ops/sec
> 
> After this patchset applied:
> 
> 	Total time: 43.706 [sec]
> 
> 	     437.062080 usecs/op
> 		   2288 ops/sec

Fantastic!

There's one area that needs more thought i think: the dump-all-classes 
init-event-injector approach. It is async, hence we could lose events if 
there's a lot of lock classes to dump. Plus we eventually want to use your 
injector approach for other things as well (such as to dump the state of a 
collection of tasks) - so i think we want it to be more synchronous.

One approach would be to allow a gradual read() deplete the dump. Also, i 
think the 'state dump' events should be separate from regular init events. 
Filters attached to these events will automatically cause the dumping to be 
restricted to the filter set. For example in the case of tasks one could dump 
only tasks from a particular UID - by adding a 'uid == 1234' filter before 
the dump (on a per tasks basis - so the filtering is nicely task local).

What do you think?

	Ingo
