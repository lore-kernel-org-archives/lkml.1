Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYIKPFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYIKPFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYIKPFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:05:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52593 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752298AbYIKPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:05:04 -0400
Message-ID: <48C9339A.4030309@sgi.com>
Date: Thu, 11 Sep 2008 08:04:58 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>	 <20080906235037.880702000@polaris-admin.engr.sgi.com>	 <1220783087.8687.73.camel@twins.programming.kicks-ass.net>	 <48C53C91.70604@sgi.com>	 <1220886335.12278.31.camel@twins.programming.kicks-ass.net>	 <20080908183852.GA3713@elte.hu>  <48C84E9E.7080507@sgi.com> <1221123630.4415.1136.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1221123630.4415.1136.camel@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
...
>> So in function prototypes:
>>
>> 	cpumask_t function(const cpumask_t *A,
>> 			   cpumask_t *B,
>> 			   cpumask_t cpumask_C)
>>
>> becomes:
>>
>> 	cpumask_val function(cpumask_t A,
>> 			     cpumask_var B,
>> 			     cpumask_t cpumask_C)
> 
> I guess we have to stick the const into the typedef otherwise we get a
> const pointer instead of a const array member, right?
> 
> In which case I much prefer the following names:
> 
>  cpumask_data_t  - value
> 
>  const_cpumask_t - pointer to constant value
>  cpumask_t       - pointer to value

There were some comments previously such that we should "imply" that the
incoming cpumask_t args are const, so the compiler would flag those
who arbitrarily modify it.

> 
...
>> 	alloc_cpumask(&mask);
> 
> Don't you have to deal with allocation errors?

In a perfect world, no... ;-)
...
>> 	static inline void alloc_cpumask(cpumask_t *m)
>> 	{
>> 		cpumask_t d = kmalloc(BYTES_PER_CPUMASK, GFP_KERNEL);
>> 		if (no_cpumask(&d))
>> 			BUG();
> 
> yuckery yuck yuck!
> 
>> 		*m = d;
>> 	}
>>
>> 	static inline void alloc_cpumask_nopanic(cpumask_t *m)
>> 	{
>> 		cpumask_t d = kmalloc(BYTES_PER_CPUMASK, GFP_KERNEL);
>>
>> 		*m = d;
>> 	}
> 
> gah - at the very least you got the naming wrong, methinks the one
> panic-ing should have panic in its name - if you really want to persist
> with that variant.

Yeah, I rather rushed through the allocation part (yuck indeed ;-).

There are some other alternatives:

	- reserve one or more of these in the task struct
	- reserve one or more in a per-cpu area
	- setup some kind of allocation pool similar to alloc_bootmem
	- ???

Thanks,
Mike
