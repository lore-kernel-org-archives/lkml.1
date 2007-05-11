Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXEKQAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXEKQAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbXEKP7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:59:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562AbXEKP7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:59:52 -0400
Date: Fri, 11 May 2007 17:56:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
Message-ID: <20070511155621.GA13150@elte.hu>
References: <20070511131541.992688403@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511131541.992688403@chello.nl>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> I was toying with a scalable rw_mutex and found that it gives ~10% 
> reduction in system time on ebizzy runs (without the MADV_FREE patch).
> 
> 2-way x86_64 pentium D box:
> 
> 2.6.21
> 
> /usr/bin/time ./ebizzy -m -P
> 59.49user 137.74system 1:49.22elapsed 180%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+33555877minor)pagefaults 0swaps
> 
> 2.6.21-rw_mutex
> 
> /usr/bin/time ./ebizzy -m -P
> 57.85user 124.30system 1:42.99elapsed 176%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+33555877minor)pagefaults 0swaps

nice! This 6% runtime reduction on a 2-way box will i suspect get 
exponentially better on systems with more CPUs/cores.

i also like the design, alot: instead of doing a full new lock type 
(with per-arch changes, extra lockdep support, etc. etc) you layered the 
new abstraction ontop of mutexes. This makes this hard locking 
abstraction look really, really simple, while the percpu_counter trick 
makes it scale _perfectly_ for the reader case. Congratulations!

given how nice this looks already, have you considered completely 
replacing rwsems with this? I suspect you could test the correctness of 
that without doing a mass API changeover, by embedding struct rw_mutex 
in struct rwsem and implementing kernel/rwsem.c's API that way. (the 
real patch would just flip it all over to rw-mutexes)

	Ingo
