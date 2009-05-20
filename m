Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZETIJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZETIJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbZETIJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:09:17 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:34328 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbZETIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:09:13 -0400
Date: Wed, 20 May 2009 10:09:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Abbott <michael@araneidae.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
Message-ID: <20090520100912.4f9c2037@skybase>
In-Reply-To: <1242725488.26820.485.camel@twins>
References: <20090518160904.7df88425@skybase>
	<1242660243.26820.439.camel@twins>
	<Pine.LNX.4.64.0905181717001.21259@venus.araneidae.co.uk>
	<20090519110047.2e0d9e55@skybase>
	<1242725488.26820.485.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 11:31:28 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-05-19 at 11:00 +0200, Martin Schwidefsky wrote:
> > I don't see a problem here. In an idle multiple cpu system there IS
> > more idle time than elapsed time. What would makes sense is to compare
> > elapsed time * #cpus with the idle time. But then there is cpu hotplug
> > which forces you to look at the delta of two measuring points where the
> > number of cpus did not change.
> 
> Sure, this one case isn't that bad, esp. as you note its about idle
> time. However, see for example /proc/stat and fs/proc/stat.c:
> 
>         for_each_possible_cpu(i) {
>                 user = cputime64_add(user, kstat_cpu(i).cpustat.user);
>                 nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
>                 system = cputime64_add(system, kstat_cpu(i).cpustat.system);
>                 idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
>                 idle = cputime64_add(idle, arch_idle_time(i));
>                 iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
>                 irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
>                 softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
>                 steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
>                 guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
>                 for_each_irq_nr(j) {
>                         sum += kstat_irqs_cpu(j, i);
>                 }
>                 sum += arch_irq_stat_cpu(i);
>         }
> 
> If that isn't a problem on a large machine, then I don't know what is.

Well, we better distinguish between the semantical problem and the
performance consideration, no? One thing is what the proc field is
supposed to contain, the other is how fast you can do it.

I have been refering to the semantical problem, but your point with the
performance is very valid as well. So
1) are we agreed that the second field of /proc/uptime should contain
the aggregate idle time of all cpus?
2) I agree that an endless loop of 'cat /proc/uptime' or
'cat /proc/stat' can have negative performance impact on a system with
many cpus. One way to deal with it would be to restrict access to the
interface. I do not like that idea to much. Another way would be to
limit the number of for_each_possible_cpu loops per second. Create
global variables that contain the aggregate values for the different
fields. If the last update has been too recent (e.g. less than 0.1
seconds ago), just print the old values again.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

