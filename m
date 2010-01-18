Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704Ab0ARKnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0ARKnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 05:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434Ab0ARKnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 05:43:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:15869 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0ARKnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 05:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v/76ucrkhHfBuC1IiuJUG2hKVK8tV8v1KhhPtsiFbj2SuQQ02ue2Az4RedEIAfyaB5
         3irVSBxCuiqr2Eb/p0nn/kmXQlpXt9yufzGo7W6fSj/Q/7Z14QjYWMtXuwALhiFYkfNR
         DExXyggTB9Ymrbkgd5962K1o6P0Kko+e59WEQ=
Date: Mon, 18 Jan 2010 11:43:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Fix inconsistency between IP and callchain
	sampling
Message-ID: <20100118104305.GA5256@nowhere>
References: <20100118054707.GT12666@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118054707.GT12666@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 04:47:07PM +1100, Anton Blanchard wrote:
> 
> When running perf across all cpus with backtracing (-a -g), sometimes we
> get samples without associated backtraces:
> 
>     23.44%         init  [kernel]                     [k] restore
>     11.46%         init                       eeba0c  [k] 0x00000000eeba0c
>      6.77%      swapper  [kernel]                     [k] .perf_ctx_adjust_freq
>      5.73%         init  [kernel]                     [k] .__trace_hcall_entry
>      4.69%         perf  libc-2.9.so                  [.] 0x0000000006bb8c
>                        |          
>                        |--11.11%-- 0xfffa941bbbc
> 
> It turns out the backtrace code has a check for the idle task and the IP
> sampling does not. This creates problems when profiling an interrupt
> heavy workload (in my case 10Gbit ethernet) since we get no backtraces
> for interrupts received while idle (ie most of the workload).


Agreed, the arch backtrace code is not well suited to decide this.


> 
> Right now x86 and sh check that current is not NULL, which should never
> happen so remove that too.


Yeah. Unless we can have backtraces in pretty rare places
where current is unavailable. But I guess not.


> 
> Signed-off-by: Anton Blanchard <anton@samba.org>


Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>


> The exclusion of idle tasks should be in the common perf events code,
> perhaps keying off the exclude_idle field. It should also ensure that
> we weren't in an interrupt at the time.


We have exclude_idle but it has only effects on cpu clock events:

if (regs) {
	if (!(event->attr.exclude_idle && current->pid == 0))
		if (perf_event_overflow(event, 0, &data, regs))
			ret = HRTIMER_NORESTART;
}


I think the exclude_idle check should move into perf_event_overflow(),
to enforce its semantics and apply it to every software events.
I'm preparing a patch for that.

(.. Even better would have been to schedule out exclude_idle events when we
enter idle. But currently this is a single event attribute, not a
group attribute, which would make such individual scheduling game a
bit insane. My guess is that it should have been a group attribute,
to keep the group counting consistent, so that its scope could have
been broader, to the point of deactivating hardware events on idle, etc...
But now the ABI is fixed.. )


Concerning interrupts that happen in idle, I think we should filter
these if exclude_idle = 1. That looks more something a user may
want: if we don't want to profile idle, neither do we want to encumber with
interrupts that occur inside. On the opposite, if someone wants a finegrained
profile, let's get idle and its interrupts.

What do you guys think about that?


> 
> I also notice this:
> 
>         if (is_user && current->state != TASK_RUNNING)
> 
> But I'm not exactly sure what that will catch. When would we get a userspace
> sample from something that isnt running?


Not sure either...

Thanks.

