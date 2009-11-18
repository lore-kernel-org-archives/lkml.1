Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZKREZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZKREZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 23:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbZKREZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 23:25:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbZKREZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 23:25:11 -0500
Date: Wed, 18 Nov 2009 05:25:16 +0100
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: -rt dbench scalabiltiy issue
Message-ID: <20091118042516.GC21813@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain> <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258507696.2077.61.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Great stuff, thanks for persisting with this. I've been a little bit busy
with a bit of distro work recently, but I hope to get back to some mainly
projects soon.

On Tue, Nov 17, 2009 at 05:28:16PM -0800, john stultz wrote:
> Hey Nick,
> 	Just an update here, I moved up to your 09102009 patch, and spent
> awhile playing with it.
> 
> Just as you theorized, moving d_count back to an atomic_t does seem to
> greatly improve the performance on -rt. 
> 
> Again, very very rough numbers for an 8-way system:
> 
> 				ext3		ramfs 
> 2.6.32-rc3:			~1800 MB/sec	~1600 MB/sec
> 2.6.32-rc3-nick			~1800 MB/sec	~2200 MB/sec
> 2.6.31.2-rt13:			 ~300 MB/sec	  ~66 MB/sec
> 2.6.31.2-rt13-nick:		  ~80 MB/sec	 ~126 MB/sec
> 2.6.31.6-rt19-nick+atomic:	 ~400 MB/sec	~2200 MB/sec

OK, that's very interesting. 09102009 patch contains the lock free path
walk that I was hoping will improve some of your issues. I guess it did
improve them a little bit but it is interesting that the atomic_t
conversion still gave such a huge speedup.

It would be interesting to know what d_count updates are causing the
most d_lock contention (without your +atomic patch).

One concern I have with +atomic is the extra atomic op required in
some cases. I still haven't gone over single thread performance with
a fine tooth comb, but even without +atomic, we have some areas that
need to be improved.

Nice numbers, btw. I never thought -rt would be able to completely
match mainline on dbench for that size of system (in vfs performance,
ie. the ramfs case).


> >From the perf report, all of the dcache related overhead has fallen
> away, and it all seems to be journal related contention at this point
> that's keeping the ext3 numbers down.
> 
> So yes, on -rt, the overhead from lock contention is way way worse then
> any extra atomic ops. :)

How about overhead for an uncontended lock? Ie. is the problem caused
because lock *contention* issues are magnified on -rt, or is it
because uncontended lock overheads are higher? Detailed callgraph
profiles and lockstat of +/-atomic case would be very interesting.
 
Ideally we just eliminate the cause of the d_count update, but I
concede that at some point and in some workloads, atomic d_count
is going to scale better.

I'd imagine in dbench case, contention comes on directory dentries
from like adding child dentries, which causes lockless path walk
to fail and retry the full locked walk from the root. One important
optimisation I have left to do is to just continue with locked
walk at the point where lockless fails, rather than the full path.
This should naturally help scalability as well as single threaded
performance.


> I'm not totally convinced I did the conversion back to atomic_t's
> properly, so I'm doing some stress testing, but I'll hopefully have
> something to send out for review soon. 
> 
> As for your concern about dbench being a poor benchmark here, I'll try
> to get some numbers on iozone or another suggested workload and get
> those out to you shortly.

Well I was mostly concerned that we needn't spend *lots* of time
trying to make dbench work. Bad performing dbench didn't necessarily
say too much, but good performing dbench is a good indication
(because it hits the vfs harder and in different ways than a lot
of other benchmarks).

Now, I don't think there is dispute that these patches vastly
improve scalability. So what I am personally most interested in
at this stage are any and all single thread performance benchmarks.
But please, the more numbers the merrier, so anything helps.

Thanks,
Nick

