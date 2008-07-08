Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYGHKYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYGHKYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 06:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYGHKYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 06:24:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:32938 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbYGHKYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:24:35 -0400
From: Andreas Schwab <schwab@suse.de>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, "H. Anvin" <hpa@zytor.com>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Dangerous code in cpumask_of_cpu?
References: <200807081816.40623.rusty@rustcorp.com.au>
	<87myksn587.fsf@saeurebad.de>
X-Yow: I'm also pre-POURED pre-MEDITATED and pre-RAPHAELITE!!
Date: Tue, 08 Jul 2008 12:24:22 +0200
In-Reply-To: <87myksn587.fsf@saeurebad.de> (Johannes Weiner's message of "Tue,
	08 Jul 2008 10:35:20 +0200")
Message-ID: <jehcb0r7vt.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:

> Hi,
>
> Rusty Russell <rusty@rustcorp.com.au> writes:
>
>> Hi Christoph/Mike,
>>
>>   Looked at cpumask_of_cpu as introduced in 
>> 9f0e8d0400d925c3acd5f4e01dbeb736e4011882 (x86: convert cpumask_of_cpu macro 
>> to allocated array), and I don't think it's safe:
>>
>>   #define cpumask_of_cpu(cpu)						\
>>   (*({								\
>> 	typeof(_unused_cpumask_arg_) m;					\
>> 	if (sizeof(m) == sizeof(unsigned long)) {			\
>> 		m.bits[0] = 1UL<<(cpu);					\
>> 	} else {							\
>> 		cpus_clear(m);						\
>> 		cpu_set((cpu), m);					\
>> 	}								\
>> 	&m;								\
>>   }))
>>
>> Referring to &m once out of scope is invalid, and I can't find any evidence 
>> that it's legal here.  In particular, the change 
>> b53e921ba1cff8453dc9a87a84052fa12d5b30bd (generic: reduce stack pressure in 
>> sched_affinity) which passes &m to other functions seems highly risky.
>>
>> I'm surprised this hasn't already hit us, but perhaps gcc isn't as clever as 
>> it could be?
>
> You don't refer to &m outside scope.  Look at the character below the
> first e of #define :)

The scope of m ends with the outmost braces, and the dereference is done
outside of it.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
