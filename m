Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZDBFUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZDBFUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZDBFTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:19:49 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43671 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZDBFTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:19:48 -0400
Message-ID: <49D44AD7.8010305@cosmosbay.com>
Date: Thu, 02 Apr 2009 07:19:19 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Tejun Heo <htejun@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>
Subject: Re: [RFC] percpu: convert SNMP mibs to new infra
References: <49D32212.80607@cosmosbay.com> <49D3A0C2.9000403@cosmosbay.com> <49D3B61F.8010507@cosmosbay.com> <200904021534.34084.rusty@rustcorp.com.au>
In-Reply-To: <200904021534.34084.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 02 Apr 2009 07:19:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell a écrit :
> On Thursday 02 April 2009 05:14:47 Eric Dumazet wrote:
>> Here is a preliminary patch for SNMP mibs that seems to work well on x86_32
>>
>> [RFC] percpu: convert SNMP mibs to new infra
> 
> OK, I have a whole heap of "convert to dynamic per-cpu" patches waiting in
> the wings too, once Tejun's conversion is complete.
> 
> Also, what is optimal depends on the arch: we had a long discussion on this
> (it's what local_t was supposed to do, with cpu_local_inc() etc: see
> Subject: local_add_return 2008-12-16 thread).
> 
> eg. on S/390, atomic_inc is a win over the two-counter version.  On Sparc,
> two-counter wins.  On x86, inc wins (obviously).
> 
> But efforts to create a single primitive have been problematic: maybe
> open-coding it like this is the Right Thing.
> 

I tried to find a generic CONFIG_ define that would annonce that an arche
has a fast percpu_add() implementation. (faster than __raw_get_cpu_var,
for example, when we already are in a preempt disabled section)

Any idea ?


For example, net/ipv4/route.c has :

static DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);
#define RT_CACHE_STAT_INC(field) \
        (__raw_get_cpu_var(rt_cache_stat).field++)

We could use percpu_add(rt_cache_stat.field, 1) instead, only if percpu_add()
is not the generic one.

#define __percpu_generic_to_op(var, val, op)                            \
do {                                                                    \
        get_cpu_var(var) op val;                                        \
        put_cpu_var(var);                                               \
} while (0)
#ifndef percpu_add
# define percpu_add(var, val)           __percpu_generic_to_op(var, (val), +=)
#endif

