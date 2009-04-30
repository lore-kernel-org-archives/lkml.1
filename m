Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZD3IYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZD3IYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZD3IYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:24:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZD3IYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:24:07 -0400
Date: Thu, 30 Apr 2009 10:23:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
	around
Message-ID: <20090430082350.GA21699@elte.hu>
References: <200904291221.40361.knikanth@novell.com> <200904291533.07377.knikanth@novell.com> <20090429081558.acaa2a9a.akpm@linux-foundation.org> <200904301259.11413.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301259.11413.knikanth@novell.com>
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


* Nikanth Karthikesan <knikanth@novell.com> wrote:

> Add a debug option to detect and warn when the 32-bit atomic_t 
> wraps around during atomic_inc and atomic_dec.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

hm, what's the motivation?

As a generic debug helper this is not appropriate i think - counts 
can easily have a meaning when going negative as well. (we have no 
signed-atomic primitives)

>  static inline void atomic_inc(atomic_t *v)
>  {
> +#if defined(CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP)
> +	WARN_ON(atomic_add_unless(v, 1, INT_MAX) == 0);
> +#else
>  	asm volatile(LOCK_PREFIX "incl %0"
>  		     : "+m" (v->counter));
> +#endif
>  }

also looks a bit ugly - this ugly #ifdef would spread into every 
architecture.

If we want to restrict atomic_t value ranges like that then the 
clean solution would be to add generic wrappers doing the debug 
(once, in generic code), and renaming the arch primitives to 
raw_atomic_inc() (etc), doing the lowlevel bits cleanly.

Do we really want this?

	Ingo
