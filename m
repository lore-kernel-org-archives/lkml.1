Return-Path: <linux-kernel-owner+w=401wt.eu-S1030768AbXAZGBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030768AbXAZGBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030773AbXAZGBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:01:50 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33362 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030768AbXAZGBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:01:49 -0500
Date: Fri, 26 Jan 2007 11:31:42 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] Fair-user scheduler
Message-ID: <20070126060142.GA2487@in.ibm.com>
Reply-To: vatsa@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current Linux CPU scheduler doesnt recognize process aggregates while
allocating bandwidth. As a result of this, an user could simply spawn large 
number of processes and get more bandwidth than others.

Here's a patch that provides fair allocation for all users in a system.

Some benchmark numbers with and without the patch applied follows:


		 	user "vatsa"		    user "guest"
		    (make -s -j4 bzImage)      (make -s -j20 bzImage)

2.6.20-rc5		472.07s (real)		   257.48s (real)
2.6.20-rc5+fairsched	766.74s (real)		   766.73s (real)


(Numbers taken on a 2way Intel x86_64 box)

Eventually something like this can be extended to do weighted fair share
scheduling for:

	- KVM
	- containers
	- resource management

Salient features of the patch:

	- Based on Ingo's RTLIMIT_RT_CPU patch [1]. Primary difference between 
	  RTLIMIT_RT_CPU patch and this one is that this patch handles 
	  starvation of lower priority tasks in a group and also accounting
	  is token based (rather than decaying avg).

	- Retains existing one-runqueue-per-cpu design

	- breaks O(1) (ouch!)
		Best way to avoid this is to split runqueue to be per-user and
		per-cpu, which I have not implemented to keep the patch simple.

	- Fairsched aware SMP load balance NOT addressed (yet)

Comments/flames wellcome!


References:

1. http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.11-rc2/2.6.11-rc2-mm2/broken-out/rlimit_rt_cpu.patch

-- 
Regards,
vatsa
