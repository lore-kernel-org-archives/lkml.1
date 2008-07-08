Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYGHIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYGHIfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbYGHIfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:35:32 -0400
Received: from saeurebad.de ([85.214.36.134]:51070 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796AbYGHIfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:35:30 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Dangerous code in cpumask_of_cpu?
References: <200807081816.40623.rusty@rustcorp.com.au>
Date: Tue, 08 Jul 2008 10:35:20 +0200
In-Reply-To: <200807081816.40623.rusty@rustcorp.com.au> (Rusty Russell's
	message of "Tue, 8 Jul 2008 18:16:40 +1000")
Message-ID: <87myksn587.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Rusty Russell <rusty@rustcorp.com.au> writes:

> Hi Christoph/Mike,
>
>   Looked at cpumask_of_cpu as introduced in 
> 9f0e8d0400d925c3acd5f4e01dbeb736e4011882 (x86: convert cpumask_of_cpu macro 
> to allocated array), and I don't think it's safe:
>
>   #define cpumask_of_cpu(cpu)						\
>   (*({								\
> 	typeof(_unused_cpumask_arg_) m;					\
> 	if (sizeof(m) == sizeof(unsigned long)) {			\
> 		m.bits[0] = 1UL<<(cpu);					\
> 	} else {							\
> 		cpus_clear(m);						\
> 		cpu_set((cpu), m);					\
> 	}								\
> 	&m;								\
>   }))
>
> Referring to &m once out of scope is invalid, and I can't find any evidence 
> that it's legal here.  In particular, the change 
> b53e921ba1cff8453dc9a87a84052fa12d5b30bd (generic: reduce stack pressure in 
> sched_affinity) which passes &m to other functions seems highly risky.
>
> I'm surprised this hasn't already hit us, but perhaps gcc isn't as clever as 
> it could be?

You don't refer to &m outside scope.  Look at the character below the
first e of #define :)

But then, this code should probably just evaluate to m without this
obscure *(&m) construct.

	Hannes
