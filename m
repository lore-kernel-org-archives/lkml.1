Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZD2Fzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZD2Fzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbZD2FzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:55:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42673 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZD2FzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:55:22 -0400
Date: Wed, 29 Apr 2009 07:55:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/5] tracing: convert ftrace_dump spinlocks to raw
Message-ID: <20090429055512.GB6148@elte.hu>
References: <20090429044814.138790038@goodmis.org> <20090429045904.381487770@goodmis.org> <20090428220723.5b85fcae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428220723.5b85fcae.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Apr 2009 00:48:15 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +	local_irq_save(flags);
> > +	__raw_spin_lock(&ftrace_dump_lock);
> 
> I'm counting twentyish instances of this. [...]

there's 9 in the tracing code, two more in the rest of the kernel.

> [...] Maybe it's time to give up and implement 
> raw_spin_lock_irqsave().

There's a difference between:

	local_irq_save(flags);
	__raw_spin_lock(&ftrace_dump_lock);

and:

	raw_local_irq_save(flags);
	__raw_spin_lock(&ftrace_dump_lock);

raw_spin_lock_irqsave() would map to the latter logic-wise - but in 
the tracing code we want the former.

But the main reason is that using raw locks has its costs - it skips 
lockdep coverage, is preempt unsafe, etc. The APIs are not complete 
and intentionally so: they are minimal building blocks for the real 
APIs. Instrumentation goes deep in the guts of the kernel so using 
very low level primitives is justified there - but we dont want to 
make it _too_ easy to use a raw-anything locking facility.

	Ingo
