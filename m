Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbYFFPEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbYFFPEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757761AbYFFPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:04:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50589 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756948AbYFFPEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:04:09 -0400
Message-ID: <484951E6.1030207@sgi.com>
Date: Fri, 06 Jun 2008 08:04:06 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
References: <20080606002957.6329a0ec.akpm@linux-foundation.org> <20080606024811.70db9ab2.akpm@linux-foundation.org> <20080606035413.37f340ef.akpm@linux-foundation.org> <20080606115759.GA29321@elte.hu> <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com> <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com> <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com> <484947A9.5050804@sgi.com> <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com> <20080606145717.GA5300@elte.hu>
In-Reply-To: <20080606145717.GA5300@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
>>> Thanks, yes I had that some after thought.  It should check the node 
>>> index if CONFIG_DEBUG_PER_CPU_MAPS is enabled.  One gotcha is that 
>>> nr_node_ids is intialized to MAX_NUMNODES until 
>>> setup_node_to_cpumask_map() sets it to the correct value.  So uses 
>>> before that should be caught by the earlier check.
>> I think it should always check the node index. The code in 
>> kernel/sched.c (see above) calls node_to_cpumask(i) on nodes 0 < i < 
>> MAX_NUMNODES and it WILL use invalid pointers. Or should 
>> kernel/sched.c be changed to use nr_node_ids instead of MAX_NUMNODES? 
>> I believe there are more places that do this than just sched.c.
>>
>> I have attached two patches. The sched one fixes Andrew's boot 
>> problem. The x86 one is untested, but I believe it is better to BUG 
>> than silently corrupt some arbitrary memory. (Then the callers can be 
>> found easily and fixed at least.)
> 
> nice fixes! I have applied both of them to -tip, this one to 
> tip/sched-devel:
> 
>> Subject: [PATCH] sched: don't call node_to_cpumask() on nodes > nr_node_ids
> 
> AFAICS this is not yet required for v2.6.26, as the requirement to never 
> iterate to MAX_NUMNODES and call nr_cpus_node() with the index only got 
> introduced by Mike's patch.
> 
> and this one to tip/x86/numa:
> 
>> Subject: [PATCH] x86: don't return invalid pointers from node_to_cpumask()
> 
> and i've undone the revert of "x86: remove the static 256k 
> node_to_cpumask_map" as well.
> 
> agreed?
> 
> 	Ingo

Hi Ingo,

My -tip branch has:

	a953e4597abd51b74c99e0e3b7074532a60fd031

	sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
	committed: 2008-05-23 09:22:17

The check for node > nr_node_ids however should be included (at least
when CONFIG_DEBUG_PER_CPU_MAPS is enabled.)

Thanks,
Mike
