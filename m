Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab0BCUuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:50:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36962 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab0BCUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:50:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JDAF2viFvQIZ9QY4T6E6szz8ZRPJ0I4n0FU4j/gkFo2Wwmtf44agr/NW3z25KC847G
         XDfuDKYmqRnir+pXCNkWx3VAc8DD4Ds7O99gd0lp9wPu3zyvlDoHWsoR6zpfqraCmKpT
         19mOgMUqqmdHvesaTfqiXzEAn4yxWYIip63R8=
Date: Wed, 3 Feb 2010 21:50:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
	improvements
Message-ID: <20100203205009.GB5068@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <20100203102540.GQ5733@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203102540.GQ5733@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 11:25:41AM +0100, Jens Axboe wrote:
> On Wed, Feb 03 2010, Frederic Weisbecker wrote:
> > Hi,
> > 
> > There are many things that happen in this patchset, treating
> > different problems:
> > 
> > - remove most of the string copy overhead in fast path
> > - open the way for lock class oriented profiling (as
> >   opposite to lock instance profiling. Both can be useful
> >   in different ways).
> > - remove the buffers muliplexing (less contention)
> > - event injection support
> > - remove violent lock events recursion (only 2 among 3, the remaining
> >   one is detailed below).
> > 
> > Some differences, by running:
> > 	perf lock record perf sched pipe -l 100000
> > 
> > Before the patchset:
> > 
> > 	Total time: 91.015 [sec]
> > 
> > 	     910.157300 usecs/op
> > 		   1098 ops/sec
> > 
> > After this patchset applied:
> > 
> > 	Total time: 43.706 [sec]
> > 
> > 	     437.062080 usecs/op
> > 		   2288 ops/sec
> 
> This does a lot better here, even if it isn't exactly stellar
> performance. It generates a LOT of data:
> 
> root@nehalem:/dev/shm # time perf lock rec -fg ls
> perf.data  perf.data.old
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 137.224 MB perf.data (~5995421
> samples) ]



Doh, 137 MB for a single ls :)

That said we don't have yet support for callchains in perf lock,
and callchains can fill the buffer quickly, especially on lock
events. You can drop the -g option for now.


> 
> real    0m3.320s
> user    0m0.000s
> sys     0m3.220s
> 
> Without -g, it has 1.688s real and 1.590s sys time.


Ok.


> So while this is orders of magnitude better than the previous patchset,
> it's still not anywhere near lean. But I expect you know that, just
> consider this a 'I tested it and this is what happened' report :-)


Ok, thanks a lot, the fact you can test on a 64 threads box is critically
helpful.

I also wonder what happens after this patch applied:

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 98fd360..254b3d4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3094,7 +3094,8 @@ static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
        if (event->parent)
                event = event->parent;
 
-       return task_pid_nr_ns(p, event->ns);
+       return p->pid;
 }

In my box it has increased the speed from 2x this patchset.

I wonder if the tool becomes usable for you with that.
Otherwise, it means we have other things to fix, and
the result of:

	perf record -g -f perf lock record sleep 6
	perf report

would be very nice to have.

Thanks!

