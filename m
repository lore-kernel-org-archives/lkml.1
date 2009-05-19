Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbZESJbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbZESJbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZESJbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:31:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZESJba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:31:30 -0400
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Abbott <michael@araneidae.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
In-Reply-To: <20090519110047.2e0d9e55@skybase>
References: <20090518160904.7df88425@skybase>
	 <1242660243.26820.439.camel@twins>
	 <Pine.LNX.4.64.0905181717001.21259@venus.araneidae.co.uk>
	 <20090519110047.2e0d9e55@skybase>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 May 2009 11:31:28 +0200
Message-Id: <1242725488.26820.485.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 11:00 +0200, Martin Schwidefsky wrote:
> On Mon, 18 May 2009 17:28:53 +0100 (BST)
> Michael Abbott <michael@araneidae.co.uk> wrote:
> 
> > > > +	for_each_possible_cpu(i)
> > > > +		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
> > > > +	idletime = cputime64_to_clock_t(idletime);
> > > >  
> > > >  	do_posix_clock_monotonic_gettime(&uptime);
> > > >  	monotonic_to_bootbased(&uptime);
> > > 
> > > This is a world readable proc file, adding a for_each_possible_cpu() in
> > > there scares me a little (this wouldn't be the first and only such case
> > > though).
> > > 
> > > Suppose you have lots of cpus, and all those cpus are dirtying those
> > > cachelines (who's updating idle time when they're idle?), then this loop
> > > can cause a massive cacheline bounce fest.
> > > 
> > > Then think about userspace doing: 
> > >   while :; do cat /proc/uptime > /dev/null; done
> > 
> > Well, the offending code derives pretty well directly from /proc/stat, 
> > which is used, for example, by top.  So if there is an issue then I guess 
> > it already exists.  
> > 
> > There is a pending problem in this code: for a multiple cpu system we'll 
> > end up with more idle time than elapsed time, which is not really very 
> > nice.  Unfortunately *something* has to be done here, as it looks as if 
> > .utime and .stime (at least for init_task) have lost any meaning.  I sort 
> > of though of dividing by number of cpus, but that's not going to work very 
> > well..
> 
> I don't see a problem here. In an idle multiple cpu system there IS
> more idle time than elapsed time. What would makes sense is to compare
> elapsed time * #cpus with the idle time. But then there is cpu hotplug
> which forces you to look at the delta of two measuring points where the
> number of cpus did not change.

Sure, this one case isn't that bad, esp. as you note its about idle
time. However, see for example /proc/stat and fs/proc/stat.c:

        for_each_possible_cpu(i) {
                user = cputime64_add(user, kstat_cpu(i).cpustat.user);
                nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
                system = cputime64_add(system, kstat_cpu(i).cpustat.system);
                idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
                idle = cputime64_add(idle, arch_idle_time(i));
                iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
                irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
                softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
                steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
                guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
                for_each_irq_nr(j) {
                        sum += kstat_irqs_cpu(j, i);
                }
                sum += arch_irq_stat_cpu(i);
        }

If that isn't a problem on a large machine, then I don't know what is.

