Return-Path: <linux-kernel-owner+w=401wt.eu-S1762728AbYALJX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762728AbYALJX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760646AbYALJXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:23:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785AbYALJXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:23:47 -0500
Subject: Re: [PATCH/RFC] synchronize_rcu(): high latency on idle system
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <20080112012626.GI28570@kvack.org>
References: <20080112012626.GI28570@kvack.org>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 10:23:11 +0100
Message-Id: <1200129791.7999.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 20:26 -0500, Benjamin LaHaise wrote:
> Hello folks,
> 
> I'd like to put the patch below out for comments to see if folks think the 
> approach is a valid fix to reduce the latency of synchronize_rcu().  The 
> motivation is that an otherwise idle system takes about 3 ticks per network 
> interface in unregister_netdev() due to multiple calls to synchronize_rcu(), 
> which adds up to quite a few seconds for tearing down thousands of 
> interfaces.  By flushing pending rcu callbacks in the idle loop, the system 
> makes progress hundreds of times faster.  If this is indeed a sane thing to, 
> it probably needs to be done for other architectures than x86.  And yes, the 
> network stack shouldn't call synchronize_rcu() quite so much, but fixing that 
> is a little more involved.

So, instead of only relying on the tick to drive the RCU state machine,
you add the idle loop to it. This seems to make sense, esp because nohz
is held off until rcu is idle too.

Even though Andi is right in that its not the proper solution to your
problem, I think its worth doing anyway for the general benefit of RCU.

But lets ask Paul, he is Mr RCU after all :-)

> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index 9663c2a..592f6e4 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -188,6 +188,9 @@ void cpu_idle(void)
>  			rmb();
>  			idle = pm_idle;
>  
> +			if (rcu_pending(cpu))
> +				rcu_check_callbacks(cpu, 0);
> +
>  			if (!idle)
>  				idle = default_idle;
>  

