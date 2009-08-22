Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbZHVK6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbZHVK6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 06:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933163AbZHVK6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 06:58:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148AbZHVK6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 06:58:18 -0400
Date: Sat, 22 Aug 2009 12:57:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC patch 00/32] x86: Refactor the setup code to provide a
	base for embedded platforms
Message-ID: <20090822105726.GB30434@elte.hu>
References: <20090821205008.518392436@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821205008.518392436@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

[...]
> The following patch series refactors the setup related x86_quirks 
> and the setup related paravirt hooks and puts them into an 
> extensible platform_setup infrastructure to provide a proper base 
> for adding the Moorestown modifications. As a side effect it also 
> unifies time_32/64.c and removes some leftovers of the pre 
> arch/x86 era.
>
> Note, this is not a replacement for paravirt_ops. It is just 
> replacing the setup related paravirt stuff so it can be reused for 
> other platforms though I have to say that it removes a fair amount 
> of obscurity which was introduced by paravirt & Co.

>  47 files changed, 622 insertions(+), 808 deletions(-)

Very nice!

One small detail, before we spread out these patches. While looking 
at the patches i noticed that at places our new x86 init namespace 
is very long:

> +     platform_setup.timers.setup_percpu_clockev = platform_setup_noop;
> +     platform_cpuhotplug_setup.setup_percpu_clockev = platform_setup_noop;
> +

I think we should shorten the name-space a bit - we'll use it in a 
_lot_ of places, so the shorter, the better and the easier to use. 

I'd suggest something like:

     x86_init.timers.init_percpu_clockev = x86_init_noop;
     x86_cpuhotplug_init.init_percpu_clockev = x86_init_noop;

( This also has the advantage that 'init' is the general term we use 
  for kernel structure initialization - 'setup' is a more 
  restrictive term we use related to bootloading, most of the time. )

An even shorter form would be to use 'x86' as a general template for 
platform details:

     x86.timers.init_percpu_ce = x86_init_noop;
     x86_cpuhotplug.init_percpu_ce = x86_init_noop;

this is even shorter, plus it allows us to put runtime details into 
this structure as well. Note that the fields themselves 
(init_percpu_clockev) already signal the 'init' property 
sufficiently. Plus 'ce' is an existing, well-known abbreviation for 
clockevents. (but 'clockev' would be good too - i might be pushing 
it)

What do you think?

	Ingo
