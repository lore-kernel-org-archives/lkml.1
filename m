Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbXKZEsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbXKZEsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 23:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXKZEsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 23:48:04 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59353 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbXKZEsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 23:48:02 -0500
Date: Mon, 26 Nov 2007 10:30:44 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [PATCH 0/4] sched: group scheduler related patches (V3)
Message-ID: <20071126050044.GA5304@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119190057.GA12650@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's V3 of the group scheduler related patches, which is mainly addressing 
improved fairness of cpu bandwidth allocation for task groups.

Patch 1/4 	-> coding style cleanup
Patch 2/4 	-> Minor group scheduling related bug fixes

Patch 3/4 (v1) 	-> Modifies how cpu load is calculated, such that there is zero
		   impact on !CONFIG_FAIR_GROUP_SCHED
Patch 3/4 (v2) 	-> Modifies how cpu load is calculated, such that there is a
		   small impact on code size (but should have NO impact on
		   functionality or runtime behavior) for
		   !CONFIG_FAIR_GROUP_SCHED case. The resulting code however is
		   much neater since it avoids some #ifdefs. I prefer v2.

Patch 4/4	-> Updates load balance logic to provide improved fairness for
		   task groups.

To have zero impact on !CONFIG_FAIR_GROUP_SCHED case, please apply the
following patches:

	- Patch 1/4
	- Patch 2/4 
	- Patch 3/4 (v1)
	- Patch 4/4

I personally prefer v2 of Patch 3/4. Even though it has a minor impact
on code size for !CONFIG_FAIR_GROUP_SCHED case, the overall code is much
neater IMHO.

Impact on sched.o size:
=======================

!CONFIG_FAIR_GROUP_SCHED:

   text    data     bss     dec     hex filename
  36829    2766      48   39643    9adb sched.o-before-nofgs
  36829    2766      48   39643    9adb sched.o-after-v1-nofgs (v1 of Patch 3/4)
  36843    2766      48   39657    9ae9 sched.o-after-v2-nofgs (v2 of Patch 3/4)

CONFIG_FAIR_GROUP_SCHED:

   text    data     bss     dec     hex filename
  39019    3346     336   42701    a6cd sched.o-before-fgs
  40303    3482     308   44093    ac3d sched.o-after-v1-fgs (v1 of Patch 3/4)
  40303    3482     308   44093    ac3d sched.o-after-v2-fgs (v2 of Patch 3/4)


Changes since V2 of this patchset [1]

- Split the patches better and make them pass under checkpatch.pl
  script
- Fixed compile issues under different config options and also
  a suspend failure (as posted by Ingo at [2])
- Make load_balance_monitor thread run as real-time task,
  so that its execution is not limited by shares allocated to
  default task group (init_task_group).
- Reduced minimum shares that can be allocated to a group to 1
  (from 100). Would be usefull if someone wants a task group
  to get very low bandiwdth or get bandwidth only when other groups
  are idle.
- Removed check for tg->last_total_load check in rebalance_shares()
  (which was incorrect in V2)

Changes since V1 of this patchset [3]:

- Introduced a task_group_mutex to serialize add/removal of task groups (as 
  pointed by Dipankar)

Please apply if there are no major concerns.


References:

1. http://marc.info/?l=linux-kernel&m=119549585223262
2. http://lkml.org/lkml/2007/11/19/127
3. http://marc.info/?l=linux-kernel&m=119547452517055


-- 
Regards,
vatsa
