Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYGHSF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYGHSF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYGHSFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:05:18 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38855 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbYGHSFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:05:17 -0400
Message-ID: <4873AC5C.1040705@sgi.com>
Date: Tue, 08 Jul 2008 11:05:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const
 ptr
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>	 <484D54F2.4070603@sgi.com> <20080626113229.GB29619@elte.hu>	 <4863C334.2090007@sgi.com> <486452CC.8050502@sgi.com>	 <48651EF5.5090808@sgi.com> <20080703084401.GB7873@elte.hu>	 <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>	 <20080703090100.GA10872@elte.hu> <48739E87.2060604@sgi.com> <19f34abd0807081035k2c7a18eckc8aa749a6f015f65@mail.gmail.com>
In-Reply-To: <19f34abd0807081035k2c7a18eckc8aa749a6f015f65@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi,
> 
> On Tue, Jul 8, 2008 at 7:06 PM, Mike Travis <travis@sgi.com> wrote:
>>> (v3 is applied already so Mike please send a delta to v3.)
>>>
>>>       Ingo
>> Subject: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr
>>
>>  * Strengthen the return type for the _node_to_cpumask_ptr to be
>>    a const pointer.  This adds compiler checking to insure that
>>    node_to_cpumask_map[] is not changed inadvertently.
>>
>> Applies to tip/master with the following patch applied:
>>
>>        "[PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3"
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>> Note: I did not change node_to_cpumask_ptr() in include/asm-generic/topology.h
>>      as node_to_cpumask_ptr_next() does change the cpumask value.
> 
> Hmmm. Does it really?
> 
> #define node_to_cpumask_ptr_next(v, node)                               \
>                           _##v = node_to_cpumask(node)
> 
> This doesn't seem to modify it?

Well I thought about it.  The pointer (*v) does not change
but the underlying cpumask variable is updated with the
cpumask for the (supposedly) new node number.  You can see
that in this code snippet from kernel/sched.c:

        for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
                int next_node = find_next_best_node(node, &used_nodes);

                node_to_cpumask_ptr_next(nodemask, next_node);
                cpus_or(*span, *span, *nodemask);
        }

In the optimized (x86_64) case, the pointer is simply modified
to point to the new node_to_cpumask_map[node] entry.  It remains
a pointer to a const value.

But the non-optimized version replaces the const cpumask value
with the new cpumask value.  Isn't this breaking the const
attribute?

> 
> Also, isn't it unfortunate to have the same function return
> const/non-const depending on your arch/config?

But isn't that exactly what it does?  (And in reality, the real
protection happens when there is a node_to_cpumask_map[] present.)

But whichever seems more correct is fine with me... ;-)

Thanks,
Mike
