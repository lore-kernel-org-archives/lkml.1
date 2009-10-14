Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZJNHGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZJNHGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZJNHGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:06:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbZJNHGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:06:01 -0400
Date: Wed, 14 Oct 2009 09:05:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] sched: add notifier for process migration
Message-ID: <20091014070508.GI784@elte.hu>
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop> <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins> <4AD04E50.7060001@redhat.com> <1255166662.7866.28.camel@twins> <4AD055B3.8070705@goop.org> <1255169528.7521.3.camel@laptop> <4AD4F02C.9060203@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD4F02C.9060203@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> @@ -1981,6 +1989,12 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>  #endif
>  		perf_swcounter_event(PERF_COUNT_SW_CPU_MIGRATIONS,
>  				     1, 1, NULL, 0);
> +
> +		tmn.task = p;
> +		tmn.from_cpu = old_cpu;
> +		tmn.to_cpu = new_cpu;
> +
> +		atomic_notifier_call_chain(&task_migration_notifier, 0, &tmn);

We already have one event notifier there - look at the 
perf_swcounter_event() callback. Why add a second one for essentially 
the same thing?

We should only put a single callback there - a tracepoint defined via 
TRACE_EVENT() - and any secondary users can register a callback to the 
tracepoint itself.

There's many similar places in the kernel - with notifier chains and 
also with a need to get tracepoints there. The fastest (and most 
consistent) solution is to add just a single event callback facility.

	Ingo
