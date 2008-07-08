Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYGHJD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYGHJD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYGHJDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:03:21 -0400
Received: from saeurebad.de ([85.214.36.134]:51587 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYGHJDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:03:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Dangerous code in cpumask_of_cpu?
References: <200807081816.40623.rusty@rustcorp.com.au>
	<87myksn587.fsf@saeurebad.de> <87iqvgn4c1.fsf@saeurebad.de>
Date: Tue, 08 Jul 2008 11:03:10 +0200
In-Reply-To: <87iqvgn4c1.fsf@saeurebad.de> (Johannes Weiner's message of "Tue,
	08 Jul 2008 10:54:38 +0200")
Message-ID: <87ej64n3xt.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:

> Hi,
>
> Johannes Weiner <hannes@saeurebad.de> writes:
>
>> Hi,
>>
>> Rusty Russell <rusty@rustcorp.com.au> writes:
>>
>>> Hi Christoph/Mike,
>>>
>>>   Looked at cpumask_of_cpu as introduced in 
>>> 9f0e8d0400d925c3acd5f4e01dbeb736e4011882 (x86: convert cpumask_of_cpu macro 
>>> to allocated array), and I don't think it's safe:
>>>
>>>   #define cpumask_of_cpu(cpu)						\
>>>   (*({								\
>>> 	typeof(_unused_cpumask_arg_) m;					\
>>> 	if (sizeof(m) == sizeof(unsigned long)) {			\
>>> 		m.bits[0] = 1UL<<(cpu);					\
>>> 	} else {							\
>>> 		cpus_clear(m);						\
>>> 		cpu_set((cpu), m);					\
>>> 	}								\
>>> 	&m;								\
>>>   }))
>>>
>>> Referring to &m once out of scope is invalid, and I can't find any evidence 
>>> that it's legal here.  In particular, the change 
>>> b53e921ba1cff8453dc9a87a84052fa12d5b30bd (generic: reduce stack pressure in 
>>> sched_affinity) which passes &m to other functions seems highly risky.
>>>
>>> I'm surprised this hasn't already hit us, but perhaps gcc isn't as clever as 
>>> it could be?
>
>> You don't refer to &m outside scope.  Look at the character below the
>> first e of #define :)
>
> Oh, well you do access it outside scope, sorry.  Me sleepy.
>
> I guess because we dereference it immediately again, the location is not
> clobbered yet.  At least in my test case, gcc assembled it to code that
> puts the address in eax and derefences it immediately, before eax is
> reused:

Gee, just ignore this bs.  The address is in eax, not the value.

> static int *foo(void)
> {
>         int x = 42;
>         return &x;
> }
>
> int main(void)
> {
>         return *foo();
> }

However, this code seems to produce valid assembly with -O2.  gcc just
warns and fixes it up.

	Hannes
