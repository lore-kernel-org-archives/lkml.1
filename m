Return-Path: <linux-kernel-owner+w=401wt.eu-S1767175AbXDTSaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767175AbXDTSaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767174AbXDTSaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:30:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:4191 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767175AbXDTSaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:30:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,433,1170662400"; 
   d="scan'208"; a="216797201:sNHT72554293"
Date: Fri, 20 Apr 2007 11:30:04 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: linux-kernel@vger.kernel.org
Subject: [RFC] Extend Linux to support proportional-share scheduling
Message-ID: <Pine.LNX.4.64.0704201111200.18780@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the existing Linux scheduler with support for
proportional-share scheduling (as a new KConfig option).

http://www.cs.duke.edu/~tongli/linux/linux-2.6.19.2-trio.patch

It uses a scheduling algorithm, called Distributed Weighted Round-Robin 
(DWRR), which retains the existing scheduler design as much as possible, 
and extends it to achieve proportional fairness with O(1) time complexity 
and a constant error bound, compared to the ideal fair scheduling 
algorithm. The code is by no means final and has been only tested on a 
four-processor dual-core x86-64 system. Rather than focusing on coding 
issues, the intent of this RFC is to invite discussions on the proposed 
DWRR algorithm and proportional-share scheduling in general.

Background:

Over the years, there has been a lot of criticism that conventional Unix 
priorities and the nice interface provide insufficient support for users 
to accurately control CPU shares of different threads or applications. 
Many have studied scheduling algorithms that achieve proportional 
fairness. Assuming that each thread has a weight that expresses its 
desired CPU share, informally, a scheduler achieves ideal proportional 
fairness if (1) it is work-conserving, and (2) it allocates CPU time to 
threads in exact proportion to their weights in any time interval. Ideal 
proportional fairness is impossible since it requires that all runnable 
threads be running simultaneously and scheduled with infinitesimally small 
quanta. In practice, every proportional-share scheduling algorithm 
approximates the ideal algorithm with the goal of achieving a constant 
error bound. For more theoretical background, please refer to the 
following papers:

[1] A. K. Parekh and R. G. Gallager. A generalized processor sharing 
approach to flow control in integrated services networks: The single-node 
case. IEEE/ACM Transactions on Networking, 1(3):344-357, June 1993.

[2] C. R. Bennett and H. Zhang. WF2Q: Worst-case fair weighted fair 
queueing. In Proceedings of IEEE INFOCOM '94, pages 120-128, Mar. 1996.

Previous proportional-share scheduling algorithms, however, suffer one or 
more of the following problems:

(1) Inaccurate fairness with non-constant error bounds;
(2) High run-time overhead (e.g., logarithmic);
(3) Poor scalability due to the use of global run queues;
(4) Inefficient support for latency-sensitive applications.

Since the Linux scheduler has been successful at avoiding problems 2 to 4, 
this design attempts to extend it with support for accurate proportional 
fairness while retaining all of its existing benefits.

User Interface:

By default, each thread is assigned a weight proportional to its static 
priority. A set of system calls also allow users to specify a weight or 
reservation for any thread. Weights are relative. For example, for two 
threads with weights 3 and 1, the scheduler ensures that the ratio of 
their CPU time is 3:1. Reservations are absolute and in the form of X% of 
the total CPU time. For example, a reservation of 80% for a thread means 
that the thread always receives at least 80% of the total CPU time 
regardless of other threads.

The system calls also support specifying weights or reservations for groups of
threads. For example, one can specify an 80% reservation for a group of
threads (e.g., a process) to control the total CPU share to which the member
threads are collectively entitled.  Within the group, the user can further
specify local weights to different threads to control their relative shares.

Scheduling Algorithm:

The scheduler keeps a set data structures, called Trio groups, to maintain 
the weight or reservation of each thread group (including one or more 
threads) and the local weight of each member thread. When scheduling a 
thread, it consults these data structures and computes (in constant time) 
a system-wide weight for the thread that represents an equivalent CPU 
share. Consequently, the scheduling algorithm, DWRR, operates solely based 
on the system-wide weight (or weight for short, hereafter) of each thread.

For each processor, besides the existing active and expired arrays, DWRR 
keeps one more array, called round-expired. It also keeps a round number 
for each processor, initially all zero. A thread is said to be in round R 
if it is in the active or expired array of a round-R processor. For each 
thread, DWRR associates it with a round slice, equal to its weight 
multiplied by a scaling factor, which controls the total time that the 
thread can run in any round. When a thread exhausts its time slice, as in 
the existing scheduler, DWRR moves it to the expired array. However, when 
it exhausts its round slice, DWRR moves it to the round-expired array, 
indicating that the thread has finished round R. In this way, all threads 
in the active and expired arrays on a round-R processor are running in 
round R, while the threads in the round-expired array have finished round 
R and are awaiting to start round R+1. Threads in the active and expired 
arrays are scheduled the same way as the existing scheduler.

When a processor's active array is empty, as usual, the active and expired 
arrays are switched. When both active and expired are empty, DWRR 
eventually wants to switch the active and round-expired arrays, thus 
advancing the current processor to the next round. However, to guarantee 
fairness, it needs to maintain the invariant that the rounds of all 
processors differ by at most one (when each processor has more than one 
thread in the run queue). Given this invariant, it can be shown that, 
during any time interval, the number of rounds that any two threads go 
through differs by at most one. This property is key to ensuring DWRR's 
constant error bound compared to the ideal algorithm (formal proofs 
available upon request).

To enforce the above invariant, DWRR keeps track of the highest round 
(referred to as highest) among all processors at any time and ensures that 
no processor in round highest can advance to round highest+1 (thus 
updating highest), if there exists at least one thread in the system that 
is in round highest and not currently running. Specifically, it operates 
as follows:

On any processor p, whenever both the active and expired arrays become 
empty, DWRR compares the round of p with highest. If equal, it performs 
idle load balancing in two steps: (1) It identifies runnable threads that 
are in round highest but not currently running. Such threads can be in the 
active or expired array of a round highest processor, or in the 
round-expired array of a round highest - 1 processor. (2) Among those 
threads from step 1, move X of them to the active array of p, where X is a 
design choice and does not impact the fairness properties of DWRR. If step 
1 returns no suitable threads, DWRR proceeds as if the round of processor 
p is less than highest, in which case DWRR switches p's active and 
round-expired arrays, and increments p's round by one, thus allowing all 
threads in its round-expired array to advance to the next round.

Whenever the system creates a new thread or awakens an existing one, DWRR
inserts the thread into the active array of an idle processor and sets the
processor's round to the current value of highest. If no idle processor
exists, it starts the thread on the least loaded processor among those in
round highest.

Whenever a processor goes idle (i.e., all of its three arrays are empty), DWRR
resets its round to zero. Similar to the existing scheduler, DWRR also
performs periodic load balancing but only among processors in round highest.
Unlike idle load balancing, periodic load balancing only improves performance
and is not necessary for fairness.

   tong
