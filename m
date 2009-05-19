Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbZESJA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbZESJA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZESJAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:00:50 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:64843 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZESJAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:00:49 -0400
Date: Tue, 19 May 2009 11:00:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
Message-ID: <20090519110047.2e0d9e55@skybase>
In-Reply-To: <Pine.LNX.4.64.0905181717001.21259@venus.araneidae.co.uk>
References: <20090518160904.7df88425@skybase>
	<1242660243.26820.439.camel@twins>
	<Pine.LNX.4.64.0905181717001.21259@venus.araneidae.co.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 17:28:53 +0100 (BST)
Michael Abbott <michael@araneidae.co.uk> wrote:

> > > +	for_each_possible_cpu(i)
> > > +		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
> > > +	idletime = cputime64_to_clock_t(idletime);
> > >  
> > >  	do_posix_clock_monotonic_gettime(&uptime);
> > >  	monotonic_to_bootbased(&uptime);
> > 
> > This is a world readable proc file, adding a for_each_possible_cpu() in
> > there scares me a little (this wouldn't be the first and only such case
> > though).
> > 
> > Suppose you have lots of cpus, and all those cpus are dirtying those
> > cachelines (who's updating idle time when they're idle?), then this loop
> > can cause a massive cacheline bounce fest.
> > 
> > Then think about userspace doing: 
> >   while :; do cat /proc/uptime > /dev/null; done
> 
> Well, the offending code derives pretty well directly from /proc/stat, 
> which is used, for example, by top.  So if there is an issue then I guess 
> it already exists.  
> 
> There is a pending problem in this code: for a multiple cpu system we'll 
> end up with more idle time than elapsed time, which is not really very 
> nice.  Unfortunately *something* has to be done here, as it looks as if 
> .utime and .stime (at least for init_task) have lost any meaning.  I sort 
> of though of dividing by number of cpus, but that's not going to work very 
> well..

I don't see a problem here. In an idle multiple cpu system there IS
more idle time than elapsed time. What would makes sense is to compare
elapsed time * #cpus with the idle time. But then there is cpu hotplug
which forces you to look at the delta of two measuring points where the
number of cpus did not change.

> I came to this problem from a uni-processor instrument which uses 
> /proc/uptime to determine whether the system is overloaded (and discovers 
> on the current kernel that it is, permanently!).  This fix is definitely 
> imperfect, but I think a better fix will require rather deeper knowledge 
> of kernel time accounting than I can offer.

Hmm, I would use the idle time field from /proc/stat for that.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

