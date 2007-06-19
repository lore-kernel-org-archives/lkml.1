Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXFSPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXFSPIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbXFSPIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:08:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55281 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbXFSPID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:08:03 -0400
Date: Tue, 19 Jun 2007 08:08:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au, clameter@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070619150800.GB8436@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070613185522.GA27335@elte.hu> <20070613233910.GJ8125@linux.vnet.ibm.com> <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com> <20070619090430.GA7471@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619090430.GA7471@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 11:04:30AM +0200, Ingo Molnar wrote:
> 
> * Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> 
> > I believe the patch below is correct. With the patch applied, I could 
> > not recreate the imbalance with rcutorture. Let me know whether you 
> > still see the problem with this patch applied on any other machine.
> 
> thanks for tracking this down! I've applied Christoph's patch (with your 
> suggested modification plus a few small cleanups).
> 
> I'm wondering, why did this trigger under CFS and not on mainline? 
> Mainline seems to have a similar problem in idle_balance() too, or am i 
> misreading it?

It did in fact trigger under all three of mainline, CFS, and -rt including
CFS -- see below for a couple of emails from last Friday giving results
for these three on the AMD box (where it happened) and on a single-quad
NUMA-Q system (where it did not, at least not with such severity).

That said, there certainly was a time when neither mainline nor -rt
acted this way!

						Thanx, Paul

------------------------------------------------------------------------

Date: Fri, 15 Jun 2007 13:06:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: v2.6.21.4-rt11

On Fri, Jun 15, 2007 at 08:14:52AM -0700, Paul E. McKenney wrote:
> On Fri, Jun 15, 2007 at 04:45:35PM +0200, Ingo Molnar wrote:
> > 
> > Paul,
> > 
> > do you still see the load-distribution problem with -rt14? (which 
> > includes cfsv17) Or rather ... could you try vanilla cfsv17 instead:
> > 
> >    http://people.redhat.com/mingo/cfs-scheduler/
> > 
> > to make sure it's not some effect in -rt causing this. v17 has an 
> > updated load balancing code. (which might or might not affect the 
> > rcutorture problem.)

No joy, see below.  Strangely hardware dependent.  My next step, left
to myself, would be to patch rcutorture.c to cause the readers to dump
the CFS state information every ten seconds or so.  My guess is that
the important per-task stuff is:

	current->sched_info.pcnt
	current->sched_info.cpu_time
	current->sched_info.run_delay
	current->sched_info.last_arrival
	current->sched_info.last_queued

And maybe the runqueue info dumped out by show_schedstat, this last
via new per-CPU tasks.

Other thoughts?

						Thanx, Paul

> Good point!  I will try the following:
> 
> 1.	Stock 2.6.21.5.  64-bit kernel on AMD Opterons.

All eight readers end up on the same CPU, CPU 1 in this case.  And they
stay there (ten minutes).

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 3058 root      39  19     0    0    0 R 12.7  0.0   0:06.91 rcu_torture_rea   
 3059 root      39  19     0    0    0 R 12.7  0.0   0:06.91 rcu_torture_rea   
 3060 root      39  19     0    0    0 R 12.7  0.0   0:06.91 rcu_torture_rea   
 3061 root      39  19     0    0    0 R 12.7  0.0   0:06.91 rcu_torture_rea   
 3062 root      39  19     0    0    0 R 12.7  0.0   0:06.91 rcu_torture_rea   
 3063 root      39  19     0    0    0 R 12.7  0.0   0:06.91 rcu_torture_rea   
 3057 root      39  19     0    0    0 R 12.3  0.0   0:06.91 rcu_torture_rea   
 3064 root      39  19     0    0    0 R 12.3  0.0   0:06.91 rcu_torture_rea   

> 1.	Stock 2.6.21.5.  32-bit kernel on NUMA-Q.

Works just fine(!).

> 2.	2.6.21-rt14.  64-bit kernel on AMD Opterons.

All eight readers are spread, but over only two CPUs (0 and 3, in this
case).  Persists, usually with 4/4 split, but sometimes with five
tasks on one CPU and three on the other.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 3111 root      39  19     0    0    0 R 23.9  0.0   0:27.27 rcu_torture_rea   
 3114 root      39  19     0    0    0 R 23.9  0.0   0:28.58 rcu_torture_rea   
 3117 root      39  19     0    0    0 R 23.9  0.0   0:32.40 rcu_torture_rea   
 3112 root      39  19     0    0    0 R 23.6  0.0   0:28.41 rcu_torture_rea   
 3110 root      39  19     0    0    0 R 22.9  0.0   0:43.46 rcu_torture_rea   
 3113 root      39  19     0    0    0 R 22.9  0.0   0:27.28 rcu_torture_rea   
 3115 root      39  19     0    0    0 R 22.9  0.0   0:33.08 rcu_torture_rea   
 3116 root      39  19     0    0    0 R 22.6  0.0   0:28.10 rcu_torture_rea   

elm3b6:~# for ((i=3110;i<=3117;i++)); do cat /proc/$i/stat | awk '{print $(NF-3)}'; done
3 3 0 3 0 0 0 3

> 2.	2.6.21-rt14.  32-bit kernel on NUMA-Q.

Works just fine.

> 3.	2.6.21.5 + sched-cfs-v2.6.21.5-v17.patch on 64-bit kernel on
	AMD Opteron.

