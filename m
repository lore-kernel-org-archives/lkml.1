Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0BFKiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 05:38:13 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:58693 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0BFKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 05:38:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s5id8MTgXWDWKtzwY9/m4kmrO5KZaGSsWGKHFOSmZRQrssmOGTVWfmlFPsnaVLjS6v
         kR+fJQtYcfIa3lWhGSpEtqYcrjm5Q1QzT8sKbrLkhYowAVHXmp8aU8wo+Yq3g2JnnfR5
         XmNoSwe+5+5ayN5RJfAqinRzIQHg5F0tKAcjQ=
Date: Sat, 6 Feb 2010 11:37:59 +0100
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
Message-ID: <20100206103755.GB5062@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <20100203102540.GQ5733@kernel.dk> <20100203205009.GB5068@nowhere> <20100204194047.GE5733@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204194047.GE5733@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:40:47PM +0100, Jens Axboe wrote:
> On Wed, Feb 03 2010, Frederic Weisbecker wrote:
> > Ok, thanks a lot, the fact you can test on a 64 threads box is critically
> > helpful.
> > 
> > I also wonder what happens after this patch applied:
> > 
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index 98fd360..254b3d4 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -3094,7 +3094,8 @@ static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
> >         if (event->parent)
> >                 event = event->parent;
> >  
> > -       return task_pid_nr_ns(p, event->ns);
> > +       return p->pid;
> >  }
> > 
> > In my box it has increased the speed from 2x this patchset.
> 
> Doesn't seem to change anything, same runtime for a ls.


Ah.


 
> > I wonder if the tool becomes usable for you with that.
> > Otherwise, it means we have other things to fix, and
> > the result of:
> > 
> > 	perf record -g -f perf lock record sleep 6
> > 	perf report
> > 
> > would be very nice to have.
> 
> root@nehalem:/dev/shm # perf record -g -f perf lock record sleep 6
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 446.208 MB perf.data (~19495127 samples) ]
> [ perf record: Woken up 9 times to write data ]
> [ perf record: Captured and wrote 1.135 MB perf.data (~49609 samples) ]
> 
> It's huuuge. Thankfully the output isn't so big, I've attached it.



Yeah. I made a mistake, both perf record and perf lock are writing to the
same perf.data with this cmdline.

Actually we'd have needed:

perf record -o perflock.data -g -f perf lock record sleep 6
perf report -i perflock.data

That's why you don't have callchains in your profile, probably because the
file has been messed up.

Anyway, we should retry after my next iteration, I have various
reviews to address :)

Thanks.

