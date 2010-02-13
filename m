Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0BMC4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:56:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0BMCz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:55:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=n158gVMZzoLGy2SwbB1ZWE6LHWP/wA/xwbbO/0iMweXiia0Dq6APnx2Xxv8bxtw8/
	AhvPcf0L2Ng1oJIiPU31Q==
Subject: [RFC PATCH v1 0/4] CFS Bandwidth Control
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Date: Fri, 12 Feb 2010 18:54:52 -0800
Message-ID: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached an early patchset for an alternate approach to CFS
bandwidth provisioning.  Bharata's excellent original RFC motivating discussion 
on this topic can be found at: http://lkml.org/lkml/2009/6/4/24.

As discussed in reply to the latest iteration of Bharata's patchset (at: 
http://lkml.org/lkml/2010/1/5/44) we have significant concerns with the
adaption of the RT-bandwidth code to the general case.  In that discussion
an alternate approach as proposed in which a global per-taskgroup pool
is maintained with runqueues acquiring time directly from that (as opposed to
the RT all-rq-mapping-to-all-rq scheme).  In particular we felt the original
approach did not scale well with increasing number-of-cores or small 
reservations.

The skeleton of our approach is as follows:
- As above we maintain a global pool, per-tg, pool of unassigned quota.  On it
  we track the bandwidth period, quota per period, and runtime remaining in
  the current period.  As bandwidth is used within a period it is decremented
  from runtime.  Runtime is currently synchronized using a spinlock, in the
  current implementation there's no reason this couldn't be done using
  atomic ops instead however the spinlock allows for a little more flexibility
  in experimentation with other schemes.
- When a cfs_rq participating in a bandwidth constrained task_group executes
  it acquires time in sysctl_sched_cfs_bandwidth_slice (default currently
  10ms) size chunks from the global pool, this synchronizes under rq->lock and
  is part of the update_curr path.
- Throttled entities are dequeued immediately (as opposed to delaying this
  operation to the put path), this avoids some potentially poor load-balancer
  interactions and preserves the 'verbage' of the put_task semantic.
  Throttled entities are gated from participating in the tree at the
  {enqueue, dequeue}_entity level.  They are also skipped for load
  balance in the same manner as Bharatta's patch-series employs.

Interface:
----------
Two new cgroupfs files are added to the cpu subsystem:
- cpu.cfs_period_us : period over which bandwidth is to be regulated
- cpu.cfs_quota_us  : bandwidth available for consumption per period

One important interface change that this introduces (versus the rate limits
proposal) is that the defined bandwidth becomes an absolute quantifier.

e.g. a bandwidth of 5 seconds (cpu.cfs_quota_us=5000000) on a period of 1 second
(cpu.cfs_period_us=1000000) would result in 5 wall seconds of cpu time being
consumable every 1 wall second.

Benchmarks:
-----------
In the attached benchmarks we compared the two approaches with each other and
the third 'ideal' case of using cpu affinities to restrict cpus to an
equivalent rate.  Tests were performed on a 16-core AMD machine with no
restrictions to affinity  [Bandwidth is cpu_rate / period ]

Pardon the wall of raw results that follows, if you prefer to view the data in
graph format it's available at:
http://docs.google.com/View?id=dgjvsb78_6dhktmzhs

Workload 1: while(1)x16
Measured: % Utilization

period=100ms, workload=while(1)x16
          affinity         cfs bandwidth           cfs hardlimits
