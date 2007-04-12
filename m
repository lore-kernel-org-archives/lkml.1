Return-Path: <linux-kernel-owner+w=401wt.eu-S1945966AbXDLKBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945966AbXDLKBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945980AbXDLKBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:01:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51115 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945966AbXDLKBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:01:48 -0400
Date: Thu, 12 Apr 2007 15:31:44 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070412100144.GA6673@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com> <20070403150336.GA850@tv-sign.ru> <20070403171820.GA8646@in.ibm.com> <20070412022220.GA10176@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412022220.GA10176@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 07:52:20AM +0530, Srivatsa Vaddagiri wrote:
> I wonder if there is some value in "enforcing" an order in which
> processes get frozen i.e freeze A first before B. That may solve the
> deadlocks we have been discussing wrt kthread_stop and flush_workqueue
> as well.
>
> The idea is similar to how deadlock wrt multiple locks are solved -
> where a ordering is enforced. Take Lock A first before Lock B. 
> 
> If process A waits on B (like in kthread_stop or flush_workqueue), then if we:
> 
> 	1. Insert A and B in a list (freeze_me_first_list)

In that case, A should insert the dependency into the
freeze_me_first_list as B is unaware of the dependency yet.

What if by the time A has inserted the dependency B is already frozen?

Can very well happen right?

A:			B:			freezer
-------------------------------------------------------------------------------
						*Check the list. don't find  A/B
						*Mark A freezeable.
						*Mark B freezeable.
			*try_to_freeze();
*insert A, B		.		
 into the		.	
 list.			.
			.		
		  	.
* wait_for_		.
  completion(done);	.			/* Freezer fails at this
  			.			 *  point 
			.			 */
		  	.
		  	.
		  	*complete(done);

*try_to_freeze();

Example: A = a thread doing flush_workqueue.
	 B = worker thread.


Of course, we can always use the freezer_skip around this
wait_for_completion as well as long as the thread A is not marked
PF_NOFREEZE. But with multiple freeze events, it won't be as simple as
that.

> -- 
> Regards,
> vatsa

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
