Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYGIOnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYGIOnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYGIOm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:42:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53418 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750824AbYGIOm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:42:56 -0400
Message-ID: <4874CE6F.2090405@sgi.com>
Date: Wed, 09 Jul 2008 07:42:55 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Dangerous code in cpumask_of_cpu?
References: <200807081816.40623.rusty@rustcorp.com.au> <87ej64n3xt.fsf@saeurebad.de> <487387DE.90602@sgi.com> <200807091222.45537.rusty@rustcorp.com.au>
In-Reply-To: <200807091222.45537.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 09 July 2008 01:29:34 Mike Travis wrote:
>> Johannes Weiner wrote:
>>> Johannes Weiner <hannes@saeurebad.de> writes:
>>>> Hi,
>>>>
>>>> Johannes Weiner <hannes@saeurebad.de> writes:
>>>>> Hi,
>>>>>
>>>>> Rusty Russell <rusty@rustcorp.com.au> writes:
>>>>>> Hi Christoph/Mike,
>>>>>>
>>>>>>   Looked at cpumask_of_cpu as introduced in
>>>>>> 9f0e8d0400d925c3acd5f4e01dbeb736e4011882 (x86: convert cpumask_of_cpu
>>>>>> macro to allocated array), and I don't think it's safe:
>>>>>>
>>>>>>   #define cpumask_of_cpu(cpu)						\
>>>>>>   (*({								\
>>>>>> 	typeof(_unused_cpumask_arg_) m;					\
>>>>>> 	if (sizeof(m) == sizeof(unsigned long)) {			\
>>>>>> 		m.bits[0] = 1UL<<(cpu);					\
>>>>>> 	} else {							\
>>>>>> 		cpus_clear(m);						\
>>>>>> 		cpu_set((cpu), m);					\
>>>>>> 	}								\
>>>>>> 	&m;								\
>>>>>>   }))
>>>>>>
>>>>>> Referring to &m once out of scope is invalid, and I can't find any
>>>>>> evidence that it's legal here.  In particular, the change
>>>>>> b53e921ba1cff8453dc9a87a84052fa12d5b30bd (generic: reduce stack
>>>>>> pressure in sched_affinity) which passes &m to other functions seems
>>>>>> highly risky.
>>>>>>
>>>>>> I'm surprised this hasn't already hit us, but perhaps gcc isn't as
>>>>>> clever as it could be?
>>>>> You don't refer to &m outside scope.  Look at the character below the
>>>>> first e of #define :)
>>>> Oh, well you do access it outside scope, sorry.  Me sleepy.
>>>>
>>>> I guess because we dereference it immediately again, the location is not
>>>> clobbered yet.  At least in my test case, gcc assembled it to code that
>>>> puts the address in eax and derefences it immediately, before eax is
>>>> reused:
>>> Gee, just ignore this bs.  The address is in eax, not the value.
>>>
>>>> static int *foo(void)
>>>> {
>>>>         int x = 42;
>>>>         return &x;
>>>> }
>>>>
>>>> int main(void)
>>>> {
>>>>         return *foo();
>>>> }
>>> However, this code seems to produce valid assembly with -O2.  gcc just
>>> warns and fixes it up.
>>>
>>> 	Hannes
>> IIRC, the problem was I needed an lvalue and it seems that the *(&m) was
>> the way I was able to coerce gcc into producing it.  That's not to say
>> there may be a better way however... ;-)  [Btw, I picked up this technique
>> in the (original) per_cpu() macro.]
> 
> Yes, but I could do that because it wasn't referring to a temporary variable.
> 
>> Note the lvalue isn't used for changing the cpumask value, but for sending
>> it to functions like set_cpus_allowed_ptr() to avoid pushing the 512 bytes
>> of a 4096 cpus cpumask onto the stack.  So it becomes &(*(&m)))  ... ;-) 
>> But I thought I checked the assembly for different config options and it
>> looked ok.
> 
> Yeah, the problem is that a future gcc will cause horrible and subtle 
> breakage.
> 
> I think we are going to want a get_cpumask()/put_cpumask() pattern for this.
> 
> Rusty.

Yes, looking at it more closely I can see the problem.  Thanks btw for spotting
this!  I'll look at replacing it with safer code.

Cheers,
Mike
