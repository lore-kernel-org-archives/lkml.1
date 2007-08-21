Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbXHULzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbXHULzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbXHULzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:55:06 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:21717 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXHULzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:55:03 -0400
Subject: Re: [accounting regression since rc1]  scheduler updates
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070821113611.GB2390@elte.hu>
References: <20070812163225.GA11996@elte.hu>
	 <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu>
	 <200708211017.02998.borntraeger@de.ibm.com> <20070821084243.GB1144@elte.hu>
	 <1187687476.7623.8.camel@localhost> <20070821093434.GB12025@elte.hu>
	 <1187692696.24279.7.camel@localhost>  <20070821113611.GB2390@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 21 Aug 2007 13:58:45 +0200
Message-Id: <1187697526.24279.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 13:36 +0200, Ingo Molnar wrote:
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > > Wouldnt it be more consistent if a virtual box would not show any 
> > > dependency on external load? (i.e. it would slow down all of its 
> > > internal functionality transparently, without exposing it via /proc. 
> > > The only way to observe that would be the TOD interfaces: 
> > > gettimeofday and real-time clock driven POSIX timers. Even 
> > > timer_list could be driven via virtual time - although that would 
> > > probably break user expectations, right?) Or would 
> > > accounting-in-virtual-time break user expectations too? (most of the 
> > > other hypervisors let guests account in virtual time.
> > 
> > No, imho it is less consistent if the virtual box shows virtual time. 
> > If you look at the top output as a user and it shows that some process 
> > used x% of cpu what does it tell you? [...]
> 
> it tells me something really important: that the virtual box's scheduler 
> gave this task as much CPU time as it could.

So? As far as accounting is concerned the user doesn't care one bit what
the scheduler decided. The user cares how much cpu was used. If you want
to know how much of the cputime available to the virtual box was used
for a process you just have to add/subtract the steal time. Your have
the complete picture what happened. You cannot get the complete picture
if you have do process accounting based on the TOD clock, you never know
how much cpu was actually spent for a process.

> > [...] With virtual cpus next to nothing, you have to normalize the 
> > numbers with the %steal while the process was running. But even then 
> > it still is not a good number because the %steal changes while a 
> > process is running. The only good solution is to use virtual time for 
> > all cputime values.
> 
> the steal percentage is really a concept one step higher in the 
> scheduling hierarchy. You should be running top (or an equivalent tool) 
> in the _hypervisor_ context if you want to know about how much time each 
> virtual box gets. 'mixing' that information with the 'internal' task 
> statistics of the virtual box is less consistent IMO and leads to the 
> loss of information. (with the 'mixing' method there's no way to tell 
> whether a task got all CPU time it asked for - and _that_ is which an 
> admin is interested in just as much as the time allocation between 
> virtual boxes.)

Not really. If I look at a process I want to know how much cpu it used.
Not virtual but real cpu. And we learned this the hard way, trying to do
accounting with numbers that have to get normalized by numbers from the
hypervisor is just plain broken.

> so in say KVM you determine the steal percentage by looking at 'top' 
> output in the hypervisor context. (or looking at steal% in the internal 
> top output) Looking at 'top' in the guest tells you everything internal 
> to that guest, without mixing external scheduling information into it.

The information about accounting numbers that are internal to the guest
is 99.99% useless. You always have to take the external scheduling into
account. We choose to do the accounting in a way that does not require
additional steps to get to useful numbers.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


