Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbZCPIkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbZCPIkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZCPIkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:40:46 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:46319 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752407AbZCPIkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:40:45 -0400
Date: Mon, 16 Mar 2009 17:40:43 +0900 (JST)
Message-Id: <20090316.174043.193698189.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: akpm@linux-foundation.org, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, jens.axboe@oracle.com,
       fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, arozansk@redhat.com, jmoyer@redhat.com,
       oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, menage@google.com,
       peterz@infradead.org, righi.andrea@gmail.com
Subject: Re: [PATCH 01/10] Documentation
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090312180126.GI10919@redhat.com>
References: <1236823015-4183-2-git-send-email-vgoyal@redhat.com>
	<20090312001146.74591b9d.akpm@linux-foundation.org>
	<20090312180126.GI10919@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> dm-ioband
> ---------
> I have briefly looked at dm-ioband also and following were some of the
> concerns I had raised in the past.
> 
> - Need of a dm device for every device we want to control
> 
> 	- This requirement looks odd. It forces everybody to use dm-tools
> 	  and if there are lots of disks in the system, configuation is
> 	  pain.

I don't think it's a pain. Could it be easily done by writing a small
script?

> - It does not support hiearhical grouping.

I can implement hierarchical grouping to dm-ioband if it's really
necessary, but at this point, I don't think it's really necessary
and I want to keep the code simple.

> - Possibly can break the assumptions of underlying IO schedulers.
> 
> 	- There is no notion of task classes. So tasks of all the classes
> 	  are at same level from resource contention point of view.
> 	  The only thing which differentiates them is cgroup weight. Which
> 	  does not answer the question that an RT task or RT cgroup should
> 	  starve the peer cgroup if need be as RT cgroup should get priority
> 	  access.
> 
> 	- Because of FIFO release of buffered bios, it is possible that
> 	  task of lower priority gets more IO done than the task of higher
> 	  priority.
> 
> 	- Buffering at multiple levels and FIFO dispatch can have more
> 	  interesting hard to solve issues.
> 
> 		- Assume there is sequential reader and an aggressive
> 		  writer in the cgroup. It might happen that writer
> 		  pushed lot of write requests in the FIFO queue first
> 		  and then a read request from reader comes. Now it might
> 		  happen that cfq does not see this read request for a long
> 		  time (if cgroup weight is less) and this writer will 
> 		  starve the reader in this cgroup.
> 
> 		  Even cfq anticipation logic will not help here because
> 		  when that first read request actually gets to cfq, cfq might
> 		  choose to idle for more read requests to come, but the
> 		  agreesive writer might have again flooded the FIFO queue
> 		  in the group and cfq will not see subsequent read request
> 		  for a long time and will unnecessarily idle for read.

I think it's just a matter of which you prioritize, bandwidth or
io-class. What do you do when the RT task issues a lot of I/O?

> - Task grouping logic
> 	- We already have the notion of cgroup where tasks can be grouped
> 	  in hierarhical manner. dm-ioband does not make full use of that
> 	  and comes up with own mechansim of grouping tasks (apart from
> 	  cgroup).  And there are odd ways of specifying cgroup id while
> 	  configuring the dm-ioband device.
> 
> 	  IMHO, once somebody has created the cgroup hieararchy, any IO
> 	  controller logic should be able to internally read that hiearchy
> 	  and provide control. There should not be need of any other
> 	  configuration utity on top of cgroup.
> 
> 	  My RFC patches had tried to get rid of this external
> 	  configuration requirement.

The reason is that it makes bio-cgroup easy to use for dm-ioband.
But It's not a final design of the interface between dm-ioband and
cgroup.

> - Task and Groups can not be treated at same level.
> 
> 	- Because at any second level solution we are controlling bio
> 	  per cgroup and don't have any notion of which task queue bio
> 	  belongs to, one can not treat task and group  at same level.
> 	
> 	  What I meant is following.
> 
> 			root
> 			/ | \
> 		       1  2  A
> 			    / \
> 			   3   4
> 
> 	In dm-ioband approach, at top level tasks 1 and 2 will get 50%
> 	of BW together and group A will get 50%. Ideally along the lines
> 	of cpu controller, I would expect it to be 33% each for task 1
> 	task 2 and group A.
> 
> 	This can create interesting scenarios where assumg task1 is
> 	an RT class task. Now one would expect task 1 get all the BW
> 	possible starving task 2 and group A, but that will not be the
> 	case and task1 will get 50% of BW.
> 
>  	Not that it is critically important but it would probably be
> 	nice if we can maitain same semantics as cpu controller. In
> 	elevator layer solution we can do it at least for CFQ scheduler
> 	as it maintains separate io queue per io context. 	

I will consider following the CPU controller's manner when dm-ioband
supports hierarchical grouping.

> 	This is in general an issue for any 2nd level IO controller which
> 	only accounts for io groups and not for io queues per process.
> 
> - We will end copying a lot of code/logic from cfq
> 
> 	- To address many of the concerns like multi class scheduler
> 	  we will end up duplicating code of IO scheduler. Why can't
> 	  we have a one point hierarchical IO scheduling (This patchset).
> Thanks
> Vivek

Thanks,
Ryo Tsuruta
