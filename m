Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbYBEVpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbYBEVpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbYBEVps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:45:48 -0500
Received: from sp604003av.neufgp.fr ([84.96.92.124]:42509 "EHLO
	neuf-infra-smtp-out-sp604003av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756350AbYBEVpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:45:47 -0500
Message-ID: <47A8D69C.8010505@cosmosbay.com>
Date: Tue, 05 Feb 2008 22:35:24 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86 mmiotrace: fix relay-buffer-full flag for SMP
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>	<1201660102.8837.9.camel@brick>	<1201660453.8837.13.camel@brick>	<20080130200827.322c4f7d@daedalus.pq.iki.fi>	<20080131150746.GB11996@elte.hu>	<20080131180253.6c007852@daedalus.pq.iki.fi>	<20080131081507.5edcde10@laptopd505.fenrus.org>	<20080203085522.2b63e15b@daedalus.pq.iki.fi>	<20080203070321.GA8293@elte.hu>	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>	<20080205223046.668309be@daedalus.pq.iki.fi>	<47A8CA97.30008@cosmosbay.com> <20080205231452.16cc2f88@daedalus.pq.iki.fi>
In-Reply-To: <20080205231452.16cc2f88@daedalus.pq.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen a écrit :
> On Tue, 05 Feb 2008 21:44:07 +0100
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Pekka Paalanen a écrit :
>>> diff --git a/arch/x86/kernel/mmiotrace/mmio-mod.c b/arch/x86/kernel/mmiotrace/mmio-mod.c
>>> index 82ae920..f492b65 100644
>>> --- a/arch/x86/kernel/mmiotrace/mmio-mod.c
>>> +++ b/arch/x86/kernel/mmiotrace/mmio-mod.c
>>> @@ -47,9 +48,13 @@ struct trap_reason {
>>>  	int active_traces;
>>>  };
>>>  
>>> +/* Accessed per-cpu. */
>>>  static struct trap_reason pf_reason[NR_CPUS];
>>>  static struct mm_io_header_rw cpu_trace[NR_CPUS];
>>>  
>>> +/* Access to this is not per-cpu. */
>>> +static atomic_t dropped[NR_CPUS];
>>> +
>> Please dont introduce NR_CPUS new arrays, since people are working hard to zap 
>> them from kernel.
>>
>> You probably can use a per_cpu variable ?
> 
> Yes, it would probably be more appropriate to use DEFINE_PER_CPU()
> for 'pf_reason' and 'cpu_trace', but I wasn't sure since the examples
> of DEFINE_PER_CPU I saw always had integers or pointers, not
> whole structs. Is it okay for whole structs?

yes you can use a structure, you can check for example :

net/ipv4/route.c:static DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);

> 
> 'dropped' on the other hand is not accessed in per-cpu style, any cpu
> may access any element. DEFINE_PER_CPU is not valid here, is it?

It is valid, you can use per_cpu() accessor to get a pointer to a particular 
cpu data.

check net/ipv4/route.c for an example :

return &per_cpu(rt_cache_stat, cpu);