bandwidth  %busy            %busy (pct%)            %busy (pct%)
    1	    6.28	    6.67 (+6.2%)	    6.87 (+9.4%)
    2	   12.57	   13.20 (+5.0%)	   11.67 (-7.2%)
    3	   18.80	   19.42 (+3.3%)	   16.13 (-14.2%)
    4	   25.02	   25.60 (+2.3%)	   19.62 (-21.6%)
    5	   31.32	   31.74 (+1.3%)	   24.05 (-23.2%)
    6	   37.47	   37.92 (+1.2%)	   30.41 (-18.8%)
    7	   43.71	   43.95 (+0.5%)	   34.11 (-22.0%)
    8	   50.08	   50.14 (+0.1%)	   39.73 (-20.7%)
    9	   56.24	   56.15 (-0.2%)	   43.63 (-22.4%)
   10	   62.38	   62.33 (-0.1%)	   47.50 (-23.9%)
   11	   68.58	   67.81 (-1.1%)	   45.09 (-34.3%)
   12	   74.92	   72.13 (-3.7%)	   47.98 (-36.0%)
   13	   81.21	   74.11 (-8.7%)	   56.62 (-30.3%)
   14	   87.40	   84.06 (-3.8%)	   51.77 (-40.8%)
   15	   93.69	   83.56 (-10.8%)	   53.61 (-42.8%)
   16	   99.93	   99.88 (-0.1%)	   61.26 (-38.7%)
   
period=250ms, workload=while(1)x16
          affinity         cfs bandwidth           cfs hardlimits
bandwidth  %busy            %busy (pct%)            %busy (pct%)
    1	    6.28	    6.59 (+4.9%)	    6.53 (+4.0%)
    2	   12.49	   12.81 (+2.6%)	   12.78 (+2.3%)
    3	   18.74	   19.03 (+1.5%)	   18.08 (-3.5%)
    4	   25.11	   25.23 (+0.5%)	   22.72 (-9.5%)
    5	   31.26	   31.45 (+0.6%)	   30.27 (-3.2%)
    6	   37.58	   37.69 (+0.3%)	   34.69 (-7.7%)
    7	   43.79	   43.90 (+0.3%)	   37.91 (-13.4%)
    8	   49.99	   50.10 (+0.2%)	   43.00 (-14.0%)
    9	   56.34	   56.29 (-0.1%)	   46.90 (-16.8%)
   10	   62.45	   62.57 (+0.2%)	   50.22 (-19.6%)
   11	   68.70	   68.49 (-0.3%)	   59.10 (-14.0%)
   12	   74.86	   74.97 (+0.1%)	   58.59 (-21.7%)
   13	   81.17	   80.92 (-0.3%)	   68.39 (-15.7%)
   14	   87.34	   87.17 (-0.2%)	   71.73 (-17.9%)
   15	   93.66	   91.74 (-2.0%)	   72.26 (-22.8%)
   16	   99.89	   99.79 (-0.1%)	   66.16 (-33.8%)

period=500ms, workload=while(1)x16
          affinity         cfs bandwidth           cfs hardlimits
bandwidth  %busy            %busy (pct%)            %busy (pct%)
    1	    6.27	    6.43 (+2.6%)	    6.56 (+4.6%)
    2	   12.48	   12.69 (+1.7%)	   12.68 (+1.6%)
    3	   19.04	   18.90 (-0.7%)	   18.99 (-0.3%)
    4	   25.05	   25.12 (+0.3%)	   25.22 (+0.7%)
    5	   31.33	   31.28 (-0.2%)	   31.45 (+0.4%)
    6	   37.39	   37.66 (+0.7%)	   37.70 (+0.8%)
    7	   43.73	   43.77 (+0.1%)	   43.83 (+0.2%)
    8	   50.13	   50.02 (-0.2%)	   49.70 (-0.9%)
    9	   56.29	   56.24 (-0.1%)	   56.16 (-0.2%)
   10	   62.47	   62.54 (+0.1%)	   61.07 (-2.2%)
   11	   68.69	   68.79 (+0.1%)	   67.70 (-1.4%)
   12	   74.98	   74.89 (-0.1%)	   75.10 (+0.2%)
   13	   81.14	   81.24 (+0.1%)	   72.29 (-10.9%)
   14	   87.43	   86.91 (-0.6%)	   85.79 (-1.9%)
   15	   93.77	   93.36 (-0.4%)	   82.12 (-12.4%)
   16	   99.90	   99.89 (-0.0%)	   91.27 (-8.6%)

