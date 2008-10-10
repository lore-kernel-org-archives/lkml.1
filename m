Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbYJJOGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbYJJOGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbYJJOFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:05:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbYJJOFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:05:54 -0400
Date: Fri, 10 Oct 2008 16:05:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] tracing/fastboot: Print ktime of sched events when
	boot tracing
Message-ID: <20081010140534.GB13137@elte.hu>
References: <20081010123450.8D3E6D1BCF0@perso1.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010123450.8D3E6D1BCF0@perso1.free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> When we use the boot tracer, we want the sched events to be printed 
> with the same timestamp than initcall events. So we have to create a 
> new type of entry which contains sched event attributes and the ktime 
> of the creation of the entry. Then the output is handled by the boot 
> tracer.

hm, i think that's unnecessary duplication. Please extend the context 
switch trace entries to be useful for the boot tracer as well:

> +	entry->time			= ktime_get();

also, ktime_get() can be a quite complex function with dependency on 
xtime_lock - that inverts with the rq lock - so this can lock up 
sporadically when called from within the scheduler.

it would be _much_ simpler to standardize the initcall timestamps on 
cpu_clock() instead. That too is a good global clock and starts at zero 
during bootup. Ok?

Your other patches look good and i've applied them to 
tip/tracing/fastboot:

 3981ce9: tracing/fastboot: use sched switch tracer from boot tracer
 563582a: tracing/ftrace: remove unused code in sched_switch tracer
 d25b1ce: tracing/ftrace: fix a race condition in sched_switch tracer

Thanks,

	Ingo
