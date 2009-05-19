Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZESItU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZESItU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbZESItE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:49:04 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:42389 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZESItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:49:03 -0400
Date: Tue, 19 May 2009 10:49:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
Message-ID: <20090519104900.12e1f80c@skybase>
In-Reply-To: <1242660243.26820.439.camel@twins>
References: <20090518160904.7df88425@skybase>
	<1242660243.26820.439.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 17:24:03 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-05-18 at 16:09 +0200, Martin Schwidefsky wrote:
> > Hi Linus,
> > 
> > please pull from 'cputime' branch of
> > 
> > 	git://git390.marist.edu/pub/scm/linux-2.6.git cputime
> > 
> > to receive the following updates:
> > 
> > Michael Abbott (1):
> >       Fix idle time field in /proc/uptime
> > 
> >  fs/proc/uptime.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
> > index 0c10a0b..c0ac0d7 100644
> > --- a/fs/proc/uptime.c
> > +++ b/fs/proc/uptime.c
> > @@ -4,13 +4,19 @@
> >  #include <linux/sched.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/time.h>
> > +#include <linux/kernel_stat.h>
> >  #include <asm/cputime.h>
> >  
> >  static int uptime_proc_show(struct seq_file *m, void *v)
> >  {
> >  	struct timespec uptime;
> >  	struct timespec idle;
> > -	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
> > +	int len, i;
> > +	cputime_t idletime = 0;
> 
> cputime_zero, I guess..

Yes, this needs to be cputime_zero.
 
> > +	for_each_possible_cpu(i)
> > +		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
> > +	idletime = cputime64_to_clock_t(idletime);
> >  
> >  	do_posix_clock_monotonic_gettime(&uptime);
> >  	monotonic_to_bootbased(&uptime);
> 
> This is a world readable proc file, adding a for_each_possible_cpu() in
> there scares me a little (this wouldn't be the first and only such case
> though).
> 
> Suppose you have lots of cpus, and all those cpus are dirtying those
> cachelines (who's updating idle time when they're idle?), then this loop
> can cause a massive cacheline bounce fest.
> 
> Then think about userspace doing: 
>   while :; do cat /proc/uptime > /dev/null; done

Well, don't do stupid things like that. That falls into the same
category as programs calling gettimeofday all the time.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

