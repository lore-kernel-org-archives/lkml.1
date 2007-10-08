Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbXJHLmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbXJHLmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJHLmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:42:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35226 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbXJHLmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:42:38 -0400
Date: Mon, 8 Oct 2007 13:42:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/6] scheduler: Do devirtualization for sched_fair
Message-ID: <20071008114234.GC22199@elte.hu>
References: <200710071059.126674000@suse.de> <20071007205956.5C4E71474B@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007205956.5C4E71474B@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Some CPUs like K8 cannot predict indirect calls. A common optimization 
> in object oriented languages is to check for the most common call 
> target and then call it directly; otherwise do an indirect call. This 
> patch does this manually for sched_fair calls in sched.c
[...]

> I unfortunately wasn't able to measure a consistent difference in 
> lmbench3 lat_ctx -- the change seems to be below its (large) 
> instability.

> + * Simple devirtualization:
> + * Most tasks are fair tasks. Avoid the overhead of
> + * doing indirect calls for them by checking for the fair case and doing
> + * a direct call. Use only in real fast paths since it generates larger code.
> + */
> +#define __CLASS_CALL(class, name, args) \
> +	((class) == &fair_sched_class ? \
> +		name ## _fair args : (class)->name args)
> +#define CLASS_CALL(p, name, args) \
> +	__CLASS_CALL((p)->sched_class, name, args)

hm, i'm not convinced about this one. It increases the code size a bit 
and it's a sched.c local hack. If then this should be done on a generic 
infrastructure level - lots of other code (VFS, networking, etc.) could 
benefit from it i suspect - and then should be .configurable as well. 
Then the benefit might become measurable too.

	Ingo
