Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZKWJG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZKWJG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZKWJG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:06:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbZKWJG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:06:26 -0500
Date: Mon, 23 Nov 2009 10:06:30 +0100
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: -rt dbench scalabiltiy issue
Message-ID: <20091123090630.GF5602@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain> <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost> <20091118042516.GC21813@wotan.suse.de> <1258683764.3840.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258683764.3840.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 06:22:44PM -0800, john stultz wrote:
> On Wed, 2009-11-18 at 05:25 +0100, Nick Piggin wrote:
> > On Tue, Nov 17, 2009 at 05:28:16PM -0800, john stultz wrote:
> > > Just as you theorized, moving d_count back to an atomic_t does seem to
> > > greatly improve the performance on -rt. 
> > > 
> > > Again, very very rough numbers for an 8-way system:
> > > 
> > > 				ext3		ramfs 
> > > 2.6.32-rc3:			~1800 MB/sec	~1600 MB/sec
> > > 2.6.32-rc3-nick			~1800 MB/sec	~2200 MB/sec
> > > 2.6.31.2-rt13:			 ~300 MB/sec	  ~66 MB/sec
> > > 2.6.31.2-rt13-nick:		  ~80 MB/sec	 ~126 MB/sec
> > > 2.6.31.6-rt19-nick+atomic:	 ~400 MB/sec	~2200 MB/sec
> 
> So I realized the above wasn't quite apples to apples, as the
> 2.6.32-rc3-nick and 2.6.31.2-rt13-nick are using your 06102009 patch, so
> I went through and regenerated all the data using the 09102009 patch so
> its a fair comparison. I also collected 1cpu, 2cpu, 4cpu and 8cpu data
> points to show the scalability from single threaded on up. Dbench still
> gives me more variability then I would like from run to run, so I'd not
> trust the numbers as very precise, but it should give you an idea of
> where things are.
> 
> I put the data I collected up here: 
> http://sr71.net/~jstultz/dbench-scalability/
> 
> The most interesting (ramfs) chart is here:
> http://sr71.net/~jstultz/dbench-scalability/graphs/ramfs-scalability.png

OK cool. So -rt-nick is a lot better, but +atomic is still yet better
again.


> > OK, that's very interesting. 09102009 patch contains the lock free path
> > walk that I was hoping will improve some of your issues. I guess it did
> > improve them a little bit but it is interesting that the atomic_t
> > conversion still gave such a huge speedup.
> > 
> > It would be interesting to know what d_count updates are causing the
> > most d_lock contention (without your +atomic patch).
> 
> >From the perf logs here:
> http://sr71.net/~jstultz/dbench-scalability/perflogs/
> 
> Its mostly d_lock contention from dput() and path_get()
> 
> rt19-nick:
> 41.09%       dbench  [kernel]                    [k] _atomic_spin_lock_irqsave
>                 |          
>                 |--85.45%-- rt_spin_lock_slowlock
>                 |          |          
>                 |          |--100.00%-- rt_spin_lock
>                 |          |          |          
>                 |          |          |--48.61%-- dput
>                 |          |          |          |          
>                 |          |          |          |--53.56%-- __link_path_walk
>                 |          |          |          |          |          
>                 |          |          |          |          |--100.00%-- path_walk
> 		...
> 		|          |          |--46.48%-- path_get
>                 |          |          |          |          
>                 |          |          |          |--59.01%-- path_walk
>                 |          |          |          |          |          
>                 |          |          |          |          |--90.13%-- do_path_lookup

Yep, these are coming from the non-_rcu variants, so probably mostly
contention on cwd. So I hope improving the lockfree fallback case
will improve this further.


> rt19-nick-atomic:

BTW. your next entry is this:
     6.92%       dbench  [kernel]                    [k] rt_spin_lock
                |          
                |--30.69%-- __d_path
                |          d_path
                |          seq_path
                |          show_vfsmnt
                |          seq_read
                |          vfs_read
                |          sys_read
                |          system_call_fastpath
                |          __GI___libc_read

Which is glibc's braindead statvfs implementation. It makes several
syscalls including reading and parsing /proc/mounts which is pretty
heavy.

I replaced the statvfs call to statfs in dbench to get around this.
(longer term we need to extend statfs to return mount flags and
get glibc to start using it). This would get rid of your most costly
spinlock and get you scaling a little further.


