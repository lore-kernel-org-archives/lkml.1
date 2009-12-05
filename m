Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZLENCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZLENCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 08:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZLENCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 08:02:15 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45612 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZLENCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 08:02:14 -0500
Date: Sat, 5 Dec 2009 18:32:02 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v4 PATCH 3/7] sched: Enforce hard limits by throttling
Message-ID: <20091205130202.GA6204@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091117143306.GK17335@in.ibm.com> <20091117143519.GN17335@in.ibm.com> <1259942995.17907.895.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259942995.17907.895.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 05:09:55PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-11-17 at 20:05 +0530, Bharata B Rao wrote:
> > sched: Enforce hard limits by throttling.
> > 
> > From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > 
> > Throttle the task-groups which exceed the runtime allocated to them.
> > Throttled group entities are removed from the run queue.
> 
> This patch is just vile, all those _locked variants should really go.
> 
> Nor it is entirely clear why they're there.
> 

update_curr() is the place where I check if the group has exceeded its
runtime and it needs to take cfs_rq->cfs_runtime_lock. However there are
2 places from where update_curr() gets called with cfs_rq->cfs_runtime_lock
already held. Hence _locked() version of update_curr() exists.

These two call paths are both enqueue paths (enqueue_task_fair and
enqueue during unthrottling when period timer fires). Hence _locked()
versions of entity_enqueue() exists.

I see that you don't have this sort of requirement (of holding
rt_rq->rt_runtime_lock) in rt. I will recheck on this one to see why you are
able to do this in rt and I can't in cfs. If convinced, I shall get rid
_locked versions.

Thanks Peter for taking time to review the hard limit patches.

Regards,
Bharata.
