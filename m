Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbXGEIx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbXGEIx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbXGEIxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:53:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163AbXGEIxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:53:19 -0400
Date: Thu, 5 Jul 2007 10:53:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
Message-ID: <20070705085304.GC3476@elte.hu>
References: <1183583529.9662.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183583529.9662.34.camel@johannes.berg>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> This adds a lockdep_map for each work struct in order to debug
> deadlocks like
>   my_function -> lock(); ...; cancel_work_sync(my_work)
> vs.
>   run_workqueue() -> my_work.f() -> ...; lock(); ...
> 
> which will deadlock if my_work.f() is invoked already but my_function()
> has acquired the lock already.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Ingo Molnar <mingo@elte.hu>

> +#ifdef CONFIG_LOCKDEP
> +/*
> + * HACK! This really should call lockdep_init_map() but can't
> + * because there's no requirement to initialise work structs
> + * at runtime. This works because subclass == 0.
> + *
> + * NB: because we have to copy the lockdep_map, setting .key
> + * here is required!
> + */

why do you consider this a hack? A static object is a static object, and 
its own address is its key. That's what we have for like 80% of all the 
spinlocks in the kernel. Static initialization is not as flexible as 
dynamic initialization, but the lockdep engine handles it. Am i missing 
something?

> +#define __WORK_INIT_LOCKDEP_MAP(n, k)				\
> +	.lockdep_map = {					\
> +		.name = n,					\
> +		.key = (void*) k,				\
> +	},

s/void*/void *

	Ingo