> > One concern I have with +atomic is the extra atomic op required in
> > some cases. I still haven't gone over single thread performance with
> > a fine tooth comb, but even without +atomic, we have some areas that
> > need to be improved.
> > 
> > Nice numbers, btw. I never thought -rt would be able to completely
> > match mainline on dbench for that size of system (in vfs performance,
> > ie. the ramfs case).
> 
> Yea, I was *very* pleased to see the ramfs numbers. Been working on this
> without much progress for quite awhile (mostly due to my vfs ignorance).

BTW. Have you tested like ext4, xfs and btrfs cases?  I don't think ext3
is likely to see a huge amount of scalability work, and so it will be
good to give an early heads up to the more active projects...


> > > >From the perf report, all of the dcache related overhead has fallen
> > > away, and it all seems to be journal related contention at this point
> > > that's keeping the ext3 numbers down.
> > > 
> > > So yes, on -rt, the overhead from lock contention is way way worse then
> > > any extra atomic ops. :)
> > 
> > How about overhead for an uncontended lock? Ie. is the problem caused
> > because lock *contention* issues are magnified on -rt, or is it
> > because uncontended lock overheads are higher? Detailed callgraph
> > profiles and lockstat of +/-atomic case would be very interesting.
> 
> Yea, Thomas already addressed this, but spinlocks become rtmutexes with
> -rt, so while the fast-path is very similar to a spinlock overhead wise,
> the slowpath hit in the contended case is much more painful.

Well, fast-path is similar but it has 2 atomics, so that means we
can do the atomic_t d_count without adding an extra atomic op in
the fastpath.

lookup does (for the last element):
spin_lock(d_lock)
// recheck fields
d_count++
spin_unlock(d_lock)

then release, dput:
spin_lock(d_lock)
d_count--
spin_unlock(d_lock)

So 2 atomics. Converting to atomic d_count would make it 3 atomics
because we can't easily avoid the d_lock in the lookup path. For
-rt, you have 4 atomics either way.


> The callgraphs perf logs are linked above. lockstat data is less useful
> with -rt, because all the atomic_spin_lock (real spinlock) contention is
> on the rtmutex waiter lock. Additionally, the actual lockstat output for
> rtmutexes is much less helpful.

Sure. I'd thought that perf may not be so good if lots of cost is
in the sleeping on the lock.

 
> > Ideally we just eliminate the cause of the d_count update, but I
> > concede that at some point and in some workloads, atomic d_count
> > is going to scale better.
> > 
> > I'd imagine in dbench case, contention comes on directory dentries
> > from like adding child dentries, which causes lockless path walk
> > to fail and retry the full locked walk from the root. One important
> > optimisation I have left to do is to just continue with locked
> > walk at the point where lockless fails, rather than the full path.
> > This should naturally help scalability as well as single threaded
> > performance.
> 
> Yea, I was trying to figure out why the rcu path walk seems to always
> fail back to the locked version, but I'm still not groking the
> vfs/dcache code well enough to understand.
> 
> The dput contention does seem mostly focused on the CWD that dbench is
> run from (I'm guessing this is where the locked full path walk is
> hurting and your change to fallback to where things failed might help?)

Exactly.


> > > I'm not totally convinced I did the conversion back to atomic_t's
> > > properly, so I'm doing some stress testing, but I'll hopefully have
> > > something to send out for review soon. 
> 
> And to follow up here, I apparently don't have the conversion back to
> atomic_t's done properly. I'm frequently hitting a bug in the unmount
> path on restart. So that still needs work, but the dcount-atomic patch
> (as well as the backport of your patch) can be found here if you'd like
> to take a look:
> http://sr71.net/~jstultz/dbench-scalability/patches/

I'll have to get some time to start working on this again. Soon.


> > > As for your concern about dbench being a poor benchmark here, I'll try
> > > to get some numbers on iozone or another suggested workload and get
> > > those out to you shortly.
> > 
> > Well I was mostly concerned that we needn't spend *lots* of time
> > trying to make dbench work. Bad performing dbench didn't necessarily
> > say too much, but good performing dbench is a good indication
> > (because it hits the vfs harder and in different ways than a lot
> > of other benchmarks).
> > 
> > Now, I don't think there is dispute that these patches vastly
> > improve scalability. So what I am personally most interested in
> > at this stage are any and all single thread performance benchmarks.
> > But please, the more numbers the merrier, so anything helps.
> 
> Ok, I'll still be working on on getting iozone numbers, but I wanted to
> collect and make more presentable the dbench data I had so far.

Yeah looks good, it's really interesting thanks.

