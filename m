Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677Ab0ASI6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0ASI6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556Ab0ASI6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:58:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53929 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0ASI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:58:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aZOotHb4uFLqo2sr33uE/wwpg3tOkDcbLs0Sy/Wndg7kPJssKQU4N9HlQzJiJ+q0ie
         jMzWDHdtjH5/bKnm1VS8xGOHSrAloS+Qz3cgilLead+uBSkU9J4DCEbYGSrdEHZ0BGJw
         ea460yJBMEhYH/z0ZLeJ/8HE75hwgthlejYEw=
Date: Tue, 19 Jan 2010 09:58:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf_event: fix race in
	perf_swevent_get_recursion_context()
Message-ID: <20100119085811.GA5145@nowhere>
References: <4B54654A.4090601@cn.fujitsu.com> <20100118164128.GI10364@nowhere> <4B5508AF.1080302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5508AF.1080302@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 09:19:43AM +0800, Xiao Guangrong wrote:
> 
> 
> Frederic Weisbecker wrote:
> > On Mon, Jan 18, 2010 at 09:42:34PM +0800, Xiao Guangrong wrote:
> >> It only disable preemption in perf_swevent_get_recursion_context()
> >> it can't avoid race of hard-irq and NMI
> >>
> >> In this patch, we use atomic operation to avoid it and reduce
> >> cpu_ctx->recursion size, it also make this patch no need diable
> >> preemption
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > 
> > 
> > 
> > I don't understand what is racy in what we have currently.
> > 
> 
> It's because hard-irq(we can handle interruption with interruption enabled)
> and NMI are nested, for example:
> 
> int perf_swevent_get_recursion_context(void)
> {
> 	......
> 	if (cpuctx->recursion[rctx]) {
> 		put_cpu_var(perf_cpu_context);
> 		return -1;
> 	}
> 
> 	/*
> 	 * Another interruption handler/NMI will re-enter there if it
> 	 * happed, it make the recursion value chaotic
> 	 */
> 	cpuctx->recursion[rctx]++;
> 	......




I still don't understand the problem.

It's not like a fight between different cpus, it's a local per cpu
fight.

NMIs can't nest other NMIs but hardirq can nest another hardirqs,
we don't care much about these though.
So let's imagine the following sequence, a fight between nested
hardirqs:

cpuctx->recursion[irq] initially = 0

Interrupt (level 0):

       if (cpuctx->recursion[rctx]) {
               put_cpu_var(perf_cpu_context);
               return -1;
       }

Interrupt (level 1):


	cpuctx->recursion[rctx]++; // = 1

	...
	do something
	...
	cpuctx->recursion[rctx]--; // = 0

End Interrupt (level 1)

	cpuctx->recursion[rctx]++; // = 1

        ...
        do something
        ...
        cpuctx->recursion[rctx]--; // = 0

End interrupt (level 0)

Another sequence could be Interrupt level 0 has
already incremented recursion and we are interrupted by
irq level 1 which then won't be able to get the recursion
context. But that's not a big deal I think.


> > This looks broken. We don't call back perf_swevent_put_recursion_context
> > in fail case, so the bit won't ever be cleared once we recurse.
> > 
> 
> Um, i think we can't clear the bit in this fail case, consider below
> sequence:
> 
>  path A:                                path B
> 
>                                 set bit but find the bit already set
>  atomic set bit                                 |
>     |                                           |
>     V                                           |
>  handle SW event                                | 
>     |                                           V
>     V                               exit and not clear the bit 
>  atomic clear bit
> 
> After A and B, the bit is still zero
> 
> Right? :-)


Ah indeed, it will be cleared by the interrupted path.
I still don't understand what this patch brings us though.

