Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZCLSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZCLSEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbZCLSEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:04:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbZCLSE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:04:29 -0400
Date: Thu, 12 Mar 2009 14:01:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       arozansk@redhat.com, jmoyer@redhat.com, oz-kernel@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       menage@google.com, peterz@infradead.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH 01/10] Documentation
Message-ID: <20090312180126.GI10919@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-2-git-send-email-vgoyal@redhat.com> <20090312001146.74591b9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312001146.74591b9d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 12:11:46AM -0700, Andrew Morton wrote:
> On Wed, 11 Mar 2009 21:56:46 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > +Currently "current" task
> > +is used to determine the cgroup (hence io group) of the request. Down the
> > +line we need to make use of bio-cgroup patches to map delayed writes to
> > +right group.
> 
> You handled this problem pretty neatly!
> 
> It's always been a BIG problem for all the io-controlling schemes, and
> most of them seem to have "handled" it in the above way :(
> 
> But for many workloads, writeback is the majority of the IO and it has
> always been the form of IO which has caused us the worst contention and
> latency problems.  So I don't think that we can proceed with _anything_
> until we at least have a convincing plan here.
> 

Hi Andrew,

Nauman is already maintaining the bio-cgroup patches (originally from
valinux folks) on top of this patchset for attributing write requests to
correct cgroup. We did not include those in initial posting thinking that
patchest will bloat further.

We can pull in bio-cgroup patches also in this series to attribute writes
to right cgroup.

> 
> Also..  there are so many IO controller implementations that I've lost
> track of who is doing what.  I do have one private report here that
> Andreas's controller "is incredibly productive for us and has allowed
> us to put twice as many users per server with faster times for all
> users".  Which is pretty stunning, although it should be viewed as a
> condemnation of the current code, I'm afraid.
> 

I had looked briefly at Andrea's implementation in the past. I will look
again. I had thought that this approach did not get much traction.

Some quick thoughts about this approach though.

- It is not a proportional weight controller. It is more of limiting
  bandwidth in absolute numbers for each cgroup on each disk.
 
  So each cgroup will define a rule for each disk in the system mentioning
  at what maximum rate that cgroup can issue IO to that disk and throttle
  the IO from that cgroup if rate has excedded.

  Above requirement can create configuration problems.

	- If there are large number of disks in system, per cgroup one shall
	  have to create rules for each disk. Until and unless admin knows
	  what applications are in which cgroup and strictly what disk
	  these applications do IO to and create rules for only those
 	  disks.

	- I think problem gets compounded if there is a hierarchy of
	  logical devices. I think in that case one shall have to create
	  rules for logical devices and not actual physical devices.

- Because it is not proportional weight distribution, if some
  cgroup is not using its planned BW, other group sharing the
  disk can not make use of spare BW.  
	
- I think one should know in advance the throughput rate of underlying media
  and also know competing applications so that one can statically define
  the BW assigned to each cgroup on each disk.

  This will be difficult. Effective BW extracted out of a rotational media
  is dependent on the seek pattern so one shall have to either try to make
  some conservative estimates and try to divide BW (we will not utilize disk
  fully) or take some peak numbers and divide BW (cgroup might not get the
  maximum rate configured).

- Above problems will comound when one goes for deeper hierarhical
  configurations.

I think for renewable resources like disk time, it might be a good idea
to do a proportional weight controller to ensure fairness at the same time
achive best throughput possible.

Andrea, please correct me if I have misunderstood the things.

> So my question is: what is the definitive list of
> proposed-io-controller-implementations and how do I cunningly get all
> you guys to check each others homework? :)
 
I will try to summarize some of the proposals I am aware of. 

- Elevator/IO scheduler modification based IO controllers
	- This proposal
	- cfq io scheduler based control (Satoshi Uchida, NEC)
	- One more cfq based io control (vasily, OpenVZ)
	- AS io scheduler based control (Naveen Gupta, Google)

- Io-throttling (Andrea Righi)
	- Max Bandwidth Controller

- dm-ioband (valinux)
	- Proportional weight IO controller.

- Generic IO controller (Vivek Goyal, RedHat)
	- My initial attempt to do proportional division of amount of bio
	  per cgroup at request queue level. This was inspired from
	  dm-ioband.

I think this proposal should hopefully meet the requirements as envisoned
by other elevator based IO controller solutions.

dm-ioband
---------
I have briefly looked at dm-ioband also and following were some of the
concerns I had raised in the past.

- Need of a dm device for every device we want to control

	- This requirement looks odd. It forces everybody to use dm-tools
	  and if there are lots of disks in the system, configuation is
	  pain.

- It does not support hiearhical grouping.

- Possibly can break the assumptions of underlying IO schedulers.

	- There is no notion of task classes. So tasks of all the classes
	  are at same level from resource contention point of view.
	  The only thing which differentiates them is cgroup weight. Which
	  does not answer the question that an RT task or RT cgroup should
	  starve the peer cgroup if need be as RT cgroup should get priority
	  access.

	- Because of FIFO release of buffered bios, it is possible that
	  task of lower priority gets more IO done than the task of higher
	  priority.

	- Buffering at multiple levels and FIFO dispatch can have more
	  interesting hard to solve issues.

		- Assume there is sequential reader and an aggressive
		  writer in the cgroup. It might happen that writer
		  pushed lot of write requests in the FIFO queue first
		  and then a read request from reader comes. Now it might
		  happen that cfq does not see this read request for a long
		  time (if cgroup weight is less) and this writer will 
		  starve the reader in this cgroup.

		  Even cfq anticipation logic will not help here because
		  when that first read request actually gets to cfq, cfq might
		  choose to idle for more read requests to come, but the
		  agreesive writer might have again flooded the FIFO queue
		  in the group and cfq will not see subsequent read request
		  for a long time and will unnecessarily idle for read.

- Task grouping logic
	- We already have the notion of cgroup where tasks can be grouped
	  in hierarhical manner. dm-ioband does not make full use of that
	  and comes up with own mechansim of grouping tasks (apart from
	  cgroup).  And there are odd ways of specifying cgroup id while
	  configuring the dm-ioband device.

	  IMHO, once somebody has created the cgroup hieararchy, any IO
	  controller logic should be able to internally read that hiearchy
	  and provide control. There should not be need of any other
	  configuration utity on top of cgroup.

	  My RFC patches had tried to get rid of this external
	  configuration requirement.

- Task and Groups can not be treated at same level.

	- Because at any second level solution we are controlling bio
	  per cgroup and don't have any notion of which task queue bio
	  belongs to, one can not treat task and group  at same level.
	
	  What I meant is following.

			root
			/ | \
		       1  2  A
			    / \
			   3   4

	In dm-ioband approach, at top level tasks 1 and 2 will get 50%
	of BW together and group A will get 50%. Ideally along the lines
	of cpu controller, I would expect it to be 33% each for task 1
	task 2 and group A.

	This can create interesting scenarios where assumg task1 is
	an RT class task. Now one would expect task 1 get all the BW
	possible starving task 2 and group A, but that will not be the
	case and task1 will get 50% of BW.

 	Not that it is critically important but it would probably be
	nice if we can maitain same semantics as cpu controller. In
	elevator layer solution we can do it at least for CFQ scheduler
	as it maintains separate io queue per io context. 	

	This is in general an issue for any 2nd level IO controller which
	only accounts for io groups and not for io queues per process.

- We will end copying a lot of code/logic from cfq

	- To address many of the concerns like multi class scheduler
	  we will end up duplicating code of IO scheduler. Why can't
	  we have a one point hierarchical IO scheduling (This patchset).
Thanks
Vivek
