Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbXHUMV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbXHUMV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759373AbXHUMVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:21:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45307 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXHUMVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:21:45 -0400
Date: Tue, 21 Aug 2007 14:21:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821122125.GA7910@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708211324.13442.borntraeger@de.ibm.com> <20070821113037.GA2390@elte.hu> <200708211358.52916.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211358.52916.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> > but i dont mind your patch either - it's really the architecture's 
> > choice how visible it wants to make external load to the task stats 
> > of its virtual machines. I think it is more logical to say that 100% 
> > CPU time displayed in 'top' means that the task got all the CPU time 
> > it asked for from the virtual machine. (and if you are curious about 
> > how much time was stolen from the virtual box altogether you look at 
> > the stolen-time stats in isolation.)
> 
> Well, as I said we started with the same approach (virtual cpu) but we 
> learned that these numbers have no meaning at all because the 
> hypervisor does have different scheduling timeslices and having 100% 
> inside the guest can still result in almost nothing if the system is 
> really loaded.

hm, i think i must have used the wrong terminology, so let me describe 
what i mean, so that we can argue this more efficiently ;-)

What i call "real time sched_clock()" is a sched_clock() that returns 
the GTOD (the real time) of the hypervisor. I.e. sched_clock() advances 
by 1 billion units every wall-clock second, in each guest.

A "virtual time sched_clock()" is a sched_clock() that returns only the 
amount of time the virtual CPU was executed by the hypervisor. I.e. on a 
3 times overloaded hypervisor with 3 guests it will advance 333 million 
nanoseconds per 1 wall-clock second, in each guest. (it is 'virtual' 
because the clock slows down as load goes up. In CFS-speak the virtual 
clock is the "fair-clock".)

to me the right scheme for sched_clock() is the virtual variant: to 
return the load-scaled nanoseconds. That way CFS will be able to 
schedule fairly even if time has been "stolen" from a task [by virtue of 
the hypervisor scheduling away the guest context without giving any 
notice about this to the guest kernel] - because sched_clock() measures 
the virtual time that got allocated to that guest by the hypervisor.

[ here i'm assuming precise host and precise guest statistics (which is 
  naturally the case if both are Linux), and in that context the virtual 
  numbers very much make sense, and whether 'top' displays 100% for a 
  sole CPU-bound task should be mostly a matter of tooling. ]

	Ingo
