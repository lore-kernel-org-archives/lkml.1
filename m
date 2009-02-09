Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZBIUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZBIUtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZBIUtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:49:32 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33105 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbZBIUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:49:31 -0500
Message-ID: <499096D5.9070903@us.ibm.com>
Date: Mon, 09 Feb 2009 12:49:25 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v2] futex: fix reference leak
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com> <1234190649.16083.44.camel@pc1117.cambridge.arm.com> <1234192363.5951.129.camel@laptop>  <1234197950.5951.132.camel@laptop> <1234198023.5951.133.camel@laptop> <1234200538.16083.52.camel@pc1117.cambridge.arm.com> <1234203975.5951.143.camel@laptop> <1234205595.4286.223.camel@localhost.localdomain> <1234205874.5951.151.camel@laptop>
In-Reply-To: <1234205874.5951.151.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-02-09 at 10:53 -0800, Pallipadi, Venkatesh wrote:
>> Yes. This patch fixes the problem on my system. With git, without the
>> patch I see the same oops as before on reboot. With the patch, system
>> reboots cleanly.
>>


OK, I remember why I didn't do this in the set I sent to Ingo for -tip.  The unqueue_me()
 call drops the key ref for us.  Eventually I think we should take/release references and
 locks in the same function as much as possible, but for now I left them where they were.
I suspect this patch is actually dropping one extra key ref than it should, but because
Caralin has been testing on linux.git and not -tip, the get/put patches I submitted there
aren't included, so this patch compensates for one of those missing patches :-)

Caralin, can you try applying the following patches from linux-tip without this patch and see if your problem still exists?

42d35d48ce7cefb9429880af19d1c329d1554e7a - futex: make futex_(get|put)_key() calls symmetric
90621c40cc4ab7b0a414311ce37e7cc7173403b6 - futex: catch certain assymetric (get|put)_futex_key calls

I haven't tried applying these to linux-2.6.git myself, so they may not apply cleanly.

Thanks,

Darren Hart

>> A minor typo in the patch
>> + ret = -RESTART_RESTARTBLOCK;
>> should be
>> + ret = -ERESTART_RESTARTBLOCK;
> 
> Gah, so much for my copy-paste skillz ;-)
> 
> Thanks!
> 
> ---
> Catalin noticed that (38d47c1b7075: futex: rely on
> get_user_pages() for shared futexes) caused an mm_struct leak.
> 
> Some tracing with the function graph tracer quickly pointed out that
> futex_wait() has exit paths with unbalanced reference counts.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Tested-by: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
> ---
>  kernel/futex.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index f89d373..ff06c76 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1284,18 +1284,23 @@ retry:
>  	 */
> 
>  	/* If we were woken (and unqueued), we succeeded, whatever. */
> -	if (!unqueue_me(&q))
> -		return 0;
> -	if (rem)
> -		return -ETIMEDOUT;
> +	if (!unqueue_me(&q)) {
> +		ret = 0;
> +		goto out_put_key;
> +	}
> +	if (rem) {
> +		ret = -ETIMEDOUT;
> +		goto out_put_key;
> +	}
> 
>  	/*
>  	 * We expect signal_pending(current), but another thread may
>  	 * have handled it for us already.
>  	 */
> -	if (!abs_time)
> -		return -ERESTARTSYS;
> -	else {
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
> 
>  out:
> 
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