All eight readers end up on the same CPU, CPU 2 in this case.  And they
stay there (ten minutes).

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 3081 root      39  19     0    0    0 R 11.3  0.0   1:31.77 rcu_torture_rea   
 3082 root      39  19     0    0    0 R 11.3  0.0   1:31.77 rcu_torture_rea   
 3085 root      39  19     0    0    0 R 11.3  0.0   1:31.78 rcu_torture_rea   
 3079 root      39  19     0    0    0 R 11.0  0.0   1:31.72 rcu_torture_rea   
 3080 root      39  19     0    0    0 R 11.0  0.0   1:31.76 rcu_torture_rea   
 3083 root      39  19     0    0    0 R 11.0  0.0   1:31.76 rcu_torture_rea   
 3084 root      39  19     0    0    0 R 11.0  0.0   1:31.77 rcu_torture_rea   
 3086 root      39  19     0    0    0 R 11.0  0.0   1:31.75 rcu_torture_rea   

Using "taskset" to pin each process to a pair of CPUs (masks 0x3, 0x6,
0xc, and 0x9) forces them to CPUs 0 and 2 -- previously this had spread
them nicely.  So I kept pinning tasks to single CPUs (which defeats
some rcutorture testing) until they did spread, getting the following:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 3079 root      39  19     0    0    0 R 49.9  0.0   3:18.91 rcu_torture_rea   
 3080 root      39  19     0    0    0 R 49.6  0.0   3:15.76 rcu_torture_rea   
 3086 root      39  19     0    0    0 R 49.6  0.0   3:48.82 rcu_torture_rea   
 3083 root      39  19     0    0    0 R 49.3  0.0   2:58.02 rcu_torture_rea   
 3084 root      39  19     0    0    0 R 48.6  0.0   3:00.54 rcu_torture_rea   
 3081 root      39  19     0    0    0 R 47.9  0.0   3:00.55 rcu_torture_rea   
 3082 root      39  19     0    0    0 R 44.6  0.0   3:18.89 rcu_torture_rea   
 3085 root      39  19     0    0    0 R 44.3  0.0   3:07.11 rcu_torture_rea   

elm3b6:~# for ((i=3079;i<=3086;i++)); do cat /proc/$i/stat | awk '{print $(NF-3)}'; done
0 0 2 1 3 2 1 3

> 3.	2.6.21.5 + sched-cfs-v2.6.21.5-v17.patch on 32-bit kernel on
	NUMA-Q.

Some imbalance:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 2263 root      39  19     0    0    0 R 92.4  0.0   2:19.69 rcu_torture_rea   
 2265 root      39  19     0    0    0 R 49.8  0.0   1:41.84 rcu_torture_rea   
 2264 root      39  19     0    0    0 R 49.5  0.0   2:11.69 rcu_torture_rea   
 2261 root      39  19     0    0    0 R 48.8  0.0   2:09.95 rcu_torture_rea   
 2262 root      39  19     0    0    0 R 48.8  0.0   3:01.42 rcu_torture_rea   
 2266 root      39  19     0    0    0 R 30.1  0.0   1:47.02 rcu_torture_rea   
 2260 root      39  19     0    0    0 R 29.8  0.0   2:10.07 rcu_torture_rea   
 2267 root      39  19     0    0    0 R 29.8  0.0   1:57.34 rcu_torture_rea   

elm3b132:~# for ((i=2260;i<=2267;i++)); do cat /proc/$i/stat | awk '{print $(NF-3)}'; done
0 1 3 1 2 2 2 0

Has persisted (with some shuffling of CPUs, see below) for about five
minutes, will let it run for an hour or so to see if it is really serious
about this.

3 0 0 2 1 0 2 3 

------------------------------------------------------------------------

Date: Fri, 15 Jun 2007 15:00:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Dinakar Guniguntala <dino@in.ibm.com>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.21.4-rt11

On Fri, Jun 15, 2007 at 10:35:39PM +0200, Ingo Molnar wrote:
> 
> (forwarding Paul's mail below to other CFS hackers too.)
> 
> ------------>

[ . . . ]

> > 3.	2.6.21.5 + sched-cfs-v2.6.21.5-v17.patch on 32-bit kernel on
> 	NUMA-Q.
> 
> Some imbalance:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2263 root      39  19     0    0    0 R 92.4  0.0   2:19.69 rcu_torture_rea
>  2265 root      39  19     0    0    0 R 49.8  0.0   1:41.84 rcu_torture_rea
>  2264 root      39  19     0    0    0 R 49.5  0.0   2:11.69 rcu_torture_rea
>  2261 root      39  19     0    0    0 R 48.8  0.0   2:09.95 rcu_torture_rea
>  2262 root      39  19     0    0    0 R 48.8  0.0   3:01.42 rcu_torture_rea
>  2266 root      39  19     0    0    0 R 30.1  0.0   1:47.02 rcu_torture_rea
>  2260 root      39  19     0    0    0 R 29.8  0.0   2:10.07 rcu_torture_rea
>  2267 root      39  19     0    0    0 R 29.8  0.0   1:57.34 rcu_torture_rea
> 
> elm3b132:~# for ((i=2260;i<=2267;i++)); do cat /proc/$i/stat | awk '{print $(NF-3)}'; done
> 0 1 3 1 2 2 2 0
> 
> Has persisted (with some shuffling of CPUs, see below) for about five
> minutes, will let it run for an hour or so to see if it is really serious
> about this.
> 
> 3 0 0 2 1 0 2 3 

And when I returned after an hour, it had straightened itself out:
1 3 1 2 2 0 3 0

The 64-bit AMD 4-CPU machines have not straightened themselves out
in the past, but will try an extended run over the weekend to see
if load balancing is just a bit on the slow side.  ;-)

But got distracted for an additional hour, and it is imbalanced again:

2 1 2 0 1 1 3 3

Strange...

						Thanx, Paul
