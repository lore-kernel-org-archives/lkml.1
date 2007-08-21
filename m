Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbXHUMx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbXHUMx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXHUMxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:53:21 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:25863 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbXHUMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:53:20 -0400
Subject: Re: [accounting regression since rc1]  scheduler updates
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070821122125.GA7910@elte.hu>
References: <20070812163225.GA11996@elte.hu>
	 <200708211324.13442.borntraeger@de.ibm.com> <20070821113037.GA2390@elte.hu>
	 <200708211358.52916.borntraeger@de.ibm.com> <20070821122125.GA7910@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 21 Aug 2007 14:57:03 +0200
Message-Id: <1187701023.24279.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 14:21 +0200, Ingo Molnar wrote:
> hm, i think i must have used the wrong terminology, so let me describe 
> what i mean, so that we can argue this more efficiently ;-)

Ok, seems we need to be a bit more precise.

> What i call "real time sched_clock()" is a sched_clock() that returns 
> the GTOD (the real time) of the hypervisor. I.e. sched_clock() advances 
> by 1 billion units every wall-clock second, in each guest.

Which is what we call the TOD clock.

> A "virtual time sched_clock()" is a sched_clock() that returns only the 
> amount of time the virtual CPU was executed by the hypervisor. I.e. on a 
> 3 times overloaded hypervisor with 3 guests it will advance 333 million 
> nanoseconds per 1 wall-clock second, in each guest. (it is 'virtual' 
> because the clock slows down as load goes up. In CFS-speak the virtual 
> clock is the "fair-clock".)

We 100% agree that sched_clock() should be virtual.

> to me the right scheme for sched_clock() is the virtual variant: to 
> return the load-scaled nanoseconds. That way CFS will be able to 
> schedule fairly even if time has been "stolen" from a task [by virtue of 
> the hypervisor scheduling away the guest context without giving any 
> notice about this to the guest kernel] - because sched_clock() measures 
> the virtual time that got allocated to that guest by the hypervisor.

Ok, this means we will need Jans patch that makes sched_clock() use the
cpu timer. You said that this change would require that scheduler_tick()
has to use virtual time as well, which would be the second patch.
And then we require a third patch that fixes the process accounting.

> [ here i'm assuming precise host and precise guest statistics (which is 
>   naturally the case if both are Linux), and in that context the virtual 
>   numbers very much make sense, and whether 'top' displays 100% for a 
>   sole CPU-bound task should be mostly a matter of tooling. ]

It is not only a matter of tooling. The tool needs to have enough,
precise information to actually return the requested information. If the
user want to know how much real cpu a process has used (and our user do
want to know that), the output of /proc/<pid>/stat fields 14-17 have to
contain the real cpu usage for user/system/cumulated user and cumulated
system time. If they would contain the virtual cpu usage you cannot tell
how much real cpu a process used, even if you have access to the steal
timer numbers. The reason is that you would have to synchronize the
scheduling points in the guest and the hypervisor to come up with
reasonable numbers. This is something we obviously do not want to do.
The output of /proc/<pid>/stat is what Christian and I are complaining
about. Since the introduction of CFS and VIRT_ACCOUNTING=y the output
of /proc/<pid>/stat has changed its meaning and in our opinion it is
wrong now.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


