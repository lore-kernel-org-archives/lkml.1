Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0BAH21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:28:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44962 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab0BAH2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 02:28:25 -0500
Date: Mon, 1 Feb 2010 08:27:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/12 v2] perf lock: New subcommand "perf lock", for
 analyzing lock statistics
Message-ID: <20100201072752.GB12039@elte.hu>
References: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20100131082953.GA12715@elte.hu>
 <20100131203103.GD5224@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131203103.GD5224@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sun, Jan 31, 2010 at 09:29:53AM +0100, Ingo Molnar wrote:
> > 
> > FYI, i've applied a file/line-less version of 'perf lock' to perf/core today.
> > 
> > The basic workflow is the usual:
> > 
> >   perf lock record sleep 1     # or some other command
> >   perf lock report             # or 'perf lock trace'
> > 
> > [ I think we can do all the things that file/line can do with a less intrusive 
> >   (and more standard) call-site-IP based approach. For now we can key off the 
> >   names of the locks, that's coarser but also informative and allows us to 
> >   progress.
> > 
> >   I've renamed 'perf lock prof' to 'perf lock report' - which is more in line 
> >   with other perf tools. ]
> > 
> > The tool clearly needs more work at the moment: i have tried perf lock on a 16 
> > cpus box, and it was very slow, while it didnt really record all that many 
> > events to justify the slowdown. A simple:
> > 
> >   perf lock record sleep 1
> > 
> > makes the system very slow and requires a Ctrl-C to stop:
> > 
> >  # time perf lock record sleep 1
> >  ^C[ perf record: Woken up 0 times to write data ]
> >  [ perf record: Captured and wrote 5.204 MB perf.data (~227374 samples) ]
> > 
> >   real	0m11.941s
> >   user	0m0.020s
> >   sys	0m11.661s
> > 
> > (The kernel config i used witht that is attached.)
> > 
> > My suspicion is that the overhead of CONFIG_LOCK_STAT based tracing is way too 
> > high at the moment, and needs to be reduced. I have removed the '-R' option 
> > from perf lock record (which it got from perf sched where it makes sense but 
> > here it's not really needed and -R further increases overhead), but that has 
> > not solved the slowdown.
> 
> 
> 
> Hmm, -R is mandatory if you want the raw sample events, otherwise the
> event is just a counter.
> 
> May be you mean -M ? Sure -M is going to be a noticeable overhead
> in 16 cores.

Yeah, i meant and tested -M.

> Anyway, I'm looking closely into improving the lock events to
> reduce all this overhead. I'll create a lock_init event so
> that we can gather the heavy informations there (especially
> the name of the lock).
> 
> Also, using TRACE_EVENT_FN lets us register a callback when
> a tracepoint gets registered, I'm going to try to synthetize
> the missing lock_init() events here.

Ok, thanks for looking into this!

	Ingo
