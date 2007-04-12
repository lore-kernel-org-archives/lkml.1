Return-Path: <linux-kernel-owner+w=401wt.eu-S1161475AbXDLCOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161475AbXDLCOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161476AbXDLCOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:14:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44954 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161475AbXDLCOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:14:50 -0400
Date: Thu, 12 Apr 2007 07:52:20 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070412022220.GA10176@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com> <20070403150336.GA850@tv-sign.ru> <20070403171820.GA8646@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403171820.GA8646@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:48:20PM +0530, Srivatsa Vaddagiri wrote:
> > Actually, we should do this before destroy_workqueue() calls flush_workqueue().
> > Otherwise flush_cpu_workqueue() can hang forever in a similar manner.
> 
> Yep. I guess these are a class of freezer deadlocks very similar to vfork
> parent waiting on child case. I get a feeling these should become common
> outside of kthread too (A waits on B for something, B gets frozen, which
> means A won't freeze causing freezer to fail). Can freezer detect this
> dependency somehow and thaw B automatically? Probably not that easy ..

I wonder if there is some value in "enforcing" an order in which
processes get frozen i.e freeze A first before B. That may solve the
deadlocks we have been discussing wrt kthread_stop and flush_workqueue
as well.

The idea is similar to how deadlock wrt multiple locks are solved -
where a ordering is enforced. Take Lock A first before Lock B. 

If process A waits on B (like in kthread_stop or flush_workqueue), then if we:

	1. Insert A and B in a list (freeze_me_first_list)
	2. Have freezer scan freeze_me_first_list before the master
	   task-list, so that it:
		2a. "freezes A and waits for A to get frozen" first
		2b. "freezes B and waits for B to get frozen" next

then we would avoid the nastiness of "B getting frozen first and A doesnt
freeze because of that" with lesser code changes?

-- 
Regards,
vatsa
