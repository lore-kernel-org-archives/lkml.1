Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZKTCWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZKTCWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 21:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZKTCWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 21:22:44 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55477 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbZKTCWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 21:22:43 -0500
Subject: Re: -rt dbench scalabiltiy issue
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091118042516.GC21813@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain>
	 <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost>
	 <20091118042516.GC21813@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 18:22:44 -0800
Message-ID: <1258683764.3840.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 05:25 +0100, Nick Piggin wrote:
> On Tue, Nov 17, 2009 at 05:28:16PM -0800, john stultz wrote:
> > Just as you theorized, moving d_count back to an atomic_t does seem to
> > greatly improve the performance on -rt. 
> > 
> > Again, very very rough numbers for an 8-way system:
> > 
> > 				ext3		ramfs 
> > 2.6.32-rc3:			~1800 MB/sec	~1600 MB/sec
> > 2.6.32-rc3-nick			~1800 MB/sec	~2200 MB/sec
> > 2.6.31.2-rt13:			 ~300 MB/sec	  ~66 MB/sec
> > 2.6.31.2-rt13-nick:		  ~80 MB/sec	 ~126 MB/sec
> > 2.6.31.6-rt19-nick+atomic:	 ~400 MB/sec	~2200 MB/sec

So I realized the above wasn't quite apples to apples, as the
2.6.32-rc3-nick and 2.6.31.2-rt13-nick are using your 06102009 patch, so
I went through and regenerated all the data using the 09102009 patch so
its a fair comparison. I also collected 1cpu, 2cpu, 4cpu and 8cpu data
points to show the scalability from single threaded on up. Dbench still
gives me more variability then I would like from run to run, so I'd not
trust the numbers as very precise, but it should give you an idea of
where things are.

I put the data I collected up here: 
http://sr71.net/~jstultz/dbench-scalability/

The most interesting (ramfs) chart is here:
http://sr71.net/~jstultz/dbench-scalability/graphs/ramfs-scalability.png


> OK, that's very interesting. 09102009 patch contains the lock free path
> walk that I was hoping will improve some of your issues. I guess it did
> improve them a little bit but it is interesting that the atomic_t
> conversion still gave such a huge speedup.
> 
> It would be interesting to know what d_count updates are causing the
> most d_lock contention (without your +atomic patch).

>From the perf logs here:
http://sr71.net/~jstultz/dbench-scalability/perflogs/

Its mostly d_lock contention from dput() and path_get()

rt19-nick:
41.09%       dbench  [kernel]                    [k] _atomic_spin_lock_irqsave
                |          
                |--85.45%-- rt_spin_lock_slowlock
                |          |          
                |          |--100.00%-- rt_spin_lock
                |          |          |          
                |          |          |--48.61%-- dput
                |          |          |          |          
                |          |          |          |--53.56%-- __link_path_walk
                |          |          |          |          |          
                |          |          |          |          |--100.00%-- path_walk
		...
		|          |          |--46.48%-- path_get
                |          |          |          |          
                |          |          |          |--59.01%-- path_walk
                |          |          |          |          |          
                |          |          |          |          |--90.13%-- do_path_lookup


rt19-nick-atomic:
13.04%       dbench  [kernel]                    [k] copy_user_generic_string
                |          
                |--62.51%-- generic_file_aio_read
                |          do_sync_read
                |          vfs_read
                |          |          
                |          |--97.80%-- sys_pread64
                |          |          system_call_fastpath
                |          |          __GI___libc_pread
                |          |          
		...
		|--32.17%-- generic_file_buffered_write
                |          __generic_file_aio_write_nolock
                |          generic_file_aio_write
                |          do_sync_write
                |          vfs_write
                |          sys_pwrite64
                |          system_call_fastpath
                |          __GI_pwrite


> One concern I have with +atomic is the extra atomic op required in
> some cases. I still haven't gone over single thread performance with
> a fine tooth comb, but even without +atomic, we have some areas that
> need to be improved.
> 
> Nice numbers, btw. I never thought -rt would be able to completely
> match mainline on dbench for that size of system (in vfs performance,
> ie. the ramfs case).

Yea, I was *very* pleased to see the ramfs numbers. Been working on this
without much progress for quite awhile (mostly due to my vfs ignorance).


> > >From the perf report, all of the dcache related overhead has fallen
> > away, and it all seems to be journal related contention at this point
> > that's keeping the ext3 numbers down.
> > 
> > So yes, on -rt, the overhead from lock contention is way way worse then
> > any extra atomic ops. :)
> 
> How about overhead for an uncontended lock? Ie. is the problem caused
> because lock *contention* issues are magnified on -rt, or is it
> because uncontended lock overheads are higher? Detailed callgraph
> profiles and lockstat of +/-atomic case would be very interesting.

Yea, Thomas already addressed this, but spinlocks become rtmutexes with
-rt, so while the fast-path is very similar to a spinlock overhead wise,
the slowpath hit in the contended case is much more painful.

The callgraphs perf logs are linked above. lockstat data is less useful
with -rt, because all the atomic_spin_lock (real spinlock) contention is
on the rtmutex waiter lock. Additionally, the actual lockstat output for
rtmutexes is much less helpful.

> Ideally we just eliminate the cause of the d_count update, but I
> concede that at some point and in some workloads, atomic d_count
> is going to scale better.
> 
> I'd imagine in dbench case, contention comes on directory dentries
> from like adding child dentries, which causes lockless path walk
> to fail and retry the full locked walk from the root. One important
> optimisation I have left to do is to just continue with locked
> walk at the point where lockless fails, rather than the full path.
> This should naturally help scalability as well as single threaded
> performance.

Yea, I was trying to figure out why the rcu path walk seems to always
fail back to the locked version, but I'm still not groking the
vfs/dcache code well enough to understand.

The dput contention does seem mostly focused on the CWD that dbench is
run from (I'm guessing this is where the locked full path walk is
hurting and your change to fallback to where things failed might help?)


> > I'm not totally convinced I did the conversion back to atomic_t's
> > properly, so I'm doing some stress testing, but I'll hopefully have
> > something to send out for review soon. 

And to follow up here, I apparently don't have the conversion back to
atomic_t's done properly. I'm frequently hitting a bug in the unmount
path on restart. So that still needs work, but the dcount-atomic patch
(as well as the backport of your patch) can be found here if you'd like
to take a look:
http://sr71.net/~jstultz/dbench-scalability/patches/


> > As for your concern about dbench being a poor benchmark here, I'll try
> > to get some numbers on iozone or another suggested workload and get
> > those out to you shortly.
> 
> Well I was mostly concerned that we needn't spend *lots* of time
> trying to make dbench work. Bad performing dbench didn't necessarily
> say too much, but good performing dbench is a good indication
> (because it hits the vfs harder and in different ways than a lot
> of other benchmarks).
> 
> Now, I don't think there is dispute that these patches vastly
> improve scalability. So what I am personally most interested in
> at this stage are any and all single thread performance benchmarks.
> But please, the more numbers the merrier, so anything helps.

Ok, I'll still be working on on getting iozone numbers, but I wanted to
collect and make more presentable the dbench data I had so far.

thanks
-john

