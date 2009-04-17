Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZDQDAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZDQDAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 23:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZDQC75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:59:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60800 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbZDQC74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:59:56 -0400
Date: Thu, 16 Apr 2009 19:59:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: Introduce APIs for waiting multi events
Message-ID: <20090417025953.GA6885@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49E55218.1020208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E55218.1020208@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 11:18:48AM +0800, Lai Jiangshan wrote:
> 
> Impact: make kernel has APIs for waiting multi events
> 
> Based on code in the RCU, the simple waiting-multi-events
> algorithm may do not serve RCU only.
> 
> Introduce 5 APIs for waiting multi events
> 
> start scheduling events:  ref_completion_get_init()
> schedule one event:       ref_completion_get()
> end scheduling events:    ref_completion_put_init()
> 
> any event is finished:    ref_completion_put()
> 
> waiting scheduled events: ref_completion_wait()

Interesting API!  What other uses for it have you found?

One question down below.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/completion.h b/include/linux/completion.h
> index 4a6b604..86c8236 100644
> --- a/include/linux/completion.h
> +++ b/include/linux/completion.h
> @@ -8,6 +8,7 @@
>   * See kernel/sched.c for details.
>   */
> 
> +#include <asm/atomic.h>
>  #include <linux/wait.h>
> 
>  /**
> @@ -98,5 +99,44 @@ extern void complete_all(struct completion *);
>   */
>  #define INIT_COMPLETION(x)	((x).done = 0)
> 
> +/*
> + * wait all references are put, or wait multi events finished in other words
> + * ref_completion_get_init() called before the struct is used or reused.
> + * ref_completion_put_init() called after all ref_completion_get()s called.
> + * ref_completion_wait()     waiting until all ref_completion_put()s and
> + *                           the ref_completion_put_init() are called.
> + */
> +struct ref_completion {
> +	atomic_t ref;
> +	struct completion wait;
> +};
> +
> +static inline void ref_completion_get_init(struct ref_completion *rc)
> +{
> +	atomic_set(&rc->ref, 1);
> +	init_completion(&rc->wait);
> +}
> +
> +static inline void ref_completion_get(struct ref_completion *rc)
> +{
> +	atomic_inc(&rc->ref);
> +}
> +
> +static inline void ref_completion_put(struct ref_completion *rc)
> +{
> +	if (atomic_dec_and_test(&rc->ref))
> +		complete_all(&rc->wait);
> +}
> +
> +static inline void ref_completion_put_init(struct ref_completion *rc)
> +{
> +	if (atomic_dec_and_test(&rc->ref))
> +		complete_all(&rc->wait);
> +}

Looks to me that ref_completion_put() and ref_completion_put_init() are
identical.  What is the story with that?

> +static inline void ref_completion_wait(struct ref_completion *rc)
> +{
> +	wait_for_completion(&rc->wait);
> +}
> 
>  #endif
> 
> 
