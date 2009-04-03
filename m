Return-Path: <linux-kernel-owner+w=401wt.eu-S1765426AbZDCNHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765426AbZDCNHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763711AbZDCNFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:05:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46336 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763393AbZDCNFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:05:46 -0400
Date: Fri, 3 Apr 2009 14:59:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] itimers: periodic timers fixes
Message-ID: <20090403145903.3f4fadd4@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20090402165753.GA12793@elte.hu>
References: <20090402141135.655d1b2b@dhcp-lab-109.englab.brq.redhat.com>
	<20090402165753.GA12793@elte.hu>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 18:57:53 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Converting those to GTOD sampling instead of jiffies sampling is a 
> worthwile change IMO and a good concept.
> 
> The unificaton of ITIMER_PROF and ITIMER_VIRT is a nice observation 
> and a good patch.
> 
> The second one, changing all the sampling from cputime to ktime_t is 
> nicely done too:
> 
> We could do more though, there's still a bit of cputime legacies 
> around:
> 
> +	cputime_t cval, nval;
> 
> Couldnt all of that go over into the ktime_t space as well, phasing 
> out cputime logic from the itimer code?
>
> The user ABI is struct timeval based, so there's no need to have 
> cputime anywhere. The scheduler does nanoseconds accurate stats so 
> it can be connected up there too.

Removing cputime stuff from itimers has probably only sense when
utime, stime and related fields in task_struct would be represented
as ktime or u64 variable in nanoseconds accurate. This mean a lot of
work. I'm not sure if is worth to do in the meaning that as result we
get better (faster and perhaps smaller) code. 

I was thinking about removing cputime as whole, make utime and stime
64 bit variables and account them in nanoseconds resolution. Remove
sum_exec_runtime from struct task_cputime and related CPUCLOCK_SCHED
code as duplicate of nanosecond accounted stime and CPUCLOCK_PROF code.
But that were too intrusive changes for me with unknown performance
impact.

My primary goal is to improve periodic itimers accuracy (see 
https://bugzilla.redhat.com/show_bug.cgi?id=441134), these patches
are just enough to achieve the goal.

Cheers
Stanislaw Gruszka