Workload 2: sysbench prime computation (100k primes, 16 threads)
Measured: time to completion
period=100ms:
          affinity         cfs bandwidth           cfs hardlimits
bandwidth time(s)         time(s) (pct%)          time(s) (pct%)
    1	  422.44	  435.19 (+3.0%)	  405.66 (-4.0%)
    2	  211.54	  217.40 (+2.8%)	  255.73 (+20.9%)
    3	  140.89	  146.98 (+4.3%)	  178.67 (+26.8%)
    4	  105.56	  110.94 (+5.1%)	  136.83 (+29.6%)
    5	   84.45	   90.88 (+7.6%)	  103.81 (+22.9%)
    6	   70.46	   72.34 (+2.7%)	   90.22 (+28.0%)
    7	   60.38	   59.97 (-0.7%)	   81.56 (+35.1%)
    8	   52.79	   54.81 (+3.8%)	   66.93 (+26.8%)
    9	   46.92	   48.33 (+3.0%)	   59.08 (+25.9%)
   10	   42.27	   42.82 (+1.3%)	   51.38 (+21.6%)
   11	   38.47	   45.50 (+18.3%)	   54.27 (+41.1%)
   12	   35.19	   35.88 (+2.0%)	   52.35 (+48.8%)
   13	   32.44	   41.01 (+26.4%)	   44.11 (+36.0%)
   14	   30.04	   34.95 (+16.4%)	   46.40 (+54.5%)
   15	   27.98	   31.13 (+11.2%)	   42.98 (+53.6%)
   16	   26.25	   26.23 (-0.1%)	   46.69 (+77.9%

period=250ms:
          affinity         cfs bandwidth           cfs hardlimits
bandwidth time(s)         time(s) (pct%)          time(s) (pct%)
    1	  422.45	  424.09 (+0.4%)	  417.32 (-1.2%)
    2	  211.53	  216.60 (+2.4%)	  218.47 (+3.3%)
    3	  140.94	  141.91 (+0.7%)	  150.92 (+7.1%)
    4	  105.55	  104.59 (-0.9%)	  113.43 (+7.5%)
    5	   84.42	   83.61 (-1.0%)	   92.40 (+9.5%)
    6	   70.53	   69.64 (-1.3%)	   78.60 (+11.4%)
    7	   60.41	   67.96 (+12.5%)	   70.19 (+16.2%)
    8	   52.76	   52.21 (-1.1%)	   55.40 (+5.0%)
    9	   46.91	   46.43 (-1.0%)	   53.49 (+14.0%)
   10	   42.38	   41.77 (-1.4%)	   50.64 (+19.5%)
   11	   38.46	   38.39 (-0.2%)	   47.19 (+22.7%)
   12	   35.22	   34.94 (-0.8%)	   42.02 (+19.3%)
   13	   32.45	   32.12 (-1.0%)	   38.57 (+18.9%)
   14	   30.08	   30.20 (+0.4%)	   36.33 (+20.8%)
   15	   27.96	   28.43 (+1.7%)	   34.41 (+23.1%)
   16	   26.20	   26.22 (+0.1%)	   37.20 (+42.0%)

period=500ms
          affinity         cfs bandwidth           cfs hardlimits
bandwidth time(s)         time(s) (pct%)          time(s) (pct%)
    1	  422.45	  423.16 (+0.2%)	  412.34 (-2.4%)
    2	  211.57	  208.95 (-1.2%)	  210.60 (-0.5%)
    3	  140.90	  139.31 (-1.1%)	  138.48 (-1.7%)
    4	  105.54	  104.45 (-1.0%)	  104.14 (-1.3%)
    5	   84.44	   83.45 (-1.2%)	   82.91 (-1.8%)
    6	   70.44	   69.41 (-1.5%)	   69.33 (-1.6%)
    7	   60.42	   59.37 (-1.7%)	   59.43 (-1.6%)
    8	   52.77	   51.92 (-1.6%)	   52.41 (-0.7%)
    9	   46.91	   46.13 (-1.7%)	   46.29 (-1.3%)
   10	   42.36	   41.69 (-1.6%)	   41.60 (-1.8%)
   11	   38.44	   37.95 (-1.3%)	   38.31 (-0.3%)
   12	   35.20	   34.82 (-1.1%)	   35.03 (-0.5%)
   13	   32.47	   34.07 (+4.9%)	   32.17 (-0.9%)
   14	   30.05	   29.89 (-0.6%)	   31.30 (+4.1%)
   15	   28.00	   27.98 (-0.1%)	   29.42 (+5.1%)
   16	   26.20	   26.22 (+0.1%)	   30.04 (+14.6%)

Again, This data is consumable more directly (graphed) at:
http://docs.google.com/View?id=dgjvsb78_6dhktmzhs

Todo:
-----
- hierarchal nr_tasks_running accounting:
  This is a deficiency currently shared with SCHED_RT rate limiting.  When
  entities is throttled the running tasks it owns are not subtracted from 
  rq->nr_running.  This then results in us missing idle_balance() due to
  phantom tasks and load balancer weight per task calculations being
  incorrect.

  This code adds complexity which was both increasing the complexity of the
  initial review for this patchset and truly probably best reviewed
  independently of this feature's scope.  To that end we'll post a separate
  patch for this issue against the current RT rate-limiting code and merge any 
  converged on approach here as appropriate.

- throttle statistics:
  Some statistics regarding the frequency and duration of throttling
  definitely in order.

- Expiration of quota from a previous period?
  The local quota assigned to a cfs_rq represents some 'slack' in the system
  currently.  While the rate of overal consumption by the system is capped by 
  the input of bandwidth into the global pool it's possible to locally exceed
  bandwidth within a period if there is remaining local quota from a previous
  period.

  The maximum slack in the system at any time is bounded above by
  weight(tg->allowed_cpus) * cfs_bandwidth_slice.  There are a number of
  approaches possible in managing this slack, from naively resetting local
  quota_assigned at period refresh to tracking when quota was issued using
  generations.

  We have an experimental patch which adds quota generations (the latter) to
  this series, however I just realized there's potential rq->lock inversion
  within it currently so I'm going to have to defer that to the next version.

Open Questions:
---------------
- per-tg slice tunable?
  Does it make sense to allow tuning of slice at the per-tg level or is global
  sufficient?
- I suspect 5ms may be a more sensible/better performing default slice, but
  the benchmarks above were performed at 10 so.. so be it, maybe in v2 :).
  It's also possible some sort of limited step-function may make sense here
  (e.g. favour repeated requests with larger slices, infrequent/likely to
  yield with smaller)

Acknowledgements:
-----------------
We would like to thank Bharata B Rao and Dhaval Giani for both discussion and 
their proposed patches, many elements in our patchset are directly based on 
their work in this area.

Thank you to Ken Chen also for early review and comments.

Thanks for reading this far :)

- Paul and Nikhil


---

Paul Turner (4):
      sched: introduce primitives to account for CFS bandwidth tracking
      sched: accumulate per-cfs_rq cpu usage
      sched: throttle cfs_rq entities which exceed their local quota
      sched: unthrottle cfs_rq(s) who ran out of quota at period refresh


 include/linux/sched.h |    4 +
 init/Kconfig          |    9 +
 kernel/sched.c        |  317 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched_fair.c   |  206 ++++++++++++++++++++++++++++++--
 kernel/sched_rt.c     |   19 ---
 kernel/sysctl.c       |   10 ++
 6 files changed, 512 insertions(+), 53 deletions(-)

