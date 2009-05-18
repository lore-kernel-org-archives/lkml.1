Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZERQ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZERQ3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZERQ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:29:14 -0400
Received: from araneidae.co.uk ([62.3.233.233]:1452 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZERQ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:29:13 -0400
Date: Mon, 18 May 2009 17:28:53 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Peter Zijlstra <peterz@infradead.org>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
In-Reply-To: <1242660243.26820.439.camel@twins>
Message-ID: <Pine.LNX.4.64.0905181717001.21259@venus.araneidae.co.uk>
References: <20090518160904.7df88425@skybase> <1242660243.26820.439.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Peter Zijlstra wrote:
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
> 
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

Well, the offending code derives pretty well directly from /proc/stat, 
which is used, for example, by top.  So if there is an issue then I guess 
it already exists.  

There is a pending problem in this code: for a multiple cpu system we'll 
end up with more idle time than elapsed time, which is not really very 
nice.  Unfortunately *something* has to be done here, as it looks as if 
.utime and .stime (at least for init_task) have lost any meaning.  I sort 
of though of dividing by number of cpus, but that's not going to work very 
well..

I came to this problem from a uni-processor instrument which uses 
/proc/uptime to determine whether the system is overloaded (and discovers 
on the current kernel that it is, permanently!).  This fix is definitely 
imperfect, but I think a better fix will require rather deeper knowledge 
of kernel time accounting than I can offer.
