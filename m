Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZCTIcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZCTIcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZCTIbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:31:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbZCTIbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:31:49 -0400
Date: Fri, 20 Mar 2009 09:30:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: peterz@infradead.org, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fix uml slowness caused by ptrace preemption bug on
	host
Message-ID: <20090320083049.GA29471@elte.hu>
References: <E1LkQeU-00020Z-Be@pomaz-ex.szeredi.hu> <1237537169.24626.29.camel@twins> <E1Lka4M-0002za-FQ@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Lka4M-0002za-FQ@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Fri, 20 Mar 2009, Peter Zijlstra wrote:
> > On Thu, 2009-03-19 at 23:23 +0100, Miklos Szeredi wrote:
> > > 
> > > This patch solves this by not scheduling on preempt_enable() after
> > > ptrace_stop() has woken up the tracer.
> > 
> > Nice,.. however did you find this?
> 
> Ftrace helped a lot, it's a really cool tool :).  I had to patch it
> with this, otherwise the timestamps would be totally off:
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index bd38c5c..557c2dd 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -108,7 +108,7 @@ u64 ring_buffer_time_stamp(int cpu)
>  
>  	preempt_disable_notrace();
>  	/* shift to debug/test normalization and TIME_EXTENTS */
> -	time = sched_clock() << DEBUG_SHIFT;
> +	time = cpu_clock(cpu) << DEBUG_SHIFT;
>  	preempt_enable_no_resched_notrace();

Btw., based on your earlier report, the same is now possible in the 
latest tracing tree via:

   echo 1 > /debug/tracing/options/global_clock

	Ingo
