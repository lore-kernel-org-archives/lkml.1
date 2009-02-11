Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZBKM3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZBKM3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZBKM3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:29:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608AbZBKM3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:29:15 -0500
Date: Wed, 11 Feb 2009 13:28:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -v2] futex: fix reference leak
Message-ID: <20090211122849.GD16535@elte.hu>
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com> <1234190649.16083.44.camel@pc1117.cambridge.arm.com> <1234192363.5951.129.camel@laptop> <1234197950.5951.132.camel@laptop> <1234198023.5951.133.camel@laptop> <1234200538.16083.52.camel@pc1117.cambridge.arm.com> <1234203975.5951.143.camel@laptop> <1234205595.4286.223.camel@localhost.localdomain> <1234205874.5951.151.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234205874.5951.151.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> +	if (!unqueue_me(&q)) {
> +		ret = 0;
> +		goto out_put_key;
> +	}
> +	if (rem) {
> +		ret = -ETIMEDOUT;
> +		goto out_put_key;
> +	}

hm, we generally prefer to write such things as:

	ret = 0;
	if (!unqueue_me(&q))
		goto out_put_key;

	ret = -ETIMEDOUT;
	if (rem)
		goto out_put_key;

Also, while at it, the flow of control looks weird in other places too:

        if (!abs_time)
                return -ERESTARTSYS;
        else {
                struct restart_block *restart;
                restart = &current_thread_info()->restart_block;
                restart->fn = futex_wait_restart;
                restart->futex.uaddr = (u32 *)uaddr;

Shouldnt it be something like:

        if (!abs_time)
                return -ERESTARTSYS;

        restart = &current_thread_info()->restart_block;
        restart->fn = futex_wait_restart;
        restart->futex.uaddr = (u32 *)uaddr;

(with the variable definition moving up to local variables.)

and this:

> +	if (!abs_time) {
> +		ret = -ERESTARTSYS;
> +		goto out_put_key;
> +	} else {
>  		struct restart_block *restart;
>  		restart = &current_thread_info()->restart_block;
>  		restart->fn = futex_wait_restart;
> @@ -1309,11 +1314,13 @@ retry:
>  			restart->futex.flags |= FLAGS_SHARED;
>  		if (clockrt)
>  			restart->futex.flags |= FLAGS_CLOCKRT;
> -		return -ERESTART_RESTARTBLOCK;
> +		ret = -ERESTART_RESTARTBLOCK;
> +		goto out_put_key;
>  	}
>  
>  out_unlock_put_key:
>  	queue_unlock(&q, hb);
> +out_put_key:
>  	put_futex_key(fshared, &q.key);

and this looks weird too, we jump-goto over the queue_unlock() in essence.

A proper flow would be to rename the error labels as err_unlock_*[etc], move
them out of line, let them jump back to the normal labels - and let the
tail section of the code above fall through.

	Ingo
